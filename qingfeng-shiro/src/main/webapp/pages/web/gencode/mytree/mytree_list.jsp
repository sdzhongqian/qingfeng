<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>
<div class="x-nav">
    <span class="layui-breadcrumb">
        <a><cite>青锋系统</cite></a>
        <a><cite>测试树表</cite></a>
    </span>
    <a class="layui-btn layui-btn-sm" style="line-height:1.6em;margin-top:3px;float:right" onclick="reload()" title="刷新">
        <i class="layui-icon layui-icon-refresh" style="line-height:30px"></i>
    </a>
</div>
<div class="layui-fluid">
    <div style="float: left; width: 15%; margin-right:15px;min-height: 580px;" id="leftDiv">
        <ul id="treeDemo" class="ztree"></ul>
        <input type="hidden" name="tree_id" id="tree_id" value="" />
        <input type="hidden" id="tree_name" value="" />
    </div>
    <div style="float: left; width: 83%" id="rightDiv">
    <div class="layui-row layui-col-space1">
        <div class="layui-col-md12">
            <div class="layui-card">
                <blockquote id="search" class="layui-elem-quote" style="position: relative;">
                    <div class="layui-card-body ">
                        <form class="layui-form layui-col-space5">
                            <div class="layui-inline">
                                <label class="layui-form-lab" style="width: auto">字典名称</label>
                                <input type="text" name="name" id="name" style="width: 180px;height: 32px;display: inline" placeholder="请输入字典名称" class="layui-input">
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-lab" style="width: auto">字典简称</label>
                                <input type="text" name="short_name" id="short_name" style="width: 180px;height: 32px;display: inline" placeholder="请输入字典简称" class="layui-input">
                            </div>
                            <div class="layui-inline">
                                <button type="button" class="layui-btn layui-btn-sm"  lay-submit="" onclick="reload()"><i class="layui-icon">&#xe615;</i></button>
                            </div>
                        </form>
                    </div>
                </blockquote>
                <div class="layui-card-body ">
                    <table class="layui-hide" id="gencode_mytree" lay-filter="gencode_mytree"></table>
                </div>
            </div>
        </div>
    </div>
    </div>
</div>

<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <shiro:hasPermission name="mytree:add">
            <button type="button" class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon"></i>新增</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="mytree:addMore">
            <button type="button" class="layui-btn layui-btn-sm" lay-event="addMore"><i class="layui-icon"></i>批量新增</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="mytree:edit">
            <button type="button" class="layui-btn layui-btn-normal layui-btn-sm" lay-event="edit"><i class="layui-icon"></i>编辑</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="mytree:del">
            <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" lay-event="del"><i class="layui-icon"></i>删除</button>
        </shiro:hasPermission>
    </div>
</script>
<script type="text/html" id="barDemo">
    <shiro:hasPermission name="mytree:info">
        <a class="layui-btn layui-btn-xs" lay-event="info">详情</a>
    </shiro:hasPermission>
    <jsp:include page="../../system/auth/auth_editdel.jsp">
        <jsp:param value="mycontent" name="moduleName"/>
    </jsp:include>
    <shiro:hasPermission name="mytree:setStatus">
        {{ d.status == '0' ? '<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="setStatus1">禁用</a>' : '' }}
        {{ d.status == '1' ? '<a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="setStatus0">启用</a>' : '' }}
    </shiro:hasPermission>
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/ztree/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/ztree/js/jquery.ztree.all.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css" />
<%@include file="mytree_ztree.jsp" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfAjaxReq.js"></script>
<script>
    var table,form;
    layui.use(['table','form'], function(){
        table = layui.table;
        form = layui.form;

        table.render({
            elem: '#gencode_mytree'
            ,url:'${pageContext.request.contextPath}/gencode/mytree/findListPage?type=${pd.type}'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            ,defaultToolbar: ['filter', 'exports', 'print', { //自定义头部工具栏右侧图标。如无需自定义，去除该参数即可
                title: '提示'
                ,layEvent: 'laytable_tips'
                ,icon: 'layui-icon-tips'
            }]
            ,title: '测试树表'
            ,cols: [[
                {type: 'checkbox', fixed: 'left', width:40}
                ,{field:'name',title:'字典名称', edit: 'text'}
                ,{field:'short_name',title:'字典简称', edit: 'text'}
                ,{field:'order_by',title:'排序', edit: 'text'}
                    ,{field:'status', title: '状态', sort: true,templet: function(res){
                    if(res.status=='0'){
                        return "<span style='color: #32CD32;font-weight: bold'>启用</span>";
                    }else  if(res.status=='1'){
                        return "<span style='color: #EE4000;font-weight: bold'>禁用</span>";
                    }
                }}
                ,{fixed: 'right', align:'center',title:'操作', width:220, toolbar: '#barDemo'}
            ]]
            ,id:'gencode_mytree'
            ,page: true
            ,done: function (res, curr, count) {
            }
        });

        //初始化

        //头工具栏事件
        table.on('toolbar(gencode_mytree)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            var data = checkStatus.data;
            switch(obj.event){
                case 'laytable_tips': //小提示
                    layer.msg("小提示：角色信息模块", {time: 2000});
                    break;
                case 'add': //增加
                    add();
                    break;
                case 'addMore': //批量增加
                    addMore();
                    break;
                case 'edit': //编辑
                    if(data.length!=1){
                        layer.msg('请选择一条数据进行操作。');
                    }else{
                        if($("#edit_"+data[0].id).text()==undefined||$("#edit_"+data[0].id).text()==''||$("#edit_"+data[0].id).text()==null){
                            layer.msg("没有编辑权限,请选择其他数据进行编辑。", {time: 2000});
                            return;
                        }
                        edit(data[0].id)
                    }
                    break;
                case 'del': //删除
                    if(data.length>0){
                        var delBol = true;
                        for ( var i = 0; i <data.length; i++){
                            if($("#del_"+data[i].id).text()==undefined||$("#del_"+data[i].id).text()==''||$("#del_"+data[i].id).text()==null){
                                delBol = false;
                            }
                        }
                        if(!delBol){
                            layer.msg("批量删除中存在没有删除权限的数据，请重新选择。", {time: 2000});
                            return;
                        }
                        layer.confirm('真的要删除数据么?', function(index){
                            var ids = [];
                            var names = [];
                            for ( var i = 0; i <data.length; i++){
                                ids.push(data[i].id);
                                names.push(data[i].name);
                            }
                        $.get("${pageContext.request.contextPath}/gencode/mytree/del?ids="+ids+"&names="+names,null,function(res){
                                if (res.success) {
                                    layer.msg("数据删除成功。", {time: 2000});
                                    reload();
                                }else{
                                    if(res.loseSession=='loseSession'){
                                        loseSession(res.msg,res.url)
                                    }else{
                                        layer.msg(res.msg, {time: 2000});
                                    }
                                }
                            },'json');
                        });
                    }else{
                        layer.msg('请选择要删除的数据。');
                    }
                    break;
            }
        });

        //监听行工具事件
        table.on('tool(gencode_mytree)', function(obj){
            var data = obj.data;
            if(obj.event === 'info'){
                info(data.id);
            }else if(obj.event === 'del'){
                layer.confirm('真的要删除数据么?', function(index){
                $.get("${pageContext.request.contextPath}/gencode/mytree/del?ids="+data.id,null,function(res){
                        if (res.success) {
                            layer.msg("数据删除成功。", {time: 2000});
                            reload();
                        }else{
                            if(res.loseSession=='loseSession'){
                                loseSession(res.msg,res.url)
                            }else{
                                layer.msg(res.msg, {time: 2000});
                            }
                        }
                    },'json');
                });
            } else if(obj.event === 'edit'){
                edit(data.id)
            } else if(obj.event === 'setStatus1'){
                updateStatus(data.id,'1');
            } else if(obj.event === 'setStatus0'){
                updateStatus(data.id,'0');
            }
        });

        //监听单元格编辑
        table.on('edit(gencode_mytree)', function(obj){
            var value = obj.value //得到修改后的值
                    ,data = obj.data //得到所在行所有键值
                    ,field = obj.field; //得到字段
//            layer.msg('[ID: '+ data.id +'] ' + field + ' 字段更改为：'+ value);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/gencode/mytree/update?"+field+"="+value ,//url
                data: {
                    id:data.id
                },
                success: function (res) {
                    if (res.success) {
                        reload();
                    }else{
                        if(res.loseSession=='loseSession'){
                            loseSession(res.msg,res.url)
                        }else{
                            layer.msg(res.msg, {time: 2000});
                        }
                    }
                }
            });
        });

    });

    function reload(){
        var parent_id =  $("#tree_id").val();
        reloadData(parent_id);
        findTreeData(parent_id);
    }
    function reloadData(parent_id){
        var name = $('#name').val();
        var short_name = $('#short_name').val();
        //执行重载
        table.reload('gencode_mytree', {
            page: {
                curr: 1 //重新从第 1 页开始
            }
            ,where: {
            parent_id:parent_id,
                name: name,
                short_name: short_name,
            }
        });
    }

    //新增
    function add(){
        var parent_id =  $("#tree_id").val();
        var name = $("#tree_name").val();
        if(parent_id==''||parent_id==null){
            layer.msg("请在左侧选择菜单父节点。");
        }else {
            parent.layer.open({
                id: 'mytree_add',
                //skin: 'layui-layer-molv',
                title: '添加',
                maxmin: true,
                type: 2,
                    content: '${pageContext.request.contextPath}/gencode/mytree/toAdd?type=${pd.type}&parent_id='+parent_id+'&name='+name,
                area: ['800px', '500px'],
                end: function () {
                    var val = getOpenCloseParam();
                    if (val == "reload") {
                        reload();
                    }
                }
            });
        }
    }

    //新增
    function addMore(){
            var parent_id =  $("#tree_id").val();
            var name = $("#tree_name").val();
        if(parent_id==''||parent_id==null){
            layer.msg("请在左侧选择菜单父节点。");
        }else {
            parent.layer.open({
                id:'mytree_add',
                //skin: 'layui-layer-molv',
                title: '批量添加',
                maxmin: true,
                type: 2,
                    content: '${pageContext.request.contextPath}/gencode/mytree/toAddMore?type=${pd.type}&parent_id='+parent_id+'&name='+name,
                area: ['800px', '500px'],
                end: function () {
                    var val = getOpenCloseParam();
                    if(val=="reload"){
                            reload();
                    }
                }
            });
        }
    }

    //编辑
    function edit(id){
        parent.layer.open({
            id:'mytree_edit',
            //skin: 'layui-layer-molv',
            title: '编辑',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/gencode/mytree/toUpdate?id='+id,
            area: ['800px', '500px'],
            end: function () {
                var val = getOpenCloseParam();
                if(val=="reload"){
                    reload();
                }
            }
        });
    }

    //详情
    function info(id){
        parent.layer.open({
            //skin: 'layui-layer-molv',
            title: '详情',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/gencode/mytree/findInfo?id='+id,
            area: ['800px', '500px']
        });
    }

    function updateStatus(id,status){
        $.get("${pageContext.request.contextPath}/gencode/mytree/updateStatus?id="+id+"&status="+status,null,function(res){
            if (res.success) {
                layer.tips("状态修改成功。");
                reload();
            }else{
                if(res.loseSession=='loseSession'){
                    loseSession(res.msg,res.url)
                }else{
                    layer.msg(res.msg, {time: 2000});
                }
            }
        },'json');
    }


</script>

<%@include file="../../system/admin/bottom.jsp"%>