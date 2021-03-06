<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>

<form class="layui-form" action="" id="form">
    <table width="95%" style="margin: 0 auto">
            <tr>
                <td width="15%" align="right">
                    <label class="layui-form-label">标题：
                        <span style="color: red">*</span>
                    </label>
                </td>
                <td colspan="3"><input type="text" name="title" id="title" value="中国" lay-verify="required" autocomplete="off" placeholder="标题" class="layui-input"></td>
            </tr>
            <tr>
                <td width="15%" align="right">
                    <label class="layui-form-label">简介：
                            <span style="color: red">*</span>
                    </label>
                </td>
                <td colspan="3"><textarea name="intro" id="intro" lay-verify="required" placeholder="请输入简介" class="layui-textarea">你好</textarea></td>
            </tr>
            <tr>
                <td width="15%" align="right">
                    <label class="layui-form-label">内容：
                    </label>
                </td>
                <td colspan="3">
                    <script type="text/plain" id="richText_content" style="width: 100%;height:500px;">2</script>
                    <input type="hidden" name="content" id="content">
                </td>
            </tr>
            <tr>
                <td width="15%" align="right">
                    <label class="layui-form-label">阅读数量：
                    </label>
                </td>
                <td colspan="3">
                    <div id="div-read_num">
                    </div>
                    <input type="hidden" name="read_num" id="read_num" value="3" />
                </td>
            </tr>
            <tr>
                <td width="15%" align="right">
                    <label class="layui-form-label">排序：
                    </label>
                </td>
                <td colspan="3"><input type="text" name="order_by" id="order_by" value="q" lay-verify="number" autocomplete="off" placeholder="排序" class="layui-input"></td>
            </tr>
            <tr>
                <td width="15%" align="right">
                    <label class="layui-form-label">备注：
                    </label>
                </td>
                <td colspan="3">
                    <select name="remark" id="remark" lay-verify="" style="height: 32px;" class="layui-input">
                        <option value=""></option>
                        <option value="0">北京</option>
                        <option value="1">上海</option>
                        <option value="2">深圳</option>
                    </select>
                </td>
            </tr>
        <tr>
            <td colspan="4">
                <table class="layui-table" style="width:95%;margin:10px auto;">
                    <thead>
                    <th>附件名称<span style="color: red">*</span></th>
                    <th>附件描述</th>
                    <th>路径</th>
                    <th>附件类型</th>
                    <th>附件后缀</th>
                    <th>操作</th>
                    </thead>
                    <tbody id="child_table">
                    <tr>
                        <td><input type="text" name="name" id="name_1" value="" lay-verify="required" autocomplete="off" placeholder="附件名称" class="layui-input"></td>
                        <td><textarea name="desnames" id="desnames_1" lay-verify="email" placeholder="请输入附件描述" class="layui-textarea"></textarea></td>
                        <td>
                            <select name="file_path" id="file_path_1" lay-verify="" style="height: 32px;" class="layui-input">
                                <option value=""></option>
                            </select>
                        </td>
                        <td><input type="text" name="file_type" id="file_type_1" value="2" lay-verify="" autocomplete="off" placeholder="附件类型" class="layui-input"></td>
                        <td><input type="text" name="file_suffix" id="file_suffix_1" value="" lay-verify="" autocomplete="off" placeholder="附件后缀" class="layui-input"></td>
                        <td style="width:60px;">
                            <div class="layui-btn-group">
                                <button type="button" onclick="addLine();" class="layui-btn layui-btn-xs"><i class="layui-icon"></i></button>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </td>
        </tr>
        <tr>
            <td style="text-align: center; padding-top: 10px;" colspan="4">
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
<link href="${pageContext.request.contextPath}/resources/plugins/umeditor/themes/default/css/umeditor.css" type="text/css" rel="stylesheet">
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/resources/plugins/umeditor/umeditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/resources/plugins/umeditor/umeditor.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/umeditor/lang/zh-cn/zh-cn.js"></script>

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
        //实例化编辑器
        var richText_content = UM.getEditor('richText_content', {zIndex: 1});
        findCheckboxDictionary('fl1001','div-','read_num','3');
                findSelectDictionary('12','file_path_1','1');
        //自定义验证规则
        form.verify(form_verify);

        //监听提交
        form.on('submit(submit_form)', function(data){
            layer.msg('正在提交数据。');

            $("#content").val(UM.getEditor('richText_content').getContent());
            $("#submit_button").attr('disabled',true);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/common/graphicTwxx/save" ,//url
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
                tt += '<td><input type="text" name="name" id="name_'+index+'" value="" lay-verify="required" autocomplete="off" placeholder="附件名称" class="layui-input"></td>';
                tt += '<td><textarea name="desnames" id="desnames_'+index+'" lay-verify="email" placeholder="请输入附件描述" class="layui-textarea"></textarea></td>';
                tt += '<td>';
                tt += '<select name="file_path" id="file_path_'+index+'" lay-verify="" style="height: 32px;" class="layui-input">';
                tt += '<option value=""></option>';
                tt += '</select>';
                tt += '</td>';
                tt += '<td><input type="text" name="file_type" id="file_type_'+index+'" value="2" lay-verify="" autocomplete="off" placeholder="附件类型" class="layui-input"></td>';
                tt += '<td><input type="text" name="file_suffix" id="file_suffix_'+index+'" value="" lay-verify="" autocomplete="off" placeholder="附件后缀" class="layui-input"></td>';
        tt += '<td style="width: 78px;"><div class="layui-btn-group"><button type="button" onclick="addLine();" class="layui-btn layui-btn-xs"><i class="layui-icon"></i></button><button type="button" onclick="delLine(\''+index+'\');" class="layui-btn layui-btn-xs layui-btn-danger"><i class="layui-icon"></i></button></div></td>';
        tt += '</tr>';
        $("#child_table tr:last").after(tt);

        //初始化
                    findSelectDictionary('12','file_path_'+index,'1');
        form.render();
    }

    function delLine(index){
        $("#tr_"+index).remove();
    }

</script>

<%@include file="../../system/admin/bottom.jsp"%>