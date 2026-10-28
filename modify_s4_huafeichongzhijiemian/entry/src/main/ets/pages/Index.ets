/**
 * 实验四：充话费页面的设计与实现
 *
 * 前端页面位于 resources/rawfile，使用 Web 组件加载；
 * 应用侧通过 javaScriptProxy 向前端注入 jsbridgeHandle 对象，
 * 前端点击默认联系人时调用 getContact() 获取联系人信息；
 * 应用侧通过 runJavaScript('recharge()') 调用前端充值函数并展示结果。
 */
import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';

class Contact {
  tel: string;
  name: string;

  constructor(tel: string, name: string) {
    this.tel = tel;
    this.name = name;
  }

  getContact(): string {
    return `${this.tel}_${this.name}`;
  }
}

@Entry
@Component
struct Index {
  private myContact: Contact = new Contact('12399939999', '李小红');
  private controller: webview.WebviewController = new webview.WebviewController();

  private showToast(message: string): void {
    try {
      this.getUIContext().getPromptAction().showToast({
        message: message,
        duration: 2500
      });
    } catch (error) {
      console.error(`showToast failed: ${error}`);
    }
  }

  private async recharge(): Promise<void> {
    try {
      const result: string = await this.controller.runJavaScript('recharge()');
      const message: string = result.replaceAll('"', '');
      this.showToast(message);
    } catch (error) {
      const err = error as BusinessError;
      console.error(`recharge failed: ${err.code}, ${err.message}`);
      this.showToast('充值失败，请重试');
    }
  }

  build() {
    Column() {
      Web({ src: $rawfile('index.html'), controller: this.controller })
        .javaScriptAccess(true)
        .javaScriptProxy({
          object: this.myContact,
          name: 'jsbridgeHandle',
          methodList: ['getContact'],
          controller: this.controller
        })
        .width('100%')
        .layoutWeight(1)

      Button('充值')
        .type(ButtonType.Normal)
        .width('90%')
        .height(48)
        .fontSize(18)
        .fontColor(Color.White)
        .backgroundColor('#007DFF')
        .borderRadius(24)
        .margin({ top: 12, bottom: 16 })
        .onClick(() => {
          this.recharge();
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}
