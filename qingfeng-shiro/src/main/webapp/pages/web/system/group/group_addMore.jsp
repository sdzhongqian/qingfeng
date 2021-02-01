<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>

<form class="layui-form" action="" id="form">
    <table class="layui-table" style="width: 99%;margin: 0 auto">
        <thead>
        <tr>
            <th>组名称<span style="color: red">*</span></th>
            <th>组简称</th>
            <th width="30%">组用户</th>
            <th width="50px">排序</th>
            <th>备注</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody id="table">
        <tr>
            <td><input type="text" name="name" lay-verify="required|field_len50" autocomplete="off" placeholder="请输入组名称" class="layui-input"></td>
            <td><input type="text" name="short_name" lay-verify="field_len50" autocomplete="off" placeholder="请输入组简称" class="layui-input"></td>
            <td>
                <input type="hidden" name="user_ids" id="user_ids_1">
                <textarea style="min-height: 40px;width: 85%" readonly name="user_names" id="user_names_1" placeholder="请选择组用户" lay-verify="required" class="layui-textarea"></textarea>
                <button style="width: 40px;position:absolute;bottom:2px;left:86%;" type="button" onclick="selectMoreUser('1')" class="layui-btn layui-btn-xs layui-btn-normal">选择</button>
            </td>
            <td><input type="text" name="order_by" value="1" lay-verify="field_len50" autocomplete="off" placeholder="请输入排序" class="layui-input"></td>
            <td><textarea name="remark" placeholder="请输入备注" class="layui-textarea" style="min-height: 40px;"></textarea></td>
            <td style="width: 78px;"><div class="layui-btn-group"><button onclick="addLine();" type="button" class="layui-btn layui-btn-xs"><i class="layui-icon"></i></button></div></td>
        </tr>
        </tbody>
        <tr>
            <td style="text-align: center; padding-top: 10px;" colspan="12">
                <div class="layui-form-item">
                    <button type="button" class="layui-btn layui-btn-sm" id="submit_button" lay-submit="" lay-filter="submit_form">保存</button>
                    <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" id="cancel">取消</button>
                </div>
            </td>
        </tr>
    </table>
</form>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/xadmin/lib/layui/layui.js" charset="utf-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfverify.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfAjaxReq.js"></script>
<!-- 注意：如果你直接复制所有代码到本地，上述js路径需要改成你本地的 -->
<script>
    var form,layer,layedit,laydate;
    layui.use(['form', 'layedit', 'laydate'], function(){
        form = layui.form;
        layer = layui.layer;
        layedit = layui.layedit;
        laydate = layui.laydate;

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
                url: "${pageContext.request.contextPath}/system/group/saveMore" ,//url
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
    });

    var index = 1;
    function addLine(){
        index ++;
        var tt = '<tr id="tr_'+index+'">';
        tt += '<td><input type="text" name="name" lay-verify="required|field_len50" autocomplete="off" placeholder="请输入组名称" class="layui-input"></td>';
        tt += '<td><input type="text" name="short_name" lay-verify="field_len50" autocomplete="off" placeholder="请输入组简称" class="layui-input"></td>';
        tt += '<td>';
        tt += '<input type="hidden" name="user_ids" id="user_ids_'+index+'">';
        tt += '<textarea style="min-height: 40px;width: 85%" readonly name="user_names" id="user_names_'+index+'" placeholder="请选择组用户" lay-verify="required" class="layui-textarea"></textarea>';
        tt += '<button style="width: 40px;position:absolute;bottom:2px;left:86%;" type="button" onclick="selectMoreUser(\''+index+'\')" class="layui-btn layui-btn-xs layui-btn-normal">选择</button>';
        tt += '</td>';
        tt += '<td><input type="text" name="order_by" value="'+index+'" lay-verify="field_len50" autocomplete="off" placeholder="请输入排序" class="layui-input"></td>';
        tt += '<td><textarea name="remark" placeholder="请输入备注" class="layui-textarea" style="min-height: 40px;"></textarea></td>';
        tt += '<td style="width: 78px;"><div class="layui-btn-group"><button type="button" onclick="addLine();" class="layui-btn layui-btn-xs"><i class="layui-icon"></i></button><button type="button" onclick="delLine(\''+index+'\');" class="layui-btn layui-btn-xs layui-btn-danger"><i class="layui-icon"></i></button></div></td>';
        tt += '</tr>';
        $("#table tr:last").after(tt);
    }

    function delLine(index){
        $("#tr_"+index).remove();
    }

    //选择用户
    function selectMoreUser(index){
        var ids = $("#user_ids_"+index).val();
        var names = $("#user_names_"+index).val();
        sessionStorage.setItem('ids', ids);
        sessionStorage.setItem('names', names);
        parent.layer.open({
            //skin: 'layui-layer-molv',
            title: '添加人员',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/system/user/selectMoreUser',
            area: ['800px', '520px'],
            end: function () {
                var val = getOpenCloseParam();
                if(val=="reload"){
                    $("#user_ids_"+index).val(sessionStorage.getItem("ids"));
                    $("#user_names_"+index).val(sessionStorage.getItem("names"));
                    sessionStorage.removeItem("ids");
                    sessionStorage.removeItem("names");
                }
            }
        });
    }

</script>

<%@include file="../admin/bottom.jsp"%>