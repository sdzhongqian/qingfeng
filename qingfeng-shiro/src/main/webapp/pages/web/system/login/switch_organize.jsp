<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>
<style>
    hr {
        margin: 0;
    }
</style>
<form class="layui-form" action="" id="form" lay-filter="formVal">
    <table width="95%" style="margin: 0 auto">
        <tr>
            <td width="20%" align="right"><label class="layui-form-label">当前组织：<span style="color: red">*</span></label></td>
            <td>${loginOrganize.organize_name}</td>
        </tr>
        <tr>
            <td colspan="4">
                <hr style="height: 2px" class="layui-bg-green">
            </td>
        </tr>
        <tr>
            <td width="20%" align="right"><label class="layui-form-label">组织切换：<span style="color: red">*</span></label></td>
            <td>
                <c:forEach items="${list}" var="var" varStatus="status">
                    <input type="radio" name="organize_id" <c:if test="${var.organize_id==loginOrganize.organize_id}"> checked </c:if> value="${var.organize_id}" title="${var.organize_name}">
                </c:forEach>
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
            layer.msg('正在提交数据。');
            $("#submit_button").attr('disabled',true);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/system/user/updateSwitchOrganize" ,//url
                data: $('#form').serialize(),
                success: function (res) {
                    if (res.success) {
                        layer.msg("密码设置成功。", {time: 2000},function(){
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
                },
                error : function() {
                    $("#submit_button").attr('disabled',false);
                    layer.msg("异常！");
                }
            });
            return false;
        });

    });
</script>

<%@include file="../admin/bottom.jsp"%>