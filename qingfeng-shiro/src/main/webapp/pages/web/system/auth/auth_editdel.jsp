<%@ page import="com.qingfeng.util.PageData" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    PageData userPd = (PageData)session.getAttribute("loginUser");
    PageData organizePd = (PageData)session.getAttribute("loginOrganize");
    String moduleName = request.getParameter("moduleName");
%>

{{#
    var user_id = '<%=userPd.get("id").toString()%>';
    var organize_id = '<%=organizePd.get("organize_id").toString()%>';
    var authOrgIds = '<%=organizePd.get("authOrgIds")%>';
    var authParams = '<%=organizePd.get("authParams")%>';
    var create_user = d.create_user;
    var create_organize = d.create_organize;
    var createParams = d.create_organize+':Y';
}}
<shiro:hasPermission name="<%=moduleName%>:edit">
    <%--未分配权限情况--%>
    {{# if(authOrgIds == ''||authOrgIds==null){ }}
        <!--创建者本身-->
        {{# if(user_id == create_user){ }}
        <a id="edit_{{d.id}}" class="layui-btn layui-btn-normal layui-btn-xs" lay-event="edit">编辑</a>
        {{#    } }}
    {{#    } }}
    <%--已分配权限情况--%>
    {{# if(authOrgIds != ''&&authOrgIds!=null){ }}
        {{# if((authParams.indexOf(createParams)>-1) || (user_id == create_user)){ }}
        <a id="edit_{{d.id}}" class="layui-btn layui-btn-normal layui-btn-xs" lay-event="edit">编辑</a>
        {{#    } }}
    {{#    } }}
</shiro:hasPermission>
<shiro:hasPermission name="<%=moduleName%>:del">
    <%--未分配权限情况--%>
    {{# if(authOrgIds == ''||authOrgIds==null){ }}
    <!--创建者本身-->
    {{# if(user_id == create_user){ }}
    <a id="del_{{d.id}}" class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
    {{#    } }}
    {{#    } }}
    <%--已分配权限情况--%>
    {{# if(authOrgIds != ''&&authOrgIds!=null){ }}
    {{# if((authParams.indexOf(createParams)>-1) || (user_id == create_user)){ }}
    <a id="del_{{d.id}}" class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
    {{#    } }}
    {{#    } }}
</shiro:hasPermission>