<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>

<form class="layui-form" action="" id="form">
    <table width="95%" style="margin: 0 auto">
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">组名称：<span style="color: red">*</span></label></td>
            <td colspan="3"><input type="text" name="name" id="name" value="${p.name}" lay-verify="required|field_len50" autocomplete="off" placeholder="组名称" class="layui-input"></td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">组简称：</label></td>
            <td colspan="3"><input type="text" name="short_name" id="short_name" value="${p.short_name}" lay-verify="field_len50" autocomplete="off" placeholder="组简称" class="layui-input"></td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">组用户：<span style="color: red">*</span></label></td>
            <td colspan="3">
                <div style="position:relative;">
                    <input type="hidden" name="user_ids" id="user_ids">
                    <textarea style="width: 92%;" readonly name="user_names" id="user_names" placeholder="请选择组用户" lay-verify="required" class="layui-textarea"></textarea>
                    <button style="width: 6%;position:absolute;bottom:0;right:1%;" type="button" onclick="selectMoreUser()" class="layui-btn layui-btn-xs layui-btn-normal">选择</button>
                </div>
            </td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">排序号：</label></td>
            <td colspan="3"><input type="text" name="order_by" id="order_by" value="${p.order_by}" lay-verify="field_len50|intNumber" autocomplete="off" placeholder="排序号" class="layui-input"></td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">备注：</label></td>
            <td colspan="3"><textarea name="remark" placeholder="请输入备注" class="layui-textarea">${p.remark}</textarea></td>
        </tr>
        <tr>
            <td style="text-align: center; padding-top: 10px;" colspan="4">
                <div class="layui-form-item">
                    <input type="hidden" name="id" id="id" value="${p.id}" />
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

        var ids = [];
        var names = [];
        $.each(${listJson},function(i,n){
            ids.push(n.user_id);
            names.push(n.user_name);
        })
        $("#user_ids").val(ids);
        $("#user_names").val(names);

        //自定义验证规则
        form.verify(form_verify);

        //监听提交
        form.on('submit(submit_form)', function(data){
            layer.msg('正在提交数据。');
            $("#submit_button").attr('disabled',true);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/system/group/update" ,//url
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

    //选择用户
    function selectMoreUser(){
        var ids = $("#user_ids").val();
        var names = $("#user_names").val();
        sessionStorage.setItem('ids', ids);
        sessionStorage.setItem('names', names);
        parent.layer.open({
            //skin: 'layui-layer-molv',
            title: '添加人员',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/system/user/selectMoreUser',
            area: ['800px', '520px'],
            end: function () {
                var val = getOpenCloseParam();
                if(val=="reload"){
                    $("#user_ids").val(sessionStorage.getItem("ids"));
                    $("#user_names").val(sessionStorage.getItem("names"));
                    sessionStorage.removeItem("ids");
                    sessionStorage.removeItem("names");
                }
            }
        });
    }
</script>

<%@include file="../admin/bottom.jsp"%>