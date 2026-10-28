# 实验四 充话费页面的设计与实现

本工程是《实验四 充话费页面的设计与实现》的完整 HarmonyOS ArkTS 实现，使用 `Web` 组件加载本地前端页面，并通过 JavaScript 桥接实现应用侧与前端页面的双向调用。

## 功能说明

- **加载前端页面**：`entry/src/main/resources/rawfile` 中保存 `index.html`、`css`、`img`、`js`，通过 `$rawfile('index.html')` 加载。
- **默认联系人**：应用侧定义 `Contact` 类，保存李小红和手机号 `12399939999`，通过 `javaScriptProxy` 注册为 `jsbridgeHandle`。前端点击联系人图标时调用 `getContact()`，显示姓名并填入手机号。
- **金额选择**：前端 JS 初始化 10、20、30、50、100、200、300、500、1000 元九个金额，选中项显示蓝色高亮。
- **手机号格式化**：输入时只保留数字，限制 11 位，并按 `3-4-4` 格式显示。
- **充值**：应用侧点击“充值”按钮后调用 `runJavaScript('recharge()')`，由前端校验金额和手机号并返回结果，应用侧通过 Toast 显示。
- **错误提示**：手机号不足时显示“请输入正确的手机号”，未选择金额时显示“请选择充值金额”。

## 工程结构

```text
modify_s4_huafeichongzhijiemian/
├── AppScope/
├── entry/
│   ├── build-profile.json5
│   ├── oh-package.json5
│   └── src/main/
│       ├── module.json5
│       ├── ets/
│       │   ├── entryability/EntryAbility.ets
│       │   └── pages/Index.ets       # Web 组件、JS 代理、充值调用
│       └── resources/
│           ├── base/
│           └── rawfile/
│               ├── index.html
│               ├── css/main.css
│               ├── img/ic_contacts.svg
│               └── js/index.js
├── build-profile.json5
├── hvigorfile.ts
├── oh-package.json5
└── README.md
```

## 运行方法

1. 使用 **DevEco Studio 26.0.0** 打开本目录，等待工程同步完成。
2. 在 `File > Project Structure > Signing Configs` 中配置自动签名或本机调试签名。
3. 选择 `entry` 模块，点击 Run。
4. 点击手机号输入框右侧的联系人图标，载入默认联系人；选择充值金额后点击“充值”查看 Toast 结果。

测试数据：

- 默认联系人：李小红，`123 9993 9999`
- 充值金额示例：`500 元`
- 成功提示：`123 9993 9999：成功充值500元！`

## 已完成的检查

- `hvigorw assembleHap` 编译通过，ArkTS 类型检查通过。
- 生成的 unsigned HAP 已在 Mate 90 Pro 模拟器中安装并运行，验证了页面加载、默认联系人、金额选择、充值成功和手机号不足提示。
- 工程未内置签名证书；正式运行前请配置本机调试签名。

## 实现要点

应用侧通过 `javaScriptProxy` 向前端注册对象：

```ts
Web({ src: $rawfile('index.html'), controller: this.controller })
  .javaScriptAccess(true)
  .javaScriptProxy({
    object: this.myContact,
    name: 'jsbridgeHandle',
    methodList: ['getContact'],
    controller: this.controller
  })
```

应用侧调用前端函数：

```ts
const result: string = await this.controller.runJavaScript('recharge()');
this.showToast(result.replaceAll('"', ''));
```

`runJavaScript()` 返回带引号的字符串，因此展示前去掉双引号。前端页面中的 `defaultContact()` 会调用 `jsbridgeHandle.getContact()`，`recharge()` 根据金额和手机号返回成功或错误信息。
