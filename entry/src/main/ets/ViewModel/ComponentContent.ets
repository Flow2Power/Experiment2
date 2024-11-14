export interface BuildSpeakerArgs {
  word: string;
  controller: WebviewController;
}
@Builder
export function BuildSpeaker(args: BuildSpeakerArgs){
  Column({space: 20}){
    Row() {
      Text('美')
        .fontColor(Color.White)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      Web({ src: `http://dict.youdao.com/dictvoice?type=2&audio=${args.word}`, controller: args.controller })
        .width("35%")
    }
    .width('95%')
    .height('40%')
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor(Color.Black)
    .borderRadius(20)
    Row() {
      Text('英')
        .fontColor(Color.White)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      Web({ src: `http://dict.youdao.com/dictvoice?type=1&audio=${args.word}`, controller: args.controller })
        .width("35%")
    }
    .width('95%')
    .height('40%')
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
}
