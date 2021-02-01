<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>
<style>
    hr {
        margin: 0 0 10px 0;
    }
</style>
<form class="layui-form" action="" id="form">
    <table width="95%" style="margin: 0 auto">
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">登录账号：</label></td>
            <td colspan="3">${loginUser.login_name}</td>
        </tr>
        <tr>
            <td colspan="4">
                <hr style="height: 2px" class="layui-bg-green">
            </td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">姓名：<span style="color: red">*</span></label></td>
            <td colspan="3"><input type="text" name="name" id="name" value="${loginUser.name}"  lay-verify="required|field_len50" autocomplete="off" placeholder="姓名" class="layui-input"></td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">性别：</label></td>
            <td>
                <select name="sex" id="sex">
                    <option value="1" <c:if test="${loginUser.sex=='1'}"> selected </c:if>>男</option>
                    <option value="2" <c:if test="${loginUser.sex=='2'}"> selected </c:if>>女</option>
                </select>
            </td>
            <td align="right"><label class="layui-form-label">手机号：</label></td>
            <td><input type="text" name="phone" id="phone" value="${loginUser.phone}" lay-verify="phone" autocomplete="off" placeholder="手机号" class="layui-input"></td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">邮箱：</label></td>
            <td><input type="text" name="email" id="email" value="${loginUser.email}" lay-verify="email" autocomplete="off" placeholder="邮箱" class="layui-input"></td>
            <td align="right"><label class="layui-form-label">出生日期：</label></td>
            <td><input type="text" name="birth_date" id="birth_date" value="${loginUser.birth_date}" lay-verify="field_len50" autocomplete="off" placeholder="出生日期" class="layui-input"></td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">座右铭：</label></td>
            <td><input type="text" name="motto" id="motto" value="${loginUser.motto}" lay-verify="field_len50" autocomplete="off" placeholder="座右铭" class="layui-input"></td>
            <td align="right"><label class="layui-form-label">排序号：</label></td>
            <td><input type="text" name="order_by" id="order_by" value="${loginUser.order_by}" lay-verify="field_len50|intNumber" autocomplete="off" placeholder="排序号" class="layui-input"></td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">居住地址：</label></td>
            <td><input type="text" name="live_address" id="live_address" value="${loginUser.live_address}" lay-verify="field_len120" autocomplete="off" placeholder="居住地址" class="layui-input"></td>
            <td align="right"><label class="layui-form-label">出生地址：</label></td>
            <td><input type="text" name="birth_address" id="birth_address" value="${loginUser.birth_address}" lay-verify="field_len120" autocomplete="off" placeholder="出生地址" class="layui-input"></td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">头像地址：</label></td>
            <td colspan="3">
                <div class="layui-upload">
                    <button type="button" class="layui-btn layui-btn-xs" id="button_head_address">上传图片</button>
                    <div>
                        <img class="layui-upload-img" id="head_address_url" width="100px;">
                        <p id="demoText"></p>
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">备注：</label></td>
            <td colspan="3"><textarea name="remark" placeholder="请输入备注" class="layui-textarea">${loginUser.remark}</textarea></td>
        </tr>
        <tr>
            <td style="text-align: center; padding-top: 10px;" colspan="4">
                <div class="layui-form-item">
                    <input type="hidden" name="id" id="id" value="${loginUser.id}" />
                    <input type="hidden" name="head_address" id="head_address" value="" />
                    <button type="button" class="layui-btn layui-btn-sm" id="submit_button" lay-submit="" lay-filter="submit_form">保存</button>
                    <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" id="cancel">取消</button>
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
    var form,layer,layedit,laydate;
    layui.use(['form', 'layedit', 'laydate'], function(){
        form = layui.form;
        layer = layui.layer;
        layedit = layui.layedit;
        laydate = layui.laydate;

        $('#cancel').on('click',function (){
            var index = parent.layer.getFrameIndex(window.name);
            parent.layer.close(index);
        })

        //自定义验证规则
        form.verify(form_verify);

        //初始化出生日期
        initDateType("birth_date",false);

        //监听提交
        form.on('submit(submit_form)', function(data){
            layer.msg('正在提交数据。');
            $("#submit_button").attr('disabled',true);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/system/user/myUupdate" ,//url
                data: $('#form').serialize(),
                success: function (res) {
                    if (res.success) {
                        layer.msg("数据更新成功。", {time: 2000},function(){
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