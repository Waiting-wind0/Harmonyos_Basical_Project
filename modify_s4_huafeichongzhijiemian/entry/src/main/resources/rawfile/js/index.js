//初始化充值金额
const chargeAmount = [10, 20, 30, 50, 100, 200, 300, 500, 1000];

//获取页面所有网格
let allGridItem = document.getElementsByClassName('grid-item');
let amount = null;

// 按网格显示充值金额并绑定点击事件
for (let i = 0; i < allGridItem.length; i++) {
    allGridItem[i].innerHTML = chargeAmount[i] + '元';
    allGridItem[i].onclick = function () {
        amount = chargeAmount[i];
        for (let i = 0; i < allGridItem.length; i++) {
            allGridItem[i].classList.remove('selected');
        }
        event.target.classList.add('selected');
    }
}

//分隔电话号码（3-4-4格式）
function splitPhone(phone) {
    let regex = /(\d{3})(\d{4})(\d{4})/;
    let result = phone.replace(regex, function () {
        return RegExp.$1 + " " + RegExp.$2 + " " + RegExp.$3;
    });
    return result;
}

//获取默认联系人信息
function defaultContact() {
    let data = jsbridgeHandle.getContact() //调用应用侧函数
    const phone = data.split('_')[0];
    const name = data.split('_')[1];
    const result = splitPhone(phone);
    document.getElementById('phone_tip').innerHTML = name;
    document.getElementById('phone').value = result;
}

//输入待充值手机号码
function changeVal() {
    let input = event.target.value;
    let name = document.getElementById('phone_tip').innerHTML;
    const tel = document.getElementById('phone').value;
    if (name !== '请输入手机号' && input.length < 13) {
        document.getElementById('phone_tip').innerHTML = '请输入手机号';
    }
    let result = input;
    let phoneNumber = input.replace(/\D/g, '').slice(0, 11);
    result = phoneNumber.replace(/(\d{3})(\d{4})(\d{1,4})/, '$1 $2 $3');
    event.target.value = result;
}

//充值
function recharge() {
    if (amount == null) {
        return '请选择充值金额';
    }
    let success = document.getElementById('phone').value + `：成功充值${amount}元！`
    let failure = '请输入正确的手机号'
    return document.getElementById('phone').value.length === 13 ? success : failure;
}