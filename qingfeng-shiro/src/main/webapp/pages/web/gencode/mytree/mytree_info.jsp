<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>

<form class="layui-form" action="" id="form">
    <table class="layui-table" style="width:95%;margin:10px auto;">
            <tr>
            <td width="20%" align="right"><label class="layui-form-label">父级名称：<span style="color: red">*</span></label></td>
            <td colspan="3">
                <c:if test="${p.parent_name==''||p.parent_name==null}">
                    测试树表
                </c:if>
                <c:if test="${p.parent_name!=''&&p.parent_name!=null}">
                    ${p.parent_name }
                </c:if>
            </td>
        </tr>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">字典名称：
                        <span style="color: red">*</span>
                </label>
            </td>
            <td colspan="3">${p.name}</td>
        </tr>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">字典简称：
                </label>
            </td>
            <td colspan="3">${p.short_name}</td>
        </tr>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">排序：
                </label>
            </td>
            <td colspan="3">${p.order_by}</td>
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

    });
</script>

<%@include file="../../system/admin/bottom.jsp"%>