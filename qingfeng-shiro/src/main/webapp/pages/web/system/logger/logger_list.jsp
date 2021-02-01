<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>
<div class="x-nav">
            <span class="layui-breadcrumb">
                <a><cite>系统管理</cite></a>
                <a><cite>日志管理</cite></a>
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
                                <label class="layui-form-lab" style="width: auto">标题</label>
                                <input type="text" name="title" id="title" style="width: 180px;height: 32px;display: inline" placeholder="请输入标题" class="layui-input">
                            </div>
                            <div class="layui-inline">
                                <button type="button" class="layui-btn layui-btn-sm"  lay-submit="" onclick="reloadData()"><i class="layui-icon">&#xe615;</i></button>
                            </div>
                        </form>
                    </div>
                </blockquote>
                <div class="layui-card-body ">
                    <table class="layui-hide" id="system_logger" lay-filter="system_logger"></table>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <shiro:hasPermission name="logger:del">
            <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" lay-event="del"><i class="layui-icon"></i>删除</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="logger:exportExcel">
            <button type="button" class="layui-btn layui-btn-primary layui-btn-sm" lay-event="exportExcel"><i class="layui-icon">&#xe67d</i>导出</button>
        </shiro:hasPermission>
    </div>
</script>
<script type="text/html" id="barDemo">
    <shiro:hasPermission name="logger:info">
        <a class="layui-btn layui-btn-xs" lay-event="info">详情</a>
    </shiro:hasPermission>
    <shiro:hasPermission name="logger:del">
        <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
    </shiro:hasPermission>
</script>
<script>
    var table,form;
    layui.use(['table','form'], function(){
        table = layui.table;
        form = layui.form;

        table.render({
            elem: '#system_logger'
            ,url:'${pageContext.request.contextPath}/system/logger/findListPage'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            ,defaultToolbar: ['filter', 'exports', 'print', { //自定义头部工具栏右侧图标。如无需自定义，去除该参数即可
                title: '提示'
                ,layEvent: 'laytable_tips'
                ,icon: 'layui-icon-tips'
            }]
            ,title: '日志数据表'
            ,cols: [[
                {type: 'checkbox', fixed: 'left', width:40}
                ,{field:'title', fixed: 'left',title:'标题'}
                ,{field:'content', title:'内容'}
                ,{field:'operate_type', title:'请求类型',width:120}
                ,{field:'operate_user', title:'操作人',width:120}
                ,{field:'create_time', title:'操作时间',width:160}
                ,{fixed: 'right', align:'center',title:'操作', width:140, toolbar: '#barDemo'}
            ]]
            ,id:'system_logger'
            ,page: true
            ,done: function (res, curr, count) {
            }
        });

        //头工具栏事件
        table.on('toolbar(system_logger)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            var data = checkStatus.data;
            switch(obj.event){
                case 'laytable_tips': //小提示
                    layer.msg("小提示：用户组信息模块", {time: 2000});
                    break;
                case 'del': //删除
                    if(data.length>0){
                        layer.confirm('删除数据会同步删除【角色菜单信息】，真的要删除数据么?', function(index){
                            var ids = [];
                            var names = [];
                            for ( var i = 0; i <data.length; i++){
                                ids.push(data[i].id);
                                names.push(data[i].name);
                            }
                            $.get("${pageContext.request.contextPath}/system/logger/del?ids="+ids+"&names="+names,null,function(res){
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
                case 'exportExcel': //导出Excel
                    exportExcel();
                    break;
            };
        });

        //监听行工具事件
        table.on('tool(system_logger)', function(obj){
            var data = obj.data;
            //console.log(obj)
            if(obj.event === 'info'){
                info(data.id);
            }else if(obj.event === 'del'){
                layer.confirm('删除数据会同步删除【角色菜单信息】，真的要删除数据么?', function(index){
                    $.get("${pageContext.request.contextPath}/system/logger/del?ids="+data.id,null,function(res){
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
            }
        });

    });

    function reloadData(){
        var title = $('#title').val();
        //执行重载
        table.reload('system_logger', {
            page: {
                curr: 1 //重新从第 1 页开始
            }
            ,where: {
                title:title
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
            content: '${pageContext.request.contextPath}/system/logger/findInfo?id='+id,
            area: ['800px', '500px']
        });
    }


    //导出Excel
    function exportExcel(){
        var title = $('#title').val();
        window.location.href="${pageContext.request.contextPath}/system/logger/exportData?title="+title;
    }


</script>

<%@include file="../admin/bottom.jsp"%>