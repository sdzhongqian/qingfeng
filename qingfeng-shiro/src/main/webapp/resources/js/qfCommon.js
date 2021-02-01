/**
 * Created by anxingtao on 2020-9-23.
 */

/*-----------------------日期时间控件----------------------------*/
//初始化日期
function initDateType(id,initData){
    if(initData){
        laydate.render({
            elem: '#'+ id
            ,format: 'yyyy-MM-dd' //可任意组合
            ,value: new Date()
            ,isInitValue:true
            ,type: 'date' //默认，可不填
        });
    }else{
        laydate.render({
            elem: '#'+ id
            ,format: 'yyyy-MM-dd' //可任意组合
            ,isInitValue:true
            ,type: 'date' //默认，可不填
        });
    }
}

//初始化日期时间
function initDateTimeType(id,initData){
    if(initData){
        laydate.render({
            elem: '#'+ id
            ,value: new Date()
            ,isInitValue:true
            ,type: 'datetime' //默认，可不填
        });
    }else{
        laydate.render({
            elem: '#'+ id
            ,isInitValue:true
            ,type: 'datetime' //默认，可不填
        });
    }
}

//初始化时间
function initTimeType(id,initData){
    if(initData){
        laydate.render({
            elem: '#'+ id
            ,value: new Date()
            ,isInitValue:true
            ,type: 'time' //默认，可不填
        });
    }else{
        laydate.render({
            elem: '#'+ id
            ,isInitValue:true
            ,type: 'time' //默认，可不填
        });
    }
}


function dateDestroy(id){
    var inputDate = $("#"+id).clone(true);
    $(inputDate).removeAttr("lay-key");
    $("#"+id).after(inputDate);
    $("#"+id).remove();
}


function initDatetimePeriod(sId,eId){
    //设置时间
    var startDate= laydate.render({//渲染开始时间选择
        elem: '#'+sId//通过id绑定html中插入的start
        , type: 'datetime'
        ,max:"2099-12-31 00:00:00"//设置一个默认最大值
        ,
        done: function (value, dates) {
            if(value!=''){
                endDate.config.min ={
                    year:dates.year,
                    month:dates.month-1, //关键
                    date: dates.date,
                    hours: dates.hours,
                    minutes: dates.minutes,
                    seconds : dates.seconds
                };
            }else{
                endDate.config.min ={
                    year:'1970',
                    month:'1', //关键
                    date: '1',
                    hours: '00',
                    minutes: '00',
                    seconds : '00'
                };
            }
        }
    });
    var endDate= laydate.render({//渲染结束时间选择
        elem: '#'+eId,//通过id绑定html中插入的end
        type: 'datetime',
        min:"1970-1-1 00:00:00",//设置min默认最小值
        done: function (value, dates) {
            if(value!=''){
                startDate.config.max={
                    year:dates.year,
                    month:dates.month-1,//关键
                    date: dates.date,
                    hours: dates.hours,
                    minutes: dates.minutes,
                    seconds : dates.seconds
                }
            }else{
                startDate.config.max={
                    year:'2099',
                    month:'12',//关键
                    date: '31',
                    hours: '00',
                    minutes: '00',
                    seconds : '00'
                }
            }
        }
    });
}


function initDatePeriod(sId,eId){
    //设置时间
    var startDate= laydate.render({//渲染开始时间选择
        elem: '#'+sId//通过id绑定html中插入的start
        , type: 'date'
        ,max:"2099-12-31"//设置一个默认最大值
        ,
        done: function (value, dates) {
            if(value!='') {
                endDate.config.min = {
                    year: dates.year,
                    month: dates.month - 1, //关键
                    date: dates.date,
                    hours: 0,
                    minutes: 0,
                    seconds: 0
                };
            }else{
                endDate.config.min = {
                    year: '1970',
                    month: '1', //关键
                    date: '1',
                    hours: 0,
                    minutes: 0,
                    seconds: 0
                };
            }
        }
    });
    var endDate= laydate.render({//渲染结束时间选择
        elem: '#'+eId,//通过id绑定html中插入的end
        type: 'date',
        min:"1970-1-1",//设置min默认最小值
        done: function (value, dates) {
            if(value!='') {
                startDate.config.max = {
                    year: dates.year,
                    month: dates.month - 1,//关键
                    date: dates.date,
                    hours: 0,
                    minutes: 0,
                    seconds: 0
                }
            }else{
                startDate.config.max = {
                    year: '2099',
                    month: '12',//关键
                    date: '31',
                    hours: 0,
                    minutes: 0,
                    seconds: 0
                }
            }
        }
    });
}

function initYear(id,val){
    laydate.render({
        elem: '#'+id
        ,format: 'yyyy' //可任意组合
        ,value: val
        ,isInitValue:true
        ,type: 'year' //默认，可不填
    });
}


function initYearPeriod(sId,eId,sVal,eVal){
    //设置时间
    var startDate= laydate.render({//渲染开始时间选择
        elem: '#'+sId//通过id绑定html中插入的start
        , type: 'year'
        ,value: sVal
        ,max:"2099"//设置一个默认最大值
        ,
        done: function (value, dates) {
            endDate.config.min ={
                year:dates.year
            };
        }
    });
    var endDate= laydate.render({//渲染结束时间选择
        elem: '#'+eId,//通过id绑定html中插入的end
        type: 'year'
        ,value: eVal,
        min:"1970",//设置min默认最小值
        done: function (value, dates) {
            startDate.config.max={
                year:dates.year
            }
        }
    });
}


function initMonth(id,initData){
    if(initData){
        laydate.render({
            elem: '#'+id
            ,format: 'yyyy-MM' //可任意组合
            ,value: new Date()
            ,isInitValue:true
            ,type: 'month' //默认，可不填
        });
    }else{
        laydate.render({
            elem: '#'+id
            ,format: 'yyyy-MM' //可任意组合
            ,isInitValue:true
            ,type: 'month' //默认，可不填
        });
    }
}


function initMonthPeriod(sId,eId,sVal,eVal){
    //设置时间
    var startDate= laydate.render({//渲染开始时间选择
        elem: '#'+sId//通过id绑定html中插入的start
        ,format: 'yyyy-MM' //可任意组合
        ,type: 'month' //默认，可不填
        ,value: sVal
        ,max:"2099-12"//设置一个默认最大值
        ,
        done: function (value, dates) {
            if(value!='') {
                endDate.config.min = {
                    year: dates.year,
                    month: dates.month - 1, //关键
                };
            }else{
                endDate.config.min = {
                    year: '1970',
                    month: '01', //关键
                };
            }
        }
    });
    var endDate= laydate.render({//渲染结束时间选择
        elem: '#'+eId,//通过id绑定html中插入的end
        format: 'yyyy-MM', //可任意组合
        type: 'month', //默认，可不填
        value: eVal,
        min:"1970-01",//设置min默认最小值
        done: function (value, dates) {
            if(value!='') {
                startDate.config.max = {
                    year: dates.year,
                    month: dates.month - 1,//关键
                }
            }else{
                startDate.config.max = {
                    year: '2099',
                    month: '12',//关键
                }
            }
        }
    });
}


function rangeMonth(id){
    //年月范围选择
    laydate.render({
        elem: '#'+id
        ,type: 'month'
        ,range: '~' //或 range: '~' 来自定义分割字符
    });
}


function rangeMonthDownEven(id) {
    //年月范围选择
    laydate.render({
        elem: '#' + id
        , type: 'month'
        , range: '~' //或 range: '~' 来自定义分割字符
        , done: function (value, date) {//value, date, endDate点击日期、清空、现在、确定均会触发。回调返回三个参数，分别代表：生成的值、日期时间对象、结束的日期时间对象
            initRangeMonthDownEven(id, value, date);
        }
    });
}


/*-----------------------判断是否是整数----------------------------*/

function isInteger(obj) {
    return typeof obj === 'number' && obj%1 === 0
}

String.prototype.replaceAll = function(s1, s2) {
    return this.replace(new RegExp(s1, "gm"), s2);
}
