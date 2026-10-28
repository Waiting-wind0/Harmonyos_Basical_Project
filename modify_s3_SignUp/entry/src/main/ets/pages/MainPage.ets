/**
 * 注册信息确认页。
 *
 * 该页面通过 router_map.json 注册为名为 "MainPage" 的路由页面，
 * 由 Index 页面通过 NavPathStack.pushPathByName 打开并传递参数。
 */

@Builder
export function MainPageBuilder() {
  MainPage()
}

@Component
export struct MainPage {
  @State type: string = '0';
  @State params: string[] = [];

  private getParam(index: number): string {
    return index < this.params.length ? this.params[index] : '';
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Stack() {
          Text('✓')
            .fontSize(38)
            .fontWeight(FontWeight.Bold)
            .fontColor('#3478F6')
        }
        .width(72)
        .height(72)
        .backgroundColor('#EAF1FF')
        .borderRadius(36)
        .margin({ bottom: 8 })

        if (this.type === '0') {
          Text('你采用了密码注册方式')
            .fontSize(15)
            .fontColor('#6B7280')
          Text(`你输入的用户名：${this.getParam(1)}`)
            .fontSize(16)
            .fontColor('#182431')
          Text(`你输入的密码：${this.getParam(2)}`)
            .fontSize(16)
            .fontColor('#182431')
        } else {
          Text('你采用了手机注册方式')
            .fontSize(15)
            .fontColor('#6B7280')
          Text(`你的手机号：${this.getParam(1)}`)
            .fontSize(16)
            .fontColor('#182431')
        }
      }
      .width('100%')
      .height('100%')
      .padding({ top: 56, left: 32, right: 32 })
      .alignItems(HorizontalAlign.Center)
      .backgroundColor(Color.White)
    }
    .title('注册信息确认', { backgroundColor: Color.White })
    .backgroundColor(Color.White)
    .onReady((context: NavDestinationContext) => {
      this.params = context.pathInfo.param as string[];
      if (this.params.length > 0) {
        this.type = this.params[0];
      }
    })
  }
}
