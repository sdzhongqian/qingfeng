<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>
<div class="x-nav">
            <span class="layui-breadcrumb">
                <a><cite>系统管理</cite></a>
                <a><cite>主题设置</cite></a>
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
                                <label class="layui-form-lab" style="width: auto">主题名称</label>
                                <input type="text" name="title" id="title" style="width: 180px;height: 32px;display: inline" placeholder="请输入主题名称" class="layui-input">
                            </div>
                            <div class="layui-inline">
                                <div style="float: left;padding-top: 5px;">
                                    <label class="layui-form-lab" style="width: auto">主题类型</label>
                                </div>
                                <div style="float: left;padding-left: 5px">
                                    <select name="type" id="type" style="width: 120px;height: 32px;" class="layui-input">
                                        <option value=""></option>
                                        <option value="0">系统主题</option>
                                        <option value="1">自定义主题</option>
                                    </select>
                                </div>
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
                    <table class="layui-hide" id="system_theme" lay-filter="system_theme"></table>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <shiro:hasPermission name="theme:add">
            <button type="button" class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon"></i>新增</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="theme:exportExcel">
            <button type="button" class="layui-btn layui-btn-primary layui-btn-sm" lay-event="exportExcel"><i class="layui-icon">&#xe67d</i>导出</button>
        </shiro:hasPermission>
    </div>
</script>
<script type="text/html" id="barDemo">
    <shiro:hasPermission name="theme:info">
        <a class="layui-btn layui-btn-xs" lay-event="info">详情</a>
    </shiro:hasPermission>
    <shiro:hasPermission name="theme:exportExcel">
        <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="exportExcel">导出</a>
    </shiro:hasPermission>
    <shiro:hasPermission name="theme:setStatus">
        {{ d.status == '0' ? '<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="setStatus1">禁用</a>' : '' }}
        {{ d.status == '1' ? '<a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="setStatus0">启用</a>' : '' }}
    </shiro:hasPermission>
    {{# if(d.type == '1'){ }}
    <jsp:include page="../auth/auth_del.jsp">
        <jsp:param value="theme" name="moduleName"/>
    </jsp:include>
    {{#    } }}
</script>
<script>
    var table,form;
    layui.use(['table','form'], function(){
        table = layui.table;
        form = layui.form;

        table.render({
            elem: '#system_theme'
            ,url:'${pageContext.request.contextPath}/system/theme/findListPage'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            ,defaultToolbar: ['filter', 'exports', 'print', { //自定义头部工具栏右侧图标。如无需自定义，去除该参数即可
                title: '提示'
                ,layEvent: 'laytable_tips'
                ,icon: 'layui-icon-tips'
            }]
            ,title: '主题设置'
            ,cols: [[
                {type: 'checkbox', fixed: 'left', width:40}
                ,{field:'type', title: '类型', sort: true,templet: function(res){
                    if(res.type=='0'){
                        return "系统主题";
                    }else  if(res.type=='1'){
                        return "自定义主题";
                    }
                }}
                ,{field:'title',title:'主题名称', edit: 'text'}
                ,{field:'use_num', title:'使用人数'}
//                ,{field:'status', title: '状态', sort: true,templet: function(res){
//                    if(res.status=='0'){
//                        return "<span style='color: #32CD32;font-weight: bold'>启用</span>";
//                    }else  if(res.status=='1'){
//                        return "<span style='color: #EE4000;font-weight: bold'>禁用</span>";
//                    }
//                }}
                ,{field:'order_by', title:'排序', edit: 'text'}
                ,{field:'create_time', title:'创建时间'}
                ,{fixed: 'right', align:'center',title:'操作', width:220, toolbar: '#barDemo'}
            ]]
            ,id:'system_theme'
            ,page: true
            ,done: function (res, curr, count) {
            }
        });

        //头工具栏事件
        table.on('toolbar(system_theme)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            var data = checkStatus.data;
            switch(obj.event){
                case 'laytable_tips': //小提示
                    layer.msg("小提示：角色信息模块", {time: 2000});
                    break;
                case 'add': //增加
                    add();
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
                        layer.confirm('删除数据会同步删除【角色菜单信息】，真的要删除数据么?', function(index){
                            var ids = [];
                            var names = [];
                            for ( var i = 0; i <data.length; i++){
                                ids.push(data[i].id);
                                names.push(data[i].name);
                            }
                            $.get("${pageContext.request.contextPath}/system/theme/del?ids="+ids+"&names="+names,null,function(res){
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
                case 'exportExcel':
                    if(data.length!=1){
                        layer.msg('请选择一条数据进行操作。');
                    }else{
                        exportExcel(data[0].id)
                    }
                    break;
            };
        });

        //监听行工具事件
        table.on('tool(system_theme)', function(obj){
            var data = obj.data;
            //console.log(obj)
            if(obj.event === 'info'){
                info(data.id);
            }else if(obj.event === 'del'){
                layer.confirm('删除数据会同步删除【角色菜单信息】，真的要删除数据么?', function(index){
                    $.get("${pageContext.request.contextPath}/system/theme/del?ids="+data.id,null,function(res){
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
            } else if(obj.event === 'exportExcel'){
                exportExcel(data.id)
            } else if(obj.event === 'setStatus1'){
                updateStatus(data.id,'1');
            } else if(obj.event === 'setStatus0'){
                updateStatus(data.id,'0');
            }
        });

        //监听单元格编辑
        table.on('edit(system_theme)', function(obj){
            var value = obj.value //得到修改后的值
                    ,data = obj.data //得到所在行所有键值
                    ,field = obj.field; //得到字段
//            layer.msg('[ID: '+ data.id +'] ' + field + ' 字段更改为：'+ value);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/system/theme/update?"+field+"="+value ,//url
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
        var title = $('#title').val();
        var status = $("#status option:selected").val();
        var type = $("#type option:selected").val();

        //执行重载
        table.reload('system_theme', {
            page: {
                curr: 1 //重新从第 1 页开始
            }
            ,where: {
                title:title,
                status:status,
                type:type
            }
        });
    }

    //新增
    function add(){
        layer.alert('请找群主获取，微信号：axt1604 ')
//        parent.showCreate();
    }

    //详情
    function info(id){
        parent.layer.open({
            //skin: 'layui-layer-molv',
            title: '详情',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/system/theme/findInfo?id='+id,
            area: ['800px', '500px']
        });
    }


    //导出Excel
    function exportExcel(id){
        var name = $('#name').val();
        var short_name = $('#short_name').val();
        var status = $("#status option:selected").val();
        window.location.href="${pageContext.request.contextPath}/system/theme/exportData?name="+name
                +"&short_name="+short_name
                +"&status="+status;
    }


    function updateStatus(id,status){
        $.get("${pageContext.request.contextPath}/system/theme/updateStatus?id="+id+"&status="+status,null,function(res){
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