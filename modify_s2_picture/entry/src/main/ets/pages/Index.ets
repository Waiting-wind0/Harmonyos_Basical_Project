import { common } from '@kit.AbilityKit';

@Entry
@Component
struct App02 {
  private images: string[] = ['/img/p1.jpg', '/img/p2.jpg', '/img/p3.jpg', '/img/p4.jpg',
    '/img/p5.jpg', '/img/p6.jpg', '/img/p7.jpg'];
  @State index: number = 0;

  private turnPage(offsetX: number): void {
    if (offsetX === 0) {
      return;
    }
    const step: number = offsetX > 0 ? -1 : 1;
    this.index = (this.index + step + this.images.length) % this.images.length;
  }

  build() {
    Stack() {
      Image(this.images[this.index])
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .draggable(false)
        .gesture(
          PanGesture({ direction: PanDirection.Left | PanDirection.Right })
            .onActionEnd((event: GestureEvent) => {
              this.turnPage(event.offsetX);
            })
        )

      Button('退出')
        .type(ButtonType.Normal)
        .opacity(0.5)
        .margin({ right: 24, bottom: 24 })
        .onClick(() => {
          const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
          context.terminateSelf();
        })
    }
    .alignContent(Alignment.BottomEnd)
    .width('100%')
    .height('100%')
  }
}