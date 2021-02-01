<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>
<style>
    hr {
        margin: 0;
    }
    .list-unstyled {
        margin: 0;
    }
    .list-unstyled {
        padding-left: 0;
        list-style: none;
        anlig:center
    }
    .clearfix li:hover{
        background: #2196f3;
        color: #fff;
        border-radius: 5px;
    }
    .activi{
        background: #2196f3;
        color: #fff;
        border-radius: 5px;
    }
</style>
<form class="layui-form" action="" id="form" lay-filter="formVal">
    <table width="95%" style="margin: 0 auto">
        <tr>
            <td width="20%" align="right"><label class="layui-form-label">当前主题：<span style="color: red">*</span></label></td>
            <td>
                <div>
                    <img src="${pageContext.request.contextPath}${loginUser.theme_file_path}" width="200px">
                </div>
                <div style="padding: 4px 0;">
                    ${loginUser.theme_title}
                </div>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <hr style="height: 2px" class="layui-bg-green">
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <ul class="list-unstyled clearfix">
                    <c:forEach items="${list}" var="var" varStatus="status">
                        <li id="li_${var.id}" onclick="selectTheme('${var.id}')" style="float:left; width: 31%; padding: 5px;padding-top: 10px;margin-top: 5px;cursor: pointer" class="<c:if test="${loginUser.theme_id==var.id}"> activi </c:if>" >
                            <div align="center">
                                <img src="${pageContext.request.contextPath}${var.file_path}" width="90%">
                            </div>
                            <div style="padding: 2px 0;" align="center">
                                    ${var.title}
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </td>
        </tr>
        <tr>
            <td style="text-align: center; padding-top: 10px;" colspan="4">
                <div class="layui-form-item">
                    <button class="layui-btn layui-btn-sm" lay-submit="" lay-filter="submit_form">保存</button>
                    <button class="layui-btn layui-btn-danger layui-btn-sm" id="cancel">取消</button>
                </div>
            </td>
        </tr>
    </table>
</form>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/xadmin/lib/layui/layui.js" charset="utf-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfverify.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfAjaxReq.js"></script>
<!-- 注意：如果你直接复制所有代码到本地，上述js路径需要改成你本地的 -->
<script>
    var form,layer;
    layui.use(['form'], function(){
        form = layui.form;
        layer = layui.layer;

        $('#cancel').on('click',function (){
            var index = parent.layer.getFrameIndex(window.name);
            parent.layer.close(index);
        })

        //自定义验证规则
        form.verify(form_verify);

        //监听提交
        form.on('submit(submit_form)', function(data){
            if(theme_id==''||theme_id==null){
                layer.msg('请选择主题。');
            }
            layer.msg('正在提交数据。');
            $("#submit_button").attr('disabled',true);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/system/user/updateSwitchTheme" ,//url
                data: {
                    theme_id:theme_id
                },
                success: function (res) {
                    if (res.success) {
                        layer.msg("主题设置成功。", {time: 2000},function(){
                            setOpenCloseParam("reload");
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                        });
                    }else{
                        $("#submit_button").attr('disabled',false);
                        if(res.loseSession=='loseSession'){
                            loseSession(res.msg,res.url)
                        }else{
                            layer.msg(res.msg, {time: 2000});
                        }
                    }
                }
            });
            return false;
        });

    });

    var theme_id = '';
    function selectTheme(id){
        $('li[id*="li_"]').each(function () {
            $(this).removeClass("activi");
        });
        theme_id = id;
        $("#li_"+id).addClass("activi");
    }
</script>

<%@include file="../admin/bottom.jsp"%>