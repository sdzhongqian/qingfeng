<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>

<style>
    .fly-none p {
        margin-top: 20px;
        padding: 0 15px;
        font-size: 20px;
        color: #999;
        font-weight: 300;
    }
</style>

<div class="layui-container">
    <div class="fly-panel">
        <div class="fly-none">
            <h2><img src="${pageContext.request.contextPath}/resources/images/403.png" width="60%"></h2>
            <c:if test="${msg.indexOf('Subject does not have permission')!=-1}">
                <p><a style="cursor: pointer" onclick="showError();">抱歉！您无权访问，数据被 纸飞机 运到火星了，啥都看不到了…</a></p>
            </c:if>
            <c:if test="${msg.indexOf('Subject does not have permission')==-1}">
                <p><a style="cursor: pointer" onclick="showError();">抱歉！访问异常，数据被 纸飞机 运到火星了，啥都看不到了…</a></p>
            </c:if>
            <p id="msg" style="display:none">${msg}</p>
        </div>
    </div>
</div>

<script>
    function showError(){
        $("#msg").show();
    }
</script>

<%@include file="../../system/admin/bottom.jsp"%>