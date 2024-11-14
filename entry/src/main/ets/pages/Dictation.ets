import { Synonym, WordInfo } from '../Model/WordInfo'
import { ComponentContent, router } from '@kit.ArkUI'
import { webview } from '@kit.ArkWeb'
import { BuildSpeaker, BuildSpeakerArgs } from '../ViewModel/ComponentContent'
import { DataPersistence } from '../Model/DataPersistence'

@Entry
@Component
struct Dictation {
  FavoriteWordNum:number=0
  @StorageLink('WordsFavorite') WordsFavorite: number[]=[]
  WebController1: webview.WebviewController = new webview.WebviewController();
  WebController2: webview.WebviewController = new webview.WebviewController();
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
  @State DictationBest: number=0
  aboutToAppear(): void {
    console.log("模拟器Learn1 aboutToAppear")
    DataPersistence.getNumberArray(this.WordBookName+'Favorite',getContext(this)).then((value:number[])=>{
      this.WordsFavorite = value
      this.WordId=this.WordsFavorite[this.FavoriteWordNum]
      this.WebController1.loadUrl(`http://dict.youdao.com/dictvoice?type=1&audio=${this.Words[this.WordId].headWord}`)
      this.WebController2.loadUrl(`http://dict.youdao.com/dictvoice?type=2&audio=${this.Words[this.WordId].headWord}`)
      this.IsActive1=this.WordsFavorite.some(item=>item==this.WordId)
      console.log("模拟器WordsFavorite",this.WordsFavorite)
    })
    DataPersistence.getRecord('DictationBest',getContext(this)).then((value:number)=>{
      this.DictationBest = value
      console.log("模拟器SpellingBest",this.DictationBest)
    })
    setInterval(()=>{
      if(this.IsActive&&this.counter>0){
        this.counter--
      }else{
        if(this.counter==0){
          this.DictationBest=this.Scores>this.DictationBest?this.Scores:this.DictationBest
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
    DataPersistence.putRecord('DictationBest',this.DictationBest,getContext(this))
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
      .opacity(this.Opacity)
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
          .height('40%')
          .fontSize(40)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .onChange((value: string) => {
            this.Text = value
          })
        SymbolGlyph(this.IsRight?$r('sys.symbol.checkmark_circle'):$r('sys.symbol.xmark_circle'))
          .fontColor([this.IsRight?Color.Green:Color.Red])
          .fontSize(80)
          .height('40%')
          .fontWeight(FontWeight.Bold)
          .opacity(this.Opacity)
      }
      .height('25%')
      .width('90%')
      .backgroundColor('#60eeeeee')
      .borderRadius(10)
      .alignItems(HorizontalAlign.Center)
      //听力按钮
      Column({space: 20}){
        Row() {
          Text('美')
            .fontColor(Color.White)
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
          Web({ src: `http://dict.youdao.com/dictvoice?type=2&audio=${this.Words[this.WordId].headWord}`, controller: this.WebController2 })
            .width("35%")
        }
        .width('95%')
        .height('45%')
        .justifyContent(FlexAlign.SpaceAround)
        .backgroundColor(Color.Black)
        .borderRadius(20)
        Row() {
          Text('英')
            .fontColor(Color.White)
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
          Web({ src: `http://dict.youdao.com/dictvoice?type=1&audio=${this.Words[this.WordId].headWord}`, controller: this.WebController1 })
            .width("35%")
        }
        .width('95%')
        .height('45%')
        .justifyContent(FlexAlign.SpaceAround)
        .backgroundColor(Color.Black)
        .borderRadius(20)
      }
      .height('20%')
      .width('90%')
      .backgroundColor('#60eeeeee')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .borderRadius(20)
      //选择按钮
      Row(){
        Column(){
          Text(this.Opacity==1?'下一词':'确认')
            .fontColor(Color.White)
            .fontSize(20)
            .textAlign(TextAlign.Center)
          Button()
            .width('0.5%')
            .height('5%')
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
              this.WebController1.loadUrl(`http://dict.youdao.com/dictvoice?type=1&audio=${this.Words[this.WordId].headWord}`)
              this.WebController2.loadUrl(`http://dict.youdao.com/dictvoice?type=2&audio=${this.Words[this.WordId].headWord}`)
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
      .height('10%')
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