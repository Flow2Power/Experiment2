import { router } from '@kit.ArkUI'
import { webview } from '@kit.ArkWeb';

@Entry
@Component
struct Translation {
  WebController: webview.WebviewController = new webview.WebviewController();
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
          .width('80%')
      }
      .width('100%')
      .height('10%')
      .justifyContent(FlexAlign.End)
      Row(){
        Web({ src: `https://cn.bing.com/translator?ref=TThis&text=&from=en&to=zh-Hans`, controller: this.WebController })
          .width('95%')
          .height('95%')
      }
      .width("90%")
      .height("85%")
      .backgroundColor('#60eeeeee')
      .borderRadius(10)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.Background1'))
    .backgroundImageSize(ImageSize.Cover)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .backdropBlur(500)
    .gesture(SwipeGesture({direction: SwipeDirection.Horizontal})
      .onAction((event: GestureEvent)=>{
        console.log("模拟器SwipeGesture")
        router.back()
      }))
  }
}