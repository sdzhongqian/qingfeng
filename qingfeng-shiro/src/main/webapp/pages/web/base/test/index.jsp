<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>
<style>
    .quote{
        margin-top: 10px;
    }
</style>
<div class="x-nav">
    <span>
        案例测试-选择用户组织
    </span>
    <a class="layui-btn layui-btn-sm" style="line-height:1.6em;margin-top:3px;float:right" onclick="location.reload()" title="刷新">
        <i class="layui-icon layui-icon-refresh" style="line-height:30px"></i>
    </a>
</div>
<form class="layui-form" action="" id="form" style="width: 98%;margin: 0 auto">
    <blockquote class="layui-elem-quote quote">单选组织</blockquote>
    <div>
        <input type="text" name="organize_id" id="organize_id_1" title="" lay-verify="field_len50" value="" autocomplete="off" placeholder="组织id" class="layui-input">
        <input type="text" name="organize_name" id="organize_name_1" lay-verify="field_len50" value="" autocomplete="off" placeholder="组织名称" class="layui-input">
    </div>
    <button type="button" class="layui-btn" onclick="selectOneOrganize(1)">选择组织</button>
    <hr class="layui-bg-green">
    <blockquote class="layui-elem-quote quote">多选组织</blockquote>
    <div>
        <input type="text" name="organize_ids" id="organize_ids" title="" lay-verify="field_len50" value="" autocomplete="off" placeholder="组织id" class="layui-input">
        <input type="text" name="organize_names" id="organize_names" lay-verify="field_len50" value="" autocomplete="off" placeholder="组织名称" class="layui-input">
    </div>
    <button type="button" class="layui-btn" onclick="selectMoreOrganize()">选择组织</button>

    <hr class="layui-bg-green">
    <blockquote class="layui-elem-quote quote">单选用户</blockquote>
    <div>
        <input type="text" name="organize_ids" id="user_id" title="" lay-verify="field_len50" value="" autocomplete="off" placeholder="用户id" class="layui-input">
        <input type="text" name="organize_names" id="user_name" lay-verify="field_len50" value="" autocomplete="off" placeholder="用户名称" class="layui-input">
    </div>
    <button type="button" class="layui-btn" onclick="selectOneUser()">选择用户</button>

    <hr class="layui-bg-green">
    <blockquote class="layui-elem-quote quote">多选用户</blockquote>
    <div>
        <input type="text" name="organize_ids" id="user_ids" title="" lay-verify="field_len50" value="" autocomplete="off" placeholder="用户id" class="layui-input">
        <input type="text" name="organize_names" id="user_names" lay-verify="field_len50" value="" autocomplete="off" placeholder="用户名称" class="layui-input">
    </div>
    <button type="button" class="layui-btn" onclick="selectMoreUser()">选择用户</button>


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
    })

    //单选组织
    function selectOneOrganize(index){
        var ids = $("#organize_id_"+index).val();
        var names = $("#organize_name_"+index).val();
        sessionStorage.setItem('ids', ids);
        sessionStorage.setItem('names', names);
        parent.layer.open({
            //skin: 'layui-layer-molv',
            title: '选择组织',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/system/organize/selectOneOrganize',
            area: ['800px', '520px'],
            end: function () {
                var val = getOpenCloseParam();
                if(val=="reload"){
                    $("#organize_id_"+index).val(sessionStorage.getItem("ids"));
                    $("#organize_name_"+index).val(sessionStorage.getItem("names"));
                    $("#organize_id_"+index).attr("title",sessionStorage.getItem("names"));
                    sessionStorage.removeItem("ids");
                    sessionStorage.removeItem("names");
                }
            }
        });
    }


    //多选组织
    function selectMoreOrganize(){
        var ids = $("#organize_ids").val();
        var names = $("#organize_names").val();
        sessionStorage.setItem('ids', ids);
        sessionStorage.setItem('names', names);
        parent.layer.open({
            //skin: 'layui-layer-molv',
            title: '选择组织',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/system/organize/selectMoreOrganize',
            area: ['800px', '520px'],
            end: function () {
                var val = getOpenCloseParam();
                if(val=="reload"){
                    $("#organize_ids").val(sessionStorage.getItem("ids"));
                    $("#organize_names").val(sessionStorage.getItem("names"));
                    sessionStorage.removeItem("ids");
                    sessionStorage.removeItem("names");
                }
            }
        });
    }

    //单选用户
    function selectOneUser(){
        var ids = $("#user_id").val();
        var names = $("#user_name").val();
        sessionStorage.setItem('ids', ids);
        sessionStorage.setItem('names', names);
        parent.layer.open({
            //skin: 'layui-layer-molv',
            title: '选择用户',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/system/user/selectOneUser',
            area: ['800px', '520px'],
            end: function () {
                var val = getOpenCloseParam();
                if(val=="reload"){
                    $("#user_id").val(sessionStorage.getItem("ids"));
                    $("#user_name").val(sessionStorage.getItem("names"));
                    sessionStorage.removeItem("ids");
                    sessionStorage.removeItem("names");
                }
            }
        });
    }

    //多选用户
    function selectMoreUser(){
        var ids = $("#user_ids").val();
        var names = $("#user_names").val();
        sessionStorage.setItem('ids', ids);
        sessionStorage.setItem('names', names);
        parent.layer.open({
            //skin: 'layui-layer-molv',
            title: '选择组织',
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

<%@include file="../../system/admin/bottom.jsp"%>