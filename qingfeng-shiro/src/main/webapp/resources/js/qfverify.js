/**
 * Created by anxingtao on 2019-6-10.
 */
var form_verify = {
    pass: [/(.+){6,12}$/, '密码必须6到12位'],
    confirmPass:function(value){
        if($('#password').val() !== value)
            return '两次密码输入不一致！';
    },
    login_name: [/^[a-zA-Z0-9_]{0,}$/, '登录名不能含有中文或特殊字符'],
    newPass:[/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[^]{6,16}$/,"密码必须含有大写字母、小写字母、数字，账号长度应在6~16个字符之间"],
    required: [/[\S]+/, '必填项不能为空'],
    phone: [/(^$)|^1\d{10}$/, '请输入正确的手机号'],
    email: [/(^$)|^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/, '邮箱格式不正确'],
    url: [/(^$)|(^#)|(^http(s*):\/\/[^\s]+\.[^\s]+)/, '链接格式不正确'],
    number: [/(^$)|^\d+$/, '只能填写数字'],
    intNumber: [/(^$)|^[0-9]*$/, '只能填写整型数字'],
    date: [/(^$)|^(\d{4})[-\/](\d{1}|0\d{1}|1[0-2])([-\/](\d{1}|0\d{1}|[1-2][0-9]|3[0-1]))*$/, '日期格式不正确'],
    identity: [/(^$)|(^\d{15}$)|(^\d{17}(x|X|\d)$)/, '请输入正确的身份证号'],
    longitude:[/^-?(((\d|[1-9]\d|1[0-7]\d|0)\.\d{0,10})|(\d|[1-9]\d|1[0-7]\d|0{1,3})|180\.0{0,10}|180)$/i,'请输入正确的经度'],
    latitude:[/^-?([0-8]?\d{1}\.\d{0,10}|90\.0{0,10}|[0-8]?\d{1}|90)$/i,'请输入正确的纬度'],
    float:[/(^-?([1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0)$)|(^(\-|\+)?\d+(\.\d+)?$)/,'请输入正确的数值'],
    floatNonNegative:[/(^[1-9]\d*\.\d*|0\.\d*[1-9]\d*$)|(^[1-9]\d*|0$)/,'请输入非负的数值'],
    floats:function(value){
        if(value != null && value != ''){
            var str = /(^-?([1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0)$)|(^(\-|\+)?\d+(\.\d+)?$)/;
            if(!str.test(value)){
                return '请输入正确的数值';
            }
        }
    },
    lon_dfm:[/^[EW]?((\d|[1-9]\d|1[0-7]\d)[s\-,;°度](\d|[0-5]\d)[s\-,;′′’分](\d|[0-5]\d)(\.\d{1,2})?[s\-,;/"″”秒]?$)/,'请输入正确的经度'],
        lon_dfms: function(value) {
        if(value != null && value != ''){
            var str = /^[EW]?((\d|[1-9]\d|1[0-7]\d)[s\-,;°度](\d|[0-5]\d)[s\-,;′′’分](\d|[0-5]\d)(\.\d{1,2})?[s\-,;/"″”秒]?$)/;
            if(!str.test(value)){
                return '请输入正确的经度';
            }
        }
    },
    lat_dfm:[/^[EW]?((\d|[1-8]\d)[s\-,;°度](\d|[0-5]\d)[s\-,;′′’分](\d|[0-5]\d)(\.\d{1,2})?[s\-,;/"″”秒]?$)/,'请输入正确的纬度'],
        lat_dfms:function(value){
        if(value != null && value != ''){
            var str = /^[EW]?((\d|[1-8]\d)[s\-,;°度](\d|[0-5]\d)[s\-,;′′’分](\d|[0-5]\d)(\.\d{1,2})?[s\-,;/"″”秒]?$)/;
            if(!str.test(value)){
                return '请输入正确的纬度';
            }
        }
    },
    field_len_eq4: function(value){ if(value.length != 4){ return '长度为4个位字符，请重新输入'; } },
    field_len4: function(value){ if(value.length > 4){ return '长度不得大于4个字符'; } },
    field_len10: function(value){ if(value.length > 10){ return '长度不得大于10个字符'; } },
    field_len25: function(value){ if(value.length > 25){ return '长度不得大于25个字符'; } },
    field_len50: function(value){ if(value.length > 50){ return '长度不得大于50个字符'; } },
    field_len100: function(value){ if(value.length > 100){ return '长度不得大于100个字符'; } },
    field_len120: function(value){ if(value.length > 120){ return '长度不得大于120个字符'; } },
    field_len160: function(value){ if(value.length > 160){ return '长度不得大于160个字符'; } },
    field_len200: function(value){ if(value.length > 200){ return '长度不得大于200个字符'; } },
    field_len240: function(value){ if(value.length > 240){ return '长度不得大于240个字符'; } },
    field_len500: function(value){ if(value.length > 500){ return '长度不得大于500个字符'; } },
    field_len1200: function(value){ if(value.length > 1200){ return '长度不得大于1200个字符'; } },
    field_len5000: function(value){ if(value.length > 1200){ return '长度不得大于5000个字符'; } },
    intNumberNo0: [/(^$)|^[1-9]\d*$/, '只能填写整型数字'],
}