<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>

<div class="layui-tab layui-tab-brief" lay-filter="docDemoTabBrief">
    <ul class="layui-tab-title">
    <c:forEach items="${list}" var="var" varStatus="status">
        <c:if test="${status.index==0}">
            <li class="layui-this">${var.name}</li>
        </c:if>
        <c:if test="${status.index!=0}">
            <li>${var.name}</li>
        </c:if>
    </c:forEach>
    </ul>
    <div class="layui-tab-content" style="height: 100px;">
        <c:forEach items="${list}" var="var" varStatus="status">
            <c:if test="${status.index==0}">
                <div class="layui-tab-item layui-show"><pre>${var.content}</pre></div>
            </c:if>
            <c:if test="${status.index!=0}">
                <div class="layui-tab-item"><pre>${var.content}</pre></div>
            </c:if>
        </c:forEach>
    </div>
</div>

<script>
    var form,layer;
    layui.use(['form'], function(){
        form = layui.form;
        layer = layui.layer;

        $('#cancel').on('click',function (){
            var index = parent.layer.getFrameIndex("gencode_info");
            parent.layer.close(index);
        });

    });

</script>

<%@include file="../admin/bottom.jsp"%>