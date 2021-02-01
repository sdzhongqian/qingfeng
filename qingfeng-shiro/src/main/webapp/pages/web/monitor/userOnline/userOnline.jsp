<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>
<div class="x-nav">
            <span class="layui-breadcrumb">
                <a><cite>系统管理</cite></a>
                <a><cite>在线用户</cite></a>
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
                                <label class="layui-form-lab" style="width: auto">登录名称</label>
                                <input type="text" name="login_name" id="login_name" style="width: 180px;height: 32px;display: inline" placeholder="请输入登录名称" class="layui-input">
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-lab" style="width: auto">姓名</label>
                                <input type="text" name="name" id="name" style="width: 180px;height: 32px;display: inline" placeholder="请输入姓名" class="layui-input">
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-lab" style="width: auto">IP地址</label>
                                <input type="text" name="ipaddr" id="ipaddr" style="width: 180px;height: 32px;display: inline" placeholder="请输入IP地址" class="layui-input">
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-lab" style="width: auto">登录地点</label>
                                <input type="text" name="iprealaddr" id="iprealaddr" style="width: 180px;height: 32px;display: inline" placeholder="请输入登录地点" class="layui-input">
                            </div>
                            <div class="layui-inline">
                                <button type="button" class="layui-btn layui-btn-sm"  lay-submit="" onclick="reloadData()"><i class="layui-icon">&#xe615;</i></button>
                            </div>
                        </form>
                    </div>
                </blockquote>
                <div class="layui-card-body ">
                    <table class="layui-hide" id="system_userOnline" lay-filter="system_userOnline"></table>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container" style="float: left">
    <shiro:hasPermission name="userOnline:retreat">
            <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" lay-event="retreat"><i class="layui-icon"></i>强退</button>
    </shiro:hasPermission>
    </div>
    <div style="float: left;font-size: 14px;">
        当前在线用户数量：<span id="userNum" style="font-size: 18px;color: red;padding: 0 4px;">0</span>个
    </div>
</script>
<script type="text/html" id="barDemo">
    <shiro:hasPermission name="userOnline:retreat">
        <a class="layui-btn layui-btn-xs" lay-event="retreat">强退</a>
    </shiro:hasPermission>
</script>
<script>
    var table,form;
    layui.use(['table','form'], function(){
        table = layui.table;
        form = layui.form;

        table.render({
            elem: '#system_userOnline'
            ,url:'${pageContext.request.contextPath}/monitor/userOnline/findUserOnlineListPage'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            ,defaultToolbar: ['filter', 'exports', 'print', { //自定义头部工具栏右侧图标。如无需自定义，去除该参数即可
                title: '提示'
                ,layEvent: 'laytable_tips'
                ,icon: 'layui-icon-tips'
            }]
            ,title: '在线用户数据表'
            ,cols: [[
                {type: 'checkbox', fixed: 'left', width:40}
                ,{field:'login_name', fixed: 'left',title:'登录名', width:120}
                ,{field:'name', title:'姓名', width:120}
                ,{field:'ipaddr', title:'主机IP'}
                ,{field:'iprealaddr', title:'登录地址'}
                ,{field:'browser', title:'浏览器'}
                ,{field:'os', title:'操作系统'}
                ,{field:'last_login_time', title:'登录时间'}
                ,{fixed: 'right', align:'center',title:'操作', width:220, toolbar: '#barDemo'}
            ]]
            ,page: true
            ,done: function (res, curr, count) {
                $("#userNum").html(count);
            }
        });

        //头工具栏事件
        table.on('toolbar(system_userOnline)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            var data = checkStatus.data;
            switch(obj.event){
                case 'laytable_tips': //小提示
                    layer.msg("小提示：用户组信息模块", {time: 2000});
                    break;
                case 'retreat': //删除
                    if(data.length>0){
                        layer.confirm('强退会导致在线用户退出系统，真的要强退么?', function(index){
                            var ids = [];
                            var names = [];
                            for ( var i = 0; i <data.length; i++){
                                ids.push(data[i].id);
                                names.push(data[i].name);
                            }
                            $.get("${pageContext.request.contextPath}/monitor/userOnline/kickUserOffline?ids="+ids+"&names="+names,null,function(res){
                                if (res.success) {
                                    layer.msg("用户强退成功。", {time: 2000});
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
                        layer.msg('请选择要强退的数据。');
                    }
                    break;
            };
        });

        //监听行工具事件
        table.on('tool(system_userOnline)', function(obj){
            var data = obj.data;
            //console.log(obj)
            if(obj.event === 'retreat'){
                layer.confirm('强退会导致在线用户退出系统，真的要强退么?', function(index){
                    $.get("${pageContext.request.contextPath}/monitor/userOnline/kickUserOffline?ids="+data.id,null,function(res){
                        if (res.success) {
                            layer.msg("用户强退成功。", {time: 2000});
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
        var name = $('#name').val();
        var login_name = $('#login_name').val();
        var ipaddr = $('#ipaddr').val();
        var iprealaddr = $('#iprealaddr').val();
        //执行重载
        table.reload('system_userOnline', {
            page: {
                curr: 1 //重新从第 1 页开始
            }
            ,where: {
                name: name,
                login_name: login_name,
                ipaddr:ipaddr,
                iprealaddr:iprealaddr
            }
        });
    }


</script>

<%@include file="../../system/admin/bottom.jsp"%>