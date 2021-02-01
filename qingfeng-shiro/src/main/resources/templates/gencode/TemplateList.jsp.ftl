<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>
<#assign statusType = 'false'>
<#list fieldList as obj>
    <#if obj.field_name == 'status'>
        <#assign statusType = 'true'>
    </#if>
</#list>
<div class="x-nav">
    <span class="layui-breadcrumb">
        <a><cite>青锋系统</cite></a>
        <a><cite>${tablePd.menu_name}</cite></a>
    </span>
<#if tablePd.temp_type == '2'>
    <a class="layui-btn layui-btn-sm" style="line-height:1.6em;margin-top:3px;float:right" onclick="reload()" title="刷新">
</#if>
<#if tablePd.temp_type != '2'>
    <a class="layui-btn layui-btn-sm" style="line-height:1.6em;margin-top:3px;float:right" onclick="reloadData()" title="刷新">
</#if>
        <i class="layui-icon layui-icon-refresh" style="line-height:30px"></i>
    </a>
</div>
<div class="layui-fluid">
<#if tablePd.temp_type == '2'>
    <div style="float: left; width: 15%; margin-right:15px;min-height: 580px;" id="leftDiv">
        <ul id="treeDemo" class="ztree"></ul>
        <input type="hidden" name="tree_id" id="tree_id" value="" />
        <input type="hidden" id="tree_name" value="" />
    </div>
    <div style="float: left; width: 83%" id="rightDiv">
</#if>
    <div class="layui-row layui-col-space1">
        <div class="layui-col-md12">
            <div class="layui-card">
                <blockquote id="search" class="layui-elem-quote" style="position: relative;">
                    <div class="layui-card-body ">
                        <form class="layui-form layui-col-space5">
                <#list fieldList as obj>
                    <#if obj.field_query == 'Y'>
                        <#if obj.query_type == 'time_period'>
                            <div class="layui-inline">
                                <div class="layui-inline">
                                    <label class="layui-form-lab" style="width: auto">${obj.field_comment}</label>
                                    <input type="text" name="start_time" id="start_time" style="width: 180px;height: 32px;display: inline" placeholder="请输入开始日期" class="layui-input">
                                </div>
                                <div class="layui-inline">
                                    <label class="layui-form-lab" style="width: auto">~</label>
                                    <input type="text" name="end_time" id="end_time" style="width: 180px;height: 32px;display: inline" placeholder="请输入结束日期" class="layui-input">
                                </div>
                            </div>
                        </#if>
                        <#if obj.query_type != 'time_period'>
                        <#--查询只处理1-7的类型-->
                        <#if obj.show_type == '1'||obj.show_type == '6'||obj.show_type == '7'>
                            <div class="layui-inline">
                                <label class="layui-form-lab" style="width: auto">${obj.field_comment}</label>
                                <input type="text" name="${obj.field_name}" id="${obj.field_name}" style="width: 180px;height: 32px;display: inline" placeholder="请输入${obj.field_comment}" class="layui-input">
                            </div>
                        </#if>
                        <#if obj.show_type == '2'>
                            <div class="layui-inline">
                                <label class="layui-form-lab" style="width: auto">${obj.field_comment}</label>
                                <textarea name="${obj.field_name}" id="${obj.field_name}" placeholder="请输入${obj.field_comment}" class="layui-textarea" style="min-height: 40px;"></textarea>
                            </div>
                        </#if>
                        <#if obj.show_type == '3'>
                            <div class="layui-inline">
                                <div style="float: left;padding-top: 5px;">
                                    <label class="layui-form-lab" style="width: auto">${obj.field_comment}</label>
                                </div>
                                <div style="float: left;padding-left: 5px">
                                    <select name="${obj.field_name}" id="${obj.field_name}" style="width: 120px;height: 32px;" class="layui-input">
                                        <option value=""></option>
                                        <#if obj.option_content?contains(";")>
                                            <#list obj.option_content?split(";") as name>
                                                <#assign param = name?split("/")>
                                                <option value="${param[0]}">${param[1]}</option>
                                            </#list>
                                        </#if>
                                    </select>
                                </div>
                            </div>
                        </#if>
                        <#if obj.show_type == '4'>
                            <div class="layui-inline">
                                <div style="float: left;padding-top: 5px;">
                                    <label class="layui-form-lab" style="width: auto">${obj.field_comment}</label>
                                </div>
                                <div id="div_${obj.field_name}" style="float: left;padding-left: 5px">
                                    <#if obj.option_content?contains(";")>
                                        <#list obj.option_content?split(";") as name>
                                            <#assign param = name?split("/")>
                                            <input type="radio" name="${obj.field_name}" value="${param[0]}" title="${param[1]}">
                                        </#list>
                                    </#if>
                                </div>
                            </div>
                        </#if>
                        <#if obj.show_type == '5'>
                            <div class="layui-inline">
                                <div style="float: left;padding-top: 5px;">
                                    <label class="layui-form-lab" style="width: auto">${obj.field_comment}</label>
                                </div>
                                <div id="div_${obj.field_name}" style="float: left;padding-left: 5px">
                                    <#if obj.option_content?contains(";")>
                                        <#list obj.option_content?split(";") as name>
                                            <#assign param = name?split("/")>
                                            <input type="checkbox" name="${obj.field_name}" value="${param[0]}" lay-skin="primary" title="${param[1]}">
                                        </#list>
                                    </#if>
                                </div>
                            </div>
                        </#if>
                        </#if>
                    </#if>
                </#list>
                            <div class="layui-inline">
                            <#if tablePd.temp_type == '2'>
                                <button type="button" class="layui-btn layui-btn-sm"  lay-submit="" onclick="reload()"><i class="layui-icon">&#xe615;</i></button>
                            </#if>
                            <#if tablePd.temp_type != '2'>
                                <button type="button" class="layui-btn layui-btn-sm"  lay-submit="" onclick="reloadData()"><i class="layui-icon">&#xe615;</i></button>
                            </#if>
                            </div>
                        </form>
                    </div>
                </blockquote>
                <div class="layui-card-body ">
                    <table class="layui-hide" id="${tablePd.mod_name}_${tablePd.bus_name}" lay-filter="${tablePd.mod_name}_${tablePd.bus_name}"></table>
                </div>
            </div>
        </div>
    </div>
<#if tablePd.temp_type == '2'>
    </div>
</#if>
</div>

<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <shiro:hasPermission name="${tablePd.mod_name}:add">
            <button type="button" class="layui-btn layui-btn-sm" lay-event="add"><i class="layui-icon"></i>新增</button>
        </shiro:hasPermission>
        <#if tablePd.more_add == '1'>
        <shiro:hasPermission name="${tablePd.mod_name}:addMore">
            <button type="button" class="layui-btn layui-btn-sm" lay-event="addMore"><i class="layui-icon"></i>批量新增</button>
        </shiro:hasPermission>
        </#if>
        <shiro:hasPermission name="${tablePd.mod_name}:edit">
            <button type="button" class="layui-btn layui-btn-normal layui-btn-sm" lay-event="edit"><i class="layui-icon"></i>编辑</button>
        </shiro:hasPermission>
        <shiro:hasPermission name="${tablePd.mod_name}:del">
            <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" lay-event="del"><i class="layui-icon"></i>删除</button>
        </shiro:hasPermission>
    </div>
</script>
<script type="text/html" id="barDemo">
    <shiro:hasPermission name="${tablePd.mod_name}:info">
        <a class="layui-btn layui-btn-xs" lay-event="info">详情</a>
    </shiro:hasPermission>
    <jsp:include page="../auth/auth_editdel.jsp">
        <jsp:param value="${tablePd.mod_name}" name="moduleName"/>
    </jsp:include>
    <#if tablePd.status_type == '0'&&statusType=='true'>
    <shiro:hasPermission name="${tablePd.mod_name}:setStatus">
        {{ d.status == '1' ? '<a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="setStatus">启用</a>' : '' }}
        {{ d.status == '0' ? '<a class="layui-btn layui-btn-xs">启用中</a>' : '' }}
    </shiro:hasPermission>
    </#if>
    <#if tablePd.status_type == '1'&&statusType=='true'>
    <shiro:hasPermission name="${tablePd.mod_name}:setStatus">
        {{ d.status == '0' ? '<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="setStatus1">禁用</a>' : '' }}
        {{ d.status == '1' ? '<a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="setStatus0">启用</a>' : '' }}
    </shiro:hasPermission>
    </#if>
</script>
<#if tablePd.temp_type == '2'>
<script type="text/javascript" src="${'$'}{pageContext.request.contextPath}/resources/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="${'$'}{pageContext.request.contextPath}/resources/plugins/ztree/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${'$'}{pageContext.request.contextPath}/resources/plugins/ztree/js/jquery.ztree.all.js"></script>
<link rel="stylesheet" href="${'$'}{pageContext.request.contextPath}/resources/plugins/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css" />
<%@include file="${tablePd.bus_name}_ztree.jsp" %>
</#if>
<script type="text/javascript" src="${'$'}{pageContext.request.contextPath}/resources/js/qfAjaxReq.js"></script>
<script>
    var table,form;
    layui.use(['table','form'], function(){
        table = layui.table;
        form = layui.form;

        table.render({
            elem: '#${tablePd.mod_name}_${tablePd.bus_name}'
            ,url:'${'$'}{pageContext.request.contextPath}/${tablePd.mod_name}/${tablePd.bus_name}/findListPage?type=${'$'}{pd.type}'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            ,defaultToolbar: ['filter', 'exports', 'print', { //自定义头部工具栏右侧图标。如无需自定义，去除该参数即可
                title: '提示'
                ,layEvent: 'laytable_tips'
                ,icon: 'layui-icon-tips'
            }]
            ,title: '${tablePd.menu_name}'
            ,cols: [[
                {type: 'checkbox', fixed: 'left', width:40}
                <#list fieldList as obj>
                <#if obj.field_list == 'Y'>
                <#if obj.show_type == '1'>
                ,{field:'${obj.field_name}',title:'${obj.field_comment}', edit: 'text'}
                </#if>
                <#if obj.show_type != '1'>
                ,{field:'${obj.field_name}',title:'${obj.field_comment}'}
                </#if>
                </#if>
                </#list>
                <#if (tablePd.status_type == '0' || tablePd.status_type == '1') &&statusType=='true'>
                    ,{field:'status', title: '状态', sort: true,templet: function(res){
                    if(res.status=='0'){
                        return "<span style='color: #32CD32;font-weight: bold'>启用</span>";
                    }else  if(res.status=='1'){
                        return "<span style='color: #EE4000;font-weight: bold'>禁用</span>";
                    }
                }}
                </#if>
                ,{fixed: 'right', align:'center',title:'操作', width:220, toolbar: '#barDemo'}
            ]]
            ,id:'${tablePd.mod_name}_${tablePd.bus_name}'
            ,page: true
            ,done: function (res, curr, count) {
            }
        });

        //初始化
<#list fieldList as obj>
    <#if obj.field_query == 'Y'>
        <#if obj.query_type == 'time_period'>
            //初始化检索时间段
            initDatePeriod("start_time","end_time");
        </#if>
        <#if obj.query_type != 'time_period'>
        <#if obj.show_type == '3'>
            <#if !obj.option_content?contains(";")>
                findSelectDictionary('${obj.option_content}','${obj.field_name}','');
            </#if>
        </#if>
        <#if obj.show_type == '4'>
            <#if !obj.option_content?contains(";")>
                findRadioDictionary('${obj.option_content}','${obj.field_name}','');
            </#if>
        </#if>
        <#if obj.show_type == '5'>
            <#if !obj.option_content?contains(";")>
                findCheckboxDictionary('${obj.option_content}','${obj.field_name}','');
            </#if>
        </#if>
        <#if obj.show_type == '7'>
            initDateType("${obj.field_name}",false);
        </#if>
        </#if>
    </#if>
</#list>

        //头工具栏事件
        table.on('toolbar(${tablePd.mod_name}_${tablePd.bus_name})', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            var data = checkStatus.data;
            switch(obj.event){
                case 'laytable_tips': //小提示
                    layer.msg("小提示：角色信息模块", {time: 2000});
                    break;
                case 'add': //增加
                    add();
                    break;
                <#if tablePd.more_add == '1'>
                case 'addMore': //批量增加
                    addMore();
                    break;
                </#if>
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
                        ${'$'}.get("${'$'}{pageContext.request.contextPath}/${tablePd.mod_name}/${tablePd.bus_name}/del?ids="+ids+"&names="+names,null,function(res){
                                if (res.success) {
                                    layer.msg("数据删除成功。", {time: 2000});
                                <#if tablePd.temp_type == '2'>
                                    reload();
                                </#if>
                                <#if tablePd.temp_type != '2'>
                                    reloadData();
                                </#if>
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
        table.on('tool(${tablePd.mod_name}_${tablePd.bus_name})', function(obj){
            var data = obj.data;
            if(obj.event === 'info'){
                info(data.id);
            }else if(obj.event === 'del'){
                layer.confirm('真的要删除数据么?', function(index){
                ${'$'}.get("${'$'}{pageContext.request.contextPath}/${tablePd.mod_name}/${tablePd.bus_name}/del?ids="+data.id,null,function(res){
                        if (res.success) {
                            layer.msg("数据删除成功。", {time: 2000});
                        <#if tablePd.temp_type == '2'>
                            reload();
                        </#if>
                        <#if tablePd.temp_type != '2'>
                            reloadData();
                        </#if>
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
            <#if tablePd.status_type == '0'>
            } else if(obj.event === 'setStatus'){
                updateStatus(data.id,'0');//单启用
            </#if>
            <#if tablePd.status_type == '1'>
            } else if(obj.event === 'setStatus1'){
                updateStatus(data.id,'1');
            } else if(obj.event === 'setStatus0'){
                updateStatus(data.id,'0');
            </#if>
            }
        });

        //监听单元格编辑
        table.on('edit(${tablePd.mod_name}_${tablePd.bus_name})', function(obj){
            var value = obj.value //得到修改后的值
                    ,data = obj.data //得到所在行所有键值
                    ,field = obj.field; //得到字段
//            layer.msg('[ID: '+ data.id +'] ' + field + ' 字段更改为：'+ value);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${'$'}{pageContext.request.contextPath}/${tablePd.mod_name}/${tablePd.bus_name}/update?"+field+"="+value ,//url
                data: {
                    id:data.id
                },
                success: function (res) {
                    if (res.success) {
                    <#if tablePd.temp_type == '2'>
                        reload();
                    </#if>
                    <#if tablePd.temp_type != '2'>
                        reloadData();
                    </#if>
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

<#if tablePd.temp_type == '2'>
    function reload(){
        var parent_id =  $("#tree_id").val();
        reloadData(parent_id);
        findTreeData(parent_id);
    }
</#if>
<#if tablePd.temp_type == '2'>
    function reloadData(parent_id){
</#if>
<#if tablePd.temp_type != '2'>
    function reloadData(){
</#if>
    <#list fieldList as obj>
    <#if obj.field_query == 'Y'>
        <#if obj.query_type == 'time_period'>
        var start_time = $('#start_time').val();
        var end_time = $('#end_time').val();
        </#if>
        <#if obj.query_type != 'time_period'>
        var ${obj.field_name} = ${'$'}('#${obj.field_name}').val();
        </#if>
    </#if>
    </#list>
        //执行重载
        table.reload('${tablePd.mod_name}_${tablePd.bus_name}', {
            page: {
                curr: 1 //重新从第 1 页开始
            }
            ,where: {
            <#if tablePd.temp_type == '2'>
            ${tablePd.tree_pid}:${tablePd.tree_pid},
            </#if>
            <#list fieldList as obj>
            <#if obj.field_query == 'Y'>
                <#if obj.query_type == 'time_period'>
                start_time:start_time,
                end_time: end_time,
                </#if>
                <#if obj.query_type != 'time_period'>
                <#if obj_has_next>
                ${obj.field_name}: ${obj.field_name},
                </#if>
                <#if !obj_has_next>
                ${obj.field_name}: ${obj.field_name}
                </#if>
                </#if>
            </#if>
            </#list>
            }
        });
    }

    //新增
    function add(){
        <#if tablePd.temp_type == '2'>
        var parent_id =  $("#tree_id").val();
        var name = $("#tree_name").val();
        if(parent_id==''||parent_id==null){
            layer.msg("请在左侧选择菜单父节点。");
        }else {
        </#if>
            parent.layer.open({
                id: '${tablePd.bus_name}_add',
                //skin: 'layui-layer-molv',
                title: '添加',
                maxmin: true,
                type: 2,
                <#if tablePd.temp_type == '2'>
                    content: '${'$'}{pageContext.request.contextPath}/${tablePd.mod_name}/${tablePd.bus_name}/toAdd?type=${'$'}{pd.type}&${tablePd.tree_pid}='+parent_id+'&${tablePd.tree_name}='+name,
                </#if>
                <#if tablePd.temp_type != '2'>
                    content: '${'$'}{pageContext.request.contextPath}/${tablePd.mod_name}/${tablePd.bus_name}/toAdd?type=${'$'}{pd.type}',
                </#if>
                area: ['800px', '500px'],
                end: function () {
                    var val = getOpenCloseParam();
                    if (val == "reload") {
                    <#if tablePd.temp_type == '2'>
                        reload();
                    </#if>
                    <#if tablePd.temp_type != '2'>
                        reloadData();
                    </#if>
                    }
                }
            });
    <#if tablePd.temp_type == '2'>
        }
    </#if>
    }

<#if tablePd.more_add == '1'>
    //新增
    function addMore(){
        <#if tablePd.temp_type == '2'>
            var parent_id =  $("#tree_id").val();
            var name = $("#tree_name").val();
        if(parent_id==''||parent_id==null){
            layer.msg("请在左侧选择菜单父节点。");
        }else {
        </#if>
            parent.layer.open({
                id:'${tablePd.bus_name}_add',
                //skin: 'layui-layer-molv',
                title: '批量添加',
                maxmin: true,
                type: 2,
                <#if tablePd.temp_type == '2'>
                    content: '${'$'}{pageContext.request.contextPath}/${tablePd.mod_name}/${tablePd.bus_name}/toAddMore?type=${'$'}{pd.type}&${tablePd.tree_pid}='+parent_id+'&${tablePd.tree_name}='+name,
                </#if>
                <#if tablePd.temp_type != '2'>
                    content: '${'$'}{pageContext.request.contextPath}/${tablePd.mod_name}/${tablePd.bus_name}/toAddMore?type=${'$'}{pd.type}',
                </#if>
                area: ['800px', '500px'],
                end: function () {
                    var val = getOpenCloseParam();
                    if(val=="reload"){
                        <#if tablePd.temp_type == '2'>
                            reload();
                        </#if>
                        <#if tablePd.temp_type != '2'>
                            reloadData();
                        </#if>
                    }
                }
            });
        <#if tablePd.temp_type == '2'>
        }
        </#if>
    }
</#if>

    //编辑
    function edit(id){
        parent.layer.open({
            id:'${tablePd.bus_name}_edit',
            //skin: 'layui-layer-molv',
            title: '编辑',
            maxmin: true,
            type: 2,
            content: '${'$'}{pageContext.request.contextPath}/${tablePd.mod_name}/${tablePd.bus_name}/toUpdate?id='+id,
            area: ['800px', '500px'],
            end: function () {
                var val = getOpenCloseParam();
                if(val=="reload"){
                <#if tablePd.temp_type == '2'>
                    reload();
                </#if>
                <#if tablePd.temp_type != '2'>
                    reloadData();
                </#if>
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
            content: '${'$'}{pageContext.request.contextPath}/${tablePd.mod_name}/${tablePd.bus_name}/findInfo?id='+id,
            area: ['800px', '500px']
        });
    }

    function updateStatus(id,status){
        $.get("${'$'}{pageContext.request.contextPath}/${tablePd.mod_name}/${tablePd.bus_name}/updateStatus?id="+id+"&status="+status,null,function(res){
            if (res.success) {
                layer.tips("状态修改成功。");
            <#if tablePd.temp_type == '2'>
                reload();
            </#if>
            <#if tablePd.temp_type != '2'>
                reloadData();
            </#if>
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