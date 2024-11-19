import { RelatedWord, Sentence, Synonym, WordInfo } from '../Model/WordInfo'
import { ComponentContent, promptAction, router } from '@kit.ArkUI'
import { webview } from '@kit.ArkWeb'
import { BuildSpeaker, BuildSpeakerArgs } from '../ViewModel/ComponentContent'
import { DataPersistence } from '../Model/DataPersistence'

@Entry
@Component
struct Review {
  WebController: webview.WebviewController = new webview.WebviewController();
  @State Opacity: number=0
  @State WordId:number = 0
  @State IsActive:boolean = false
  @StorageLink('Words') Words: WordInfo[]=[]
  @StorageLink('WordsFavorite') WordsFavorite: number[]=[]
  @StorageLink('WordBookName') WordBookName: string=''
  @StorageLink('WordsProgress') WordsProgress: number[]=[]
  @State TotalWordsProgress: number=0
  aboutToAppear(): void {
    console.log("模拟器Learn1 aboutToAppear")
    while (this.WordId<this.Words.length-1&& this.WordsProgress[this.WordId]!=1){
      this.WordId++
    }
    DataPersistence.getRecord('TotalWordsProgress',getContext(this)).then((value:number)=>{
      this.TotalWordsProgress = value
      console.log("模拟器TotalWordsProgress",this.TotalWordsProgress)
    })
  }
  aboutToDisappear(): void {
    console.log("模拟器Learn aboutToDisappear")
    this.WordsFavorite.filter((item, index) => this.WordsFavorite.indexOf(item) === index);
    DataPersistence.putNumberArray(this.WordBookName,this.WordsProgress,getContext(this))
    DataPersistence.putNumberArray(this.WordBookName+'Favorite',this.WordsFavorite,getContext(this))
    DataPersistence.putRecord('TotalWordsProgress',this.TotalWordsProgress,getContext(this))
  }
  build() {
    Column({space:10}){
      Row({space:20}){
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontColor([Color.White])
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .onClick(()=>{
            router.back()
            console.log("模拟器Learn1 back")
          })
        Text('')
          .width('55%')
        SymbolGlyph(this.IsActive?$r('sys.symbol.star_fill'):$r('sys.symbol.star'))
          .fontColor([Color.White])
          .fontSize(30)
          .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE))
          .onClick(()=>{
            console.log("模拟器star word "+this.WordId)
            if(this.IsActive){
              this.WordsFavorite = this.WordsFavorite.filter(item=>item!=this.WordId)
            }else{
              this.WordsFavorite.push(this.WordId)
            }
            this.IsActive=this.WordsFavorite.some(item=>item==this.WordId)
          })
        SymbolGlyph($r('sys.symbol.trash'))
          .fontColor([Color.White])
          .fontSize(30)
          .margin({ right: 10})
          .onClick(()=>{
            console.log("模拟器delete")
            this.WordsProgress[this.WordId]=2
            this.TotalWordsProgress++
            while (this.WordId<this.Words.length-1&&this.WordsProgress[this.WordId]!=1){
              this.WordId++
            }
            if(this.WordsProgress.filter(item=>item==1).length==0){
              router.back()
            }
          })
      }
      .width('100%')
      .height('8%')
      .justifyContent(FlexAlign.End)
      //单词
      Text(this.Words[this.WordId].headWord)
        .width('90%')
        .height('5%')
        .fontSize(40)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)
      //音标
      Row({space:20}){
        SymbolGlyph($r('sys.symbol.speaker_wave_3'))
          .fontColor([Color.White])
          .fontSize(20)
          .onClick(()=>{
            console.log("模拟器Speaker play")
            const promptAction = this.getUIContext().getPromptAction();
            const contentNode = new ComponentContent(this.getUIContext(), wrapBuilder(BuildSpeaker),
              {word:this.Words[this.WordId].headWord,controller:this.WebController} as BuildSpeakerArgs);
            promptAction.openCustomDialog(contentNode, { alignment: DialogAlignment.Center });
          })
        Text('美：/'+this.Words[this.WordId].content.word.content.usphone+'/')
          .textAlign(TextAlign.Start)
          .fontColor(Color.White)
          .fontSize(12)
        Text('英：/'+this.Words[this.WordId].content.word.content.ukphone+'/')
          .textAlign(TextAlign.Start)
          .fontColor(Color.White)
          .fontSize(12)
      }
      .width('90%')
      .height('5%')
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      //词性、词义
      List(){
        ForEach(this.Words[this.WordId]?.content?.word?.content?.syno?.synos, (item:Synonym)=>{
          ListItem(){
            Row(){
              Text(item.pos+'. '+item.tran)
                .fontColor(Color.White)
                .fontSize(15)
                .textAlign(TextAlign.Start)
            }
            .width('90%')
            .height('50%')
          }
        })
      }
      .height('10%')
      .width('90%')
      .opacity(this.Opacity)
      //例句
      Row(){
        Text('例句:')
          .fontColor(Color.White)
          .fontSize(20)
          .textAlign(TextAlign.Start)
      }
      .height('5%')
      .width('90%')
      .opacity(this.Opacity)
      List({space:10}){
        ForEach(this.Words[this.WordId]?.content?.word?.content?.sentence?.sentences, (item:Sentence)=>{
          ListItem(){
            Column(){
              Text(item?.sContent)
                .fontColor(Color.White)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.Center)
                .width('100%')
              Text(item?.sCn)
                .fontColor(Color.White)
                .fontSize(20)
                .textAlign(TextAlign.Center)
                .width('100%')
                .height('50%')
            }
            .width('100%')
            .height('100%')
          }
        })
      }
      .height('20%')
      .width('90%')
      .backgroundColor('#60eeeeee')
      .borderRadius(10)
      .alignListItem(ListItemAlign.Center)
      .opacity(this.Opacity)
      //同根词
      Row(){
        Text('同根词:')
          .fontColor(Color.White)
          .fontSize(20)
          .textAlign(TextAlign.Start)
      }
      .height('5%')
      .width('90%')
      .opacity(this.Opacity)
      List({space:10}){
        ForEach(this.Words[this.WordId]?.content?.word?.content?.relWord?.rels, (item:RelatedWord)=>{
          ListItem(){
            Row(){
              Text(item?.pos+'. '+item?.words[0].hwd+' '+item?.words[0].tran)
                .fontColor(Color.White)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .textAlign(TextAlign.Center)
            }
            .width('100%')
          }
        })
      }
      .height('20%')
      .width('90%')
      .backgroundColor('#60eeeeee')
      .borderRadius(10)
      .alignListItem(ListItemAlign.Center)
      .opacity(this.Opacity)
      //选择按钮
      Row(){
        Column(){
          Text(this.Opacity==1?'下一词':'认识')
            .fontColor(Color.White)
            .fontSize(20)
            .textAlign(TextAlign.Center)
          Button()
            .width('0.5%')
            .height('2.5%')
            .backgroundColor('#067d6e')
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .onClick(()=>{
          console.log("模拟器Learn1 know")
          //下一词
          if(this.Opacity==1){
            this.WordsProgress[this.WordId]=2
            this.TotalWordsProgress++
            console.log("模拟器WordsProgress"+this.WordsProgress)
            while (this.WordId<this.Words.length-1&&this.WordsProgress[this.WordId]!=1){
              this.WordId++
            }
            if(this.WordsProgress.filter(item=>item==1).length==0){
              router.back()
            }
            this.IsActive=this.WordsFavorite.some(item=>item==this.WordId)
            this.Opacity=0
          }
          //认识
          else{
            this.Opacity=1
          }

        })
        Column(){
          Text('模糊')
            .fontColor(Color.White)
            .fontSize(20)
            .textAlign(TextAlign.Center)
          Button()
            .width('0.5%')
            .height('2.5%')
            .backgroundColor('#8f6a07')
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .opacity(this.Opacity==1?0:1)
        .onClick(()=>{
          console.log("模拟器Learn1 obscure")
          this.Opacity=1
          this.WordsProgress[this.WordId]=0
          console.log("模拟器WordsProgress"+this.WordsProgress)
        })
        Column(){
          Text(this.Opacity==1?'记错了':'忘记了')
            .fontColor(Color.White)
            .fontSize(20)
            .textAlign(TextAlign.Center)
          Button()
            .width('0.5%')
            .height('2.5%')
            .backgroundColor('#973a3f')
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .onClick(()=>{
          console.log("模拟器Learn1 forget")
          this.WordsProgress[this.WordId]=0
          console.log("模拟器WordsProgress"+this.WordsProgress)
          //记错了
          if(this.Opacity==1){
            while (this.WordId<this.Words.length-1&&this.WordsProgress[this.WordId]!=1){
              this.WordId++
            }
            if(this.WordsProgress.filter(item=>item==1).length==0){
              router.back()
            }
            this.IsActive=this.WordsFavorite.some(item=>item==this.WordId)
            this.Opacity=0
          }
          //忘记了
          else{
            this.Opacity=1
          }
        })
      }
      .width('80%')
      .height('15%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.Background1'))
    .backgroundImageSize(ImageSize.Cover)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .backdropBlur(500)
  }
}