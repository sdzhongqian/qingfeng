<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>

<form class="layui-form" action="" id="form">
    <table width="95%" style="margin: 0 auto">
        <tr>
            <td width="20%" align="right"><label class="layui-form-label">父级名称：<span style="color: red">*</span></label></td>
            <td colspan="3"><input type="text" readonly value="${pd.name }" class="layui-input"></td>
        </tr>
            <tr>
                <td width="15%" align="right">
                    <label class="layui-form-label">字典名称：
                        <span style="color: red">*</span>
                    </label>
                </td>
                <td colspan="3"><input type="text" name="name" id="name" value="" lay-verify="required" autocomplete="off" placeholder="字典名称" class="layui-input"></td>
            </tr>
            <tr>
                <td width="15%" align="right">
                    <label class="layui-form-label">字典简称：
                    </label>
                </td>
                <td colspan="3"><input type="text" name="short_name" id="short_name" value="" lay-verify="" autocomplete="off" placeholder="字典简称" class="layui-input"></td>
            </tr>
            <tr>
                <td width="15%" align="right">
                    <label class="layui-form-label">排序：
                    </label>
                </td>
                <td colspan="3"><input type="text" name="order_by" id="order_by" value="" lay-verify="" autocomplete="off" placeholder="排序" class="layui-input"></td>
            </tr>
            <tr>
                <td width="15%" align="right">
                    <label class="layui-form-label">备注：
                    </label>
                </td>
                <td colspan="3"><textarea name="remark" id="remark" lay-verify="" placeholder="请输入备注" class="layui-textarea"></textarea></td>
            </tr>
        <tr>
            <td style="text-align: center; padding-top: 10px;" colspan="4">
                <div class="layui-form-item">
                    <input type="hidden" id="parent_id" name="parent_id" value="${pd.parent_id }">
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
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/uploadFile.js"></script>
<!-- 注意：如果你直接复制所有代码到本地，上述js路径需要改成你本地的 -->

<script>
    var form,layer,layedit,laydate,upload;
    layui.use(['form', 'layedit', 'laydate','upload'], function(){
        form = layui.form;
        layer = layui.layer;
        layedit = layui.layedit;
        laydate = layui.laydate;
        upload = layui.upload;

        $('#cancel').on('click',function (){
            var index = parent.layer.getFrameIndex(window.name);
            parent.layer.close(index);
        });

        //初始化
        //自定义验证规则
        form.verify(form_verify);

        //监听提交
        form.on('submit(submit_form)', function(data){
            layer.msg('正在提交数据。');

            $("#submit_button").attr('disabled',true);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/gencode/mytree/save" ,//url
                data: $('#form').serialize(),
                success: function (res) {
                    if (res.success) {
                        layer.msg("数据保存成功。", {time: 2000},function(){
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

<%@include file="../../system/admin/bottom.jsp"%>