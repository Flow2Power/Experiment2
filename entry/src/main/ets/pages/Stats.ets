import { RelatedWord, Sentence, Synonym, WordInfo } from '../Model/WordInfo'
import { ComponentContent, router } from '@kit.ArkUI'
import { webview } from '@kit.ArkWeb'
import { BuildSpeaker, BuildSpeakerArgs } from '../ViewModel/ComponentContent'
import { DataPersistence } from '../Model/DataPersistence'
import JsonFileManager from '../Model/JsonFileManager'

@Entry
@Component
struct Stats {
  select:number | number[] = 0
  WordBookNames:string[]=['CET4','CET6','IELTS','TOEFl','TEM4','TEM8','KaoYan']
  WordsFavorite:number[]=[]
  WebController: webview.WebviewController = new webview.WebviewController();
  @State WordId:number = 0
  @State IsActive:boolean = false
  @StorageLink('Words') Words: WordInfo[]=[]
  @State TotalWordsProgress: number=0
  @State SpellingBest: number=0
  @State DictationBest: number=0
  @Watch('onChange')@StorageLink('WordBookName') WordBookName: string=''
  onChange(){
    console.log('模拟器Stats onChange')
    this.Words = JsonFileManager.GetWordsData(this.WordBookName+'.json',this)
    DataPersistence.getNumberArray(this.WordBookName,getContext(this)).then((value:number[])=>{
      this.WordsProgress = (value.length==0)?new Array(this.Words.length).fill(0):value
      console.log("模拟器WordsProgress",this.WordsProgress)
    })
  }
  aboutToAppear(): void {
    DataPersistence.getRecord('TotalWordsProgress',getContext(this)).then((value:number)=>{
      this.TotalWordsProgress = value
      console.log("模拟器TotalWordsProgress",this.TotalWordsProgress)
    })
    DataPersistence.getRecord('SpellingBest',getContext(this)).then((value:number)=>{
      this.SpellingBest = value
      console.log("模拟器SpellingBest",this.SpellingBest)
    })
    DataPersistence.getRecord('DictationBest',getContext(this)).then((value:number)=>{
      this.DictationBest = value
      console.log("模拟器DictationBest",this.DictationBest)
    })
  }
  aboutToDisappear(): void {
    console.log('模拟器Stats aboutToDisappear')
    DataPersistence.putWordBookName(this.WordBookName,getContext(this))
    this.Words = JsonFileManager.GetWordsData(this.WordBookName+'.json',this)
  }
  @StorageLink('WordsProgress') WordsProgress: number[]=[]
  build() {
    Column({space:10}){
      Row(){
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontColor([Color.White])
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .onClick(()=>{
            router.back()
            console.log("模拟器Stats back")
          })
      }
      .width('90%')
      .height('8%')
      .justifyContent(FlexAlign.Start)
      //正在学习
      Row(){
        Text('正在学习')
          .fontColor(Color.White)
          .fontSize(25)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bold)
      }
      .height('5%')
      .width('90%')
      Column(){
        Row({space:80}){
          Text(this.WordBookName)
            .fontColor(Color.White)
            .fontSize(30)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
          Image($r(`app.media.${this.WordBookName}`))
            .width(100)
            .height(140)
            .borderWidth(2)
            .borderRadius(10)
            .borderColor(Color.Black)
        }
        .height('70%')
        .width('90%')
        .justifyContent(FlexAlign.Start)
        Progress({value:0, total:this.Words.length, type:ProgressType.Capsule}).width('90%').height('5%')
          .style({strokeWidth:50}).value(this.WordsProgress.filter(item=>item==2).length)
        Row(){
          Text('已学习 '+this.WordsProgress.filter(item=>item==2).length)
            .fontColor(Color.White)
            .fontSize(15)
            .textAlign(TextAlign.Center)
          Text('总词数 '+this.Words.length)
            .fontColor(Color.White)
            .fontSize(15)
            .textAlign(TextAlign.Center)
        }
        .width('90%')
        .height('20%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .height('30%')
      .width('90%')
      .backgroundColor('#60eeeeee')
      .borderRadius(10)
      .alignItems(HorizontalAlign.Center)
      //我的数据
      Row(){
        Text('我的数据')
          .fontColor(Color.White)
          .fontSize(25)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bold)
      }
      .height('5%')
      .width('90%')
      Column(){
        Row(){
          SymbolGlyph($r('sys.symbol.sort'))
            .fontSize(40)
            .fontWeight(FontWeight.Bold)
            .fontColor(['#175d7e'])
          Column(){
            Text('待复习')
              .fontSize(20)
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)
            Row({space:10}){
              Text(`${this.WordsProgress.filter(item=>item==1).length}`)
                .fontSize(40)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bold)
              Text('词')
                .fontSize(10)
                .fontColor(Color.White)
            }
          }
          .width('40%')
          .height('40%')
          SymbolGlyph($r('sys.symbol.list_letter'))
            .fontSize(40)
            .fontWeight(FontWeight.Bold)
            .fontColor(['#175d7e'])
          Column(){
            Text('累计学习')
              .fontSize(20)
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)
            Row({space:10}){
              Text(`${this.TotalWordsProgress}`)
                .fontSize(40)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bold)
              Text('词')
                .fontSize(10)
                .fontColor(Color.White)
            }
          }
          .width('40%')
          .height('40%')
        }
        .width('90%')
        .height('50%')
        .justifyContent(FlexAlign.SpaceBetween)
        Row(){
          SymbolGlyph($r('sys.symbol.pencil_waveform'))
            .fontSize(40)
            .fontWeight(FontWeight.Bold)
            .fontColor(['#175d7e'])
          Column(){
            Text('拼写挑战')
              .fontSize(20)
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)
            Row({space:10}){
              Text(`${this.SpellingBest}`)
                .fontSize(40)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bold)
              Text('词')
                .fontSize(10)
                .fontColor(Color.White)
            }
          }
          .width('40%')
          .height('40%')
          SymbolGlyph($r('sys.symbol.ear'))
            .fontSize(40)
            .fontWeight(FontWeight.Bold)
            .fontColor(['#175d7e'])
          Column(){
            Text('听写挑战')
              .fontSize(20)
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)
            Row({space:10}){
              Text(`${this.DictationBest}`)
                .fontSize(40)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bold)
              Text('词')
                .fontSize(10)
                .fontColor(Color.White)
            }
          }
          .width('40%')
          .height('40%')
        }
        .width('90%')
        .height('50%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .height('35%')
      .width('90%')
      .backgroundColor('#60eeeeee')
      .borderRadius(10)
      .alignItems(HorizontalAlign.Center)
      //换本词书
      Column({space:10}){
        Text('换本词书')
          .fontColor(Color.White)
          .fontSize(20)
          .textAlign(TextAlign.Center)
        Button()
          .width('10%')
          .height('5%')
          .backgroundColor('#067d6e')
      }
      .width('90%')
      .height('10%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .onClick(()=>{
        console.log('模拟器换本词书')
        TextPickerDialog.show({
          range:this.WordBookNames,
          selected:this.select,
          textStyle: {color: Color.Black, font: {size: 20, weight: FontWeight.Normal}},
          onAccept:(value:TextPickerResult)=>{
            this.select = value.index
            this.WordBookName=value.value as string
            DataPersistence.getNumberArray(this.WordBookName,getContext(this)).then((value:number[])=>{
              this.WordsProgress = (value.length==0)?new Array(this.Words.length).fill(0):value
            })
            console.info("TextPickerDialog:onAccept()" + JSON.stringify(value))
          },
          onCancel: () => {
            console.info("TextPickerDialog:onCancel()")
          }
        })
      })
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