<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>
<form class="layui-form" action="" id="form">
    <table class="layui-table" style="width:95%;margin:10px auto;">
        <tr>
            <td width="20%" align="right"><label class="layui-form-label">父级名称：<span style="color: red">*</span></label></td>
            <td colspan="3">
                <c:if test="${p.parent_name==''||p.parent_name==null}">
                    菜单信息
                </c:if>
                <c:if test="${p.parent_name!=''&&p.parent_name!=null}">
                    ${p.parent_name }
                </c:if>

            </td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">菜单名称：<span style="color: red">*</span></label></td>
            <td colspan="3">${p.name}</td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">菜单编码：<span style="color: red">*</span></label></td>
            <td colspan="3">${p.code}</td>
        </tr>
        <c:if test="${p.type=='menu'}">
            <tr>
                <td align="right"><label class="layui-form-label">URL：</label></td>
                <td colspan="3">${p.url}</td>
            </tr>
            <tr>
                <td width="20%" align="right"><label class="layui-form-label">icon：</label></td>
                <td colspan="3"><i class="layui-icon">${p.icon}</i></td>
            </tr>
        </c:if>
        <tr>
            <td align="right"><label class="layui-form-label">排序号：</label></td>
            <td colspan="3">${p.order_by}</td>
        </tr>
        <c:if test="${p.type=='menu'}">
            <tr id="button_tr" <c:if test="${fn:length(list)==0}"> style="display: none;" </c:if>>
                <td width="20%" align="right"><label class="layui-form-label">功能按钮</label></td>
                <td colspan="3">
                    <div style="width:564px; overflow:auto;">
                        <table class="layui-table" style="width:564px;">
                            <thead>
                            <tr>
                                <th>名称</th>
                                <th>编号</th>
                                <th>排序号</th>
                            </tr>
                            </thead>
                            <tbody id="table">
                            <c:if test="${fn:length(list)>0}">
                                <c:forEach items="${list}" var="var" varStatus="status">
                                    <tr id="tr_ls${var.id}">
                                        <td style="padding: 10px">${var.name}</td>
                                        <td>${var.code}</td>
                                        <td>${var.order_by}</td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </td>
            </tr>
        </c:if>
        <tr>
            <td align="right"><label class="layui-form-label">备注：</label></td>
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

<%@include file="../admin/bottom.jsp"%>