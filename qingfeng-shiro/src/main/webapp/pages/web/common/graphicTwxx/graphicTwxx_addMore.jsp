<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>

<form class="layui-form" action="" id="form">
    <table class="layui-table" style="width: 99%;margin: 0 auto">
        <thead>
        <tr>
            <th>标题<span style="color: red">*</span></th>
            <th>简介<span style="color: red">*</span></th>
            <th>内容</th>
            <th>阅读数量</th>
            <th>排序</th>
            <th>备注</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody id="table">
        <tr>
            <td><input type="text" name="title" id="title_1" value="中国" lay-verify="required" autocomplete="off" placeholder="标题" class="layui-input"></td>
            <td><textarea name="intro" id="intro_1" lay-verify="required" placeholder="请输入简介" class="layui-textarea">你好</textarea></td>
            <td><textarea name="content" id="content_1" lay-verify="" placeholder="请输入内容" class="layui-textarea">2</textarea></td>
            <td>
                <div id="div-1-read_num">
                </div>
                <input type="hidden" name="read_num" id="read_num_1" value="3" />
            </td>
            <td><input type="text" name="order_by" id="order_by_1" value="q" lay-verify="number" autocomplete="off" placeholder="排序" class="layui-input"></td>
            <td>
                <select name="remark" id="remark_1" lay-verify="" style="height: 32px;" class="layui-input">
                    <option value=""></option>
                    <option value="0">北京</option>
                    <option value="1">上海</option>
                    <option value="2">深圳</option>
                </select>
            </td>
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
    var form,layer,layedit,laydate,upload;
    layui.use(['form', 'layedit', 'laydate','upload'], function(){
        form = layui.form;
        layer = layui.layer;
        layedit = layui.layedit;
        laydate = layui.laydate;
        upload = layui.upload;

        $('#cancel').on('click',function (){
            var index = parent.layer.getFrameIndex(window.name);
            parent.layer.close(index);
        });

        //初始化
        findCheckboxDictionary('fl1001','div-1-','read_num','3');

        //自定义验证规则
        form.verify(form_verify);

        //监听提交
        form.on('submit(submit_form)', function(data){
            layer.msg('正在提交数据。');
            $("#submit_button").attr('disabled',true);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/common/graphicTwxx/saveMore" ,//url
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

        //处理复选框
        form.on('checkbox(checkField)', function(obj){
            var obj_name = obj.elem.name;
            var values = obj_name.split('-');
            //获取值
            var checkboxValue="";
            $("input:checkbox[name='"+obj_name+"']:checked").each(function() { // 遍历name=standard的多选框
                checkboxValue += ',' + $(this).val();
            });
            if(values.length==2){//添加、编辑
                $("#"+values[1]).val(checkboxValue);
            }else if(values.length==3){//批量添加
                $("#"+values[2]+"_"+values[1]).val(checkboxValue);
            }
            form.render();
            return false;
        });

    });

    var index = 1;
    function addLine(){
        index ++;
        var tt = '<tr id="tr_'+index+'">';
            tt += '<td><input type="text" name="title" id="title_'+index+'" value="中国" lay-verify="required" autocomplete="off" placeholder="标题" class="layui-input"></td>';
            tt += '<td><textarea name="intro" id="intro_'+index+'" lay-verify="required" placeholder="请输入简介" class="layui-textarea">你好</textarea></td>';
            tt += '<td><textarea name="content" id="content_'+index+'" lay-verify="" placeholder="请输入内容" class="layui-textarea">2</textarea></td>';
            tt += '<td>';
                tt += '<div id="div-'+index+'-read_num">';
                tt += '</div>';
                tt += '<input type="hidden" name="read_num" id="read_num_'+index+'" value="3" />';
                tt += '</td>';
            tt += '<td><input type="text" name="order_by" id="order_by_'+index+'" value="q" lay-verify="number" autocomplete="off" placeholder="排序" class="layui-input"></td>';
            tt += '<td>';
            tt += '<select name="remark" id="remark_'+index+'" lay-verify="" style="height: 32px;" class="layui-input">';
                tt += '<option value=""></option>';
                tt += '<option value="0">北京</option>';
                tt += '<option value="1">上海</option>';
                tt += '<option value="2">深圳</option>';
                tt += '</select>';
                tt += '</td>';
            tt += '<td style="width: 78px;"><div class="layui-btn-group"><button type="button" onclick="addLine();" class="layui-btn layui-btn-xs"><i class="layui-icon"></i></button><button type="button" onclick="delLine(\''+index+'\');" class="layui-btn layui-btn-xs layui-btn-danger"><i class="layui-icon"></i></button></div></td>';
            tt += '</tr>';
            $("#table tr:last").after(tt);

        //初始化
            findCheckboxDictionary('fl1001','div-'+index+'-','read_num','3');
            form.render();
    }

    function delLine(index){
        $("#tr_"+index).remove();
    }


</script>

<%@include file="../../system/admin/bottom.jsp"%>