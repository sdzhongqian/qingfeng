<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>

<form class="layui-form" action="" id="form">
    <table class="layui-table" style="width:95%;margin:10px auto;">
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">任务名称：<span style="color: red">*</span></label></td>
            <td colspan="3">${p.job_name}</td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">接收人：<span style="color: red">*</span></label></td>
            <td colspan="3">
                <span style="color: red">多个通知人以英文符号[,]进行分割，如：张三,李四</span><br>
                ${p.notice_user}
            </td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">执行时间表达式：<span style="color: red">*</span></label></td>
            <td colspan="3">${p.cron_expression}</td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">任务描述：</label></td>
            <td colspan="3">${p.description}</td>
        </tr>
        <tr>
            <td width="20%" align="right"><label class="layui-form-label">排序：</label></td>
            <td colspan="3">${p.order_by}</td>
        </tr>
        <tr>
            <td width="20%" align="right"><label class="layui-form-label">备注：</label></td>
            <td colspan="3">${p.remark}</td>
        </tr>
        <tr>
            <td style="text-align: center; padding-top: 10px;" colspan="4">
                <div class="layui-form-item">
                    <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" id="cancel">关闭</button>
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
    });
</script>

<%@include file="../../system/admin/bottom.jsp"%>