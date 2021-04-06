<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>
<div class="x-nav">
    <span class="layui-breadcrumb">
        <a><cite>青锋系统</cite></a>
        <a><cite>Excel导入导出案例</cite></a>
    </span>
    <a class="layui-btn layui-btn-sm" style="line-height:1.6em;margin-top:3px;float:right" onclick="reloadData()" title="刷新">
        <i class="layui-icon layui-icon-refresh" style="line-height:30px"></i>
    </a>
</div>
<div class="layui-fluid">
    <div class="layui-row layui-col-space1">
        <div class="layui-col-md12">
            <div class="layui-card">
                <blockquote id="search" class="layui-elem-quote" style="position: relative;">
                    <div class="layui-card-body ">
                        <form class="layui-form layui-col-space5">
                            <div class="layui-inline">
                                <div style="float: left;padding-top: 5px;">
                                    <label class="layui-form-lab" style="width: auto">分类</label>
                                </div>
                                <div style="float: left;padding-left: 5px">
                                    <select name="classify" id="classify" style="width: 120px;height: 32px;" class="layui-input">
                                        <option value=""></option>
                                                <option value="0">水果</option>
                                                <option value="1">蔬菜</option>
                                                <option value="2">其他</option>
                                    </select>
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-lab" style="width: auto">名称</label>
                                <input type="text" name="name" id="name" style="width: 180px;height: 32px;display: inline" placeholder="请输入名称" class="layui-input">
                            </div>
                            <div class="layui-inline">
                                <button type="button" class="layui-btn layui-btn-sm"  lay-submit="" onclick="reloadData()"><i class="layui-icon">&#xe615;</i></button>
                                <button type="button" class="layui-btn layui-btn-sm layui-btn-warm" exclude="" onclick="exportData();">
                                    <i class="layui-icon">&#xe601;</i>列表导出
                                </button>
                                <button type="button" class="layui-btn layui-btn-sm layui-btn-warm" exclude="" onclick="exportMergeData();">
                                    <i class="layui-icon">&#xe601;</i>合并导出
                                </button>

                            </div>
                        </form>
                    </div>
                </blockquote>
                <div class="layui-card-body ">
                    <table class="layui-hide" id="example_eiedata" lay-filter="example_eiedata"></table>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <shiro:hasPermission name="eiedata:add">
            <button type="button" class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon"></i>新增</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="eiedata:addMore">
            <button type="button" class="layui-btn layui-btn-sm" lay-event="addMore"><i class="layui-icon"></i>批量新增</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="eiedata:edit">
            <button type="button" class="layui-btn layui-btn-normal layui-btn-sm" lay-event="edit"><i class="layui-icon"></i>编辑</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="eiedata:del">
            <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" lay-event="del"><i class="layui-icon"></i>删除</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="eiedata:downloadExcel">
            <button class="layui-btn layui-btn-sm" onclick="downloadExcel();"><i class="layui-icon layui-icon-add"></i>模板下载</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="eiedata:import">
            <button class="layui-btn layui-btn-sm" onclick="toImport();"><i class="layui-icon layui-icon-add"></i>批量导入</button>
        </shiro:hasPermission>
    </div>
</script>
<script type="text/html" id="barDemo">
    <shiro:hasPermission name="eiedata:info">
        <a class="layui-btn layui-btn-xs" lay-event="info">详情</a>
    </shiro:hasPermission>
    <jsp:include page="../../system/auth/auth_editdel.jsp">
        <jsp:param value="eiedata" name="moduleName"/>
    </jsp:include>
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfAjaxReq.js"></script>
<script>
    var table,form;
    layui.use(['table','form'], function(){
        table = layui.table;
        form = layui.form;

        table.render({
            elem: '#example_eiedata'
            ,url:'${pageContext.request.contextPath}/example/eiedata/findListPage?type=${pd.type}'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            ,defaultToolbar: ['filter', 'exports', 'print', { //自定义头部工具栏右侧图标。如无需自定义，去除该参数即可
                title: '提示'
                ,layEvent: 'laytable_tips'
                ,icon: 'layui-icon-tips'
            }]
            ,title: 'Excel导入导出案例'
            ,cols: [[
                {type: 'checkbox', fixed: 'left', width:40}
                ,{field:'classify',title:'分类',templet: function(res){
                    if(res.classify=='0'){
                        return "水果";
                    }else  if(res.classify=='1'){
                        return "蔬菜";
                    }else  if(res.classify=='2'){
                        return "其他";
                    }
                }}
                ,{field:'name',title:'名称', edit: 'text'}
                ,{field:'num',title:'数量', edit: 'text'}
                ,{field:'order_by',title:'排序', edit: 'text'}
                ,{fixed: 'right', align:'center',title:'操作', width:220, toolbar: '#barDemo'}
            ]]
            ,id:'example_eiedata'
            ,page: true
            ,done: function (res, curr, count) {
            }
        });

        //初始化

        //头工具栏事件
        table.on('toolbar(example_eiedata)', function(obj){
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
                            for ( var i = 0; i <data.length; i++){
                                ids.push(data[i].id);
                            }
                        $.get("${pageContext.request.contextPath}/example/eiedata/del?ids="+ids,null,function(res){
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
            };
        });

        //监听行工具事件
        table.on('tool(example_eiedata)', function(obj){
            var data = obj.data;
            if(obj.event === 'info'){
                info(data.id);
            }else if(obj.event === 'del'){
                layer.confirm('真的要删除数据么?', function(index){
                $.get("${pageContext.request.contextPath}/example/eiedata/del?ids="+data.id,null,function(res){
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
            } else if(obj.event === 'setStatus'){
                updateStatus(data.id,'0');//单启用
            }
        });

        //监听单元格编辑
        table.on('edit(example_eiedata)', function(obj){
            var value = obj.value //得到修改后的值
                    ,data = obj.data //得到所在行所有键值
                    ,field = obj.field; //得到字段
//            layer.msg('[ID: '+ data.id +'] ' + field + ' 字段更改为：'+ value);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/example/eiedata/update?"+field+"="+value ,//url
                data: {
                    id:data.id
                },
                success: function (res) {
                    if (res.success) {
                        reloadData();
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

    function reloadData(){
        var classify = $('#classify').val();
        var name = $('#name').val();
        //执行重载
        table.reload('example_eiedata', {
            page: {
                curr: 1 //重新从第 1 页开始
            }
            ,where: {
                classify: classify,
                name: name,
            }
        });
    }

    //新增
    function add(){
            parent.layer.open({
                id: 'eiedata_add',
                //skin: 'layui-layer-molv',
                title: '添加',
                maxmin: true,
                type: 2,
                    content: '${pageContext.request.contextPath}/example/eiedata/toAdd?type=${pd.type}',
                area: ['800px', '500px'],
                end: function () {
                    var val = getOpenCloseParam();
                    if (val == "reload") {
                        reloadData();
                    }
                }
            });
    }

    //新增
    function addMore(){
            parent.layer.open({
                id:'eiedata_add',
                //skin: 'layui-layer-molv',
                title: '批量添加',
                maxmin: true,
                type: 2,
                    content: '${pageContext.request.contextPath}/example/eiedata/toAddMore?type=${pd.type}',
                area: ['800px', '500px'],
                end: function () {
                    var val = getOpenCloseParam();
                    if(val=="reload"){
                            reloadData();
                    }
                }
            });
    }

    //编辑
    function edit(id){
        parent.layer.open({
            id:'eiedata_edit',
            //skin: 'layui-layer-molv',
            title: '编辑',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/example/eiedata/toUpdate?id='+id,
            area: ['800px', '500px'],
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
            content: '${pageContext.request.contextPath}/example/eiedata/findInfo?id='+id,
            area: ['800px', '500px']
        });
    }

    function updateStatus(id,status){
        $.get("${pageContext.request.contextPath}/example/eiedata/updateStatus?id="+id+"&status="+status,null,function(res){
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


    //下载Excel
    function downloadExcel(){
        window.location.href="${pageContext.request.contextPath}/example/eiedata/downloadExcel";
    }

    //跳转到导入
    function toImport(){
        parent.layer.open({
            title: '批量导入',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/example/eiedata/toImport',
            area: ['500px', '300px'],
            end: function () {
                var val = getOpenCloseParam();
                if(val=="reload"){
                    reloadData();
                }
            }
        });
    }


    function exportData() {
        var classify = $('#classify').val();
        var name = $('#name').val();
        window.location.href = "${pageContext.request.contextPath}/example/eiedata/exportData?classify=" + classify + "&name=" + name;
    }



    function exportMergeData() {
        var classify = $('#classify').val();
        var name = $('#name').val();
        window.location.href = "${pageContext.request.contextPath}/example/eiedata/exportMergeData?classify=" + classify + "&name=" + name;
    }



</script>

<%@include file="../../system/admin/bottom.jsp"%>