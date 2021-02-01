<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>

<form class="layui-form" action="" id="form">
    <table class="layui-table" style="width:95%;margin:10px auto;">
        <tr>
            <td width="16%" align="right"><label class="layui-form-label">登录账号：<span style="color: red">*</span></label></td>
            <td>${p.login_name}</td>
            <td width="16%" align="right"><label class="layui-form-label">姓名：<span style="color: red">*</span></label></td>
            <td>${p.name}</td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">性别：</label></td>
            <td>
                <c:if test="${p.sex=='1'}"> 男 </c:if>
                <c:if test="${p.sex=='2'}"> 女 </c:if>
            </td>
            <td align="right"><label class="layui-form-label">手机号：</label></td>
            <td>${p.phone}</td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">邮箱：</label></td>
            <td>${p.email}</td>
            <td align="right"><label class="layui-form-label">出生日期：</label></td>
            <td>${p.birth_date}</td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">座右铭：</label></td>
            <td>${p.motto}</td>
            <td align="right"><label class="layui-form-label">排序号：</label></td>
            <td>${p.order_by}</td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">居住地址：</label></td>
            <td>${p.live_address}</td>
            <td align="right"><label class="layui-form-label">出生地址：</label></td>
            <td>${p.birth_address}</td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">头像地址：</label></td>
            <td colspan="3">
                <div class="layui-upload">
                    <div>
                        <img class="layui-upload-img" id="head_address_url" width="100px;">
                        <p id="demoText"></p>
                    </div>
                </div>
            </td>
        </tr>
        <tr id="button_tr">
            <td width="20%" align="right"><label class="layui-form-label">用户组织</label></td>
            <td colspan="3">
                <div style="overflow:auto;">
                    <table class="layui-table">
                        <thead>
                        <tr>
                            <th style="width: 80px">类型</th>
                            <th>组织名称<span style="color: red">*</span></th>
                            <th>职务</th>
                            <th style="width: 50px">排序</th>
                        </tr>
                        </thead>
                        <tbody id="table">
                        <c:if test="${fn:length(list)>0}">
                            <c:forEach items="${list}" var="var" varStatus="status">
                                <tr id="tr_ls${var.id}">
                                    <td style="padding: 10px">
                                        <c:if test="${var.type=='0'}">主组织</c:if>
                                        <c:if test="${var.type=='1'}">兼职组织</c:if>
                                    </td>
                                    <td>
                                        ${var.organize_name}
                                    </td>
                                    <td>${var.position}</td>
                                    <td>${var.order_by}</td>
                                </tr>
                            </c:forEach>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </td>
        </tr>
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