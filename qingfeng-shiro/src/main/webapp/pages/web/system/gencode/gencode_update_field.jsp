<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>
<style>
    .lay-ext-mulitsel .tips {
         top: 0px;
    }
</style>
<form class="layui-form" action="" id="form">
    <table width="95%" style="margin: 0 auto">
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">字段名称：<span style="color: red">*</span></label></td>
            <td><input type="text" value="${p.field_name}" readonly lay-verify="required|field_len50" autocomplete="off" placeholder="字段名称" class="layui-input"></td>
            <td width="15%" align="right"><label class="layui-form-label">字段描述：<span style="color: red">*</span></label></td>
            <td><input type="text" name="field_comment" id="field_comment" value="${p.field_comment}" lay-verify="field_len50" autocomplete="off" placeholder="字段描述" class="layui-input"></td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">字段类型：<span style="color: red">*</span></label></td>
            <td><input type="text" value="${p.field_type}" readonly lay-verify="required|field_len50" autocomplete="off" placeholder="字段类型" class="layui-input"></td>
            <td width="15%" align="right"><label class="layui-form-label">添加编辑：</label></td>
            <td>
                <input type="hidden" name="field_operat" id="field_operat_${p.id}" value="${p.field_operat}" class="layui-input">
                <input type="checkbox" lay-skin="primary" id="show_field_operat_${p.id}" lay-filter='checkField' <c:if test="${p.field_operat=='Y'}">checked</c:if> title="">
            </td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">列表展示：</label></td>
            <td>
                <input type="hidden" name="field_list" id="field_list_${p.id}" value="${p.field_list}" class="layui-input">
                <input type="checkbox"  id="show_field_list_${p.id}" lay-filter='checkField' lay-skin="primary" <c:if test="${p.field_list=='Y'}">checked</c:if> title="">
            </td>
            <td width="15%" align="right"><label class="layui-form-label">查询展示：</label></td>
            <td>
                <input type="hidden" name="field_query" id="field_query_${p.id}" value="${p.field_query}" class="layui-input">
                <input type="checkbox"  id="show_field_query_${p.id}" lay-filter='checkField' lay-skin="primary" <c:if test="${p.field_query=='Y'}">checked</c:if> title="">
            </td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">查询方式：</label></td>
            <td>
                <select name="query_type" id="query_type" lay-verify="" lay-filter='' style="width: 200px;" lay-search="">
                    <option value="=" <c:if test="${p.query_type=='='}">selected</c:if>>=</option>
                    <option value="!=" <c:if test="${p.query_type=='!='}">selected</c:if>>!=</option>
                    <option value=">" <c:if test="${p.query_type=='>'}">selected</c:if>>></option>
                    <option value=">=" <c:if test="${p.query_type=='>='}">selected</c:if>>>=</option>
                    <option value="<" <c:if test="${p.query_type=='<'}">selected</c:if>><</option>
                    <option value="<=" <c:if test="${p.query_type=='<='}">selected</c:if>><=</option>
                    <option value="like" <c:if test="${p.query_type=='like'}">selected</c:if>>like</option>
                    <option value="is null" <c:if test="${p.query_type=='is null'}">selected</c:if>>is null</option>
                    <option value="is not null" <c:if test="${p.query_type=='is not null'}">selected</c:if>>is not null</option>
                    <option value="time_period" <c:if test="${p.query_type=='time_period'}">selected</c:if>>时间区间</option>
                </select>
            </td>
            <td width="15%" align="right"><label class="layui-form-label">校验规则：</label></td>
            <td>
                <input type="hidden" name="verify_rule" id="verify_rule" value="${p.verify_rule}" class="layui-input">
                <div id="select_verify_rule" style=""></div>
            </td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">显示类型：</label></td>
            <td>
                <select name="show_type" id="showType_${p.id}" lay-verify="" lay-filter='selectShowType' style="width: 200px;" lay-search="">
                    <option value="1" <c:if test="${p.show_type=='1'}">selected</c:if>>文本框</option>
                    <option value="2" <c:if test="${p.show_type=='2'}">selected</c:if>>文本域</option>
                    <option value="3" <c:if test="${p.show_type=='3'}">selected</c:if>>下拉框</option>
                    <option value="4" <c:if test="${p.show_type=='4'}">selected</c:if>>单选框</option>
                    <option value="5" <c:if test="${p.show_type=='5'}">selected</c:if>>复选框</option>
                    <option value="6" <c:if test="${p.show_type=='6'}">selected</c:if>>富文本</option>
                    <option value="7" <c:if test="${p.show_type=='7'}">selected</c:if>>日期控件</option>
                    <option value="8" <c:if test="${p.show_type=='8'}">selected</c:if>>上传控件</option>
                    <option value="9" <c:if test="${p.show_type=='9'}">selected</c:if>>单选人</option>
                    <option value="10" <c:if test="${p.show_type=='10'}">selected</c:if>>单选组织</option>
                    <option value="11" <c:if test="${p.show_type=='11'}">selected</c:if>>多选人</option>
                    <option value="12" <c:if test="${p.show_type=='12'}">selected</c:if>>多选组织</option>
                    <option value="0" <c:if test="${p.show_type=='0'}">selected</c:if>>隐藏字段</option>
                </select>
            </td>
            <td width="15%" align="right"><label class="layui-form-label">选项内容：</label></td>
            <td>
                <div id="optionContent_${p.id}" <c:if test="${p.show_type!='3'&&p.show_type!='4'&&p.show_type!='5'}">style="display: none"</c:if>>
                    <input type="text" name="option_content" value="${p.option_content}" lay-verify="field_len50" placeholder="选项内容" class="layui-input">
                </div>
            </td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">默认值：</label></td>
            <td>
                <input type="text" name="default_value" value="${p.default_value}" lay-verify="field_len50" placeholder="默认值" class="layui-input">
            </td>
            <td width="15%" align="right"><label class="layui-form-label">排序：</label></td>
            <td>
                <input type="text" name="order_by" value="${p.order_by}" lay-verify="field_len50" placeholder="排序" class="layui-input">
            </td>
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

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/xadmin/lib/layui/layui.js" charset="utf-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfverify.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfAjaxReq.js"></script>
<!-- 注意：如果你直接复制所有代码到本地，上述js路径需要改成你本地的 -->
<script>
    var tagData = [{"id":"required","name":"必输"},{"id":"phone","name":"电话"},{"id":"email","name":"邮箱"},{"id":"url","name":"链接"},{"id":"number","name":"数字"},{"id":"intNumber","name":"整型数字"},{"id":"date","name":"日期"},{"id":"identity","name":"身份证号"},
        {"id":"longitude","name":"经度"},{"id":"latitude","name":"纬度"},{"id":"float","name":"浮点型"},{"id":"floats","name":"可为空浮点型"},
        {"id":"field_len10","name":"最大长度10字符"},{"id":"field_len25","name":"最大长度25字符"},{"id":"field_len50","name":"最大长度50字符"},{"id":"field_len100","name":"最大长度100字符"},
        {"id":"field_len200","name":"最大长度200字符"},{"id":"field_len500","name":"最大长度500字符"},{"id":"field_len1200","name":"最大长度1200字符"},{"id":"field_len5000","name":"最大长度5000字符"}];

    var form,layer,layedit,laydate,selectM;
    layui.config({
        base : '${pageContext.request.contextPath}'
    }).extend({
        selectM: '/resources/plugins/layui_extends/selectM',
    }).use(['form', 'layedit', 'laydate','selectM'],function(){
        form = layui.form;
        layer = layui.layer;
        layedit = layui.layedit;
        laydate = layui.laydate;
        selectM = layui.selectM;

        $('#cancel').on('click',function (){
            var index = parent.layer.getFrameIndex(window.name);
            parent.layer.close(index);
        })

        //多选标签-基本配置
        var fn = '${p.verify_rule}';
        var fns = selectM({
            //元素容器【必填】
            elem: '#select_verify_rule'
            //候选数据【必填】
            ,data: tagData
            ,selected: fn.split(',')
            ,max:3
            ,width:'95%'
            //添加验证
            ,verify:'required'
        });


        //自定义验证规则
        form.verify(form_verify);

        //监听提交
        form.on('submit(submit_form)', function(data){
            layer.msg('正在提交数据。');
            $("#verify_rule").val(fns.values);
            $("#submit_button").attr('disabled',true);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/system/gencode/updateField" ,//url
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

</script>

<%@include file="../admin/bottom.jsp"%>