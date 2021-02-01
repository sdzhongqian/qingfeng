<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>

<form class="layui-form" action="" id="form">
    <table class="layui-table" style="width:95%;margin:10px auto;">
    <#if tablePd.temp_type == '2'>
        <tr>
            <td width="20%" align="right"><label class="layui-form-label">父级名称：<span style="color: red">*</span></label></td>
            <td colspan="3">
                <c:if test="${'$'}{p.parent_name==''||p.parent_name==null}">
                    ${tablePd.menu_name}
                </c:if>
                <c:if test="${'$'}{p.parent_name!=''&&p.parent_name!=null}">
                    ${'$'}{p.parent_name }
                </c:if>
            </td>
        </tr>
    </#if>
<#list fieldList as obj>
    <#if obj.field_operat == 'Y'>
    <#if obj.show_type == '1'||obj.show_type == '7'>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">${obj.field_comment}：
                    <#if obj.verify_rule?contains("required")>
                        <span style="color: red">*</span>
                    </#if>
                </label>
            </td>
            <td colspan="3">${'$'}{p.${obj.field_name}}</td>
        </tr>
    </#if>
    <#if obj.show_type == '2'>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">${obj.field_comment}：
                    <#if obj.verify_rule?contains("required")>
                        <span style="color: red">*</span>
                    </#if>
                </label>
            </td>
            <td colspan="3">${'$'}{p.${obj.field_name}}</td>
        </tr>
    </#if>
    <#if obj.show_type == '3'>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">${obj.field_comment}：
                    <#if obj.verify_rule?contains("required")>
                        <span style="color: red">*</span>
                    </#if>
                </label>
            </td>
            <td colspan="3">
                <div id="${obj.field_name}">
                <#if obj.option_content?contains(";")>
                    <#list obj.option_content?split(";") as name>
                    <#assign param = name?split("/")>
                    <c:if test="${'$'}{p.${obj.field_name}=='${param[0]}'}"> ${param[1]} </c:if>
                    </#list>
                </#if>
                </div>
            </td>
        </tr>
    </#if>
    <#if obj.show_type == '4'>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">${obj.field_comment}：
                    <#if obj.verify_rule?contains("required")>
                        <span style="color: red">*</span>
                    </#if>
                </label>
            </td>
            <td colspan="3">
                <div id="${obj.field_name}">
                <#if obj.option_content?contains(";")>
                    <#list obj.option_content?split(";") as name>
                    <#assign param = name?split("/")>
                    <c:if test="${'$'}{p.${obj.field_name}=='${param[0]}'}"> ${param[1]} </c:if>
                    </#list>
                </#if>
                </div>
            </td>
        </tr>
    </#if>
    <#if obj.show_type == '5'>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">${obj.field_comment}：
                    <#if obj.verify_rule?contains("required")>
                        <span style="color: red">*</span>
                    </#if>
                </label>
            </td>
            <td colspan="3">
                <div id="${obj.field_name}">
                <#if obj.option_content?contains(";")>
                    <#list obj.option_content?split(";") as name>
                    <#assign param = name?split("/")>
                    <c:if test="${'$'}{p.${obj.field_name}.indexOf('${param[0]}')!=-1}"> ${param[1]} </c:if>
                    </#list>
                </#if>
                </div>
            </td>
        </tr>
    </#if>
    <#if obj.show_type == '6'>
        <#assign richText = 'true'>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">${obj.field_comment}：
                    <#if obj.verify_rule?contains("required")>
                        <span style="color: red">*</span>
                    </#if>
                </label>
            </td>
            <td colspan="3">
            ${'$'}{p.${obj.field_name}}
            </td>
        </tr>
    </#if>
    <#if obj.show_type == '8'>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">${obj.field_comment}：
                    <#if obj.verify_rule?contains("required")>
                        <span style="color: red">*</span>
                    </#if>
                </label>
            </td>
            <td colspan="3">
                <div style="margin-top:5px;">
                    <table class="layui-table">
                        <thead>
                        <tr>
                            <th>附件名称</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody id="tbody_file_${obj.field_name}">
                        <c:forEach items="${'$'}{${obj.field_name}FileList}" var="v" varStatus="vs">
                            <tr id="tr_ls${'$'}{v.id}">
                                <td>${'$'}{v.name}</td>
                                <td>
                                    <div class="layui-btn-group">
                                        <button type="button" onclick="downloadFile('${'$'}{v.id}','${'$'}{v.file_path}','${'$'}{v.name}');" class="layui-btn layui-btn-xs">下载</button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </td>
        </tr>
    </#if>
</#if>
</#list>

    <#if tablePd.temp_type == '1'>
        <tr>
            <td colspan="4">
                <table class="layui-table" style="width:95%;margin:10px auto;">
                    <thead>
                        <#list linkFieldList as obj>
                            <#if obj.field_operat == 'Y' && obj.show_type != '0'>
                            <th>${obj.field_comment}<#if obj.verify_rule?contains("required")><span style="color: red">*</span></#if></th>
                            </#if>
                        </#list>
                    </thead>
                    <tbody id="child_table">
                    <c:if test="${'$'}{fn:length(list)>0}">
                        <c:forEach items="${'$'}{list}" var="var" varStatus="status">
                            <tr id="child_tr_ls${'$'}{var.id}" style="height: 36px;">
                            <#list linkFieldList as obj>
                            <#if obj.field_operat == 'Y'>
                                <#if obj.show_type == '1'||obj.show_type == '7'>
                                <td>${'$'}{var.${obj.field_name}}</td>
                                </#if>
                                <#if obj.show_type == '2'||obj.show_type == '6'>
                                <td>${'$'}{var.${obj.field_name}}</td>
                                </#if>
                                <#if obj.show_type == '3'>
                                <td>
                                    <div id="${obj.field_name}_${'$'}{var.id}">
                                        <#if obj.option_content?contains(";")>
                                            <#list obj.option_content?split(";") as name>
                                                <#assign param = name?split("/")>
                                                <c:if test="${'$'}{var.${obj.field_name}=='${param[0]}'}"> ${param[1]} </c:if>
                                            </#list>
                                        </#if>
                                    </div>
                                </td>
                                </#if>
                                <#if obj.show_type == '4'>
                                <td>
                                    <div id="${obj.field_name}_${'$'}{var.id}">
                                        <#if obj.option_content?contains(";")>
                                            <#list obj.option_content?split(";") as name>
                                                <#assign param = name?split("/")>
                                                <c:if test="${'$'}{var.${obj.field_name}=='${param[0]}'}"> ${param[1]} </c:if>
                                            </#list>
                                        </#if>
                                    </div>
                                </td>
                                </#if>
                                <#if obj.show_type == '5'>
                                <td>
                                    <div id="${obj.field_name}_${'$'}{var.id}">
                                        <#if obj.option_content?contains(";")>
                                            <#list obj.option_content?split(";") as name>
                                                <#assign param = name?split("/")>
                                                <c:if test="${'$'}{var.${obj.field_name}.indexOf('${param[0]}')!=-1}"> ${param[1]} </c:if>
                                            </#list>
                                        </#if>
                                    </div>
                                </td>
                                </#if>
                                <#if obj.show_type == '8'>
                                <td>
                                    <div style="margin-top:5px;">
                                        <table class="layui-table">
                                            <thead>
                                            <tr>
                                                <th>附件名称</th>
                                                <th>操作</th>
                                            </tr>
                                            </thead>
                                            <tbody id="tbody_file_${obj.field_name}_${'$'}{var.id}">
                                            <c:forEach items="${'$'}{var.${obj.field_name}FileList}" var="v" varStatus="vs">
                                                <tr id="tr_ls${'$'}{v.id}">
                                                    <td>${'$'}{v.name}</td>
                                                    <td>
                                                        <div class="layui-btn-group">
                                                            <button type="button" onclick="downloadFile('${'$'}{v.id}','${'$'}{v.file_path}','${'$'}{v.name}');" class="layui-btn layui-btn-xs">下载</button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                                </#if>
                            </#if>
                            </#list>
                            </tr>
                        </c:forEach>
                    </c:if>
                    </tbody>
                </table>
            </td>
        </tr>
    </#if>
        <tr>
            <td style="text-align: center; padding-top: 10px;" colspan="4">
                <div class="layui-form-item">
                    <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" id="cancel">关闭</button>
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
        findValueDictionary('${obj.field_name}','${'$'}{p.${obj.field_name}}');
        </#if>
    </#if>
    <#if obj.show_type == '4'>
        <#if !obj.option_content?contains(";")>
        findValueDictionary('${obj.field_name}','${'$'}{p.${obj.field_name}}');
        </#if>
    </#if>
    <#if obj.show_type == '5'>
        <#if !obj.option_content?contains(";")>
        findValueDictionary('${obj.field_name}','${'$'}{p.${obj.field_name}}');
        </#if>
    </#if>
</#if>
</#list>

<#if tablePd.temp_type == '1'>
    <#list linkFieldList as obj>
        <#if obj.field_operat == 'Y'>
            <#if obj.show_type == '3'>
                <#if !obj.option_content?contains(";")>
                ${'$'}.each(${'$'}{listJson},function(i,n){
                    findValueDictionary('${obj.field_name}_'+ n.id,'${'$'}{p.${obj.field_name}}');
                })
                </#if>
            </#if>
            <#if obj.show_type == '4'>
                <#if !obj.option_content?contains(";")>
                ${'$'}.each(${'$'}{listJson},function(i,n){
                    findRadioDictionary('${obj.option_content}_'+ n.id,'div_'+ n.id+'_','${obj.field_name}_'+ n.id,'${obj.default_value}');
                })
                </#if>
            </#if>
            <#if obj.show_type == '5'>
                <#assign checkboxText = 'true'>
                <#if !obj.option_content?contains(";")>
                ${'$'}.each(${'$'}{listJson},function(i,n){
                    findCheckboxDictionary('${obj.option_content}_'+ n.id,'div-'+ n.id+'-','${obj.field_name}_'+ n.id,'${obj.default_value}');
                })
                </#if>
            </#if>
        </#if>
    </#list>

</#if>
    });
</script>

<%@include file="../../system/admin/bottom.jsp"%>