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


//查询字典项
function findDictionary(parent_id,show_id,value){
    //查询关联普查队
    $.ajax({
        type: "GET",//方法类型
        dataType: "json",//预期服务器返回的数据类型
        url: prefix+"/system/dictionary/findList?parent_id="+parent_id,//url
        data: "",
        success: function (res) {
            if (res.success) {
                if(show_id.indexOf(',')>=0){
                    var showIds = show_id.split(',');
                    var values = value.split(',');
                    for(var i=0;i<showIds.length;i++){
                        var tt = '<option value="">请选择</option>';
                        $.each(res.data,function(m,n){
                            if(values[i]== n.id){
                                tt += '<option value="'+ n.id+'" selected>'+ n.name+'</option>';
                            }else{
                                tt += '<option value="'+ n.id+'">'+ n.name+'</option>';
                            }
                        });
                        $("#"+showIds[i]).html(tt);
                    }
                }else{
                    var tt = '<option value="">请选择</option>';
                    $.each(res.data,function(i,n){
                        if(value== n.id){
                            tt += '<option value="'+ n.id+'" selected>'+ n.name+'</option>';
                        }else{
                            tt += '<option value="'+ n.id+'">'+ n.name+'</option>';
                        }
                    });
                    $("#"+show_id).html(tt);
                }
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
function findTabClassify(show_id,value){
    //查询关联普查队
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
    //查询关联普查队
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



