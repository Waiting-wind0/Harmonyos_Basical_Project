@Entry
@Component
struct Index {
  @State message: string = '';
  @State telNo: string = '';
  @State telPwd: string = '';

  build() {
    Column() {
      TextInput({ placeholder: "请输入已验证手机" })
        .onChange((v) => {
          this.telNo = v
        })
        .borderRadius(0)
        .padding(10)
        .borderWidth(1)
        .borderColor("#ffaab0aa")
        .type(InputType.PhoneNumber).width("90%")
      TextInput({ placeholder: "请输入密码" })
        .type(InputType.Password)
        .onChange((value) => {
          this.telPwd = value
        })
        .borderRadius(0)
        .padding(10)
        .borderWidth(1)
        .borderColor("#ffaab0aa")
        .margin({ top: 15 }).width("90%")
      Text("忘记密码").width("90%").textAlign(TextAlign.End).fontColor(Color.Blue)
        .margin({ top: 5 })
      Button("登录")
        .width("90%")
        .type(ButtonType.Normal)
        .backgroundColor("#ff315858")
        .onClick(() => {
          this.message = `您输入的手机号：${this.telNo}\n您输入的密码：${this.telPwd}`
        })
      Text() {
        Span("还没有账号？")
        Span("立即注册->").fontColor(Color.Blue)
      }.margin({ top: 5, bottom: 5 })
      Text(this.message)
        .width("80%").borderWidth(1).borderColor("#ffaab0aa")
    }
    .padding(20)
    .height('100%')
    .width('100%')
    .backgroundColor("#ff9cd0b9")
  }
}
