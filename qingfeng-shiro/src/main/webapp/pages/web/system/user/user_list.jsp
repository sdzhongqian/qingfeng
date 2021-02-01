<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>
<div class="x-nav">
            <span class="layui-breadcrumb">
                <a><cite>系统管理</cite></a>
                <a><cite>用户管理</cite></a>
            </span>
    <button class="layui-btn layui-btn-xs" style="margin-left: 10px;" onclick="openAndCloseLeft83('system_user');"><i title="展开左侧栏" class="iconfont"></i></button>
    <a class="layui-btn layui-btn-sm" style="line-height:1.6em;margin-top:3px;float:right" onclick="location.reload()" title="刷新">
        <i class="layui-icon layui-icon-refresh" style="line-height:30px"></i>
    </a>
</div>
<div class="layui-fluid">
    <div style="float: left; width: 15%; margin-right:15px;min-height: 580px;" id="leftDiv">
        <ul id="treeDemo" class="ztree"></ul>
        <input type="hidden" name="tree_id" id="tree_id" value="" />
        <input type="hidden" id="tree_name" value="" />
        <input type="hidden" id="org_cascade" value="" />
        <input type="hidden" id="level_num" value="" />
    </div>
    <div style="float: left; width: 83%" id="rightDiv">
        <div class="layui-row layui-col-space1">
            <div class="layui-col-md12">
                <div class="layui-card">
                    <blockquote id="search" class="layui-elem-quote" style="position: relative;">
                        <div class="layui-card-body ">
                            <form class="layui-form layui-col-space5">
                                <div class="layui-inline">
                                    <label class="layui-form-lab" style="width: auto">登录账号</label>
                                    <input type="text" name="login_name" id="login_name" style="width: 180px;height: 32px;display: inline" placeholder="请输入登录账号" class="layui-input">
                                </div>
                                <div class="layui-inline">
                                    <label class="layui-form-lab" style="width: auto">姓名</label>
                                    <input type="text" name="name" id="name" style="width: 180px;height: 32px;display: inline" placeholder="请输入姓名" class="layui-input">
                                </div>
                                <div class="layui-inline">
                                    <label class="layui-form-lab" style="width: auto">手机号</label>
                                    <input type="text" name="phone" id="phone" style="width: 180px;height: 32px;display: inline" placeholder="请输入手机号" class="layui-input">
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
                                            <option value="2">休眠</option>
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
                        <table class="layui-hide" id="system_user" lay-filter="system_user"></table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <shiro:hasPermission name="user:add">
            <button type="button" class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon"></i>新增</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="user:addMore">
            <button type="button" class="layui-btn layui-btn-sm" lay-event="addMore"><i class="layui-icon"></i>批量新增</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="user:edit">
            <button type="button" class="layui-btn layui-btn-normal layui-btn-sm" lay-event="edit"><i class="layui-icon"></i>编辑</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="user:del">
            <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" lay-event="del"><i class="layui-icon"></i>删除</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="user:resetPwd">
            <button type="button" class="layui-btn layui-btn-primary layui-btn-sm" lay-event="resetPwd"><i class="layui-icon">&#xe673;</i>密码重置</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="user:assignAuth">
            <button type="button" class="layui-btn layui-btn-primary layui-btn-sm" lay-event="assignAuth"><i class="layui-icon">&#xe716;</i>权限分配</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="user:exportExcel">
            <button type="button" class="layui-btn layui-btn-primary layui-btn-sm" lay-event="exportExcel"><i class="layui-icon">&#xe67d</i>导出</button>
        </shiro:hasPermission>
    </div>
</script>
<script type="text/html" id="barDemo">
    <shiro:hasPermission name="user:info">
        <a class="layui-btn layui-btn-xs" lay-event="info">详情</a>
    </shiro:hasPermission>
    <shiro:hasPermission name="user:resetPwd">
        <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="resetPwd">密码重置</a>
    </shiro:hasPermission>
    <shiro:hasPermission name="user:assignAuth">
        <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="assignAuth">分配权限</a>
    </shiro:hasPermission>
    <jsp:include page="../auth/auth_editdel.jsp">
        <jsp:param value="user" name="moduleName"/>
    </jsp:include>
    <shiro:hasPermission name="user:setStatus">
        {{ d.status == '0' ? '<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="setStatus1">禁用</a>' : '' }}
        {{ d.status == '1' ? '<a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="setStatus0">启用</a>' : '' }}
        {{ d.status == '2' ? '<a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="setStatus0">恢复</a>' : '' }}
    </shiro:hasPermission>
</script>

<script type="text/html" id="switchTpl">
    <!-- 这里的checked的状态只是演示 -->
    <input type = "checkbox" name = "sex" value = "{{d.id}}" lay-skin = "switch"lay-text = "男|女" lay-filter = "sexDemo" {{ d.sex == '1' ? 'checked': ''}} >
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/ztree/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/ztree/js/jquery.ztree.all.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css" />
<%@include file="../organize/organize_ztree.jsp" %>
<script>
    var table,form;
    layui.use(['table','form'], function(){
        table = layui.table;
        form = layui.form;

        table.render({
            elem: '#system_user'
            ,url:'${pageContext.request.contextPath}/system/user/findListPage'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            ,defaultToolbar: ['filter', 'exports', 'print', { //自定义头部工具栏右侧图标。如无需自定义，去除该参数即可
                title: '提示'
                ,layEvent: 'laytable_tips'
                ,icon: 'layui-icon-tips'
            }]
            ,title: '用户数据表'
            ,cols: [[
                {type: 'checkbox', fixed: 'left', width:40}
                ,{field:'login_name', fixed: 'left',title:'登录名', width:120}
                ,{field:'name', title:'姓名', width:120}
//                ,{field:'uorg_type', title:'类型', width:100, templet: function(res){
//                    if(res.uorg_type=='0'){
//                        return '主组织';
//                    }else if(res.uorg_type=='1'){
//                        return '兼职组织';
//                    }
//                }}
                ,{field:'sex', title:'性别', width:100, sort: true, templet: function(res){
                    if(res.sex=='1'){
                        return '男';
                    }else if(res.sex=='2'){
                        return '女';
                    }else{
                        return '未知';
                    }
                }}
                ,{field:'phone', title:'手机号', width:120, edit: 'text'}
                ,{field:'email', title:'邮箱', width:120, edit: 'text', templet: function(res){
                    return '<em>'+ res.email +'</em>'
                }}
                ,{field:'status', title: '状态', sort: true,templet: function(res){
                    if(res.status=='0'){
                        return "<span style='color: #32CD32;font-weight: bold'>启用</span>";
                    }else  if(res.status=='1'){
                        return "<span style='color: #EE4000;font-weight: bold'>禁用</span>";
                    }else  if(res.status=='2'){
                        return "<span style='color: #CDAD00;font-weight: bold'>休眠</span>";
                    }
                }}
                ,{field:'order_by', title:'排序', edit: 'text'}
                ,{field:'create_time', title:'创建时间'}
                ,{fixed: 'right', align:'center',title:'操作', width:290, toolbar: '#barDemo'}
            ]]
            ,id:'system_user'
            ,page: true
            ,done: function (res, curr, count) {
//                let maxWidth = 0;
//                let fixedRight = $(".layui-table-fixed-r");
//                //移除thead中原先的宽度样式
//                fixedRight.children(".layui-table-header").children("table").children("thead").children("tr").each(function () {$(this).children("th").children("div").removeClass();$(this).children("th").children("div").addClass("layui-table-cell");});
//                //移除tbody中原先的宽度样式，并计算出最后所需宽度
//                fixedRight.children(".layui-table-body").children("table").children("tbody").children("tr").each(function () {$(this).children("td").children("div").removeClass();$(this).children("td").children("div").addClass("layui-table-cell");maxWidth = $(this).width() - 30;});
//                //修改thead中该列各单元格的宽度
//                fixedRight.children(".layui-table-header").children("table").children("thead").children("tr").each(function () {$(this).children("th").children("div").width(maxWidth);});
//                //修改tbody中该列各单元格的宽度
//                fixedRight.children(".layui-table-body").children("table").children("tbody").children("tr").each(function () {$(this).children("td").children("div").width(maxWidth);});
//                //由于layui的table组件中 浮动并不是单个单元格真浮动，而是实际上是新加了一个浮动对象覆盖在原先的单元格上，所以如果不写如下代码，会造成被覆盖的那一层单元格没有被完全覆盖的bug
//                $(".layui-table-box .layui-table-header").children("table").children("thead").children("tr").each(function () {$(this).children("th:last").children("div").width(maxWidth);});
//                $(".layui-table-box .layui-table-main").children("table").children("tbody").children("tr").each(function () {$(this).children("td:last").children("div").width(maxWidth);});
            }
        });

        //头工具栏事件
        table.on('toolbar(system_user)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            var data = checkStatus.data;
            switch(obj.event){
                case 'laytable_tips': //小提示
                    layer.msg("小提示：用户信息模块", {time: 2000});
                    break;
                case 'add': //增加
                    add();
                    break;
                case 'addMore': //增加
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
                        layer.confirm('删除数据会同步删除【用户组织信息、用户权限信息】，真的要删除数据么?', function(index){
                            var ids = [];
                            var names = [];
                            for ( var i = 0; i <data.length; i++){
                                ids.push(data[i].id);
                                names.push(data[i].name);
                            }
                            $.get("${pageContext.request.contextPath}/system/user/del?ids="+ids+"&names="+names,null,function(res){
                                if (res.success) {
                                    layer.msg("数据删除成功。", {time: 2000});
                                    reloadData();
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
                case 'resetPwd': //密码重置
                    if(data.length>0){
                        var ids = [];
                        var names = [];
                        for ( var i = 0; i <data.length; i++){
                            ids.push(data[i].id);
                            names.push(data[i].name);
                        }
                        resetPwd(ids);
                    }else{
                        layer.msg('请选择要重置密码的数据。');
                    }
                    break;
                case 'assignAuth': //设置权限
                    if(data.length!=1){
                        layer.msg('请选择一条数据进行操作。');
                    }else{
                        assignAuth(data[0].id)
                    }
                    break;
                case 'exportExcel': //导出Excel
                    exportExcel();
                    break;
            };
        });

        //监听行工具事件
        table.on('tool(system_user)', function(obj){
            var data = obj.data;
            //console.log(obj)
            if(obj.event === 'info'){
                info(data.id);
            }else if(obj.event === 'del'){
                layer.confirm('删除数据会同步删除【用户组织信息、用户权限信息】，真的要删除数据么?', function(index){
                    $.get("${pageContext.request.contextPath}/system/user/del?ids="+data.id,null,function(res){
                        if (res.success) {
                            layer.msg("数据删除成功。", {time: 2000});
                            reloadData();
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
            } else if(obj.event === 'resetPwd'){
                resetPwd(data.id)
            } else if(obj.event === 'assignAuth'){
                assignAuth(data.id)
            } else if(obj.event === 'setStatus1'){
                updateStatus(data.id,data.login_name,'1');
            } else if(obj.event === 'setStatus0'){
                updateStatus(data.id,data.login_name,'0');
            }
        });

        //监听单元格编辑
        table.on('edit(system_user)', function(obj){
            var value = obj.value //得到修改后的值
                    ,data = obj.data //得到所在行所有键值
                    ,field = obj.field; //得到字段
//            layer.msg('[ID: '+ data.id +'] ' + field + ' 字段更改为：'+ value);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/system/user/update?"+field+"="+value ,//url
                data: {
                    id:data.id
                },
                success: function (res) {
                    if (res.success) {
                        location.reload();
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

        //监听选择城市
        form.on('select(selectSex)', function(obj){
            console.log(obj);
            form.render();
            return false;
        });

    });

    function reloadData(organize_id){
        var login_name = $('#login_name').val();
        var name = $('#name').val();
        var status = $("#status option:selected").val();
        var phone = $("#phone").val();
        //执行重载
        table.reload('system_user', {
            page: {
                curr: 1 //重新从第 1 页开始
            }
            ,where: {
                organize_id:organize_id,
                login_name: login_name,
                name: name,
                status:status,
                phone:phone
            }
        });
    }

    //新增
    function add(){
        var organize_id = $("#tree_id").val();
        var organize_name = $("#tree_name").val();
        if(organize_id==''||organize_id==null){
            layer.msg("请在左侧选择组织。");
        }else{
            parent.layer.open({
                id:'user_add',
                //skin: 'layui-layer-molv',
                title: '添加',
                maxmin: true,
                type: 2,
                content: '${pageContext.request.contextPath}/system/user/toAdd?organize_id='+organize_id+'&organize_name='+organize_name,
                area: ['1000px', '500px'],
                end: function () {
                    var val = getOpenCloseParam();
                    if(val=="reload"){
                        reloadData(organize_id);
                    }
                }
            });
        }
    }

    //新增
    function addMore(){
        var organize_id = $("#tree_id").val();
        var organize_name = $("#tree_name").val();
        if(organize_id==''||organize_id==null){
            layer.msg("请在左侧选择组织。");
        }else{
            parent.layer.open({
                id:'user_add',
                //skin: 'layui-layer-molv',
                title: '批量添加',
                maxmin: true,
                type: 2,
                content: '${pageContext.request.contextPath}/system/user/toAddMore?organize_id='+organize_id+'&organize_name='+organize_name,
                area: ['1000px', '500px'],
                end: function () {
                    var val = getOpenCloseParam();
                    if(val=="reload"){
                        reloadData();
                    }
                }
            });
        }
    }

    //编辑
    function edit(id){
        parent.layer.open({
            id:'user_edit',
            //skin: 'layui-layer-molv',
            title: '编辑',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/system/user/toUpdate?id='+id,
            area: ['1000px', '500px'],
            end: function () {
                var val = getOpenCloseParam();
                if(val=="reload"){
                    reloadData();
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
            content: '${pageContext.request.contextPath}/system/user/findInfo?id='+id,
            area: ['1000px', '500px']
        });
    }


    //密码重置
    function resetPwd(ids){
        parent.layer.open({
            id:'user_password',
            //skin: 'layui-layer-molv',
            title: '重置密码',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/system/user/toResetPwd?ids='+ids,
            area: ['600px', '240px'],
            end: function () {
            }
        });
    }

    //设置权限
    function assignAuth(id){
        parent.layer.open({
            //skin: 'layui-layer-molv',
            title: '设置权限',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/system/user/toAssignRoleAuth?id='+id,
            area: ['800px', '500px']
        });
    }

    //导出Excel
    function exportExcel(){
        var login_name = $('#login_name').val();
        var name = $('#name').val();
        var status = $("#status option:selected").val();
        var phone = $("#phone").val();
        window.location.href="${pageContext.request.contextPath}/system/user/exportData?login_name="+login_name
                +"&name="+name
                +"&status="+status
                +"&phone="+phone;
    }


    function updateStatus(id,login_name,status){
        $.get("${pageContext.request.contextPath}/system/user/updateStatus?id="+id+"&login_name="+login_name+"&status="+status,null,function(res){
            if (res.success) {
                layer.tips("状态修改成功。");
                reloadData();
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