<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>
<div class="x-nav">
            <span class="layui-breadcrumb">
                <a><cite>系统管理</cite></a>
                <a><cite>菜单管理</cite></a>
            </span>
    <button class="layui-btn layui-btn-xs" style="margin-left: 10px;" onclick="openAndCloseLeft83('system_menu');"><i title="展开左侧栏" class="iconfont"></i></button>
    <span style="padding-left: 10px;color: red">
        最多可添加【4】级菜单，顶部【1】级菜单+左侧【3】级菜单。
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
        <input type="hidden" id="menu_cascade" value="" />
        <input type="hidden" id="level_num" value="" />
        <input type="hidden" id="tree_type" value="" />
    </div>
    <div style="float: left; width: 83%" id="rightDiv">
        <div class="layui-row layui-col-space1">
            <div class="layui-col-md12">
                <div class="layui-card">
                    <blockquote id="search" class="layui-elem-quote" style="position: relative;">
                        <div class="layui-card-body ">
                            <form class="layui-form layui-col-space5">
                                <div class="layui-inline">
                                    <label class="layui-form-lab" style="width: auto">菜单名称</label>
                                    <input type="text" name="name" id="name" style="width: 180px;height: 32px;display: inline" placeholder="请输入菜单名称" class="layui-input">
                                </div>
                                <div class="layui-inline">
                                    <label class="layui-form-lab" style="width: auto">菜单简称</label>
                                    <input type="text" name="short_name" id="short_name" style="width: 180px;height: 32px;display: inline" placeholder="请输入菜单简称" class="layui-input">
                                </div>
                                <div class="layui-inline">
                                    <div style="float: left;padding-top: 5px;">
                                        <label class="layui-form-lab" style="width: auto">状态</label>
                                    </div>
                                    <div style="float: left;padding-left: 5px">
                                        <select name="status" id="status" style="width: 120px;height: 32px;" class="layui-input">
                                            <option value=""></option>
                                            <option value="0">启用</option>
                                            <option value="1">禁用</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="layui-inline">
                                    <button type="button" class="layui-btn layui-btn-sm"  lay-submit="" onclick="reloadData()"><i class="layui-icon">&#xe615;</i></button>
                                </div>
                            </form>
                        </div>
                    </blockquote>
                    <div class="layui-card-body ">
                        <table class="layui-hide" id="system_menu" lay-filter="system_menu"></table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <shiro:hasPermission name="menu:add">
            <button type="button" class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon"></i>新增</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="menu:addMore">
            <button type="button" class="layui-btn layui-btn-sm" lay-event="addMore"><i class="layui-icon"></i>批量新增</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="menu:edit">
            <button type="button" class="layui-btn layui-btn-normal layui-btn-sm" lay-event="edit"><i class="layui-icon"></i>编辑</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="menu:del">
            <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" lay-event="del"><i class="layui-icon"></i>删除</button>
        </shiro:hasPermission>
    </div>
</script>
<script type="text/html" id="barDemo">
    <shiro:hasPermission name="menu:info">
        <a class="layui-btn layui-btn-xs" lay-event="info">详情</a>
    </shiro:hasPermission>
    <jsp:include page="../auth/auth_editdel.jsp">
        <jsp:param value="menu" name="moduleName"/>
    </jsp:include>
    <shiro:hasPermission name="menu:setStatus">
        {{ d.status == '0' ? '<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="setStatus1">禁用</a>' : '' }}
        {{ d.status == '1' ? '<a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="setStatus0">启用</a>' : '' }}
    </shiro:hasPermission>
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/ztree/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/ztree/js/jquery.ztree.all.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css" />
<%@include file="menu_ztree.jsp" %>
<script>
    var table,form;
    layui.use(['table','form'], function(){
        table = layui.table;
        form = layui.form;

        table.render({
            elem: '#system_menu'
            ,url:'${pageContext.request.contextPath}/system/menu/findListPage'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            ,defaultToolbar: ['filter', 'exports', 'print', { //自定义头部工具栏右侧图标。如无需自定义，去除该参数即可
                title: '提示'
                ,layEvent: 'laytable_tips'
                ,icon: 'layui-icon-tips'
            }]
            ,title: '菜单数据表'
            ,cols: [[
                {type: 'checkbox', fixed: 'left', width:40}
                ,{field:'name', fixed: 'left',title:'菜单名称', edit: 'text'}
                ,{field:'code', title:'菜单编码', edit: 'text'}
                ,{field:'type', title:'菜单类型',templet: function(res){
                    if(res.type=='menu'){
                        return "菜单";
                    }else if(res.type=='button'){
                        return "按钮";
                    }
                }}
                ,{field:'order_by', title:'排序', edit: 'text'}
                ,{field:'create_time', title:'创建时间'}
                ,{fixed: 'right', align:'center',title:'操作', width:220, toolbar: '#barDemo'}
            ]]
            ,id:'system_menu'
            ,page: true
            ,done: function (res, curr, count) {
            }
        });

        //头工具栏事件
        table.on('toolbar(system_menu)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            var data = checkStatus.data;
            switch(obj.event){
                case 'laytable_tips': //小提示
                    layer.msg("小提示：菜单信息模块", {time: 2000});
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
                        edit(data[0].id)
                    }
                    break;
                case 'del': //删除
                    if(data.length>0){
                        layer.confirm('删除数据会同步删除下级数据，是否进行删除操作?', function(index){
                            var ids = [];
                            var names = [];
                            for ( var i = 0; i <data.length; i++){
                                ids.push(data[i].id);
                                names.push(data[i].name);
                            }
                            $.get("${pageContext.request.contextPath}/system/menu/del?ids="+ids+"&names="+names,null,function(res){
                                if (res.success) {
                                    layer.msg("数据删除成功。", {time: 2000});
                                    var parent_id =  $("#tree_id").val();
                                    reloadData(parent_id);
                                    findTreeData(parent_id);
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
            };
        });

        //监听行工具事件
        table.on('tool(system_menu)', function(obj){
            var data = obj.data;
            //console.log(obj)
            if(obj.event === 'info'){
                info(data.id);
            }else if(obj.event === 'del'){
                layer.confirm('删除数据会同步删除下级数据，是否进行删除操作?', function(index){
                    $.get("${pageContext.request.contextPath}/system/menu/del?ids="+data.id,null,function(res){
                        if (res.success) {
                            layer.msg("数据删除成功。", {time: 2000});
                            var parent_id =  $("#tree_id").val();
                            reloadData(parent_id);
                            findTreeData(parent_id);
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
        table.on('edit(system_menu)', function(obj){
            var value = obj.value //得到修改后的值
                    ,data = obj.data //得到所在行所有键值
                    ,field = obj.field; //得到字段
//            layer.msg('[ID: '+ data.id +'] ' + field + ' 字段更改为：'+ value);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/system/menu/update?"+field+"="+value ,//url
                data: {
                    id:data.id
                },
                success: function (res) {
                    if (res.success) {
                        var parent_id =  $("#tree_id").val();
                        reloadData(parent_id);
                        findTreeData(parent_id);
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
        var status = $("#status option:selected").val();
        //执行重载
        table.reload('system_menu', {
            page: {
                curr: 1 //重新从第 1 页开始
            }
            ,where: {
                name: name,
                short_name: short_name,
                status:status,
                parent_id:parent_id
            }
        });
    }

    //新增
    function add(){
        var parent_id =  $("#tree_id").val();
        var name = $("#tree_name").val();
        var level_num = $("#level_num").val();
        var menu_cascade = $("#menu_cascade").val();
        var curr_type = $("#tree_type").val();
        if(parent_id==''||parent_id==null){
            layer.msg("请在左侧选择菜单父节点。");
        }else{
            if(curr_type=='button'){
                layer.msg("按钮下不可添加菜单！");
            }else if(level_num=='4'){
                layer.msg("最多添加四级菜单！");
            }else{
                parent.layer.open({
                    //skin: 'layui-layer-molv',
                    title: '添加',
                    maxmin: true,
                    type: 2,
                    content: '${pageContext.request.contextPath}/system/menu/toAdd?parent_id='+parent_id+'&name='+name+'&level_num='+level_num+'&menu_cascade='+menu_cascade,
                    area: ['800px', '500px'],
                    end: function () {
                        var val = getOpenCloseParam();
                        if(val=="reload"){
                            reloadData(parent_id);
                            findTreeData(parent_id);
                        }
                    }
                });
            }
        }

    }


    //新增
    function addMore(){
        var parent_id =  $("#tree_id").val();
        var name = $("#tree_name").val();
        var level_num = $("#level_num").val();
        var menu_cascade = $("#menu_cascade").val();
        var curr_type = $("#tree_type").val();
        if(parent_id==''||parent_id==null){
            layer.msg("请在左侧选择菜单父节点。");
        }else{
            if(curr_type=='button'){
                layer.msg("按钮下不可添加菜单！");
            }else if(level_num=='4'){
                layer.msg("最多添加四级菜单！");
            }else{
                parent.layer.open({
                    id: 'addMore',
                    //skin: 'layui-layer-molv',
                    title: '添加',
                    maxmin: true,
                    type: 2,
                    content: '${pageContext.request.contextPath}/system/menu/toAddMore?parent_id='+parent_id+'&name='+name+'&level_num='+level_num+'&menu_cascade='+menu_cascade,
                    area: ['1000px', '500px'],
                    end: function () {
                        var val = getOpenCloseParam();
                        if(val=="reload"){
                            reloadData(parent_id);
                            findTreeData(parent_id);
                        }
                    }
                });
            }
        }
    }

    //编辑
    function edit(id){
        var parent_id =  $("#tree_id").val();
        parent.layer.open({
            id:'menu_edit',
            //skin: 'layui-layer-molv',
            title: '编辑',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/system/menu/toUpdate?id='+id,
            area: ['800px', '500px'],
            end: function () {
                var val = getOpenCloseParam();
                if(val=="reload"){
                    reloadData(parent_id);
                    findTreeData(parent_id);
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
            content: '${pageContext.request.contextPath}/system/menu/findInfo?id='+id,
            area: ['800px', '500px']
        });
    }

    function updateStatus(id,status){
        $.get("${pageContext.request.contextPath}/system/menu/updateStatus?id="+id+"&status="+status,null,function(res){
            if (res.success) {
                layer.tips("状态修改成功。");
                var parent_id =  $("#tree_id").val();
                reloadData(parent_id);
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

<%@include file="../admin/bottom.jsp"%>