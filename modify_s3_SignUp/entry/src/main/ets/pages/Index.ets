/**
 * 实验三：注册界面的设计与实现
 *
 * 功能：
 * 1. 使用 Tabs 实现“密码注册 / 手机注册”选项卡布局；
 * 2. 使用 TextTimer 实现验证码倒计时；
 * 3. 使用 Navigation + NavPathStack 跳转到确认页，并传递注册信息。
 */
@Entry
@Component
struct Index {
  @State message: string = '发送验证码';
  @State userName: string = '';
  @State userPwd: string = '';
  @State userTel: string = '';
  @State verifyCode: string = '';
  @State currentIndex: number = 0;
  @State isCounting: boolean = false;

  private stackPath: NavPathStack = new NavPathStack();
  private timerController: TextTimerController = new TextTimerController();
  private readonly countdownSeconds: number = 60;
  private sentPhone: string = '';
  private sentCode: string = '';

  /**
   * 自定义选项卡标题：选中时显示蓝色文字和下划线。
   */
  @Builder
  tabBuilder(title: string, index: number) {
    Column() {
      Text(title)
        .fontSize(16)
        .fontColor(this.currentIndex === index ? '#3478F6' : '#8A8A8E')
        .fontWeight(this.currentIndex === index ? FontWeight.Medium : FontWeight.Regular)
      Divider()
        .width(24)
        .strokeWidth(3)
        .color(this.currentIndex === index ? '#3478F6' : Color.Transparent)
        .margin({ top: 8 })
    }
    .width('100%')
    .height(52)
    .justifyContent(FlexAlign.Center)
  }

  private showToast(message: string): void {
    try {
      this.getUIContext().getPromptAction().showToast({
        message: message,
        duration: 2000
      });
    } catch (error) {
      console.error(`showToast failed: ${error}`);
    }
  }

  private isPhoneValid(): boolean {
    return /^1\d{10}$/.test(this.userTel);
  }

  /**
   * 密码注册：校验后把 ["0", 用户名, 密码] 传给 MainPage。
   */
  private registerByPassword(): void {
    const name: string = this.userName.trim();
    if (name.length === 0) {
      this.showToast('请输入用户名');
      return;
    }
    if (this.userPwd.length < 6) {
      this.showToast('请输入至少 6 位密码');
      return;
    }
    this.stackPath.pushPathByName('MainPage', ['0', name, this.userPwd]);
  }

  /**
   * 手机注册：校验手机号和验证码后把 ["1", 手机号] 传给 MainPage。
   */
  private registerByPhone(): void {
    if (!this.isPhoneValid()) {
      this.showToast('请输入正确的 11 位手机号');
      return;
    }
    if (this.sentPhone.length === 0) {
      this.showToast('请先获取验证码');
      return;
    }
    if (this.sentPhone !== this.userTel) {
      this.showToast('手机号已变更，请重新获取验证码');
      return;
    }
    if (this.verifyCode !== this.sentCode) {
      this.showToast('验证码不正确');
      return;
    }
    this.stackPath.pushPathByName('MainPage', ['1', this.userTel]);
  }

  /**
   * 发送验证码并启动 60 秒倒计时。
   * 实验中没有短信服务，演示验证码固定为 1234，并通过 Toast 提示。
   */
  private sendVerifyCode(): void {
    if (this.isCounting) {
      return;
    }
    if (!this.isPhoneValid()) {
      this.showToast('请输入正确的 11 位手机号');
      return;
    }

    this.sentPhone = this.userTel;
    this.sentCode = '1234';
    this.isCounting = true;
    this.message = `已发送${this.countdownSeconds}s`;
    this.timerController.reset();
    this.timerController.start();
    this.showToast('验证码已发送，演示验证码：1234');
  }

  /**
   * TextTimer 使用 ss 格式时，elapsedTime 的最小单位为秒。
   */
  private onCountdownTick(elapsedTime: number): void {
    if (!this.isCounting) {
      return;
    }
    if (elapsedTime >= this.countdownSeconds) {
      this.isCounting = false;
      this.message = '再发送一次';
      this.timerController.pause();
      return;
    }
    const remain: number = this.countdownSeconds - elapsedTime;
    this.message = `已发送${remain}s`;
  }

  @Builder
  passwordForm() {
    Column({ space: 16 }) {
      TextInput({ placeholder: '请输入用户名' })
        .width('100%')
        .height(48)
        .fontSize(16)
        .fontColor('#182431')
        .placeholderColor('#A0A0A5')
        .backgroundColor('#F7F8FA')
        .borderRadius(8)
        .borderWidth(1)
        .borderColor('#E5E7EB')
        .padding({ left: 16, right: 16 })
        .onChange((value: string) => {
          this.userName = value;
        })

      TextInput({ placeholder: '请输入密码' })
        .type(InputType.Password)
        .showPasswordIcon(true)
        .width('100%')
        .height(48)
        .fontSize(16)
        .fontColor('#182431')
        .placeholderColor('#A0A0A5')
        .backgroundColor('#F7F8FA')
        .borderRadius(8)
        .borderWidth(1)
        .borderColor('#E5E7EB')
        .padding({ left: 16, right: 16 })
        .onChange((value: string) => {
          this.userPwd = value;
        })

      Button('注册')
        .type(ButtonType.Normal)
        .width('100%')
        .height(48)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
        .backgroundColor('#3478F6')
        .borderRadius(8)
        .onClick(() => {
          this.registerByPassword();
        })
    }
    .width('80%')
    .padding({ top: 36 })
  }

  @Builder
  phoneForm() {
    Column({ space: 16 }) {
      TextInput({ placeholder: '请输入手机号' })
        .type(InputType.PhoneNumber)
        .maxLength(11)
        .width('100%')
        .height(48)
        .fontSize(16)
        .fontColor('#182431')
        .placeholderColor('#A0A0A5')
        .backgroundColor('#F7F8FA')
        .borderRadius(8)
        .borderWidth(1)
        .borderColor('#E5E7EB')
        .padding({ left: 16, right: 16 })
        .onChange((value: string) => {
          this.userTel = value;
        })

      Row({ space: 10 }) {
        TextInput({ placeholder: '验证码' })
          .type(InputType.Number)
          .maxLength(4)
          .layoutWeight(1)
          .height(48)
          .fontSize(16)
          .fontColor('#182431')
          .placeholderColor('#A0A0A5')
          .backgroundColor('#F7F8FA')
          .borderRadius(8)
          .borderWidth(1)
          .borderColor('#E5E7EB')
          .padding({ left: 16, right: 16 })
          .onChange((value: string) => {
            this.verifyCode = value;
          })

        Button(this.message)
          .type(ButtonType.Normal)
          .width(120)
          .height(48)
          .fontSize(14)
          .fontColor(Color.White)
          .backgroundColor(this.isCounting ? '#A9C6FA' : '#3478F6')
          .borderRadius(8)
          .enabled(!this.isCounting)
          .onClick(() => {
            this.sendVerifyCode();
          })
      }
      .width('100%')

      Button('注册')
        .type(ButtonType.Normal)
        .width('100%')
        .height(48)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
        .backgroundColor('#3478F6')
        .borderRadius(8)
        .onClick(() => {
          this.registerByPhone();
        })

      // 计时器本身不显示，只把剩余秒数写入“发送验证码”按钮。
      TextTimer({ isCountDown: false, controller: this.timerController })
        .format('ss')
        .visibility(Visibility.None)
        .onTimer((utc: number, elapsedTime: number) => {
          this.onCountdownTick(elapsedTime);
        })
    }
    .width('80%')
    .padding({ top: 36 })
  }

  build() {
    Navigation(this.stackPath) {
      Tabs({ barPosition: BarPosition.Start }) {
        TabContent() {
          Column() {
            this.passwordForm()
          }
          .width('100%')
          .height('100%')
          .alignItems(HorizontalAlign.Center)
          .backgroundColor(Color.White)
        }
        .tabBar(this.tabBuilder('密码注册', 0))

        TabContent() {
          Column() {
            this.phoneForm()
          }
          .width('100%')
          .height('100%')
          .alignItems(HorizontalAlign.Center)
          .backgroundColor(Color.White)
        }
        .tabBar(this.tabBuilder('手机注册', 1))
      }
      .barMode(BarMode.Fixed)
      .barWidth('100%')
      .barHeight(52)
      .barBackgroundColor(Color.White)
      .divider({ strokeWidth: 0.5, color: '#EEEEEE' })
      .scrollable(false)
      .animationDuration(200)
      .onChange((index: number) => {
        this.currentIndex = index;
      })
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}
