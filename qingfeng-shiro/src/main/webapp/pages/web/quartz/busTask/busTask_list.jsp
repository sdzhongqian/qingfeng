<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>
<div class="x-nav">
            <span class="layui-breadcrumb">
                <a><cite>Quartz定时任务</cite></a>
                <a><cite>业务任务管理</cite></a>
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
                                <label class="layui-form-lab" style="width: auto">任务名称</label>
                                <input type="text" name="job_name" id="job_name" style="width: 180px;height: 32px;display: inline" placeholder="请输入任务名称" class="layui-input">
                            </div>
                            <%--<div class="layui-inline">--%>
                                <%--<label class="layui-form-lab" style="width: auto">任务分组</label>--%>
                                <%--<input type="text" name="job_group" id="job_group" style="width: 180px;height: 32px;display: inline" placeholder="请输入任务分组" class="layui-input">--%>
                            <%--</div>--%>
                            <div class="layui-inline">
                                <button type="button" class="layui-btn layui-btn-sm"  lay-submit="" onclick="reloadData()"><i class="layui-icon">&#xe615;</i></button>
                            </div>
                        </form>
                    </div>
                </blockquote>
                <div class="layui-card-body ">
                    <table class="layui-hide" id="quartz_busTask" lay-filter="quartz_busTask"></table>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <shiro:hasPermission name="busTask:add">
            <button type="button" class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon"></i>新增</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="busTask:edit">
            <button type="button" class="layui-btn layui-btn-normal layui-btn-sm" lay-event="edit"><i class="layui-icon"></i>编辑</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="busTask:del">
            <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" lay-event="del"><i class="layui-icon"></i>删除</button>
        </shiro:hasPermission>
    </div>
</script>
<script type="text/html" id="barDemo">
    <shiro:hasPermission name="busTask:info">
        <a class="layui-btn layui-btn-xs" lay-event="info">详情</a>
    </shiro:hasPermission>
    <shiro:hasPermission name="busTask:execution">
        <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="execution">执行</a>
    </shiro:hasPermission>
    <shiro:hasPermission name="busTask:stopOrRestore">
        {{# if(d.trigger_state == 'N'){ }}
        <a id="stopOrRestore{{d.job_group}}{{d.job_name}}" title="Y" class="layui-btn layui-btn-normal layui-btn-xs" lay-event="stopOrRestore">恢复</a>
        {{#    } }}
        {{# if(d.trigger_state == 'Y'){ }}
        <a id="stopOrRestore{{d.job_group}}{{d.job_name}}" title="N" class="layui-btn layui-btn-normal layui-btn-xs" lay-event="stopOrRestore">停止</a>
        {{#    } }}
    </shiro:hasPermission>
    <jsp:include page="../../system/auth/auth_editdel.jsp">
        <jsp:param value="busTask" name="moduleName"/>
    </jsp:include>
</script>
<script>
    var table,form;
    layui.use(['table','form'], function(){
        table = layui.table;
        form = layui.form;

        table.render({
            elem: '#quartz_busTask'
            ,url:'${pageContext.request.contextPath}/quartz/busTask/findListPage?type=${pd.type}'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            ,defaultToolbar: ['filter', 'exports', 'print', { //自定义头部工具栏右侧图标。如无需自定义，去除该参数即可
                title: '提示'
                ,layEvent: 'laytable_tips'
                ,icon: 'layui-icon-tips'
            }]
            ,title: '角色数据表'
            ,cols: [[
                {type: 'checkbox', fixed: 'left', width:40}
                ,{field:'job_name', title: '任务名称', sort: true, fixed: true}
//                ,{field:'job_group', title: '任务分组'}
                ,{field:'description', title: '任务描述'}
//                ,{field:'job_class_name', title: '执行类'}
                ,{field:'cron_expression', title: '执行时间表达式'}
                ,{field:'trigger_state', title: '状态', sort: true,templet: function(res){
                    if(res.trigger_state=='Y'){
                        return "<span style='color: #32CD32;font-weight: bold'>执行中</span>";
                    }else  if(res.trigger_state=='N'){
                        return "<span style='color: #EE4000;font-weight: bold'>已停止</span>";
                    }
                }}
                ,{field:'order_by', title: '排序'}
                ,{field:'trigger_time', title: '执行开始时间'}
                ,{fixed: 'right', align:'center',title:'操作', width:220, toolbar: '#barDemo'}
            ]]
            ,id:'quartz_busTask'
            ,page: true
            ,done: function (res, curr, count) {
            }
        });

        //头工具栏事件
        table.on('toolbar(quartz_busTask)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            var data = checkStatus.data;
            switch(obj.event){
                case 'laytable_tips': //小提示
                    layer.msg("小提示：角色信息模块", {time: 2000});
                    break;
                case 'add': //增加
                    add();
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
                        layer.confirm('真的要删除数据么?', function(index){
                            var ids = [];
                            for ( var i = 0; i <data.length; i++){
                                ids.push(data[i].id);
                            }
                            $.get("${pageContext.request.contextPath}/quartz/busTask/del?ids="+ids,null,function(res){
                                if (res.success) {
                                    reloadData();
                                    layer.msg("数据删除成功。", {time: 2000});
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
        table.on('tool(quartz_busTask)', function(obj){
            var data = obj.data;
            //console.log(obj)
            if(obj.event === 'info'){
                info(data.id)
            }else if(obj.event === 'del'){
                layer.confirm('真的要删除数据么?', function(index){
                    $.get("${pageContext.request.contextPath}/quartz/busTask/del?ids="+data.id,null,function(res) {
                        if (res.success) {
                            reloadData();
                            layer.msg("数据删除成功。", {time: 2000});
                        } else {
                            if (res.loseSession == 'loseSession') {
                                loseSession(res.msg, res.url)
                            } else {
                                layer.msg(res.msg, {time: 2000});
                            }
                        }
                    })
                });
            } else if(obj.event === 'edit'){
                edit(data.id);
            } else if(obj.event === 'execution'){
                execution(data.job_name,data.job_group);
            } else if(obj.event === 'stopOrRestore'){
                stopOrRestore(data.id,data.job_name,data.job_group);
            }
        });

        //监听单元格编辑
        table.on('edit(quartz_busTask)', function(obj){
            var value = obj.value //得到修改后的值
                    ,data = obj.data //得到所在行所有键值
                    ,field = obj.field; //得到字段
//            layer.msg('[ID: '+ data.id +'] ' + field + ' 字段更改为：'+ value);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/quartz/busTask/update?"+field+"="+value ,//url
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
        var job_name = $('#job_name').val();
        var job_group = $('#job_group').val();
        //执行重载
        table.reload('quartz_busTask', {
            page: {
                curr: 1 //重新从第 1 页开始
            }
            ,where: {
                job_name: job_name,
                job_group:job_group
            }
        });
    }

    //新增
    function add(){
        parent.layer.open({
            id:'busTask_add',
            //skin: 'layui-layer-molv',
            title: '添加',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/quartz/busTask/toAdd?type=${pd.type}',
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
            id:'busTask_edit',
            //skin: 'layui-layer-molv',
            title: '编辑',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/quartz/busTask/toUpdate?id='+id,
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
            content: '${pageContext.request.contextPath}/quartz/busTask/findInfo?id='+id,
            area: ['800px', '500px']
        });
    }

    //执行
    function execution(jobname,jobgroup){
        $.ajax({
            type: "GET",//方法类型
            dataType: "json",//预期服务器返回的数据类型
            url: "${pageContext.request.contextPath}/quartz/busTask/execution?jobname="+jobname+"&jobgroup="+jobgroup,//url
            data: "",
            success: function (res) {
                if (res.success) {
                    layer.msg(res.msg, {time: 2000});
                }else{
                    if(res.loseSession=='loseSession'){
                        loseSession(res.msg,res.url);
                    }else{
                        layer.msg(res.msg, {time: 2000});
                    }
                }
            },
            error : function() {
                layer.msg("异常！");
            }
        });
    }

    //停止或者启用
    function stopOrRestore(id,jobname,jobgroup){
        var stopOrRestore = $("#stopOrRestore"+jobgroup+jobname).text();
        var type = '';
        console.log(stopOrRestore);
        if(stopOrRestore.indexOf("停止")!=-1){
            $("#stopOrRestore"+jobgroup+jobname).text("恢复");
            type = 'N';
        }else{
            $("#stopOrRestore"+jobgroup+jobname).text("停止");
            type = 'Y';
        }
        console.log(type);
        $.ajax({
            type: "GET",//方法类型
            dataType: "json",//预期服务器返回的数据类型
            url: "${pageContext.request.contextPath}/quartz/busTask/stopOrRestore?id="+id+"&jobname="+jobname+"&jobgroup="+jobgroup+"&type="+type,//url
            data: "",
            success: function (res) {
                if (res.success) {
                    location.reload();
                    layer.msg(res.msg, {time: 2000});
                }else{
                    if(res.loseSession=='loseSession'){
                        loseSession(res.msg,res.url);
                    }else{
                        layer.msg(res.msg, {time: 2000});
                    }
                }
            },
            error : function() {
                layer.msg("异常！");
            }
        });
    }

</script>

<%@include file="../../system/admin/bottom.jsp"%>