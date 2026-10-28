# 实验三 注册界面的设计与实现

本工程是《实验三 注册界面的设计与实现》的完整 HarmonyOS ArkTS 实现，可直接用 DevEco Studio 打开。

## 功能说明

- **选项卡布局**：使用 `Tabs` + `TabContent` 实现“密码注册 / 手机注册”两个页签。
- **密码注册**：输入用户名和密码，校验通过后跳转到确认页。
- **手机注册**：输入 11 位手机号，点击“发送验证码”后启动 `TextTimer` 60 秒倒计时，按钮显示“已发送 Ns”，结束后变为“再发送一次”。
- **页面跳转**：使用 `Navigation` + `NavPathStack.pushPathByName`，把注册方式和注册信息传递给 `MainPage`。
- **路由配置**：`router_map.json` 注册 `MainPage`，`module.json5` 中通过 `routerMap` 引用。
- **信息确认**：`MainPage` 根据 `type` 参数显示密码注册或手机注册的对应信息。

> 本实验没有接入短信服务。获取验证码后，演示验证码固定为 **1234**，会通过 Toast 提示。

## 工程结构

```text
modify_s3_SignUp/
├── AppScope/
│   ├── app.json5
│   └── resources/base/
├── entry/
│   ├── build-profile.json5
│   ├── oh-package.json5
│   └── src/main/
│       ├── module.json5
│       ├── ets/
│       │   ├── entryability/EntryAbility.ets
│       │   └── pages/
│       │       ├── Index.ets        # 注册主页面：选项卡、表单、倒计时、跳转
│       │       └── MainPage.ets     # 信息确认页面：接收并显示参数
│       └── resources/base/
│           ├── element/             # 字符串、颜色等资源
│           ├── media/               # 应用图标
│           └── profile/
│               ├── main_pages.json
│               └── router_map.json  # MainPage 路由表
├── build-profile.json5
├── hvigorfile.ts
├── oh-package.json5
└── README.md
```

## 运行方法

1. 使用 **DevEco Studio 26.0.0** 打开本目录。
2. 等待工程同步完成。
3. 在 `File > Project Structure > Signing Configs` 中勾选自动签名（或选择本机已有调试签名）。
4. 选择 `entry` 模块，点击 Run。
5. 可使用以下数据体验：
   - 密码注册：用户名 `mainuser`，密码 `123456`。
   - 手机注册：手机号 `13901344004`，验证码 `1234`。

## 已完成的检查

- `hvigorw assembleHap` 编译通过，ArkTS 类型检查通过。
- 路由表 `router_map.json` 已被构建任务 `ProcessRouterMap` 处理。
- 工程未内置签名证书；运行前请按上面的步骤配置本机调试签名。

## 实现要点

### 1. 选项卡与表单

`Index.ets` 中分别用 `@Builder passwordForm()` 和 `@Builder phoneForm()` 组织两个页签的表单，外层用 `Tabs` 承载。

### 2. 验证码倒计时

`TextTimer` 使用 `ss` 格式，回调中的 `elapsedTime` 以秒为单位：

```ts
TextTimer({ isCountDown: false, controller: this.timerController })
  .format('ss')
  .visibility(Visibility.None)
  .onTimer((utc: number, elapsedTime: number) => {
    this.onCountdownTick(elapsedTime);
  })
```

`onCountdownTick` 根据已用时间计算剩余秒数并更新按钮文字，达到 60 秒后暂停计时。

### 3. 参数传递

密码注册传递 `["0", 用户名, 密码]`，手机注册传递 `["1", 手机号]`：

```ts
this.stackPath.pushPathByName('MainPage', ['0', name, this.userPwd]);
```

`MainPage` 在 `NavDestination.onReady` 中读取：

```ts
this.params = context.pathInfo.param as string[];
this.type = this.params[0];
```
