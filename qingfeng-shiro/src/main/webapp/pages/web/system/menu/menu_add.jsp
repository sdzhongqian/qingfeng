<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>
<style>
    .layui-table td {
        padding: 10px 10px;
    }
</style>
<form class="layui-form" action="" id="form">
    <table width="95%" style="margin: 0 auto">
        <tr>
            <td width="20%" align="right"><label class="layui-form-label">父级名称：<span style="color: red">*</span></label></td>
            <td colspan="3"><input type="text" readonly value="${pd.name }" class="layui-input"></td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">菜单名称：<span style="color: red">*</span></label></td>
            <td colspan="3"><input type="text" name="name" id="name" lay-verify="required|field_len50" autocomplete="off" placeholder="菜单名称" class="layui-input"></td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">菜单编码：<span style="color: red">*</span></label></td>
            <td colspan="3"><input type="text" name="code" id="code" lay-verify="required|field_len50" autocomplete="off" placeholder="菜单编码" class="layui-input"></td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">URL：</label></td>
            <td colspan="3"><input type="text" name="url"  lay-verify="field_len1200" autocomplete="off" placeholder="请输入URL" class="layui-input"></td>
        </tr>
        <tr>
            <td width="20%" align="right"><label class="layui-form-label">icon：</label></td>
            <td colspan="3"><input type="text" name="icon" id="iconPicker" lay-filter="iconPicker" class="layui-input"></td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">排序号：</label></td>
            <td colspan="3"><input type="text" name="order_by" id="order_by" lay-verify="field_len50|intNumber" autocomplete="off" placeholder="排序号" class="layui-input"></td>
        </tr>
        <tr>
            <td width="20%" align="right"><label class="layui-form-label">功能权限</label></td>
            <td colspan="3"><input type="checkbox" name="open_button" lay-filter="openButton" title="开启功能权限"></td>
        </tr>
        <tr id="button_tr" style="display: none;">
            <td width="20%" align="right"><label class="layui-form-label">功能按钮</label></td>
            <td colspan="3">
                <div style="width:564px; overflow:auto;">
                    <table class="layui-table" style="width:564px;">
                        <thead>
                        <tr>
                            <th>名称</th>
                            <th>编号</th>
                            <th>排序号</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody id="table">
                        <tr>
                            <td><input type="text" name="button_name" lay-verify="title" value="添加" autocomplete="off" placeholder="请输入名称" class="layui-input"></td>
                            <td><input type="text" name="button_code" lay-verify="title" value="add" autocomplete="off" placeholder="请输入编号" class="layui-input"></td>
                            <td><input type="text" name="button_order_by" lay-verify="title" autocomplete="off" placeholder="请输入排序号" value="1" class="layui-input"></td>
                            <td style="width: 78px;"><div class="layui-btn-group"><button onclick="addLine('','');" type="button" class="layui-btn layui-btn-xs"><i class="layui-icon"></i></button></div></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">备注：</label></td>
            <td colspan="3"><textarea name="remark" placeholder="请输入备注" class="layui-textarea"></textarea></td>
        </tr>
        <tr>
            <td style="text-align: center; padding-top: 10px;" colspan="4">
                <div class="layui-form-item">
                    <input type="hidden" id="parent_id" name="parent_id" value="${pd.parent_id }">
                    <input type="hidden" name="menu_cascade" value="${pd.menu_cascade }"/>
                    <input type="hidden" name="level_num" value="${pd.level_num }"/>
                    <button type="button" class="layui-btn layui-btn-sm" id="submit_button" lay-submit="" lay-filter="submit_form">保存</button>
                    <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" id="cancel">取消</button>
                </div>
            </td>
        </tr>
    </table>
</form>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfverify.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfAjaxReq.js"></script>
<!-- 注意：如果你直接复制所有代码到本地，上述js路径需要改成你本地的 -->
<script>
    //图标选择器相关
    layui.config({
        base: '${pageContext.request.contextPath}/resources/plugins/module/'
    }).extend({
        iconPicker: 'iconPicker/iconPicker'
    });
    var form,layer,layedit,laydate,iconPicker;
    layui.use(['form', 'layedit', 'laydate','iconPicker'], function(){
        form = layui.form;
        layer = layui.layer;
        layedit = layui.layedit;
        laydate = layui.laydate;
        iconPicker = layui.iconPicker;

        //图标选择器相关
        iconPicker.render({
            // 选择器，推荐使用input
            elem: '#iconPicker',
            // 数据类型：fontClass/unicode，推荐使用fontClass
            type: 'unicode',
            // 是否开启搜索：true/false
            search: true,
            // 点击回调
            click: function (data) {
//            console.log(data);
            }
        });

        $('#cancel').on('click',function (){
            var index = parent.layer.getFrameIndex(window.name);
            parent.layer.close(index);
        })

        //自定义验证规则
        form.verify(form_verify);

        //监听提交
        form.on('submit(submit_form)', function(data){
            layer.msg('正在提交数据。');
            $("#submit_button").attr('disabled',true);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/system/menu/save" ,//url
                data: $('#form').serialize(),
                success: function (res) {
                    if (res.success) {
                        layer.msg("数据保存成功。", {time: 2000},function(){
                            setOpenCloseParam("reload");
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                        });
                    }else{
                        $("#submit_button").attr('disabled',false);
                        if(res.loseSession=='loseSession'){
                            loseSession(res.msg,res.url)
                        }else{
                            layer.msg(res.msg, {time: 2000});
                        }
                    }
                },
                error : function() {
                    $("#submit_button").attr('disabled',false);
                    layer.msg("异常！");
                }
            });
            return false;
        });

        //监听状态操作
        form.on('checkbox(openButton)', function(obj){
            if(obj.elem.checked){
                $("#button_tr").show();
            }else{
                $("#button_tr").hide();
            }
        });


        addLine("编辑","edit");
        addLine("删除","del");
        addLine("详情","info");

    });


    var index = 1;
    function addLine(k,v){
        index ++;
        var tt = '<tr id="tr_'+index+'">';
        tt += '<td><input type="text" name="button_name" lay-verify="title" value="'+k+'" autocomplete="off" placeholder="请输入名称" class="layui-input"></td>';
        tt += '<td><input type="text" name="button_code" lay-verify="title" value="'+v+'" autocomplete="off" placeholder="请输入编号" class="layui-input"></td>';
        tt += '<td><input type="text" name="button_order_by" lay-verify="title" autocomplete="off" placeholder="请输入排序号" value="'+index+'" class="layui-input"></td>';
        tt += '<td style="width: 78px;"><div class="layui-btn-group"><button type="button" onclick="addLine(\'\',\'\');" class="layui-btn layui-btn-xs"><i class="layui-icon"></i></button><button type="button" onclick="delLine(\''+index+'\');" class="layui-btn layui-btn-xs layui-btn-danger"><i class="layui-icon"></i></button></div></td>';
        tt += '</tr>';
        $("#table tr:last").after(tt);
    }

    function delLine(index){
        $("#tr_"+index).remove();
    }

</script>

<%@include file="../admin/bottom.jsp"%>