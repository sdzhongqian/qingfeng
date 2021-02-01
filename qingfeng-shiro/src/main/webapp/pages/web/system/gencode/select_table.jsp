<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>
<div class="layui-fluid">
    <div class="layui-row layui-col-space1">
        <div class="layui-col-md12">
            <div class="layui-card">
                <blockquote id="search" class="layui-elem-quote" style="position: relative;">
                    <div class="layui-card-body ">
                        <form class="layui-form layui-col-space5">
                            <div class="layui-inline">
                                <label class="layui-form-lab" style="width: auto">表名称</label>
                                <input type="text" name="table_name" id="table_name" style="width: 140px;height: 32px;display: inline" placeholder="请输入表名称" class="layui-input">
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-lab" style="width: auto">表描述</label>
                                <input type="text" name="table_comment" id="table_comment" style="width: 140px;height: 32px;display: inline" placeholder="请输入表描述" class="layui-input">
                            </div>
                            <div class="layui-inline">
                                <div style="float: left;padding-left: 5px">
                                    <label class="layui-form-lab" style="width: auto">表时间：</label>
                                    <input type="text" name="start_time" id="start_time" style="width: 140px;height: 32px;display: inline" placeholder="起始日期" class="layui-input">
                                    <label class="layui-form-lab" style="width: auto">至:</label>
                                    <input type="text" name="end_time" id="end_time" style="width: 140px;height: 32px;display: inline" placeholder="结束日期" class="layui-input">
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
                <div align="center">
                    <div class="layui-form-item" style="padding: 20px 0;">
                        <button type="button" class="layui-btn layui-btn-sm" id="submit_button">保存</button>
                        <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" id="cancel">取消</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    var table,form,laydate;
    layui.use(['table','laydate'], function(){
        table = layui.table;
        form = layui.form;
        laydate = layui.laydate;

        table.render({
            elem: '#system_gencode'
            ,url:'${pageContext.request.contextPath}/system/gencode/findTableListPage'
            ,defaultToolbar: ['filter', 'exports', 'print']
            ,title: '系统数据表'
            ,cols: [[
                {type: 'checkbox', fixed: 'left', width:40}
                ,{field:'table_name', fixed: 'left',title:'表名称'}
                ,{field:'table_comment', title:'表描述', edit: 'text'}
                ,{field:'create_time', title:'创建时间',templet: function(res){
                    return jutils.formatDate(new Date(res.create_time),"yyyy-MM-dd HH:ii:ss")
                }}
                ,{field:'update_time', title:'更新时间',templet: function(res){
                    if(res.update_time==''||res.update_time==null){
                        return ""
                    }else{
                        return jutils.formatDate(new Date(res.update_time),"yyyy-MM-dd HH:ii:ss")
                    }
                }}
            ]]
            ,id:'system_gencode'
            ,page: true
            ,done: function (res, curr, count) {
            }
        });

        //初始化检索时间段
        initDatePeriod("start_time","end_time");

        $('#cancel').on('click',function (){
            var index = parent.layer.getFrameIndex(window.name);
            parent.layer.close(index);
        })

        $('#submit_button').on('click',function (){
            var checkStatus = table.checkStatus("system_gencode");
            var data = checkStatus.data;
            if(data.length>0){
                var table_names = [];
                var table_comments = [];
                for ( var i = 0; i <data.length; i++){
                    table_names.push(data[i].table_name);
                    table_comments.push(data[i].table_comment);
                }
                console.log(table_names);
                console.log(table_comments);
                $.post("${pageContext.request.contextPath}/system/gencode/save?table_names="+table_names+"&table_comments="+table_comments,null,function(res){
                    if (res.success) {
                        setOpenCloseParam("reload");
                        var index = parent.layer.getFrameIndex(window.name);
                        parent.layer.close(index);
                    }else{
                        if(res.loseSession=='loseSession'){
                            loseSession(res.msg,res.url)
                        }else{
                            layer.msg(res.msg, {time: 2000});
                        }
                    }
                },'json');
            }else{
                layer.msg('请选择要导入的数据。');
            }
        })

        //监听单元格编辑
        table.on('edit(system_gencode)', function(obj){
            var value = obj.value //得到修改后的值
                    ,data = obj.data //得到所在行所有键值
                    ,field = obj.field; //得到字段
//            layer.msg('[ID: '+ data.table_name +'] ' + field + ' 字段更改为：'+ value);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/system/gencode/updateComment?"+field+"="+value ,//url
                data: {
                    table_name:data.table_name
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
        var table_name = $('#table_name').val();
        var table_comment = $('#table_comment').val();
        var start_time = $('#start_time').val();
        var end_time = $('#end_time').val();
        //执行重载
        table.reload('system_gencode', {
            page: {
                curr: 1 //重新从第 1 页开始
            }
            ,where: {
                table_name: table_name,
                table_comment: table_comment,
                start_time:start_time,
                end_time:end_time
            }
        });
    }


</script>

<%@include file="../admin/bottom.jsp"%>