/**
 * Created by anxingtao on 2018-8-29.
 */
//设置单选、多选用户
function defineUser(ids_key,names_key){
    sessionStorage.setItem('ids', ids_key);
    sessionStorage.setItem('names', names_key);
}
//获取单选、多选用户
function getUser(ids,names){
    console.log("#"+names+"#");
    $("#"+ids).val(sessionStorage.getItem("ids"));
    $("#"+names).val(sessionStorage.getItem("names"));
    sessionStorage.removeItem("ids");
    sessionStorage.removeItem("names");
}

//获取单选、多选用户-自定义弹出
function getMUser(field_name,ids,names){
    console.log("#"+names+"#");
    $("#"+ids).val(sessionStorage.getItem("ids"));
    $("#"+names).val(sessionStorage.getItem("names"));
    if(sessionStorage.getItem("ids")!=''&&sessionStorage.getItem("ids")!=null){
        $("#"+field_name).val(sessionStorage.getItem("ids")+"#"+sessionStorage.getItem("names"));
    }else{
        $("#"+field_name).val("");
    }

    sessionStorage.removeItem("ids");
    sessionStorage.removeItem("names");
}


//设置单选、多选组织
function defineOrganize(ids_key,names_key){
    sessionStorage.setItem('ids', ids_key);
    sessionStorage.setItem('names', names_key);
}
//获取单选、多选组织
function getOrganize(ids,names){
    $("#"+ids).val(sessionStorage.getItem("ids"));
    $("#"+names).val(sessionStorage.getItem("names"));
    sessionStorage.removeItem("ids");
    sessionStorage.removeItem("names");
}


//获取单选、多选组织-自定义弹出
function getMOrg(field_name,ids,names){
    $("#"+ids).val(sessionStorage.getItem("ids"));
    $("#"+names).val(sessionStorage.getItem("names"));
    if(sessionStorage.getItem("ids")!=''&&sessionStorage.getItem("ids")!=null){
        $("#"+field_name).val(sessionStorage.getItem("ids")+"#"+sessionStorage.getItem("names"));
    }else{
        $("#"+field_name).val("");
    }
    sessionStorage.removeItem("ids");
    sessionStorage.removeItem("names");
}

//设置默认值
function setMrz(msg){
    sessionStorage.setItem('msg', msg);
}
//获取默认值
function getMrz(index){
    $("#field_value"+index).val(sessionStorage.getItem("msg"));
    sessionStorage.removeItem("msg");
}


//设置默认值
function setJsMrz(msg){
    sessionStorage.setItem('msg', msg);
}

//获取默认值
function getJsMrz(index){
    $("#field_value"+index).val(sessionStorage.getItem("msg"));
    sessionStorage.removeItem("msg");
}



//设置默认值
function setParam(param1,param2,param3,param4){
    sessionStorage.setItem('param1', param1);
    sessionStorage.setItem('param2', param2);
    sessionStorage.setItem('param3', param3);
    sessionStorage.setItem('param4', param4);
}
//获取默认值
function getParam(param1,param2,param3,param4){
    if(sessionStorage.getItem("param1")!=''&&sessionStorage.getItem("param1")!=null){
        $("#"+param1).val(sessionStorage.getItem("param1"));
    }
    if(sessionStorage.getItem("param2")!=''&&sessionStorage.getItem("param2")!=null){
        $("#"+param2).val(sessionStorage.getItem("param2"));
    }
    if(sessionStorage.getItem("param3")!=''&&sessionStorage.getItem("param3")!=null){
        $("#"+param3).val(sessionStorage.getItem("param3"));
    }
    if(sessionStorage.getItem("param4")!=''&&sessionStorage.getItem("param4")!=null){
        $("#"+param4).val(sessionStorage.getItem("param4"));
    }
    sessionStorage.removeItem("param1");
    sessionStorage.removeItem("param2");
    sessionStorage.removeItem("param3");
    sessionStorage.removeItem("param4");
}



function formatLonDegree(value) {///<summary>将度转换成为度分秒</summary>
    value = Math.abs(value);
    var v1 = Math.floor(value);//度
    var v2 = Math.floor((value - v1) * 60);//分
    var v3 = Math.round((value - v1) * 3600 % 60);//秒
    return 'E'+v1 + '°' + v2 + '\'' + v3 + '"';
};


function formatLatDegree(value) {///<summary>将度转换成为度分秒</summary>
    value = Math.abs(value);
    var v1 = Math.floor(value);//度
    var v2 = Math.floor((value - v1) * 60);//分
    var v3 = Math.round((value - v1) * 3600 % 60);//秒
    return 'N'+v1 + '°' + v2 + '\'' + v3 + '"';
};

function formatDegree(value) {///<summary>将度转换成为度分秒</summary>
    value = Math.abs(value);
    var v1 = Math.floor(value);//度
    var v2 = Math.floor((value - v1) * 60);//分
    var v3 = Math.round((value - v1) * 3600 % 60);//秒
    return v1 + '°' + v2 + '\'' + v3 + '"';
};



function DegreeConvertBack(value) { ///<summary>度分秒转换成为度</summary>
    var du = value.split("°")[0];
    var fen = value.split("°")[1].split("'")[0];
    var miao = value.split("°")[1].split("'")[1].split('"')[0];
    return Math.abs(du) + "." + (Math.abs(fen)/60 + Math.abs(miao)/3600);
}


//设置默认值
function setImportParam(param1,param2,param3,param4,param5,param6,param7,param8){
    sessionStorage.setItem('param1', param1);
    sessionStorage.setItem('param2', param2);
    sessionStorage.setItem('param3', param3);
    sessionStorage.setItem('param4', param4);
    sessionStorage.setItem('param5', param5);
    sessionStorage.setItem('param6', param6);
    sessionStorage.setItem('param7', param7);
    sessionStorage.setItem('param8', param8);
}
//获取默认值
function getImportParam(param1,param2,param3,param4,param5,param6,param7,param8){
    $("#"+param1).val(sessionStorage.getItem("param1"));
    $("#"+param2).val(sessionStorage.getItem("param2"));
    $("#"+param3).val(sessionStorage.getItem("param3"));
    $("#"+param4).val(sessionStorage.getItem("param4"));
    $("#"+param5).val(sessionStorage.getItem("param5"));
    $("#"+param6).val(sessionStorage.getItem("param6"));
    $("#"+param7).val(sessionStorage.getItem("param7"));
    $("#"+param8).val(sessionStorage.getItem("param8"));
    sessionStorage.removeItem("param1");
    sessionStorage.removeItem("param2");
    sessionStorage.removeItem("param3");
    sessionStorage.removeItem("param4");
    sessionStorage.removeItem("param5");
    sessionStorage.removeItem("param6");
    sessionStorage.removeItem("param7");
    sessionStorage.removeItem("param8");
}

//拖拽设置参数
function setDragMrz(param1,param2,param3,param4,param5,param6,param7,param8,param9){
    sessionStorage.setItem('param1', param1);
    sessionStorage.setItem('param2', param2);
    sessionStorage.setItem('param3', param3);
    sessionStorage.setItem('param4', param4);
    sessionStorage.setItem('param5', param5);
    sessionStorage.setItem('param6', param6);
    sessionStorage.setItem('param7', param7);
    sessionStorage.setItem('param8', param8);
    sessionStorage.setItem('param9', param9);
}

//拖拽参数获取
function getDragMrz(param1,param2,param3,param4,param5,param6,param7,param8,param9){
    $("#"+param1).val(sessionStorage.getItem("param1"));
    $("#"+param2).val(sessionStorage.getItem("param2"));
    $("#"+param3).val(sessionStorage.getItem("param3"));
    $("#"+param4).val(sessionStorage.getItem("param4"));
    $("#"+param5).val(sessionStorage.getItem("param5"));
    $("#"+param6).val(sessionStorage.getItem("param6"));
    $("#"+param7).val(sessionStorage.getItem("param7"));
    $("#"+param8).val(sessionStorage.getItem("param8"));
    $("#"+param9).val(sessionStorage.getItem("param9"));
    sessionStorage.removeItem("param1");
    sessionStorage.removeItem("param2");
    sessionStorage.removeItem("param3");
    sessionStorage.removeItem("param4");
    sessionStorage.removeItem("param5");
    sessionStorage.removeItem("param6");
    sessionStorage.removeItem("param7");
    sessionStorage.removeItem("param8");
    sessionStorage.removeItem("param9");
}



//设置默认值
function setParam5(param1,param2,param3,param4,param5){
    sessionStorage.setItem('param1', param1);
    sessionStorage.setItem('param2', param2);
    sessionStorage.setItem('param3', param3);
    sessionStorage.setItem('param4', param4);
    sessionStorage.setItem('param5', param5);
}
//获取默认值
function getParam5(param1,param2,param3,param4,param5){
    $("#"+param1).val(sessionStorage.getItem("param1"));
    $("#"+param2).val(sessionStorage.getItem("param2"));
    $("#"+param3).val(sessionStorage.getItem("param3"));
    $("#"+param4).val(sessionStorage.getItem("param4"));
    $("#"+param5).val(sessionStorage.getItem("param5"));
    sessionStorage.removeItem("param1");
    sessionStorage.removeItem("param2");
    sessionStorage.removeItem("param3");
    sessionStorage.removeItem("param4");
    sessionStorage.removeItem("param5");
}


//给js数组对象原型加indexof方法 获得元素索引
Array.prototype.indexOf = function(val) {
    for (var i = 0; i < this.length; i++) {
        if (this[i] == val) return i;
    }
    return -1;
};
//给js数组对象原型加remove方法 去掉元素
Array.prototype.remove = function(val) {
    var index = this.indexOf(val);
    if (index > -1) {
        this.splice(index, 1);
    }
};


//设置默认值
function setOpenCloseParam(param1){
    sessionStorage.setItem('openCloseParam', param1);
}
//获取默认值
function getOpenCloseParam(){
    var val = sessionStorage.getItem("openCloseParam");
    sessionStorage.removeItem("openCloseParam");
    return val;
}


function clearParam(){
    var exclude = $("#clearSearchParam").attr("exclude");//排除不清理的内容
    $("#search input").each(function(){
        if(exclude.indexOf($(this).attr("id"))==-1&&$(this).attr("id")!=undefined){
            $(this).val("");
        }
    });

    $("#search select").each(function(){
        if(exclude.indexOf($(this).attr("id"))==-1&&$(this).attr("id")!=undefined){
            $(this).val("");
        }
    });
    form.render();
}


function openAndCloseLeft(table_id) {
    if ($('#leftDiv').is(':hidden')) {//如果当前隐藏
        $('#leftDiv').show();//那么就显示div
        $("#rightDiv").width("80%");
    } else {//否则
        $('#leftDiv').hide();//就隐藏div
        $("#rightDiv").width("100%");
    }
    table.resize(table_id);
}


function openAndCloseLeft83(table_id) {
    if ($('#leftDiv').is(':hidden')) {//如果当前隐藏
        $('#leftDiv').show();//那么就显示div
        $("#rightDiv").width("83%");
    } else {//否则
        $('#leftDiv').hide();//就隐藏div
        $("#rightDiv").width("100%");
    }
    table.resize(table_id);
}


Date.prototype.Format = function (fmt) {
    var o = {
        "M+": this.getMonth() + 1, // 月份
        "d+": this.getDate(), // 日
        "h+": this.getHours(), // 小时
        "m+": this.getMinutes(), // 分
        "s+": this.getSeconds(), // 秒
        "q+": Math.floor((this.getMonth() + 3) / 3), // 季度
        "S": this.getMilliseconds() // 毫秒
    };
    if (/(y+)/.test(fmt))
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + ""));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}