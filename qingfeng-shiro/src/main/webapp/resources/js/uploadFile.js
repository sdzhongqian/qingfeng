var prefix = $("#ctxValue").val();

//多附件上传
function uploadMoreFile(index,type){
    if($("#fileIds_"+index).val()==''||$("#fileIds_"+index).val()==null){
        fileIds=[];
    }else{
        fileIds=$("#fileIds_"+index).val().split(",");
    }
    //多图片上传
    upload.render({
        elem: '#upload_file_'+index
        ,url: prefix+'/common/upload/uploadFile?source='+type
        ,multiple: true
        ,accept: 'file' //普通文件
        ,done: function(res){
            var tt = '<tr id="tr_'+index+'">';
            tt += '<td>'+res.data.name+'</td>';
            tt += '<td>' +
                '<div class="layui-btn-group">' +
                '<button type="button" onclick="downloadFile(\''+ res.data.id +'\',\''+ res.data.file_path +'\',\''+ res.data.name +'\');" class="layui-btn layui-btn-xs">下载</button>' +
                '<button type="button" onclick="delMoreFile(\''+ index +'\',\''+ res.data.id +'\',\''+ res.data.file_path +'\');" class="layui-btn layui-btn-xs layui-btn-danger">删除</button>' +
                '</div>' +
                '</td>';
            tt += '</tr>';
            $('#tbody_file_'+index).append(tt);
            fileIds.push(res.data.id);
            $("#fileIds_"+index).val(fileIds);
        }
    });
}

//多附件删除
function delMoreFile(index,id,file_path){
    layer.confirm('删除文件后，只能重新上传，真的要删除文件么？', function(i){
        if($("#fileIds_"+index).val()==''||$("#fileIds_"+index).val()==null){
            fileIds=[];
        }else{
            fileIds=$("#fileIds_"+index).val().split(",");
        }
        $.ajax({
            type: "GET",//方法类型
            dataType: "json",//预期服务器返回的数据类型
            url: prefix+"/common/upload/delFile?id="+id+"&file_path="+file_path,//url
            data: "",
            success: function (res) {
                if (res.success) {
                    layer.msg(res.msg, {time: 2000});
                    //图片数量减1
                    $("#tr_"+index).remove();
                    fileIds.remove(id);
                    $("#fileIds_"+index).val(fileIds);
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
    });
}

//单附件上传
function uploadOneFile(type){
    //单文件上传
    upload.render({
        elem: '#upload_file'
        ,url: prefix+'/common/upload/uploadFile?source='+type
        ,multiple: true
        ,accept: 'file' //普通文件
        ,done: function(res){
            if($("#fileId").val()!=''&&$("#fileId").val()!=null) {
                var fileId = $("#fileId").val();
                var filePath = $("#filePath").val();
                delOneFile(fileId, filePath);
            }
            var tt = '<a type="button" style="color: #F8F8FF;cursor: pointer" onclick="downloadFile(\''+ res.data.id +'\',\''+ res.data.file_path +'\',\''+ res.data.name +'\');">'+res.data.name+'</a>';
            $('#file_show').html(tt);
            $("#fileId").val(res.data.id);
            $("#filePath").val(res.data.file_path);
        }
    });
}

//单附件删除
function delOneFile(id,file_path){
    $.ajax({
        type: "GET",//方法类型
        dataType: "json",//预期服务器返回的数据类型
        url: prefix+"/common/upload/delFile?id="+id+"&file_path="+file_path,//url
        data: "",
        success: function (res) {
            if (res.success) {
                layer.msg(res.msg, {time: 2000});
                //图片数量减1
                $("#file_show").html("");
                $("#fileId").val("");
                $("#filePath").val("");
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

//下载
function downloadFile(file_path,name){
    window.location.href=prefix+"/common/upload/downloadFile?name="+name+"&file_path="+file_path;
}
