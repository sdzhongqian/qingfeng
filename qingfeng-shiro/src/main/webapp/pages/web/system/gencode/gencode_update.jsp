<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>

<form class="layui-form" action="" id="form">
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
        <legend>基础信息设置</legend>
    </fieldset>
    <hr class="layui-bg-green">
    <table width="95%" style="margin: 0 auto">
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">表名称：<span style="color: red">*</span></label></td>
            <td><input type="text" value="${p.table_name}" lay-verify="field_len50" readonly class="layui-input"></td>
            <td width="15%" align="right"><label class="layui-form-label">表描述：<span style="color: red">*</span></label></td>
            <td><input type="text" name="table_comment" id="table_comment" value="${p.table_comment}" lay-verify="required|field_len50" autocomplete="off" placeholder="表描述" class="layui-input"></td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">模板类型：<span style="color: red">*</span></label></td>
            <td>
                <select name="temp_type" id="temp_type" lay-verify="required" lay-filter='selectTempType' style="width: 200px;" lay-search="">
                    <option value="0" <c:if test="${p.temp_type=='0'}">selected</c:if>>单表</option>
                    <option value="1" <c:if test="${p.temp_type=='1'}">selected</c:if>>主子表</option>
                    <option value="2" <c:if test="${p.temp_type=='2'}">selected</c:if>>树表</option>
                </select>
            </td>
            <td width="15%" align="right"><label class="layui-form-label">生成包路径：<span style="color: red">*</span></label></td>
            <td><input type="text" name="pack_path" id="pack_path" value="${p.pack_path}" lay-verify="required|field_len50" autocomplete="off" placeholder="生成包路径" class="layui-input"></td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">生成模块名：<span style="color: red">*</span></label></td>
            <td><input type="text" name="mod_name" id="mod_name" value="${p.mod_name}" lay-verify="required|field_len50" autocomplete="off" placeholder="生成模块名" class="layui-input"></td>
            <td width="15%" align="right"><label class="layui-form-label">生成业务名：<span style="color: red">*</span></label></td>
            <td><input type="text" name="bus_name" id="bus_name" value="${p.bus_name}" lay-verify="required|field_len50" autocomplete="off" placeholder="生成业务名" class="layui-input"></td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">功能名称：<span style="color: red">*</span></label></td>
            <td><input type="text" name="menu_name" id="menu_name" value="${p.menu_name}" lay-verify="required|field_len50" autocomplete="off" placeholder="功能名称" class="layui-input"></td>
            <td width="15%" align="right"><label class="layui-form-label">上级菜单：<span style="color: red">*</span></label></td>
            <td>
                <input type="text" readonly autocomplete="off" id="m_name" name="m_name" placeholder="请选择上级菜单" value="${p.m_name}" class="layui-input" onclick="showMenu('m_name','menu_id');">
                <input type="hidden" name="menu_id" id="menu_id" value="${p.menu_id}" lay-verify="required|field_len50" autocomplete="off" placeholder="上级菜单" class="layui-input">
            </td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">是否批量添加：</label></td>
            <td>
                <select name="more_add" id="more_add" lay-verify="required" lay-filter='' style="width: 200px;" lay-search="">
                    <option value="0" <c:if test="${p.more_add=='0'}">selected</c:if>>否</option>
                    <option value="1" <c:if test="${p.more_add=='1'}">selected</c:if>>是</option>
                </select>
            </td>
            <td width="15%" align="right"><label class="layui-form-label">状态类型：</label></td>
            <td>
                <select name="status_type" id="status_type" lay-verify="" lay-filter='' style="width: 200px;" lay-search="">
                    <option value="">无状态</option>
                    <option value="0" <c:if test="${p.status_type=='0'}">selected</c:if>>单启用</option>
                    <option value="1" <c:if test="${p.status_type=='1'}">selected</c:if>>多启用</option>
                </select>
            </td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">生成方式：</label></td>
            <td>
                <select name="gen_type" id="gen_type" lay-verify="required" lay-filter='selectGenType' style="width: 200px;" lay-search="">
                    <option value="0" <c:if test="${p.gen_type=='0'}">selected</c:if>>zip包下载</option>
                    <option value="1" <c:if test="${p.gen_type=='1'}">selected</c:if>>生成到指定路径</option>
                </select>
            </td>
                <td width="15%" align="right"><label class="layui-form-label">生成路径：</label></td>
                <td>
                    <div id="div_gen_path" <c:if test="${p.gen_type=='0'}">style="display: none"</c:if>>
                        <input type="text" name="gen_path" id="gen_path" value="${p.gen_path}" lay-verify="field_len50" autocomplete="off" placeholder="生成路径" class="layui-input">
                    </div>
                </td>
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
            <th>操作</th>
        </tr>
        </thead>
        <tbody id="table">
        <c:set var="index" value="0"></c:set>
        <c:forEach items="${list}" var="var" varStatus="status">
            <c:if test="${!fn:contains(pd.excludeField,var.field_name)}">
                <c:set var="index" value="${index+1}"></c:set>
            <tr>
                <td>${index}</td>
                <td>${var.field_name}<input type="hidden" name="field_id" value="${var.id}" class="layui-input"></td>
                <td><input type="text" name="field_comment" value="${var.field_comment}" lay-verify="field_len50" placeholder="字段描述" class="layui-input"></td>
                <td>${var.field_type}</td>
                <td>
                    <c:if test="${!fn:contains(pd.excludeField,var.field_name)}">
                        <input type="hidden" name="field_operat" id="field_operat_${var.id}" value="${var.field_operat}" class="layui-input">
                        <input type="checkbox" lay-skin="primary" id="show_field_operat_${var.id}" lay-filter='checkField' <c:if test="${var.field_operat=='Y'}">checked</c:if> title=""></c:if>
                    </td>
                <td>
                    <c:if test="${!fn:contains(pd.excludeField,var.field_name)}">
                        <input type="hidden" name="field_list" id="field_list_${var.id}" value="${var.field_list}" class="layui-input">
                        <input type="checkbox"  id="show_field_list_${var.id}" lay-filter='checkField' lay-skin="primary" <c:if test="${var.field_list=='Y'}">checked</c:if> title="">
                    </c:if>
                </td>
                <td>
                    <c:if test="${!fn:contains(pd.excludeField,var.field_name)}">
                        <input type="hidden" name="field_query" id="field_query_${var.id}" value="${var.field_query}" class="layui-input">
                        <input type="checkbox"  id="show_field_query_${var.id}" lay-filter='checkField' lay-skin="primary" <c:if test="${var.field_query=='Y'}">checked</c:if> title="">
                    </c:if>
                </td>
                <td>
                    <select name="query_type" id="query_type" lay-verify="" lay-filter='' style="width: 200px;" lay-search="">
                        <option value="=" <c:if test="${var.query_type=='='}">selected</c:if>>=</option>
                        <option value="!=" <c:if test="${var.query_type=='!='}">selected</c:if>>!=</option>
                        <option value=">" <c:if test="${var.query_type=='>'}">selected</c:if>>></option>
                        <option value=">=" <c:if test="${var.query_type=='>='}">selected</c:if>>>=</option>
                        <option value="<" <c:if test="${var.query_type=='<'}">selected</c:if>><</option>
                        <option value="<=" <c:if test="${var.query_type=='<='}">selected</c:if>><=</option>
                        <option value="like" <c:if test="${var.query_type=='like'}">selected</c:if>>like</option>
                        <option value="is null" <c:if test="${var.query_type=='is null'}">selected</c:if>>is null</option>
                        <option value="is not null" <c:if test="${var.query_type=='is not null'}">selected</c:if>>is not null</option>
                        <option value="time_period" <c:if test="${var.query_type=='time_period'}">selected</c:if>>时间区间</option>
                    </select>
                </td>
                <td>
                    <select name='verify_rule' style='width:70px' class="layui-input layui-unselect">
                        <option value="">请选择</option>
                        <c:if test="${fn:contains(var.verify_rule,',')}">
                            <option value="${var.verify_rule}" selected>${var.verify_rule}</option>
                        </c:if>
                        <option value="required" <c:if test="${var.verify_rule=='required'}">selected</c:if>>必输</option>
                        <option value="phone" <c:if test="${var.verify_rule=='phone'}">selected</c:if>>电话</option>
                        <option value="email" <c:if test="${var.verify_rule=='email'}">selected</c:if>>邮箱</option>
                        <option value="url" <c:if test="${var.verify_rule=='url'}">selected</c:if>>链接</option>
                        <option value="number" <c:if test="${var.verify_rule=='number'}">selected</c:if>>数字</option>
                        <option value="date" <c:if test="${var.verify_rule=='date'}">selected</c:if>>日期</option>
                        <option value="identity" <c:if test="${var.verify_rule=='identity'}">selected</c:if>>身份证号</option>
                        <option value="longitude" <c:if test="${var.verify_rule=='longitude'}">selected</c:if>>经度</option>
                        <option value="latitude" <c:if test="${var.verify_rule=='latitude'}">selected</c:if>>纬度</option>
                        <option value="float" <c:if test="${var.verify_rule=='float'}">selected</c:if>>浮点型</option>
                        <option value="floats" <c:if test="${var.verify_rule=='floats'}">selected</c:if>>可为空浮点型</option>
                        <option value="field_len10" <c:if test="${var.verify_rule=='field_len10'}">selected</c:if>>最大长度10字符</option>
                        <option value="field_len25" <c:if test="${var.verify_rule=='field_len25'}">selected</c:if>>最大长度25字符</option>
                        <option value="field_len50" <c:if test="${var.verify_rule=='field_len50'}">selected</c:if>>最大长度50字符</option>
                        <option value="field_len100" <c:if test="${var.verify_rule=='field_len100'}">selected</c:if>>最大长度100字符</option>
                        <option value="field_len200" <c:if test="${var.verify_rule=='field_len200'}">selected</c:if>>最大长度200字符</option>
                        <option value="field_len500" <c:if test="${var.verify_rule=='field_len500'}">selected</c:if>>最大长度500字符</option>
                        <option value="field_len1200" <c:if test="${var.verify_rule=='field_len1200'}">selected</c:if>>最大长度1200字符</option>
                        <option value="field_len5000" <c:if test="${var.verify_rule=='field_len5000'}">selected</c:if>>最大长度5000字符</option>
                    </select>
                </td>
                <td>
                    <select name="show_type" id="showType_${var.id}" lay-verify="" lay-filter='selectShowType' style="width: 200px;" lay-search="">
                        <option value="1" <c:if test="${var.show_type=='1'}">selected</c:if>>文本框</option>
                        <option value="2" <c:if test="${var.show_type=='2'}">selected</c:if>>文本域</option>
                        <option value="3" <c:if test="${var.show_type=='3'}">selected</c:if>>下拉框</option>
                        <option value="4" <c:if test="${var.show_type=='4'}">selected</c:if>>单选框</option>
                        <option value="5" <c:if test="${var.show_type=='5'}">selected</c:if>>复选框</option>
                        <option value="6" <c:if test="${var.show_type=='6'}">selected</c:if>>富文本</option>
                        <option value="7" <c:if test="${var.show_type=='7'}">selected</c:if>>日期控件</option>
                        <option value="8" <c:if test="${var.show_type=='8'}">selected</c:if>>上传控件</option>
                        <%--<option value="9" <c:if test="${var.show_type=='9'}">selected</c:if>>单选人</option>--%>
                        <%--<option value="10" <c:if test="${var.show_type=='10'}">selected</c:if>>单选组织</option>--%>
                        <%--<option value="11" <c:if test="${var.show_type=='11'}">selected</c:if>>多选人</option>--%>
                        <%--<option value="12" <c:if test="${var.show_type=='12'}">selected</c:if>>多选组织</option>--%>
                        <option value="0" <c:if test="${var.show_type=='0'}">selected</c:if>>隐藏字段</option>
                    </select>
                </td>
                <td>
                    <div id="optionContent_${var.id}" <c:if test="${var.show_type!='3'&&var.show_type!='4'&&var.show_type!='5'}">style="display: none"</c:if>>
                        <input type="text" name="option_content" value="${var.option_content}" lay-verify="field_len50" placeholder="选项内容" class="layui-input">
                    </div>
                </td>
                <td><input type="text" name="default_value" value="${var.default_value}" lay-verify="field_len50" placeholder="默认值" class="layui-input"></td>
                <td><input type="text" name="table_order_by" value="${var.order_by}" lay-verify="field_len50" placeholder="排序" class="layui-input"></td>
                <td><button type="button" class="layui-btn layui-btn-normal layui-btn-xs" onclick="editField('${var.id}','0');"><i class="layui-icon"></i></button></td>
            </tr>
            </c:if>
        </c:forEach>
        <tr>
            <td colspan="13" style="line-height: 32px">
                说明：字段【
                <c:forEach items="${list}" var="var" varStatus="status">
                    <c:if test="${fn:contains(pd.excludeField,var.field_name)}">
                        ${var.field_name}
                    </c:if>
                </c:forEach>
                】属于系统保留字段，会默认存储使用，不可设置业务操作，如需操作可后续修改代码使用！！！
                <br>
                选项内容说明：模式一：取值方式：[值]/[显示文字];[值]/[显示文字];...。例：【0/北京;1/上海;2/深圳】。模式二：关联字典表，选项内容填写父节点字段code值，默认值填写对应code值。
            </td>
        </tr>
        </tbody>
    </table>
    <div id="tempType1" <c:if test="${p.temp_type!='1'}"> style="display: none"</c:if>>
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
            <legend>关联表信息设置</legend>
        </fieldset>
        <hr class="layui-bg-green">
        <table width="95%" style="margin: 0 auto">
            <tr>
                <td width="15%" align="right"><label class="layui-form-label">选择关联子表：<span style="color: red">*</span></label></td>
                <td>
                    <input type="hidden" name="link_table_id" value="${linkTablePd.id}" class="layui-input">
                    <select name="link_table" id="link_table" lay-verify="" lay-filter='selectLinkTable' style="width: 200px;" lay-search="">
                        <option value="">请选择</option>
                        <c:forEach items="${tableList}" var="var" varStatus="status">
                            <option value="${var.id}" <c:if test="${var.id==linkTablePd.link_table}"> selected </c:if>>${var.table_comment}【${var.table_name}】</option>
                        </c:forEach>
                    </select>
                </td>
                <td width="15%" align="right"><label class="layui-form-label">选择关联字段：<span style="color: red">*</span></label></td>
                <td>
                    <select name="link_field" id="link_field" lay-verify="" lay-filter='' style="width: 200px;" lay-search="">
                        <option value="">请选择</option>
                        <c:forEach items="${linkFieldList}" var="var" varStatus="status">
                            <option value="${var.field_name}" <c:if test="${var.field_name==linkTablePd.link_field}"> selected </c:if>>${var.field_comment}【${var.field_name}】</option>
                        </c:forEach>
                    </select>
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
                <th>操作</th>
            </tr>
            </thead>
            <tbody id="link_tbody">
                <c:set var="index" value="0"></c:set>
                <c:forEach items="${linkFieldList}" var="var" varStatus="status">
                    <c:if test="${!fn:contains(pd.excludeField,var.field_name)}">
                        <c:set var="index" value="${index+1}"></c:set>
                        <tr>
                            <td>${index}</td>
                            <td>${var.field_name}
                                <input type="hidden" name="link_field_id" value="${var.id}" class="layui-input">
                            </td>
                            <td><input type="text" name="link_field_comment" value="${var.field_comment}" lay-verify="field_len50" placeholder="字段描述" class="layui-input"></td>
                            <td>${var.field_type}
                            </td>
                            <td>
                                <c:if test="${!fn:contains(pd.excludeField,var.field_name)}">
                                    <input type="hidden" name="link_field_operat" id="link_field_operat_${var.id}" value="${var.field_operat}" class="layui-input">
                                    <input type="checkbox" id="show_link_field_operat_${var.id}" lay-filter='checkField' lay-skin="primary" <c:if test="${var.field_operat=='Y'}">checked</c:if> title="">
                                </c:if>
                            </td>
                            <td>
                                <select name='link_verify_rule' style='width:70px' class="layui-input layui-unselect">
                                    <option value="">请选择</option>
                                    <c:if test="${fn:contains(var.verify_rule,',')}">
                                        <option value="${var.verify_rule}" selected>${var.verify_rule}</option>
                                    </c:if>
                                    <option value="required" <c:if test="${var.verify_rule=='required'}">selected</c:if>>必输</option>
                                    <option value="phone" <c:if test="${var.verify_rule=='phone'}">selected</c:if>>电话</option>
                                    <option value="email" <c:if test="${var.verify_rule=='email'}">selected</c:if>>邮箱</option>
                                    <option value="url" <c:if test="${var.verify_rule=='url'}">selected</c:if>>链接</option>
                                    <option value="number" <c:if test="${var.verify_rule=='number'}">selected</c:if>>数字</option>
                                    <option value="date" <c:if test="${var.verify_rule=='date'}">selected</c:if>>日期</option>
                                    <option value="identity" <c:if test="${var.verify_rule=='identity'}">selected</c:if>>身份证号</option>
                                    <option value="longitude" <c:if test="${var.verify_rule=='longitude'}">selected</c:if>>经度</option>
                                    <option value="latitude" <c:if test="${var.verify_rule=='latitude'}">selected</c:if>>纬度</option>
                                    <option value="float" <c:if test="${var.verify_rule=='float'}">selected</c:if>>浮点型</option>
                                    <option value="floats" <c:if test="${var.verify_rule=='floats'}">selected</c:if>>可为空浮点型</option>
                                    <option value="field_len10" <c:if test="${var.verify_rule=='field_len10'}">selected</c:if>>最大长度10字符</option>
                                    <option value="field_len25" <c:if test="${var.verify_rule=='field_len25'}">selected</c:if>>最大长度25字符</option>
                                    <option value="field_len50" <c:if test="${var.verify_rule=='field_len50'}">selected</c:if>>最大长度50字符</option>
                                    <option value="field_len100" <c:if test="${var.verify_rule=='field_len100'}">selected</c:if>>最大长度100字符</option>
                                    <option value="field_len200" <c:if test="${var.verify_rule=='field_len200'}">selected</c:if>>最大长度200字符</option>
                                    <option value="field_len500" <c:if test="${var.verify_rule=='field_len500'}">selected</c:if>>最大长度500字符</option>
                                    <option value="field_len1200" <c:if test="${var.verify_rule=='field_len1200'}">selected</c:if>>最大长度1200字符</option>
                                    <option value="field_len5000" <c:if test="${var.verify_rule=='field_len5000'}">selected</c:if>>最大长度5000字符</option>
                                </select>
                            </td>
                            <td>
                                <select name="link_show_type" id="showType_${var.id}" lay-verify="" lay-filter='selectShowType' style="width: 200px;" lay-search="">
                                    <option value="1" <c:if test="${var.show_type=='1'}">selected</c:if>>文本框</option>
                                    <option value="2" <c:if test="${var.show_type=='2'}">selected</c:if>>文本域</option>
                                    <option value="3" <c:if test="${var.show_type=='3'}">selected</c:if>>下拉框</option>
                                    <option value="4" <c:if test="${var.show_type=='4'}">selected</c:if>>单选框</option>
                                    <option value="5" <c:if test="${var.show_type=='5'}">selected</c:if>>复选框</option>
                                    <%--<option value="6" <c:if test="${var.show_type=='6'}">selected</c:if>>富文本</option>--%>
                                    <option value="7" <c:if test="${var.show_type=='7'}">selected</c:if>>日期控件</option>
                                    <option value="8" <c:if test="${var.show_type=='8'}">selected</c:if>>上传控件</option>
                                    <%--<option value="9" <c:if test="${var.show_type=='9'}">selected</c:if>>单选人</option>--%>
                                    <%--<option value="10" <c:if test="${var.show_type=='10'}">selected</c:if>>单选组织</option>--%>
                                    <%--<option value="11" <c:if test="${var.show_type=='11'}">selected</c:if>>多选人</option>--%>
                                    <%--<option value="12" <c:if test="${var.show_type=='12'}">selected</c:if>>多选组织</option>--%>
                                    <option value="0" <c:if test="${var.show_type=='0'}">selected</c:if>>隐藏字段</option>
                                </select>
                            </td>
                            <td>
                                <div id="optionContent_${var.id}" <c:if test="${var.show_type!='3'&&var.show_type!='4'&&var.show_type!='5'}">style="display: none"</c:if>>
                                    <input type="text" name="link_option_content" value="${var.option_content}" lay-verify="field_len50" placeholder="选项内容" class="layui-input">
                                </div>
                            </td>
                            <td><input type="text" name="link_default_value" value="${var.default_value}" lay-verify="field_len50" placeholder="默认值" class="layui-input"></td>
                            <td><input type="text" name="link_order_by" value="${var.order_by}" lay-verify="field_len50" placeholder="排序" class="layui-input"></td>
                            <td><button type="button" class="layui-btn layui-btn-normal layui-btn-xs" onclick="editField('${var.id}','1');"><i class="layui-icon"></i></button></td>
                        </tr>
                    </c:if>
                </c:forEach>
                <tr>
                    <td colspan="13" style="line-height: 32px">
                        说明：字段【
                        <c:forEach items="${linkFieldList}" var="var" varStatus="status">
                            <c:if test="${fn:contains(pd.excludeField,var.field_name)}">
                                ${var.field_name}
                            </c:if>
                        </c:forEach>
                        】属于系统保留字段，会默认存储使用，不可设置业务操作，如需操作可后续修改代码使用！！！
                        <br>
                        选项内容说明：
                        模式一：取值方式：[值]/[显示文字];[值]/[显示文字];...。例：【0/北京;1/上海;2/深圳】。模式二：关联字典表，选项内容填写父节点字段code值，默认值填写对应code值。<br>
                        关联字段说明：【选择关联字段】会重新进行设置，上面列表中对应字段的设置情况会失效。
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <div id="tempType2" <c:if test="${p.temp_type!='2'}"> style="display: none"</c:if>>
        <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
            <legend>树结构信息设置</legend>
        </fieldset>
        <hr class="layui-bg-green">
        <table width="95%" style="margin: 0 auto">
            <tr>
                <td width="15%" align="right"><label class="layui-form-label">父节点字段：<span style="color: red">*</span></label></td>
                <td>
                    <select name="tree_pid" id="tree_pid" lay-verify="" lay-filter='' style="width: 200px;" lay-search="">
                        <option value="">请选择</option>
                        <c:forEach items="${list}" var="var" varStatus="status">
                            <c:if test="${!fn:contains(pd.excludeField,var.field_name)}">
                                <option value="${var.field_name}" <c:if test="${p.tree_pid==var.field_name}">selected</c:if>>${var.field_comment}【${var.field_name}】</option>
                            </c:if>
                        </c:forEach>
                    </select>
                </td>
                <td width="15%" align="right"><label class="layui-form-label">节点名称字段：<span style="color: red">*</span></label></td>
                <td>
                    <select name="tree_name" id="tree_name" lay-verify="" lay-filter='' style="width: 200px;" lay-search="">
                        <option value="">请选择</option>
                        <c:forEach items="${list}" var="var" varStatus="status">
                            <c:if test="${!fn:contains(pd.excludeField,var.field_name)}">
                                <option value="${var.field_name}" <c:if test="${p.tree_name==var.field_name}">selected</c:if>>${var.field_comment}【${var.field_name}】</option>
                            </c:if>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr style="height: 40px;">
                <td align="right">说明：</td>
                <td colspan="3">
                    在树表中，【父节点字段】会重新进行设置，上面列表中对应字段的设置情况会失效。
                </td>
            </tr>
        </table>
    </div>

    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
        <legend>其他信息设置</legend>
    </fieldset>
    <hr class="layui-bg-green">
    <table width="95%" style="margin: 0 auto">
        <tr>
            <td align="right" style="width: 15%"><label class="layui-form-label">排序号：</label></td>
            <td colspan="3"><input type="text" name="order_by" id="order_by" value="${p.order_by}" lay-verify="field_len50|intNumber" autocomplete="off" placeholder="排序号" class="layui-input"></td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">备注：</label></td>
            <td colspan="3"><textarea name="remark" placeholder="请输入备注" class="layui-textarea">${p.remark}</textarea></td>
        </tr>
        <tr>
            <td style="text-align: center; padding-top: 10px;" colspan="4">
                <div class="layui-form-item">
                    <input type="hidden" name="id" id="id" value="${p.id}" />
                    <button type="button" class="layui-btn layui-btn-sm" id="submit_button" lay-submit="" lay-filter="submit_form">保存</button>
                    <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" id="cancel">取消</button>
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
    var form,layer,layedit,laydate;
    layui.use(['form', 'layedit', 'laydate'],function(){
        form = layui.form;
        layer = layui.layer;
        layedit = layui.layedit;
        laydate = layui.laydate;

        $('#cancel').on('click',function (){
            var index = parent.layer.getFrameIndex("gencode_edit");
            parent.layer.close(index);
        });

        //自定义验证规则
        form.verify(form_verify);

        //监听提交
        form.on('submit(submit_form)', function(data){
            layer.msg('正在提交数据。');
            $("#submit_button").attr('disabled',true);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/system/gencode/update" ,//url
                data: $('#form').serialize(),
                success: function (res) {
                    if (res.success) {
                        layer.msg("数据更新成功。", {time: 2000},function(){
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

        //监听选择
        form.on('select(selectTempType)', function(obj){
            $("#link_table").attr("lay-verify", "field_len50");
            $("#link_field").attr("lay-verify", "field_len50");
            $("#tree_pid").attr("lay-verify", "field_len50");
            $("#tree_name").attr("lay-verify", "field_len50");
            if(obj.value=='0'){//单表
                $("#tempType1").hide();
                $("#tempType2").hide();
            }else if(obj.value=='1'){//主子表
                $("#tempType1").show();
                $("#tempType2").hide();
                $("#link_table").attr("lay-verify", "required|field_len50");
                $("#link_field").attr("lay-verify", "required|field_len50");
            }else if(obj.value=='2'){//树表
                $("#tree_pid").attr("lay-verify", "required|field_len50");
                $("#tree_name").attr("lay-verify", "required|field_len50");
                $("#tempType1").hide();
                $("#tempType2").show();
            }
            form.render('select');
            return false;
        });

        form.on('select(selectShowType)', function(obj){
            //3/4/5
            var obj_id = obj.elem.id;
            var id = obj_id.substring(obj_id.lastIndexOf("_")+1);
            console.log(id);
            if(obj.value=='3'||obj.value=='4'||obj.value=='5'){
                $("#optionContent_"+id).show();
            }else{
                $("#optionContent_"+id).hide();
            }
            form.render('select');
            return false;
        });

        form.on('select(selectGenType)', function(obj){
            if(obj.value=='1'){
                $("#div_gen_path").show();
            }else{
                $("#div_gen_path").hide();
            }
            form.render('select');
            return false;
        });


        form.on('select(selectLinkTable)', function(obj){
            findLinkFieldList(obj.value);
            form.render('select');
            return false;
        });

        form.on('checkbox(checkField)', function(obj){
            var obj_id = obj.elem.id;
            var id = obj_id.substring(obj_id.indexOf('_')+1);
            if($("#"+obj_id).prop("checked")){//选中
                $("#"+id).val('Y');
            }else{
                $("#"+id).val('N');
            }
            form.render();
            return false;
        });

    });


    var excludeField  = '${pd.excludeField}';
    function findLinkFieldList(table_id){
        $.ajax({
            type: "GET",//方法类型
            dataType: "json",//预期服务器返回的数据类型
            url: "${pageContext.request.contextPath}/system/gencode/findFieldLinkList?table_id="+table_id ,//url
            data: "",
            success: function (res) {
                if (res.success) {
                    var select_tt = '<option value="">请选择</option>';
                    var tt = '';
                    var index = 0;
                    $.each(res.data,function(i,n){
                        select_tt += '<option value="'+ n.field_name+'">'+ n.field_comment+'【'+ n.field_name+'】</option>';
                        if(excludeField.indexOf(n.field_name)==-1){
                            index++;
                            tt += '<tr>';
                            tt += '<td>'+index+'</td>';
                            tt += '<td>'+ n.field_name;
                            tt += '<input type="hidden" name="link_field_id" value="'+ n.id+'" class="layui-input"></td>';
                            tt += '<td><input type="text" name="link_field_comment" value="'+ n.field_comment+'" lay-verify="field_len50" placeholder="字段描述" class="layui-input"></td>';
                            tt += '<td>'+ n.field_type;
                            tt += '</td>';
                            if(n.field_operat=='Y'){
                                tt += '<td><input type="hidden" name="link_field_operat" id="link_field_operat_${var.id}" value="${var.field_operat}" class="layui-input"><input type="checkbox" checked id="show_link_field_operat_'+ n.id+'" lay-filter="checkField" lay-skin="primary" title=""></td>';
                            }else{
                                tt += '<td><input type="hidden" name="link_field_operat" id="link_field_operat_${var.id}" value="${var.field_operat}" class="layui-input"><input type="checkbox" id="show_link_field_operat_'+ n.id+'" lay-filter="checkField" lay-skin="primary" title=""></td>';
                            }
                            tt += '<td><select name="link_verify_rule" style="width:70px" class="layui-input layui-unselect">';
                            tt += '<option value="">请选择</option>';
                            if(n.verify_rule.indexOf(',')!=-1) {
                                tt += '<option value="'+ n.verify_rule+'" selected>'+ n.verify_rule+'</option>';
                            }
                            if(n.verify_rule=='required') {
                                tt += '<option value="required" selected>必输</option>';
                            }else{
                                tt += '<option value="required">必输</option>';
                            }
                            if(n.verify_rule=='phone') {
                                tt += '<option value="phone" selected>电话</option>';
                            }else{
                                tt += '<option value="phone">电话</option>';
                            }
                            if(n.verify_rule=='email') {
                                tt += '<option value="email" selected>邮箱</option>';
                            }else{
                                tt += '<option value="email">邮箱</option>';
                            }
                            if(n.verify_rule=='url') {
                                tt += '<option value="url" selected>链接</option>';
                            }else{
                                tt += '<option value="url">链接</option>';
                            }
                            if(n.verify_rule=='number') {
                                tt += '<option value="number" selected>数字</option>';
                            }else{
                                tt += '<option value="number">数字</option>';
                            }
                            if(n.verify_rule=='date') {
                                tt += '<option value="date" selected>日期</option>';
                            }else{
                                tt += '<option value="date">日期</option>';
                            }
                            if(n.verify_rule=='identity') {
                                tt += '<option value="identity" selected>身份证号</option>';
                            }else{
                                tt += '<option value="identity">身份证号</option>';
                            }
                            if(n.verify_rule=='longitude') {
                                tt += '<option value="longitude" selected>经度</option>';
                            }else{
                                tt += '<option value="longitude">经度</option>';
                            }
                            if(n.verify_rule=='latitude') {
                                tt += '<option value="latitude" selected>纬度</option>';
                            }else{
                                tt += '<option value="latitude">纬度</option>';
                            }
                            if(n.verify_rule=='float') {
                                tt += '<option value="float" selected>浮点型</option>';
                            }else{
                                tt += '<option value="float">浮点型</option>';
                            }
                            if(n.verify_rule=='floats') {
                                tt += '<option value="floats" selected>可为空浮点型</option>';
                            }else{
                                tt += '<option value="floats">可为空浮点型</option>';
                            }
                            if(n.verify_rule=='field_len10') {
                                tt += '<option value="field_len10" selected>最大长度10字符</option>';
                            }else{
                                tt += '<option value="field_len10">最大长度10字符</option>';
                            }
                            if(n.verify_rule=='field_len25') {
                                tt += '<option value="field_len25" selected>最大长度25字符</option>';
                            }else{
                                tt += '<option value="field_len25">最大长度25字符</option>';
                            }
                            if(n.verify_rule=='field_len50') {
                                tt += '<option value="field_len50" selected>最大长度50字符</option>';
                            }else{
                                tt += '<option value="field_len50">最大长度50字符</option>';
                            }
                            if(n.verify_rule=='field_len100') {
                                tt += '<option value="field_len100" selected>最大长度100字符</option>';
                            }else{
                                tt += '<option value="field_len100">最大长度100字符</option>';
                            }
                            if(n.verify_rule=='field_len200') {
                                tt += '<option value="field_len200" selected>最大长度200字符</option>';
                            }else{
                                tt += '<option value="field_len200">最大长度200字符</option>';
                            }
                            if(n.verify_rule=='field_len500') {
                                tt += '<option value="field_len500" selected>最大长度500字符</option>';
                            }else{
                                tt += '<option value="field_len500">最大长度500字符</option>';
                            }
                            if(n.verify_rule=='field_len500') {
                                tt += '<option value="field_len1200" selected>最大长度1200字符</option>';
                            }else{
                                tt += '<option value="field_len1200">最大长度1200字符</option>';
                            }
                            if(n.verify_rule=='field_len500') {
                                tt += '<option value="field_len5000" selected>最大长度5000字符</option>';
                            }else{
                                tt += '<option value="field_len5000">最大长度5000字符</option>';
                            }
                            tt += '</select></td>';
                            tt += '<td><select name="link_show_type" id="showType_'+ n.id+'" lay-verify="" lay-filter="selectShowType" style="width: 200px;" lay-search="">';
                            if(n.show_type=='1') {
                                tt += '<option value="1" selected>文本框</option>';
                            }else{
                                tt += '<option value="1">文本框</option>';
                            }
                            if(n.show_type=='2') {
                                tt += '<option value="2" selected>文本域</option>';
                            }else{
                                tt += '<option value="2">文本域</option>';
                            }
                            if(n.show_type=='3') {
                                tt += '<option value="3" selected>下拉框</option>';
                            }else{
                                tt += '<option value="3">下拉框</option>';
                            }
                            if(n.show_type=='4') {
                                tt += '<option value="4" selected>单选框</option>';
                            }else{
                                tt += '<option value="4">单选框</option>';
                            }
                            if(n.show_type=='5') {
                                tt += '<option value="5" selected>复选框</option>';
                            }else{
                                tt += '<option value="5">复选框</option>';
                            }
//                            if(n.show_type=='6') {
//                                tt += '<option value="6" selected>富文本</option>';
//                            }else{
//                                tt += '<option value="6">富文本</option>';
//                            }
                            if(n.show_type=='7') {
                                tt += '<option value="7" selected>日期控件</option>';
                            }else{
                                tt += '<option value="7">日期控件</option>';
                            }
                            if(n.show_type=='8') {
                                tt += '<option value="8" selected>上传控件</option>';
                            }else{
                                tt += '<option value="8">上传控件</option>';
                            }
//                            if(n.show_type=='9') {
//                                tt += '<option value="9" selected>单选人</option>';
//                            }else{
//                                tt += '<option value="9">单选人</option>';
//                            }
//                            if(n.show_type=='10') {
//                                tt += '<option value="10" selected>单选组织</option>';
//                            }else{
//                                tt += '<option value="10">单选组织</option>';
//                            }
//                            if(n.show_type=='11') {
//                                tt += '<option value="11" selected>多选人</option>';
//                            }else{
//                                tt += '<option value="11">多选人</option>';
//                            }
//                            if(n.show_type=='12') {
//                                tt += '<option value="12" selected>多选组织</option>';
//                            }else{
//                                tt += '<option value="12">多选组织</option>';
//                            }
                            if(n.show_type=='0') {
                                tt += '<option value="0" selected>隐藏字段</option>';
                            }else{
                                tt += '<option value="0">隐藏字段</option>';
                            }
                            tt += '</select></td>';
                            tt += '<td>';
                            if(n.show_type=='3'||n.show_type=='4'||n.show_type=='5'){
                                tt += '<div id="optionContent_'+ n.id+'">';
                                tt += '<input type="text" name="link_option_content" value="" lay-verify="field_len50" placeholder="选项内容" class="layui-input">';
                                tt += '</div>';
                            }else{
                                tt += '<div id="optionContent_'+ n.id+'" style="display: none">';
                                tt += '<input type="text" name="link_option_content" value="" lay-verify="field_len50" placeholder="选项内容" class="layui-input">';
                                tt += '</div>';
                            }
                            tt += '</td>';
                            tt += '<td><input type="text" name="link_default_value" value="" lay-verify="field_len50" placeholder="默认值" class="layui-input"></td>';
                            tt += '<td><input type="text" name="link_order_by" value="'+ n.order_by+'" lay-verify="field_len50" placeholder="排序" class="layui-input"></td>';
                            tt += '<td><button type="button" class="layui-btn layui-btn-normal layui-btn-xs" onclick="editField(\''+ n.id+'\',1);"><i class="layui-icon"></i></button></td>';
                            tt += '</tr>';
                        }

                    });
                    $("#link_field").html(select_tt);
//                    console.log(tt);
                    $("#link_tbody tr:last").before(tt);
                    form.render();
                }else{
                    $("#submit_button").attr('disabled',false);
                    if(res.loseSession=='loseSession'){
                        loseSession(res.msg,res.url)
                    }else{
                        layer.msg(res.msg, {time: 2000});
                    }
                }
            }
        });
    }



    function editField(id,type){
        parent.layer.open({
            //skin: 'layui-layer-molv',
            title: '编辑',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/system/gencode/toUpdateField?id='+id+'&type='+type,
            area: ['800px', '500px'],
            end: function () {
                var val = getOpenCloseParam();
                if(val=="reload"){
                    location.reload();
                }
            }
        });
    }











</script>

<%@include file="../admin/bottom.jsp"%>