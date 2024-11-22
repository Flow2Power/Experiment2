import router from '@ohos.router'

@Entry
@Component
struct Splash {

  aboutToAppear() {
    setTimeout(()=> {
      router.replaceUrl({ url: 'pages/Index'});
    }, 3000)
  }

  build() {
    Column(){
      Text("Frieren")
        .width('100%')
        .height('55%')
        .fontSize(40)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
      Row().height('30%')
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.MyStartIcon2'))
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.End)
  }
}