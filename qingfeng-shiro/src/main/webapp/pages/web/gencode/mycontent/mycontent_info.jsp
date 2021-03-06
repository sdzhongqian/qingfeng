<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>

<form class="layui-form" action="" id="form">
    <table class="layui-table" style="width:95%;margin:10px auto;">
            <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">标题：
                </label>
            </td>
            <td colspan="3">${p.title}</td>
        </tr>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">简介：
                </label>
            </td>
            <td colspan="3">
                <div id="intro">
                </div>
            </td>
        </tr>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">内容：
                </label>
            </td>
            <td colspan="3">${p.content}</td>
        </tr>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">排序：
                </label>
            </td>
            <td colspan="3">
                <div id="order_by">
                    <c:if test="${p.order_by=='0'}"> 北京 </c:if>
                    <c:if test="${p.order_by=='1'}"> 上海 </c:if>
                    <c:if test="${p.order_by=='2'}"> 深圳 </c:if>
                </div>
            </td>
        </tr>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">备注：
                </label>
            </td>
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
        findValueDictionary('intro','${p.intro}');

    });
</script>

<%@include file="../../system/admin/bottom.jsp"%>