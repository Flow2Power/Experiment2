import { Synonym, WordInfo } from '../Model/WordInfo'
import { ComponentContent, router } from '@kit.ArkUI'
import { webview } from '@kit.ArkWeb'
import { BuildSpeaker, BuildSpeakerArgs } from '../ViewModel/ComponentContent'
import { DataPersistence } from '../Model/DataPersistence'

@Entry
@Component
struct Spelling {
  FavoriteWordNum:number=0
  @StorageLink('WordsFavorite') WordsFavorite: number[]=[]
  WebController: webview.WebviewController = new webview.WebviewController();
  @State Opacity: number=0
  @State WordId:number = 0
  @State IsActive:boolean = false
  @State IsActive1:boolean = false
  @State IsRight:boolean = false
  @State Text:string=''
  @State counter:number=10
  @State Scores:number=0
  @StorageLink('Words') Words: WordInfo[]=[]
  @StorageLink('WordBookName') WordBookName: string=''
  @State SpellingBest: number=0
  aboutToAppear(): void {
    console.log("模拟器Learn1 aboutToAppear")
    DataPersistence.getNumberArray(this.WordBookName+'Favorite',getContext(this)).then((value:number[])=>{
      this.WordsFavorite = value
      this.WordId=this.WordsFavorite[this.FavoriteWordNum]
      this.IsActive1=this.WordsFavorite.some(item=>item==this.WordId)
      console.log("模拟器WordsFavorite",this.WordsFavorite)
    })
    DataPersistence.getRecord('SpellingBest',getContext(this)).then((value:number)=>{
      this.SpellingBest = value
      console.log("模拟器SpellingBest",this.SpellingBest)
    })
    setInterval(()=>{
      if(this.IsActive&&this.counter>0){
        this.counter--
      }else{
        if(this.counter==0){
          this.SpellingBest=this.Scores>this.SpellingBest?this.Scores:this.SpellingBest
        }
        this.IsActive=false
        this.counter=10
      }
    },1000)
  }
  aboutToDisappear(): void {
    console.log("模拟器Learn aboutToDisappear")
    this.WordsFavorite.filter((item, index) => this.WordsFavorite.indexOf(item) === index);
    DataPersistence.putNumberArray(this.WordBookName+'Favorite',this.WordsFavorite,getContext(this))
    DataPersistence.putRecord('SpellingBest',this.SpellingBest,getContext(this))
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
        SymbolGlyph(this.IsActive1?$r('sys.symbol.star_fill'):$r('sys.symbol.star'))
          .fontColor([Color.White])
          .fontSize(30)
          .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE))
          .onClick(()=>{
            console.log("模拟器star word "+this.WordId)
            if(this.IsActive1){
              this.WordsFavorite=this.WordsFavorite.filter(item=>item!=this.WordId)
            }else{
              this.WordsFavorite.push(this.WordId)
            }
            this.IsActive1=this.WordsFavorite.some(item=>item==this.WordId)
          })
          SymbolGlyph(this.IsActive?$r('sys.symbol.clock_fill'):$r('sys.symbol.clock'))
            .fontColor([Color.White])
            .fontSize(30)
            .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE))
            .onClick(()=>{
              console.log("模拟器Learn1 timer")
              this.IsActive=!this.IsActive
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
        .opacity(this.Opacity)
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
      //计分系统
      Row(){
        SymbolGlyph($r('sys.symbol.clock'))
          .fontColor([Color.White])
          .fontWeight(400)
          .fontSize(30)
          .effectStrategy(1)
          .onClick(() => {
            console.log('back')
            router.back()
          })
        Text(`${this.counter}`+' s')
          .fontColor(Color.White)
          .fontWeight(400)
          .width('auto')
          .fontSize(30)
          .textAlign(TextAlign.Center)
        SymbolGlyph($r('sys.symbol.grid'))
          .fontColor([Color.White])
          .fontWeight(400)
          .fontSize(30)
          .effectStrategy(1)
          .onClick(() => {
            console.log('back')
            router.back()
          })
        Text(`${this.Scores}`+' 个')
          .fontColor(Color.White)
          .fontWeight(400)
          .width('auto')
          .fontSize(30)
          .textAlign(TextAlign.Center)
      }
      .width('90%')
      .height('10%')
      .backgroundColor('#60eeeeee')
      .borderRadius(10)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceAround)
      .opacity(this.IsActive?1:0)
      //单词输入框
      Column(){
        TextInput({ placeholder:'请输入单词', text: this.Text })
          .width('90%')
          .height('50%')
          .fontSize(40)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .onChange((value: string) => {
            this.Text = value
          })
        SymbolGlyph(this.IsRight?$r('sys.symbol.checkmark_circle'):$r('sys.symbol.xmark_circle'))
          .fontColor([this.IsRight?Color.Green:Color.Red])
          .fontSize(100)
          .height('50%')
          .fontWeight(FontWeight.Bold)
          .opacity(this.Opacity)
      }
      .height('40%')
      .width('90%')
      .backgroundColor('#60eeeeee')
      .borderRadius(10)
      .alignItems(HorizontalAlign.Center)
      //选择按钮
      Row(){
        Column(){
          Text(this.Opacity==1?'下一词':'确认')
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
          if(this.Opacity==1){
            if(this.FavoriteWordNum<this.WordsFavorite.length-1){
              this.FavoriteWordNum++
              this.WordId=this.WordsFavorite[this.FavoriteWordNum]
              this.IsActive1=true
              this.Text=''
              this.Opacity=0
            }
            else{
              router.back()
              console.log("模拟器Learn1 back")
            }
          }
          else{
            this.IsRight=this.Text==this.Words[this.WordId].headWord
            this.Scores+=this.IsRight&&this.IsActive?1:0
            this.Opacity=1
          }
        })
      }
      .width('80%')
      .height('15%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
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