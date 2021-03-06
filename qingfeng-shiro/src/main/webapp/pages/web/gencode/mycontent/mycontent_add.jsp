<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>

<form class="layui-form" action="" id="form">
    <table width="95%" style="margin: 0 auto">
            <tr>
                <td width="15%" align="right">
                    <label class="layui-form-label">标题：
                    </label>
                </td>
                <td colspan="3"><input type="text" name="title" id="title" value="" lay-verify="" autocomplete="off" placeholder="标题" class="layui-input"></td>
            </tr>
            <tr>
                <td width="15%" align="right">
                    <label class="layui-form-label">简介：
                    </label>
                </td>
                <td colspan="3">
                    <div id="div_intro">
                    </div>
                </td>
            </tr>
            <tr>
                <td width="15%" align="right">
                    <label class="layui-form-label">内容：
                    </label>
                </td>
                <td colspan="3"><input type="text" name="content" id="content" value="" lay-verify="" autocomplete="off" placeholder="内容" class="layui-input"></td>
            </tr>
            <tr>
                <td width="15%" align="right">
                    <label class="layui-form-label">排序：
                    </label>
                </td>
                <td colspan="3">
                    <select name="order_by" id="order_by" lay-verify="" style="height: 32px;" class="layui-input">
                        <option value=""></option>
                        <option value="0">北京</option>
                        <option selected value="1">上海</option>
                        <option value="2">深圳</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td width="15%" align="right">
                    <label class="layui-form-label">备注：
                    </label>
                </td>
                <td colspan="3"><input type="text" name="remark" id="remark" value="" lay-verify="" autocomplete="off" placeholder="备注" class="layui-input"></td>
            </tr>
        <tr>
            <td style="text-align: center; padding-top: 10px;" colspan="4">
                <div class="layui-form-item">
                    <input type="hidden" name="read_num" id="read_num" value="0" lay-verify="number" autocomplete="off" placeholder="阅读数量" class="layui-input">
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
        findRadioDictionary('fl1001','div_','intro','');
        initDateType("content",true);
        //自定义验证规则
        form.verify(form_verify);

        //监听提交
        form.on('submit(submit_form)', function(data){
            layer.msg('正在提交数据。');

            $("#submit_button").attr('disabled',true);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/gencode/mycontent/save" ,//url
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