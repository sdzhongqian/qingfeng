<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>

<form class="layui-form" action="${pageContext.request.contextPath}/system/user/updatePwd" id="form" lay-filter="formVal">
    <table width="90%">
        <tr>
            <td width="20%" align="right"><label class="layui-form-label">密码说明：<span style="color: red">*</span></label></td>
            <td>重置默认初始密码为：123456；初始密码设置规则：密码可含有字母、数字，密码长度应在6~16个字符之间。</td>
        </tr>
        <tr>
            <td width="20%" align="right"><label class="layui-form-label">新密码：<span style="color: red">*</span></label></td>
            <td><input type="password" name="login_password" id="password"  lay-verify="required|pass" autocomplete="off" placeholder="新密码" class="layui-input"></td>
        </tr>
        <tr>
            <td width="20%" align="right"><label class="layui-form-label">确认密码：<span style="color: red">*</span></label></td>
            <td><input type="password" name="confirm_password" id="confirm_password"  lay-verify="required|pass|confirmPass" autocomplete="off" placeholder="确认密码" class="layui-input"></td>
        </tr>
        <tr>
            <td style="text-align: center; padding-top: 10px;" colspan="4">
                <div class="layui-form-item">
                    <input type="hidden" name="ids" id="ids" value="${pd.ids}" />
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
                url: "${pageContext.request.contextPath}/system/user/updatePwd" ,//url
                data: $('#form').serialize(),
                beforeSend: function (XMLHttpRequest) {
                    XMLHttpRequest.setRequestHeader("httpToken", '${csrfToken}');
                },
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


        //表单初始赋值
        form.val('formVal', {
            "login_password": "123456",
            "confirm_password":"123456"
        })

    });
</script>

<%@include file="../admin/bottom.jsp"%>