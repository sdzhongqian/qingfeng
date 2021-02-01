<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>
<div class="x-nav">
            <span class="layui-breadcrumb">
                <a><cite>系统管理</cite></a>
                <a><cite>代码生成</cite></a>
            </span>
    <a class="layui-btn layui-btn-sm" style="line-height:1.6em;margin-top:3px;float:right" onclick="location.reload()" title="刷新">
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
                                <label class="layui-form-lab" style="width: auto">表名称</label>
                                <input type="text" name="name" id="name" style="width: 180px;height: 32px;display: inline" placeholder="请输入角色名称" class="layui-input">
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-lab" style="width: auto">表描述</label>
                                <input type="text" name="short_name" id="short_name" style="width: 180px;height: 32px;display: inline" placeholder="请输入角色简称" class="layui-input">
                            </div>
                            <div class="layui-inline">
                                <div style="float: left;padding-left: 5px">
                                    <label class="layui-form-lab" style="width: auto">表时间：</label>
                                    <input type="text" name="start_time" id="start_time" style="width: 200px;height: 32px;display: inline" placeholder="起始日期" class="layui-input">
                                    <label class="layui-form-lab" style="width: auto">至:</label>
                                    <input type="text" name="end_time" id="end_time" style="width: 200px;height: 32px;display: inline" placeholder="结束日期" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-inline">
                                <button type="button" class="layui-btn layui-btn-sm"  lay-submit="" onclick="reloadData()"><i class="layui-icon">&#xe615;</i></button>
                            </div>
                        </form>
                    </div>
                </blockquote>
                <div class="layui-card-body ">
                    <table class="layui-hide" id="system_gencode" lay-filter="system_gencode"></table>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <shiro:hasPermission name="gencode:gencode">
            <button type="button" class="layui-btn layui-btn-normal layui-btn-sm" lay-event="gencode"><i class="layui-icon"></i>生成代码</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="gencode:import">
            <button type="button" class="layui-btn layui-btn-normal layui-btn-sm" lay-event="import"><i class="layui-icon">&#xe67d;</i>导入</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="gencode:edit">
            <button type="button" class="layui-btn layui-btn-normal layui-btn-sm" lay-event="edit"><i class="layui-icon"></i>编辑</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="gencode:del">
            <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" lay-event="del"><i class="layui-icon"></i>删除</button>
        </shiro:hasPermission>
    </div>
</script>
<script type="text/html" id="barDemo">
    <shiro:hasPermission name="gencode:viewCode">
        <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="viewCode">预览</a>
    </shiro:hasPermission>
    <shiro:hasPermission name="gencode:gencode">
        <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="gencode">生成</a>
    </shiro:hasPermission>
    <shiro:hasPermission name="gencode:info">
        <a class="layui-btn layui-btn-xs" lay-event="info">详情</a>
    </shiro:hasPermission>
    <jsp:include page="../auth/auth_editdel.jsp">
        <jsp:param value="gencode" name="moduleName"/>
    </jsp:include>
</script>
<script>
    var table,form,laydate;
    layui.use(['table','laydate'], function(){
        table = layui.table;
        form = layui.form;
        laydate = layui.laydate;

        table.render({
            elem: '#system_gencode'
            ,url:'${pageContext.request.contextPath}/system/gencode/findListPage'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            ,defaultToolbar: ['filter', 'exports', 'print']
            ,title: '角色数据表'
            ,cols: [[
                {type: 'checkbox', fixed: 'left', width:40}
                ,{field:'table_name', fixed: 'left',title:'表名称', width:200}
                ,{field:'table_comment', title:'表描述', edit: 'text'}
                ,{field:'temp_type', title: '模板类型', sort: true,templet: function(res){
                    if(res.temp_type=='0'){
                        return "单表";
                    }else  if(res.temp_type=='1'){
                        return "主子表";
                    }else  if(res.temp_type=='2'){
                        return "树表";
                    }else  if(res.temp_type=='3'){
                        return "组织树表";
                    }
                }}
                ,{field:'pack_path', title:'生成包路径', edit: 'text'}
                ,{field:'mod_name', title:'模块名称', edit: 'text'}
                ,{field:'bus_name', title:'业务名称', edit: 'text'}
                ,{field:'order_by', title:'排序', edit: 'text', width:60}
                ,{field:'create_time', title:'创建时间'}
                ,{fixed: 'right', align:'center',title:'操作', width:200, toolbar: '#barDemo'}
            ]]
            ,id:'system_gencode'
            ,page: true
            ,done: function (res, curr, count) {
            }
        });

        //初始化检索时间段
        initDatePeriod("start_time","end_time");

        //头工具栏事件
        table.on('toolbar(system_gencode)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            var data = checkStatus.data;
            switch(obj.event){
                case 'laytable_tips': //小提示
                    layer.msg("小提示：代码生成模块", {time: 2000});
                    break;
                case 'gencode': //增加
                    if(data.length!=1){
                        layer.msg('请选择一条数据进行操作。');
                    }else{
                        gencode(data[0].id,data[0].gen_type)
                    }
                    break;
                case 'import': //导入
                    importTable();
                    break;
                case 'edit': //编辑
                    if(data.length!=1){
                        layer.msg('请选择一条数据进行操作。');
                    }else{
                        if($("#edit_"+data[0].id).text()==undefined||$("#edit_"+data[0].id).text()==''||$("#edit_"+data[0].id).text()==null){
                            layer.msg("没有编辑权限,请选择其他数据进行编辑。", {time: 2000});
                            return;
                        }
                        edit(data[0].id,data[0].table_comment)
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
                        layer.confirm('删除信息会同步删除配置的字段信息，真的要删除数据么?', function(index){
                            var ids = [];
                            var names = [];
                            for ( var i = 0; i <data.length; i++){
                                ids.push(data[i].id);
                                names.push(data[i].name);
                            }
                            $.get("${pageContext.request.contextPath}/system/gencode/del?ids="+ids+"&names="+names,null,function(res){
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
        table.on('tool(system_gencode)', function(obj){
            var data = obj.data;
            //console.log(obj)
            if(obj.event === 'info'){
                info(data.id);
            }else if(obj.event === 'del'){
                layer.confirm('删除信息会同步删除配置的字段信息，真的要删除数据么?', function(index){
                    $.get("${pageContext.request.contextPath}/system/gencode/del?ids="+data.id,null,function(res){
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
                edit(data.id,data.table_comment)
            } else if(obj.event === 'gencode'){
                gencode(data.id,data.gen_type)
            } else if(obj.event === 'viewCode'){
                viewCode(data.id,data.gen_type)
            }
        });

        //监听单元格编辑
        table.on('edit(system_gencode)', function(obj){
            var value = obj.value //得到修改后的值
                    ,data = obj.data //得到所在行所有键值
                    ,field = obj.field; //得到字段
            console.log('[ID: '+ data.id +'] ' + field + ' 字段更改为：'+ value);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/system/gencode/update?"+field+"="+value ,//url
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

    });

    function reloadData(){
        var name = $('#name').val();
        var short_name = $('#short_name').val();
        var status = $("#status option:selected").val();
        //执行重载
        table.reload('system_gencode', {
            page: {
                curr: 1 //重新从第 1 页开始
            }
            ,where: {
                name: name,
                short_name: short_name,
                status:status
            }
        });
    }

    //导入
    function importTable(){
        parent.layer.open({
            id:'gencode_importTable',
            //skin: 'layui-layer-molv',
            title: '导入',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/system/gencode/toImportTable',
            area: ['1000px', '500px'],
            end: function () {
                var val = getOpenCloseParam();
                if(val=="reload"){
                    reloadData();
                }
            }
        });
    }

    //编辑
    function edit(id,table_comment){
//        console.log(id);
        parent.xadmin.add_tab(table_comment,'${pageContext.request.contextPath}/system/gencode/toUpdate?id='+id);
        <%--parent.layer.open({--%>
            <%--id:'gencode_edit',--%>
            <%--//skin: 'layui-layer-molv',--%>
            <%--title: '编辑',--%>
            <%--maxmin: true,--%>
            <%--type: 2,--%>
            <%--content: '${pageContext.request.contextPath}/system/gencode/toUpdate?id='+id,--%>
            <%--area: ['1000px', '540px'],--%>
            <%--end: function () {--%>
                <%--var val = getOpenCloseParam();--%>
                <%--if(val=="reload"){--%>
                    <%--reloadData();--%>
                <%--}--%>
            <%--}--%>
        <%--});--%>
    }

    //详情
    function info(id){
        parent.layer.open({
            id:'gencode_info',
            //skin: 'layui-layer-molv',
            title: '详情',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/system/gencode/findInfo?id='+id,
            area: ['1000px', '500px']
        });
    }

    //代码预览
    function viewCode(id){
        $.ajax({
            type: "GET",//方法类型
            dataType: "json",//预期服务器返回的数据类型
            url: "${pageContext.request.contextPath}/system/gencode/gencode?id="+id ,//url
            data: {},
            success: function (res) {
                console.log(res);
                if (res.success) {
                    parent.layer.open({
                        id:'gencode_view',
                        //skin: 'layui-layer-molv',
                        title: '详情',
                        maxmin: true,
                        type: 2,
                        content: '${pageContext.request.contextPath}/system/gencode/toViewCode?id='+id+"&path="+res.data,
                        area: ['1000px', '500px']
                    });

                }else{
                    if(res.loseSession=='loseSession'){
                        loseSession(res.msg,res.url)
                    }else{
                        layer.msg(res.msg, {time: 2000});
                    }
                }
            }
        });
    }


    //代码生成
    function gencode(id,gen_type){
        $.ajax({
            type: "GET",//方法类型
            dataType: "json",//预期服务器返回的数据类型
            url: "${pageContext.request.contextPath}/system/gencode/gencode?id="+id ,//url
            data: {},
            success: function (res) {
                console.log(res);
                if (res.success) {
                    if(gen_type=='0'){
                        window.location.href="${pageContext.request.contextPath}/system/gencode/downloadCode?id="+id+"&path="+res.data;
                    }else if(gen_type=='1'){
                        layer.msg(res.msg, {time: 2000});
                    }
                }else{
                    if(res.loseSession=='loseSession'){
                        loseSession(res.msg,res.url)
                    }else{
                        layer.msg(res.msg, {time: 2000});
                    }
                }
            }
        });
    }



</script>

<%@include file="../admin/bottom.jsp"%>