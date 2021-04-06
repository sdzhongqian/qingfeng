<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>
<form class="layui-form" id="form" action="">
    <div id="zhongxin" style="text-align: center">
        <button type="button" class="layui-btn" id="test1">
            <i class="layui-icon">&#xe67c;</i>上传附件
        </button>
        <div id='div_upload'></div>
        <div style="margin-top: 10px;">
            <input type="hidden" name="file_path" id="file_path" value="">
            <button type="button" class="layui-btn layui-btn-sm" lay-submit="" lay-filter="submit_form">保存</button>
            <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" id="cancel">取消</button>
        </div>
    </div>
    <div align="center" style="padding-top: 40px;width: 80%;margin: 0 auto;color: red;">
        注：请根据正确的的模板进行导入，导入文件格式为：excel 后缀文件为：xlsx
    </div>
</form>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/layui/layui.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/commonLayer.js"></script>

<script type="text/javascript">
    layui.use(['form','upload'], function(){
        var form = layui.form
                ,layer = layui.layer
                ,upload = layui.upload
                ,$ = layui.$;

        $('#cancel').on('click',function (){
            var file_path = $("#file_path").val();
            if(file_path != null && file_path != ''){
                delFiles(file_path);
            }
            var index = parent.layer.getFrameIndex(window.name);
            parent.layer.close(index);
        })

        upload.render({
            elem: '#test1'
            ,url: '${pageContext.request.contextPath}/common/upload/uploadOnlyLocalFile'
            ,auto: true
            ,multiple: true
            ,accept:'file'
            ,exts: 'xlsx'
            ,done: function(res){
                if(res.success){
                    var tt = '<div>'+res.data.name+'<a style="color: red;" onclick="delFiles(\''+res.data.file_path+'\');">删除</a></div>';
                    $("#div_upload").html(tt);
                    $("#file_path").val(res.data.file_path);
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

        //监听提交
        form.on('submit(submit_form)', function(data){
            save();
            return false;
        });
    });

    function save(){
        var file_path = $("#file_path").val();
        if(file_path == null || file_path == ''){
            layer.msg("请上传导入数据文件。", {time: 2000});
            return;
        }else{
            var index = layer.load(1, {
                shade: [0.1,'#fff'] //0.1透明度的白色背景
            });
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/example/eiedata/saveImportExcel",//url
                data: $('#form').serialize(),
                success: function (res) {
                    if (res.success) {
                        setOpenCloseParam("reload");
                        delFiles(file_path);
                        layer.msg("数据保存成功。", {time: 2000});
                        var index = parent.layer.getFrameIndex(window.name);
                        parent.layer.close(index);
                    }else{
                        delFiles(file_path);
                        if(res.loseSession=='loseSession'){
                            loseSession(res.msg,res.url);
                        }else{
                            layer.msg(res.msg, {time: 5000});
                        }
                    }
                },
                error : function() {
                    delFiles(file_path);
                    layer.msg("异常！");
                }
            });
        }
    }

    //删除文件
    function delFiles(file_path){
        $.ajax({
            type: "GET",//方法类型
            dataType: "json",//预期服务器返回的数据类型
            url: "${pageContext.request.contextPath}/common/upload/delLocalFile?file_path="+file_path,//url
            data: "",
            success: function (res) {
                if (res.success) {
                    $("#div_upload").html("");
                    $("#file_path").val("");
                    //layer.msg("文件删除成功。", {time: 2000});
                }else{
                    if(res.loseSession=='loseSession'){
                        loseSession(res.msg,res.url)
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
</script>

<%@include file="../../system/admin/bottom.jsp"%>