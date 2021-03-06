<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>

<form class="layui-form" action="" id="form">
    <table class="layui-table" style="width:95%;margin:10px auto;">
            <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">标题：
                        <span style="color: red">*</span>
                </label>
            </td>
            <td colspan="3">${p.title}</td>
        </tr>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">内容：
                </label>
            </td>
            <td colspan="3">
                <div style="margin-top:5px;">
                    <table class="layui-table">
                        <thead>
                        <tr>
                            <th>附件名称</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody id="tbody_file_content">
                        <c:forEach items="${contentFileList}" var="v" varStatus="vs">
                            <tr id="tr_ls${v.id}">
                                <td>${v.name}</td>
                                <td>
                                    <div class="layui-btn-group">
                                        <button type="button" onclick="downloadFile('${v.id}','${v.file_path}','${v.name}');" class="layui-btn layui-btn-xs">下载</button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </td>
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
            <td colspan="4">
                <table class="layui-table" style="width:95%;margin:10px auto;">
                    <thead>
                            <th>名称<span style="color: red">*</span></th>
                            <th>简介</th>
                            <th>排序</th>
                            <th>备注</th>
                    </thead>
                    <tbody id="child_table">
                    <c:if test="${fn:length(list)>0}">
                        <c:forEach items="${list}" var="var" varStatus="status">
                            <tr id="child_tr_ls${var.id}" style="height: 36px;">
                                <td>${var.name}</td>
                                <td>
                                    <div id="content_${var.id}">
                                                <c:if test="${var.content.indexOf('0')!=-1}"> 北京 </c:if>
                                                <c:if test="${var.content.indexOf('1')!=-1}"> 上海 </c:if>
                                                <c:if test="${var.content.indexOf('2')!=-1}"> 深圳 </c:if>
                                    </div>
                                </td>
                                <td>${var.order_by}</td>
                                <td>
                                    <div style="margin-top:5px;">
                                        <table class="layui-table">
                                            <thead>
                                            <tr>
                                                <th>附件名称</th>
                                                <th>操作</th>
                                            </tr>
                                            </thead>
                                            <tbody id="tbody_file_remark_${var.id}">
                                            <c:forEach items="${var.remarkFileList}" var="v" varStatus="vs">
                                                <tr id="tr_ls${v.id}">
                                                    <td>${v.name}</td>
                                                    <td>
                                                        <div class="layui-btn-group">
                                                            <button type="button" onclick="downloadFile('${v.id}','${v.file_path}','${v.name}');" class="layui-btn layui-btn-xs">下载</button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>
                    </tbody>
                </table>
            </td>
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