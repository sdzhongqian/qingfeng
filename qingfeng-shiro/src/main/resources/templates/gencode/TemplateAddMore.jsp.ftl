<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>

<#assign checkboxText = 'false'>
<form class="layui-form" action="" id="form">
    <table class="layui-table" style="width: 99%;margin: 0 auto">
        <thead>
        <tr>
        <#if tablePd.temp_type == '2'>
            <th>父级名称<span style="color: red">*</span></th>
        </#if>
        <#list fieldList as obj>
            <#if obj.field_operat == 'Y' && obj.show_type != '0'>
            <th>${obj.field_comment}<#if obj.verify_rule?contains("required")><span style="color: red">*</span></#if></th>
            </#if>
        </#list>
            <th>操作</th>
        </tr>
        </thead>
        <tbody id="table">
        <tr>
        <#if tablePd.temp_type == '2'>
            <td>${'$'}{pd.name }</td>
        </#if>
    <#list fieldList as obj>
        <#if obj.field_operat == 'Y'>
        <#if obj.show_type == '1'||obj.show_type == '7'>
            <td><input type="text" name="${obj.field_name}" id="${obj.field_name}_1" value="${obj.default_value}" lay-verify="${obj.verify_rule?replace(',','|')}" autocomplete="off" placeholder="${obj.field_comment}" class="layui-input"></td>
        </#if>
        <#if obj.show_type == '2'||obj.show_type == '6'>
            <td><textarea name="${obj.field_name}" id="${obj.field_name}_1" lay-verify="${obj.verify_rule?replace(',','|')}" placeholder="请输入${obj.field_comment}" class="layui-textarea">${obj.default_value}</textarea></td>
        </#if>
        <#if obj.show_type == '3'>
            <td>
                <select name="${obj.field_name}" id="${obj.field_name}_1" lay-verify="${obj.verify_rule?replace(',','|')}" style="height: 32px;" class="layui-input">
                    <option value=""></option>
                <#if obj.option_content?contains(";")>
                <#list obj.option_content?split(";") as name>
                    <#assign param = name?split("/")>
                    <#if obj.default_value == param[0]>
                    <option selected value="${param[0]}">${param[1]}</option>
                    </#if>
                    <#if obj.default_value != param[0]>
                    <option value="${param[0]}">${param[1]}</option>
                    </#if>
                </#list>
                </#if>
                </select>
            </td>
        </#if>
        <#if obj.show_type == '4'>
            <td>
                <div id="div_1_${obj.field_name}">
                <#if obj.option_content?contains(";")>
                <#list obj.option_content?split(";") as name>
                    <#assign param = name?split("/")>
                    <#if obj.default_value == param[0]>
                    <input type="radio" checked name="${obj.field_name}" value="${param[0]}" title="${param[1]}" lay-verify="${obj.verify_rule?replace(',','|')}">
                    </#if>
                    <#if obj.default_value != param[0]>
                    <input type="radio" name="${obj.field_name}" value="${param[0]}" title="${param[1]}" lay-verify="${obj.verify_rule?replace(',','|')}">
                    </#if>
                </#list>
                </#if>
                </div>
            </td>
        </#if>
        <#if obj.show_type == '5'>
            <#assign checkboxText = 'true'>
            <td>
                <div id="div-1-${obj.field_name}">
                <#if obj.option_content?contains(";")>
                <#list obj.option_content?split(";") as name>
                    <#assign param = name?split("/")>
                    <#if obj.default_value?contains(param[0])>
                    <input type="checkbox" lay-filter='checkField' checked name="div-1-${obj.field_name}" value="${param[0]}" lay-skin="primary" title="${param[1]}" lay-verify="${obj.verify_rule?replace(',','|')}">
                    </#if>
                    <#if !obj.default_value?contains(param[0])>
                    <input type="checkbox" lay-filter='checkField' name="div-1-${obj.field_name}" value="${param[0]}" lay-skin="primary" title="${param[1]}" lay-verify="${obj.verify_rule?replace(',','|')}">
                    </#if>
                </#list>
                </#if>
                </div>
                <input type="hidden" name="${obj.field_name}" id="${obj.field_name}_1" value="${obj.default_value}" />
            </td>
        </#if>
        <#if obj.show_type == '8'>
            <td>
                <div style="margin-top:5px;">
                    <input type="hidden" name="${obj.field_name}" id="fileIds_${obj.field_name}_1" value="" class="layui-input">
                    <button type="button" class="layui-btn layui-btn-xs" id="upload_file_${obj.field_name}_1">选择附件</button>
                    <table class="layui-table">
                        <thead>
                        <tr>
                            <th>附件名称</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody id="tbody_file_${obj.field_name}_1">
                        </tbody>
                    </table>
                </div>
            </td>
        </#if>
        <#if obj.show_type == '0'>
            <input type="hidden" name="${obj.field_name}" value="${obj.default_value}" lay-verify="${obj.verify_rule?replace(',','|')}" autocomplete="off" placeholder="${obj.field_comment}" class="layui-input">
        </#if>
    </#if>
    </#list>
            <td style="width: 78px;"><div class="layui-btn-group"><button onclick="addLine();" type="button" class="layui-btn layui-btn-xs"><i class="layui-icon"></i></button></div></td>
        </tr>
        <tr></tr>
        </tbody>
        <tr>
            <td style="text-align: center; padding-top: 10px;" colspan="12">
                <div class="layui-form-item">
                    <#if tablePd.temp_type == '2'>
                        <input type="hidden" id="${tablePd.tree_pid}" name="${tablePd.tree_pid}" value="${'$'}{pd.parent_id }">
                    </#if>
                    <button type="button" class="layui-btn layui-btn-sm" id="submit_button" lay-submit="" lay-filter="submit_form">保存</button>
                    <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" id="cancel">取消</button>
                </div>
            </td>
        </tr>
    </table>
</form>

<script type="text/javascript" src="${'$'}{pageContext.request.contextPath}/resources/plugins/xadmin/lib/layui/layui.js" charset="utf-8"></script>
<script type="text/javascript" src="${'$'}{pageContext.request.contextPath}/resources/js/qfverify.js"></script>
<script type="text/javascript" src="${'$'}{pageContext.request.contextPath}/resources/js/qfAjaxReq.js"></script>
<script type="text/javascript" src="${'$'}{pageContext.request.contextPath}/resources/js/uploadFile.js"></script>
<!-- 注意：如果你直接复制所有代码到本地，上述js路径需要改成你本地的 -->
<script>
    var form,layer,layedit,laydate,upload;
    layui.use(['form', 'layedit', 'laydate','upload'], function(){
        form = layui.form;
        layer = layui.layer;
        layedit = layui.layedit;
        laydate = layui.laydate;
        upload = layui.upload;

        ${'$'}('#cancel').on('click',function (){
            var index = parent.layer.getFrameIndex(window.name);
            parent.layer.close(index);
        })

        //初始化
<#list fieldList as obj>
    <#if obj.field_operat == 'Y'>
    <#if obj.show_type == '3'>
        <#if !obj.option_content?contains(";")>
        findSelectDictionary('${obj.option_content}','${obj.field_name}_1','${obj.default_value}');
        </#if>
    </#if>
    <#if obj.show_type == '4'>
        <#if !obj.option_content?contains(";")>
        findRadioDictionary('${obj.option_content}','div_1_','${obj.field_name}','${obj.default_value}');
        </#if>
    </#if>
    <#if obj.show_type == '5'>
        <#assign checkboxText = 'true'>
        <#if !obj.option_content?contains(";")>
        findCheckboxDictionary('${obj.option_content}','div-1-','${obj.field_name}','${obj.default_value}');
        </#if>
    </#if>
    <#if obj.show_type == '7'>
        initDateType("${obj.field_name}_1",true);
    </#if>
    <#if obj.show_type == '8'>
        uploadMoreFile('${obj.field_name}_1','${obj.field_name}');
    </#if>
</#if>
</#list>

        //自定义验证规则
        form.verify(form_verify);

        //监听提交
        form.on('submit(submit_form)', function(data){
            layer.msg('正在提交数据。');
            ${'$'}("#submit_button").attr('disabled',true);
            ${'$'}.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${'$'}{pageContext.request.contextPath}/${tablePd.mod_name}/${tablePd.bus_name}/saveMore" ,//url
                data: ${'$'}('#form').serialize(),
                success: function (res) {
                    if (res.success) {
                        layer.msg("数据保存成功。", {time: 2000},function(){
                            setOpenCloseParam("reload");
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                        });
                    }else{
                        ${'$'}("#submit_button").attr('disabled',false);
                        if(res.loseSession=='loseSession'){
                            loseSession(res.msg,res.url)
                        }else{
                            layer.msg(res.msg, {time: 2000});
                        }
                    }
                },
                error : function() {
                    ${'$'}("#submit_button").attr('disabled',false);
                    layer.msg("异常！");
                }
            });
            return false;
        });

    <#if checkboxText == 'true'>
        //处理复选框
        form.on('checkbox(checkField)', function(obj){
            var obj_name = obj.elem.name;
            var values = obj_name.split('-');
            //获取值
            var checkboxValue="";
            ${'$'}("input:checkbox[name='"+obj_name+"']:checked").each(function() { // 遍历name=standard的多选框
                checkboxValue += ',' + $(this).val();
            });
            if(values.length==2){//添加、编辑
                ${'$'}("#"+values[1]).val(checkboxValue);
            }else if(values.length==3){//批量添加
                ${'$'}("#"+values[2]+"_"+values[1]).val(checkboxValue);
            }
            form.render();
            return false;
        });
    </#if>

    });

    var index = 1;
    function addLine(){
        index ++;
        var tt = '<tr id="tr_'+index+'">';
            <#if tablePd.temp_type == '2'>
            tt += '<td>${'$'}{pd.name }</td>';
            </#if>
    <#list fieldList as obj>
        <#if obj.field_operat == 'Y'>
        <#if obj.show_type == '1'||obj.show_type == '7'>
            tt += '<td><input type="text" name="${obj.field_name}" id="${obj.field_name}_'+index+'" value="${obj.default_value}" lay-verify="${obj.verify_rule?replace(',','|')}" autocomplete="off" placeholder="${obj.field_comment}" class="layui-input"></td>';
        </#if>
        <#if obj.show_type == '2'||obj.show_type == '6'>
            tt += '<td><textarea name="${obj.field_name}" id="${obj.field_name}_'+index+'" lay-verify="${obj.verify_rule?replace(',','|')}" placeholder="请输入${obj.field_comment}" class="layui-textarea">${obj.default_value}</textarea></td>';
        </#if>
        <#if obj.show_type == '3'>
            tt += '<td>';
            tt += '<select name="${obj.field_name}" id="${obj.field_name}_'+index+'" lay-verify="${obj.verify_rule?replace(',','|')}" style="height: 32px;" class="layui-input">';
                tt += '<option value=""></option>';
            <#if obj.option_content?contains(";")>
            <#list obj.option_content?split(";") as name>
                <#assign param = name?split("/")>
                <#if obj.default_value == param[0]>
                tt += '<option selected value="${param[0]}">${param[1]}</option>';
                </#if>
                <#if obj.default_value != param[0]>
                tt += '<option value="${param[0]}">${param[1]}</option>';
                </#if>
            </#list>
            </#if>
                tt += '</select>';
                tt += '</td>';
        </#if>
        <#if obj.show_type == '4'>
            tt += '<td>';
                tt += '<div id="div_'+index+'_${obj.field_name}">';
            <#if obj.option_content?contains(";")>
            <#list obj.option_content?split(";") as name>
                <#assign param = name?split("/")>
                <#if obj.default_value == param[0]>
                tt += '<input type="radio" checked name="${obj.field_name}" value="${param[0]}" title="${param[1]}" lay-verify="${obj.verify_rule?replace(',','|')}">';
                </#if>
                <#if obj.default_value != param[0]>
                tt += '<input type="radio" name="${obj.field_name}" value="${param[0]}" title="${param[1]}" lay-verify="${obj.verify_rule?replace(',','|')}">';
                </#if>
            </#list>
            </#if>
                tt += '</div>';
                tt += '</td>';
        </#if>
        <#if obj.show_type == '5'>
            tt += '<td>';
                tt += '<div id="div-'+index+'-${obj.field_name}">';
            <#if obj.option_content?contains(";")>
            <#list obj.option_content?split(";") as name>
                <#assign param = name?split("/")>
                <#if obj.default_value?contains(param[0])>
                tt += '<input type="checkbox" lay-filter="checkField" checked name="div-'+index+'-${obj.field_name}" value="${param[0]}" lay-skin="primary" title="${param[1]}" lay-verify="${obj.verify_rule?replace(',','|')}">';
                </#if>
                <#if !obj.default_value?contains(param[0])>
                tt += '<input type="checkbox" lay-filter="checkField" name="div-'+index+'-${obj.field_name}" value="${param[0]}" lay-skin="primary" title="${param[1]}" lay-verify="${obj.verify_rule?replace(',','|')}">';
                </#if>
            </#list>
            </#if>
                tt += '</div>';
                tt += '<input type="hidden" name="${obj.field_name}" id="${obj.field_name}_'+index+'" value="${obj.default_value}" />';
                tt += '</td>';
        </#if>
        <#if obj.show_type == '8'>
            tt += '<td>';
            tt += '<div style="margin-top:5px;">';
            tt += '<input type="hidden" name="${obj.field_name}" id="fileIds_${obj.field_name}_'+index+'" value="" class="layui-input">';
            tt += '<button type="button" class="layui-btn layui-btn-xs" id="upload_file_${obj.field_name}_'+index+'">选择附件</button>';
            tt += '<table class="layui-table">';
            tt += '<thead>';
            tt += '<tr><th>附件名称</th><th>操作</th></tr>';
            tt += '</thead>';
                tt += '<tbody id="tbody_file_${obj.field_name}_'+index+'">';
                tt += '</tbody>';
                tt += '</table>';
                tt += '</div>';
                tt += '</td>';
        </#if>
        <#if obj.show_type == '0'>
            tt += '<input type="hidden" name="${obj.field_name}" value="${obj.default_value}" lay-verify="${obj.verify_rule?replace(',','|')}" autocomplete="off" placeholder="${obj.field_comment}" class="layui-input">';
        </#if>
    </#if>
    </#list>
            tt += '<td style="width: 78px;"><div class="layui-btn-group"><button type="button" onclick="addLine();" class="layui-btn layui-btn-xs"><i class="layui-icon"></i></button><button type="button" onclick="delLine(\''+index+'\');" class="layui-btn layui-btn-xs layui-btn-danger"><i class="layui-icon"></i></button></div></td>';
            tt += '</tr>';
            ${'$'}("#table tr:last").before(tt);

        //初始化
<#list fieldList as obj>
    <#if obj.field_operat == 'Y'>
        <#if obj.show_type == '3'>
            <#if !obj.option_content?contains(";")>
            findSelectDictionary('${obj.option_content}','${obj.field_name}_'+index,'${obj.default_value}');
            </#if>
        </#if>
        <#if obj.show_type == '4'>
            <#if !obj.option_content?contains(";")>
            findRadioDictionary('${obj.option_content}','div_'+index+'_','${obj.field_name}','${obj.default_value}');
            </#if>
        </#if>
        <#if obj.show_type == '5'>
            <#assign checkboxText = 'true'>
            <#if !obj.option_content?contains(";")>
            findCheckboxDictionary('${obj.option_content}','div-'+index+'-','${obj.field_name}','${obj.default_value}');
            </#if>
        </#if>
        <#if obj.show_type == '7'>
            initDateType("${obj.field_name}_"+index,true);
        </#if>
        <#if obj.show_type == '6'>
        </#if>
        <#if obj.show_type == '8'>
            uploadMoreFile('${obj.field_name}_'+index,'${obj.field_name}');
        </#if>
    </#if>
</#list>
            form.render();
    }

    function delLine(index){
        ${'$'}("#tr_"+index).remove();
    }


</script>

<%@include file="../../system/admin/bottom.jsp"%>