import { promptAction, router } from '@kit.ArkUI'
import { DataPersistence } from '../Model/DataPersistence'
import JsonFileManager from '../Model/JsonFileManager'
import { WordInfo } from '../Model/WordInfo'

@Entry
@Component
struct Index {
  @StorageLink('WordsFavorite') WordsFavorite: number[]=[]
  @StorageLink('Words') Words: WordInfo[]=[]
  @StorageLink('WordBookName') WordBookName: string=''
  @StorageLink('WordsProgress') WordsProgress: number[]=[]
  @State LearnNum: number=0
  @State ReviewNum: number=0
  aboutToAppear(): void {
    console.log("模拟器Index aboutToAppear")
    DataPersistence.getWordBookName(getContext(this)).then((value:string)=>{
      this.WordBookName = value
      console.log("模拟器WordBookName",this.WordBookName)
      this.Words = JsonFileManager.GetWordsData(this.WordBookName+'.json',this)
      DataPersistence.getNumberArray(this.WordBookName,getContext(this)).then((value:number[])=>{
        this.WordsProgress = (value.length==0)?new Array(this.Words.length).fill(0):value
        this.LearnNum=this.WordsProgress.filter(item=>item==0).length
        this.ReviewNum=this.WordsProgress.filter(item=>item==1).length
        console.log("模拟器WordsProgress",this.WordsProgress)
      })
      DataPersistence.getNumberArray(this.WordBookName+'Favorite',getContext(this)).then((value:number[])=>{
        this.WordsFavorite = value
        console.log("模拟器WordsFavorite",this.WordsFavorite)
      })
    })
  }
  onPageShow(): void {
    console.log("模拟器Index onPageShow")
    this.LearnNum=this.WordsProgress.filter(item=>item==0).length
    this.ReviewNum=this.WordsProgress.filter(item=>item==1).length
  }
  build() {
    Column(){
      Text("The Brave")
        .width('100%')
        .height('55%')
        .fontSize(40)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
      Row(){
        Column(){
          Text("Learn")
            .fontSize(25)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .margin({left: '15%', top: '5%'})
          Text(`${this.LearnNum}`)
            .fontSize(20)
            .fontColor('#175d7e')
            .textAlign(TextAlign.Center)
            .margin({left: '15%',bottom: '5%'})
        }
        .width('45%')
        .height('50%')
        .backgroundColor('#60eeeeee')
        .borderRadius(10)
        .alignItems(HorizontalAlign.Start)
        .onClick(()=>{
          router.pushUrl({
            url: 'pages/Learn'
          })
          console.log("模拟器Learn1 Clicked")
        })
        Column(){
          Text("Review")
            .fontSize(25)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .margin({left: '15%', top: '5%'})
          Text(`${this.ReviewNum}`)
            .fontSize(20)
            .fontColor('#175d7e')
            .textAlign(TextAlign.Center)
            .margin({left: '15%',bottom: '5%'})
        }
        .width('45%')
        .height('50%')
        .backgroundColor('#60eeeeee')
        .borderRadius(10)
        .alignItems(HorizontalAlign.Start)
        .onClick(()=>{
          if(this.ReviewNum==0){
            promptAction.showToast({
              message:'没有需要复习的单词了，开始今天的学习吧！',
              duration: 2000
            });
          }
          else{
            router.pushUrl({
              url: 'pages/Review'
            })
          }
          console.log("模拟器Review1 Clicked")
        })
      }
      .width('100%')
      .height('20%')
      .justifyContent(FlexAlign.SpaceEvenly)
      Row(){
        SymbolGlyph($r('sys.symbol.ear'))
          .fontColor([Color.White])
          .fontSize(35)
          .onClick(()=>{
            console.log("模拟器Dictation Clicked")
            if(this.WordsFavorite.length==0){
              promptAction.showToast({
                message:'没有收藏的单词，快去收藏吧！',
                duration: 2000
              });
            }
            else{
              router.pushUrl({
                url: 'pages/Dictation'
              })
            }
          })
        SymbolGlyph($r('sys.symbol.pencil_waveform'))
          .fontColor([Color.White])
          .fontSize(35)
          .onClick(()=>{
            console.log("模拟器Spelling Clicked")
            if(this.WordsFavorite.length==0){
              promptAction.showToast({
                message:'没有收藏的单词，快去收藏吧！',
                duration: 2000
              });
            }
            else{
              router.pushUrl({
                url: 'pages/Spelling'
              })
            }
          })
        SymbolGlyph($r('sys.symbol.calendar'))
          .fontColor([Color.White])
          .fontSize(35)
          .onClick(()=>{
            console.log("模拟器Stats Clicked")
            router.pushUrl({
              url: 'pages/Stats'
            })
          })
      }
      .width('90%')
      .height('10%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.Background1'))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.End)
    .gesture(SwipeGesture({direction: SwipeDirection.Horizontal})
      .onAction((event: GestureEvent)=>{
        console.log("模拟器SwipeGesture")
        router.pushUrl({
          url: 'pages/Translation'
        })
      }))
  }
}