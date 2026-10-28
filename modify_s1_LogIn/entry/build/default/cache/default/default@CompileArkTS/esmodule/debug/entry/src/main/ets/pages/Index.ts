if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Index_Params {
    message?: string;
    telNo?: string;
    telPwd?: string;
}
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__message = new ObservedPropertySimplePU('', this, "message");
        this.__telNo = new ObservedPropertySimplePU('', this, "telNo");
        this.__telPwd = new ObservedPropertySimplePU('', this, "telPwd");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Index_Params) {
        if (params.message !== undefined) {
            this.message = params.message;
        }
        if (params.telNo !== undefined) {
            this.telNo = params.telNo;
        }
        if (params.telPwd !== undefined) {
            this.telPwd = params.telPwd;
        }
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__message.purgeDependencyOnElmtId(rmElmtId);
        this.__telNo.purgeDependencyOnElmtId(rmElmtId);
        this.__telPwd.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__message.aboutToBeDeleted();
        this.__telNo.aboutToBeDeleted();
        this.__telPwd.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __message: ObservedPropertySimplePU<string>;
    get message() {
        return this.__message.get();
    }
    set message(newValue: string) {
        this.__message.set(newValue);
    }
    private __telNo: ObservedPropertySimplePU<string>;
    get telNo() {
        return this.__telNo.get();
    }
    set telNo(newValue: string) {
        this.__telNo.set(newValue);
    }
    private __telPwd: ObservedPropertySimplePU<string>;
    get telPwd() {
        return this.__telPwd.get();
    }
    set telPwd(newValue: string) {
        this.__telPwd.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.padding(20);
            Column.height('100%');
            Column.width('100%');
            Column.backgroundColor("#ff9cd0b9");
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TextInput.create({ placeholder: "请输入已验证手机" });
            TextInput.onChange((v) => {
                this.telNo = v;
            });
            TextInput.borderRadius(0);
            TextInput.padding(10);
            TextInput.borderWidth(1);
            TextInput.borderColor("#ffaab0aa");
            TextInput.type(InputType.PhoneNumber);
            TextInput.width("90%");
        }, TextInput);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TextInput.create({ placeholder: "请输入密码" });
            TextInput.type(InputType.Password);
            TextInput.onChange((value) => {
                this.telPwd = value;
            });
            TextInput.borderRadius(0);
            TextInput.padding(10);
            TextInput.borderWidth(1);
            TextInput.borderColor("#ffaab0aa");
            TextInput.margin({ top: 15 });
            TextInput.width("90%");
        }, TextInput);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create("忘记密码");
            Text.width("90%");
            Text.textAlign(TextAlign.End);
            Text.fontColor(Color.Blue);
            Text.margin({ top: 5 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel("登录");
            Button.width("90%");
            Button.type(ButtonType.Normal);
            Button.backgroundColor("#ff315858");
            Button.onClick(() => {
                this.message = `您输入的手机号：${this.telNo}\n您输入的密码：${this.telPwd}`;
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create();
            Text.margin({ top: 5, bottom: 5 });
        }, Text);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Span.create("还没有账号？");
        }, Span);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Span.create("立即注册->");
            Span.fontColor(Color.Blue);
        }, Span);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.message);
            Text.width("80%");
            Text.borderWidth(1);
            Text.borderColor("#ffaab0aa");
        }, Text);
        Text.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    public __resetStateVarsOnReuse__Internal(params: Object): void {
    }
    static getEntryName(): string {
        return "Index";
    }
}
registerNamedRoute(() => new Index(undefined, {}), "", { bundleName: "com.example.myapplication", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
