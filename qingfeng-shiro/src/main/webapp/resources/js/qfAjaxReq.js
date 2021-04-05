/**
 * Created by anxingtao on 2019-3-13.
 */
var prefix = $("#ctxValue").val();
//查询省份
function findAddress(parent_id,show_id,value){
    $.ajax({
        type: "GET",//方法类型
        dataType: "json",//预期服务器返回的数据类型
        url: prefix+"/system/area/findList?parent_id="+parent_id,//url
        data: "",
        success: function (res) {
            if (res.success) {
                var tt = '<option value="">请选择</option>';
                $.each(res.data,function(i,n){
                    if(value== n.id){
                        tt += '<option value="'+ n.id+'" selected>'+ n.name+'</option>';
                    }else{
                        tt += '<option value="'+ n.id+'">'+ n.name+'</option>';
                    }
                });
                $("#"+show_id).html(tt);
                form.render('select');
            }else{
                if(res.loseSession=='loseSession'){
                    loseSession(res.msg,res.url);
                }else{
                    layer.msg(res.msg, {time: 2000});
                }
            }
        },
        error : function() {
            layer.msg("异常！");
        }
    });
}


//查询Select字典项
function findSelectDictionary(parent_id,show_id,value){
    $.ajax({
        type: "GET",//方法类型
        dataType: "json",//预期服务器返回的数据类型
        url: prefix+"/system/dictionary/findList?parent_id="+parent_id,//url
        data: "",
        success: function (res) {
            if (res.success) {
                var tt = '<option value="">请选择</option>';
                $.each(res.data,function(i,n){
                    if(value== n.id || value== n.code){
                        tt += '<option value="'+ n.id+'" selected>'+ n.name+'</option>';
                    }else{
                        tt += '<option value="'+ n.id+'">'+ n.name+'</option>';
                    }
                });
                $("#"+show_id).html(tt);
                form.render();
            }else{
                if(res.loseSession=='loseSession'){
                    loseSession(res.msg,res.url);
                }else{
                    layer.msg(res.msg, {time: 2000});
                }
            }
        },
        error : function() {
            layer.msg("异常！");
        }
    });
}


//查询Checkbox字典项
function findCheckboxDictionary(parent_code,show_prefix,show_id,value){
    $.ajax({
        type: "GET",//方法类型
        dataType: "json",//预期服务器返回的数据类型
        url: prefix+"/system/dictionary/findList?parent_code="+parent_code,//url
        data: "",
        success: function (res) {
            if (res.success) {
                var tt = '';
                $.each(res.data,function(i,n){
                    if(value.indexOf(n.id)!=-1||value.indexOf(n.code)!=-1){
                        tt += '<input type="checkbox" checked name="'+show_prefix+show_id+'"  lay-filter="checkField" value="'+ n.id+'" lay-skin="primary" title="'+ n.name+'">';
                    }else{
                        tt += '<input type="checkbox" name="'+show_prefix+show_id+'"  lay-filter="checkField" value="'+ n.id+'" lay-skin="primary" title="'+ n.name+'">';
                    }
                });
                console.log(tt);
                $("#"+show_prefix+show_id).html(tt);
                form.render();
            }else{
                if(res.loseSession=='loseSession'){
                    loseSession(res.msg,res.url);
                }else{
                    layer.msg(res.msg, {time: 2000});
                }
            }
        }
    });
}


//查询Radio字典项
function findRadioDictionary(parent_code,show_prefix,show_id,value){
    var child_prefix = '';
    if(show_prefix.indexOf('-1-')!=-1){
        child_prefix = 'child_';
    }
    $.ajax({
        type: "GET",//方法类型
        dataType: "json",//预期服务器返回的数据类型
        url: prefix+"/system/dictionary/findList?parent_code="+parent_code,//url
        data: "",
        success: function (res) {
            if (res.success) {
                var tt = '';
                $.each(res.data,function(i,n){
                    if(value== n.id || value== n.code){
                        tt += '<input type="radio" checked name="'+child_prefix+show_id+'" value="'+ n.id+'" title="'+ n.name+'">';
                    }else{
                        tt += '<input type="radio" name="'+child_prefix+show_id+'" value="'+ n.id+'" title="'+ n.name+'">';
                    }
                });
                console.log(tt);
                $("#"+show_prefix+show_id).html(tt);
                form.render();
            }else{
                if(res.loseSession=='loseSession'){
                    loseSession(res.msg,res.url);
                }else{
                    layer.msg(res.msg, {time: 2000});
                }
            }
        }
    });
}


function findValueDictionary(show_id,value){
    $.ajax({
        type: "GET",//方法类型
        dataType: "json",//预期服务器返回的数据类型
        url: prefix+"/system/dictionary/findInfoJson?id="+value,//url
        data: "",
        success: function (res) {
            if (res.success) {
                var names = [];
                $.each(res.data,function(i,n){
                    names.push(n.name);
                });
                $("#"+show_id).html(names.join(','));
                form.render();
            }else{
                if(res.loseSession=='loseSession'){
                    loseSession(res.msg,res.url);
                }else{
                    layer.msg(res.msg, {time: 2000});
                }
            }
        }
    });
}


//查询表分类
function findTabClassify(show_id,value){
    $.ajax({
        type: "GET",//方法类型
        dataType: "json",//预期服务器返回的数据类型
        url: prefix+"/customize/tclassify/findList?status=Y",//url
        data: "",
        success: function (res) {
            if (res.success) {
                var tt = '<option value="">请选择</option>';
                $.each(res.data,function(i,n){
                    if(value== n.id){
                        tt += '<option value="'+ n.id+'" selected>'+ n.name+'</option>';
                    }else{
                        tt += '<option value="'+ n.id+'">'+ n.name+'</option>';
                    }
                });
                $("#"+show_id).html(tt);
                form.render('select');
            }else{
                if(res.loseSession=='loseSession'){
                    loseSession(res.msg,res.url);
                }else{
                    layer.msg(res.msg, {time: 2000});
                }
            }
        },
        error : function() {
            layer.msg("异常！");
        }
    });
}


//查询表分类
function findTableList(classify_id,show_id,value){
    $.ajax({
        type: "GET",//方法类型
        dataType: "json",//预期服务器返回的数据类型
        url: prefix+"/customize/ttable/findList?status=Y&classify_id="+classify_id,//url
        data: "",
        success: function (res) {
            if (res.success) {
                var tt = '<option value="">请选择</option>';
                $.each(res.data,function(i,n){
                    if(value== n.id){
                        tt += '<option value="'+ n.id+'" title="'+ n.name+'" selected>'+ n.desname+'</option>';
                    }else{
                        tt += '<option value="'+ n.id+'" title="'+ n.name+'">'+ n.desname+'</option>';
                    }
                });
                $("#"+show_id).html(tt);
                form.render('select');
            }else{
                if(res.loseSession=='loseSession'){
                    loseSession(res.msg,res.url);
                }else{
                    layer.msg(res.msg, {time: 2000});
                }
            }
        },
        error : function() {
            layer.msg("异常！");
        }
    });
}



