<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>

<form class="layui-form" action="" id="form">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
        <legend>基础信息设置</legend>
    </fieldset>
    <hr class="layui-bg-green">
    <table class="layui-table" style="width:95%;margin:10px auto;">
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">表名称：<span style="color: red">*</span></label></td>
            <td>${p.table_name}</td>
            <td width="15%" align="right"><label class="layui-form-label">表描述：<span style="color: red">*</span></label></td>
            <td>${p.table_comment}</td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">模板类型：<span style="color: red">*</span></label></td>
            <td>
                <c:if test="${p.temp_type=='0'}">单表</c:if>
                <c:if test="${p.temp_type=='1'}">主子表</c:if>
                <c:if test="${p.temp_type=='2'}">树表</c:if>
            </td>
            <td width="15%" align="right"><label class="layui-form-label">生成包路径：<span style="color: red">*</span></label></td>
            <td>${p.pack_path}</td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">生成模块名：<span style="color: red">*</span></label></td>
            <td>${p.mod_name}</td>
            <td width="15%" align="right"><label class="layui-form-label">生成业务名：<span style="color: red">*</span></label></td>
            <td>${p.bus_name}</td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">功能名称：<span style="color: red">*</span></label></td>
            <td>${p.menu_name}</td>
            <td width="15%" align="right"><label class="layui-form-label">上级菜单：<span style="color: red">*</span></label></td>
            <td>
                ${p.m_name}
            </td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">是否批量添加：</label></td>
            <td>
                <c:if test="${p.more_add=='0'}">否</c:if>
                <c:if test="${p.more_add=='1'}">是</c:if>
            </td>
            <td width="15%" align="right"><label class="layui-form-label">状态类型：</label></td>
            <td>
                <c:if test="${p.status_type=='0'}">单启用</c:if>
                <c:if test="${p.status_type=='1'}">多启用</c:if>
            </td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">生成方式：</label></td>
            <td>
                <c:if test="${p.more_add=='0'}">zip包下载</c:if>
                <c:if test="${p.more_add=='1'}">生成到指定路径</c:if>
            </td>
            <c:if test="${p.more_add=='1'}">
                <td width="15%" align="right"><label class="layui-form-label">生成路径：</label></td>
                <td>
                    ${p.gen_path}
                </td>
            </c:if>

        </tr>
    </table>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
        <legend>字段信息设置</legend>
    </fieldset>
    <hr class="layui-bg-green">
    <table class="layui-table" style="width: 99%;margin: 0 auto">
        <thead>
        <tr>
            <th>序号</th>
            <th width="8%">字段名称</th>
            <th width="8%">字段描述</th>
            <th width="8%">字段类型</th>
            <th>添加编辑</th>
            <th>列表展示</th>
            <th>查询展示</th>
            <th>查询方式</th>
            <th>校验规则</th>
            <th>显示类型</th>
            <th>选项内容</th>
            <th>默认值</th>
            <th>排序</th>
        </tr>
        </thead>
        <tbody id="table">
        <tr>
            <td colspan="13" style="line-height: 32px">
                说明：字段【
                <c:forEach items="${list}" var="var" varStatus="status">
                    <c:if test="${fn:contains(pd.excludeField,var.field_name)}">
                        ${var.field_name}
                    </c:if>
                </c:forEach>
                】属于系统保留字段，会默认存储使用，不可设置业务操作，如需操作可后续修改代码使用！！！
            </td>
        </tr>
        <c:set var="index" value="0"></c:set>
        <c:forEach items="${list}" var="var" varStatus="status">
            <c:if test="${!fn:contains(pd.excludeField,var.field_name)}">
                <c:set var="index" value="${index+1}"></c:set>
                <tr style="height: 40px">
                <td>${index}</td>
                <td>${var.field_name}</td>
                <td>${var.field_comment}</td>
                <td>${var.field_type}</td>
                <td>
                    <input type="checkbox" lay-skin="primary" disabled lay-filter='checkField' <c:if test="${var.field_operat=='Y'}">checked</c:if> title="">
                <td>
                    <input type="checkbox"  disabled lay-skin="primary" <c:if test="${var.field_list=='Y'}">checked</c:if> title="">
                </td>
                <td>
                    <input type="checkbox" disabled lay-skin="primary" <c:if test="${var.field_query=='Y'}">checked</c:if> title="">
                </td>
                <td>
                    ${var.query_type}
                </td>
                <td>
                    <c:if test="${fn:contains(var.verify_rule,',')}">
                        ${var.verify_rule}
                    </c:if>
                    <c:if test="${var.verify_rule=='required'}">必输</c:if>
                    <c:if test="${var.verify_rule=='phone'}">电话</c:if>
                    <c:if test="${var.verify_rule=='email'}">邮箱</c:if>
                    <c:if test="${var.verify_rule=='url'}">链接</c:if>
                    <c:if test="${var.verify_rule=='number'}">数字</c:if>
                    <c:if test="${var.verify_rule=='date'}">日期</c:if>
                    <c:if test="${var.verify_rule=='identity'}">身份证号</c:if>
                    <c:if test="${var.verify_rule=='longitude'}">经度</c:if>
                    <c:if test="${var.verify_rule=='latitude'}">纬度</c:if>
                    <c:if test="${var.verify_rule=='float'}">浮点型</c:if>
                    <c:if test="${var.verify_rule=='floats'}">可为空浮点型</c:if>
                    <c:if test="${var.verify_rule=='field_len10'}">最大长度10字符</c:if>
                    <c:if test="${var.verify_rule=='field_len25'}">最大长度25字符</c:if>
                    <c:if test="${var.verify_rule=='field_len50'}">最大长度50字符</c:if>
                    <c:if test="${var.verify_rule=='field_len100'}">最大长度100字符</c:if>
                    <c:if test="${var.verify_rule=='field_len200'}">最大长度200字符</c:if>
                    <c:if test="${var.verify_rule=='field_len500'}">最大长度500字符</c:if>
                    <c:if test="${var.verify_rule=='field_len1200'}">最大长度1200字符</c:if>
                    <c:if test="${var.verify_rule=='field_len5000'}">最大长度5000字符</c:if>
                </td>
                <td>
                    <c:if test="${var.show_type=='1'}">文本框</c:if>
                    <c:if test="${var.show_type=='2'}">文本域</c:if>
                    <c:if test="${var.show_type=='3'}">下拉框</c:if>
                    <c:if test="${var.show_type=='4'}">单选框</c:if>
                    <c:if test="${var.show_type=='5'}">复选框</c:if>
                    <c:if test="${var.show_type=='6'}">富文本</c:if>
                    <c:if test="${var.show_type=='7'}">日期控件</c:if>
                    <c:if test="${var.show_type=='8'}">上传控件</c:if>
                    <c:if test="${var.show_type=='9'}">单选人</c:if>
                    <c:if test="${var.show_type=='10'}">单选组织</c:if>
                    <c:if test="${var.show_type=='11'}">多选人</c:if>
                    <c:if test="${var.show_type=='12'}">多选组织</c:if>
                    <c:if test="${var.show_type=='0'}">隐藏字段</c:if>
                </td>
                <td>
                    <c:if test="${var.show_type=='3'||var.show_type=='4'||var.show_type=='5'}">
                        ${var.option_content}
                    </c:if>
                </td>
                <td>${var.default_value}</td>
                <td>${var.order_by}</td>
            </tr>
            </c:if>
        </c:forEach>
        <tr>
            <td colspan="13" style="line-height: 32px">
                选项内容说明：模式一：取值方式：[值]/[显示文字];[值]/[显示文字];...。例：【0/北京;1/上海;2/深圳】。模式二：关联字典表，选项内容填写父节点字段code值，默认值填写对应code值。
            </td>
        </tr>
        </tbody>
    </table>
    <c:if test="${p.temp_type=='1'}">
    <div id="tempType1">
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
            <legend>关联表信息设置</legend>
        </fieldset>
        <hr class="layui-bg-green">
        <table width="95%" style="margin: 0 auto">
            <tr>
                <td width="15%" align="right"><label class="layui-form-label">选择关联子表：<span style="color: red">*</span></label></td>
                <td>
                    ${linkTablePd.link_table_comment}【${linkTablePd.link_table_name}】
                </td>
                <td width="15%" align="right"><label class="layui-form-label">选择关联字段：<span style="color: red">*</span></label></td>
                <td>
                    ${linkTablePd.link_field_comment}【${linkTablePd.link_field_name}】
                </td>
            </tr>
        </table>
        <table class="layui-table" style="width: 99%;margin: 0 auto">
            <thead>
            <tr>
                <th>序号</th>
                <th width="8%">字段名称</th>
                <th width="8%">字段描述</th>
                <th width="8%">字段类型</th>
                <th>添加编辑</th>
                <th>校验规则</th>
                <th>显示类型</th>
                <th>选项内容</th>
                <th>默认值</th>
                <th>排序</th>
            </tr>
            </thead>
            <tbody id="link_tbody">
                <c:set var="index" value="0"></c:set>
                <c:forEach items="${linkFieldList}" var="var" varStatus="status">
                    <c:if test="${!fn:contains(pd.excludeField,var.field_name)}">
                        <c:set var="index" value="${index+1}"></c:set>
                        <tr style="height: 40px">
                            <td>${index}</td>
                            <td>${var.field_name}
                            </td>
                            <td>${var.field_comment}</td>
                            <td>${var.field_type}
                            </td>
                            <td>
                                <input type="checkbox" disabled lay-filter='checkField' lay-skin="primary" <c:if test="${var.field_operat=='Y'}">checked</c:if> title="">
                            </td>
                            <td>
                                <c:if test="${fn:contains(var.verify_rule,',')}">
                                    ${var.verify_rule}
                                </c:if>
                                <c:if test="${var.verify_rule=='required'}">必输</c:if>
                                <c:if test="${var.verify_rule=='phone'}">电话</c:if>
                                <c:if test="${var.verify_rule=='email'}">邮箱</c:if>
                                <c:if test="${var.verify_rule=='url'}">链接</c:if>
                                <c:if test="${var.verify_rule=='number'}">数字</c:if>
                                <c:if test="${var.verify_rule=='date'}">日期</c:if>
                                <c:if test="${var.verify_rule=='identity'}">身份证号</c:if>
                                <c:if test="${var.verify_rule=='longitude'}">经度</c:if>
                                <c:if test="${var.verify_rule=='latitude'}">纬度</c:if>
                                <c:if test="${var.verify_rule=='float'}">浮点型</c:if>
                                <c:if test="${var.verify_rule=='floats'}">可为空浮点型</c:if>
                                <c:if test="${var.verify_rule=='field_len10'}">最大长度10字符</c:if>
                                <c:if test="${var.verify_rule=='field_len25'}">最大长度25字符</c:if>
                                <c:if test="${var.verify_rule=='field_len50'}">最大长度50字符</c:if>
                                <c:if test="${var.verify_rule=='field_len100'}">最大长度100字符</c:if>
                                <c:if test="${var.verify_rule=='field_len200'}">最大长度200字符</c:if>
                                <c:if test="${var.verify_rule=='field_len500'}">最大长度500字符</c:if>
                                <c:if test="${var.verify_rule=='field_len1200'}">最大长度1200字符</c:if>
                                <c:if test="${var.verify_rule=='field_len5000'}">最大长度5000字符</c:if>
                            </td>
                            <td>
                                <c:if test="${var.show_type=='1'}">文本框</c:if>
                                <c:if test="${var.show_type=='2'}">文本域</c:if>
                                <c:if test="${var.show_type=='3'}">下拉框</c:if>
                                <c:if test="${var.show_type=='4'}">单选框</c:if>
                                <c:if test="${var.show_type=='5'}">复选框</c:if>
                                <c:if test="${var.show_type=='6'}">富文本</c:if>
                                <c:if test="${var.show_type=='7'}">日期控件</c:if>
                                <c:if test="${var.show_type=='8'}">上传控件</c:if>
                                <c:if test="${var.show_type=='9'}">单选人</c:if>
                                <c:if test="${var.show_type=='10'}">单选组织</c:if>
                                <c:if test="${var.show_type=='11'}">多选人</c:if>
                                <c:if test="${var.show_type=='12'}">多选组织</c:if>
                                <c:if test="${var.show_type=='0'}">隐藏字段</c:if>
                            </td>
                            <td>
                                <c:if test="${var.show_type=='3'||var.show_type=='4'||var.show_type=='5'}">
                                    ${var.option_content}
                                </c:if>
                            </td>
                            <td>${var.default_value}</td>
                            <td>${var.order_by}</td>
                        </tr>
                    </c:if>
                </c:forEach>
            </tbody>
        </table>
    </div>
    </c:if>
    <c:if test="${p.temp_type=='2'}">
    <div id="tempType2">
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
            <legend>树结构信息设置</legend>
        </fieldset>
        <hr class="layui-bg-green">
        <table class="layui-table" style="width:95%;margin:10px auto;">
            <tr>
                <td width="15%" align="right"><label class="layui-form-label">父节点字段：<span style="color: red">*</span></label></td>
                <td>
                    ${p.tree_pid_comment}【${p.tree_pid}】
                </td>
                <td width="15%" align="right"><label class="layui-form-label">节点名称字段：<span style="color: red">*</span></label></td>
                <td>
                    ${p.tree_name_comment}【${p.tree_name}】
                </td>
            </tr>
        </table>
    </div>
    </c:if>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
        <legend>其他信息设置</legend>
    </fieldset>
    <hr class="layui-bg-green">
    <table class="layui-table" style="width:95%;margin:10px auto;">
        <tr>
            <td align="right" style="width: 15%"><label class="layui-form-label">排序号：</label></td>
            <td colspan="3">${p.order_by}</td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">备注：</label></td>
            <td colspan="3">${p.remark}</td>
        </tr>
        <tr>
            <td style="text-align: center; padding-top: 10px;" colspan="4">
                <div class="layui-form-item">
                    <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" id="cancel">关闭</button>
                </div>
            </td>
        </tr>
    </table>
</form>
<div id="menuContent" class="menuContent" style="display:none; position: absolute; background-color: #eaeaea; min-height: 300px;min-width:180px;z-index:999; ">
    <ul id="selectMenuZtree" class="ztree" style="margin-top:0; min-width:180px; min-height: 300px;"></ul>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/xadmin/lib/layui/layui.js" charset="utf-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfverify.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfAjaxReq.js"></script>
<!-- 注意：如果你直接复制所有代码到本地，上述js路径需要改成你本地的 -->
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/ztree/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/ztree/js/jquery.ztree.excheck.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css" />
<%@include file="select_menu.jsp" %>

<script>
    var form,layer;
    layui.use(['form'], function(){
        form = layui.form;
        layer = layui.layer;

        $('#cancel').on('click',function (){
            var index = parent.layer.getFrameIndex("gencode_info");
            parent.layer.close(index);
        });

    });

</script>

<%@include file="../admin/bottom.jsp"%>