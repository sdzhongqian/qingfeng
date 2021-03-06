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
            <td colspan="3"><input type="text" name="title" id="title" value="${p.title}" lay-verify="required" autocomplete="off" placeholder="标题" class="layui-input"></td>
        </tr>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">内容：
                </label>
            </td>
            <td colspan="3">
                <div style="margin-top:5px;">
                    <input type="hidden" name="content" id="fileIds_content" value="${p.content}" class="layui-input">
                    <button type="button" class="layui-btn layui-btn-xs" id="upload_file_content">选择附件</button>
                    <table class="layui-table">
                        <thead>
                        <tr>
                            <th>附件名称</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody id="tbody_file_content">
                        <c:forEach items="${contentFileList}" var="v" varStatus="vs">
                            <tr id="tr_ls${v.id}">
                                <td>${v.name}</td>
                                <td>
                                    <div class="layui-btn-group">
                                        <button type="button" onclick="downloadFile('${v.id}','${v.file_path}','${v.name}');" class="layui-btn layui-btn-xs">下载</button>
                                        <button type="button" onclick="delMoreFile('ls${v.id}','${v.id}','${v.file_path}');" class="layui-btn layui-btn-xs layui-btn-danger">删除</button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">排序：
                </label>
            </td>
            <td colspan="3"><input type="text" name="order_by" id="order_by" value="${p.order_by}" lay-verify="number" autocomplete="off" placeholder="排序" class="layui-input"></td>
        </tr>
        <tr>
            <td width="15%" align="right">
                <label class="layui-form-label">备注：
                </label>
            </td>
            <td colspan="3"><input type="text" name="remark" id="remark" value="${p.remark}" lay-verify="" autocomplete="off" placeholder="备注" class="layui-input"></td>
        </tr>

        <tr>
            <td colspan="4">
                <table class="layui-table" style="width:95%;margin:10px auto;">
                    <thead>
                        <th>名称<span style="color: red">*</span></th>
                        <th>简介</th>
                        <th>排序</th>
                        <th>备注</th>
                    <th>操作</th>
                    </thead>
                    <tbody id="child_table">
                    <c:if test="${fn:length(list)>0}">
                        <c:forEach items="${list}" var="var" varStatus="status">
                            <tr id="child_tr_ls${var.id}">
                                            <td><input type="text" name="child_name" id="name_1" value="${var.name}" lay-verify="required" autocomplete="off" placeholder="名称" class="layui-input"></td>
                                            <td>
                                                <div id="div-${var.id}-content">
                                                            <input type="checkbox" lay-filter='checkField' <c:if test="${var.content.indexOf('0')!=-1}"> checked </c:if> name="div-${var.id}-content" value="0" lay-skin="primary" title="北京" lay-verify="">
                                                            <input type="checkbox" lay-filter='checkField' <c:if test="${var.content.indexOf('1')!=-1}"> checked </c:if> name="div-${var.id}-content" value="1" lay-skin="primary" title="上海" lay-verify="">
                                                            <input type="checkbox" lay-filter='checkField' <c:if test="${var.content.indexOf('2')!=-1}"> checked </c:if> name="div-${var.id}-content" value="2" lay-skin="primary" title="深圳" lay-verify="">
                                                </div>
                                                <input type="hidden" name="child_content" id="content_${var.id}" value="${var.content}" />
                                            </td>
                                            <td><input type="text" name="child_order_by" id="order_by_1" value="${var.order_by}" lay-verify="" autocomplete="off" placeholder="排序" class="layui-input"></td>
                                            <td>
                                                <div style="margin-top:5px;">
                                                    <input type="hidden" name="child_remark" id="fileIds_remark_${var.id}" value="${var.remark}" class="layui-input">
                                                    <button type="button" class="layui-btn layui-btn-xs" id="upload_file_remark_${var.id}">选择附件</button>
                                                    <table class="layui-table">
                                                        <thead>
                                                        <tr>
                                                            <th>附件名称</th>
                                                            <th>操作</th>
                                                        </tr>
                                                        </thead>
                                                        <tbody id="tbody_file_remark_${var.id}">
                                                        <c:forEach items="${var.remarkFileList}" var="v" varStatus="vs">
                                                            <tr id="tr_ls${v.id}">
                                                                <td>${v.name}</td>
                                                                <td>
                                                                    <div class="layui-btn-group">
                                                                        <button type="button" onclick="downloadFile('${v.id}','${v.file_path}','${v.name}');" class="layui-btn layui-btn-xs">下载</button>
                                                                        <button type="button" onclick="delMoreFile('ls${v.id}','${v.id}','${v.file_path}');" class="layui-btn layui-btn-xs layui-btn-danger">删除</button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                <td style="width:60px;">
                                    <div class="layui-btn-group">
                                        <input type="hidden" name="c_ids" value="${var.id}">
                                        <button type="button" onclick="addLine();" class="layui-btn layui-btn-xs"><i class="layui-icon"></i></button>
                                        <c:if test="${status.index!=0}">
                                            <button type="button" onclick="delLine('ls${var.id}');" class="layui-btn layui-btn-xs layui-btn-danger"><i class="layui-icon"></i></button>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>
                    <c:if test="${fn:length(list)==0}">
                        <tr>
                                        <td><input type="text" name="child_name" id="name_1" value="子内容" lay-verify="required" autocomplete="off" placeholder="名称" class="layui-input"></td>
                                        <td>
                                            <div id="div-1-content">
                                                            <input type="checkbox" lay-filter='checkField' checked name="div-1-content" value="0" lay-skin="primary" title="北京" lay-verify="">
                                                            <input type="checkbox" lay-filter='checkField' name="div-1-content" value="1" lay-skin="primary" title="上海" lay-verify="">
                                                            <input type="checkbox" lay-filter='checkField' name="div-1-content" value="2" lay-skin="primary" title="深圳" lay-verify="">
                                            </div>
                                            <input type="hidden" name="child_content" id="content_1" value="0" />
                                        </td>
                                        <td><input type="text" name="child_order_by" id="order_by_1" value="" lay-verify="" autocomplete="off" placeholder="排序" class="layui-input"></td>
                                        <td>
                                            <div style="margin-top:5px;">
                                                <input type="hidden" name="child_remark" id="fileIds_remark_1" value="" class="layui-input">
                                                <button type="button" class="layui-btn layui-btn-xs" id="upload_file_remark_1">选择附件</button>
                                                <table class="layui-table">
                                                    <thead>
                                                    <tr>
                                                        <th>附件名称</th>
                                                        <th>操作</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody id="tbody_file_remark_1">
                                                    </tbody>
                                                </table>
                                            </div>
                                        </td>
                            <td style="width:60px;">
                                <div class="layui-btn-group">
                                    <input type="hidden" name="c_ids" value="">
                                    <button type="button" onclick="addLine();" class="layui-btn layui-btn-xs"><i class="layui-icon"></i></button>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                    <tr></tr>
                    </tbody>
                </table>
            </td>
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
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/uploadFile.js"></script>
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
        uploadMoreFile('content','content');
                uploadMoreFile('remark_1','remark');
$.each(${listJson},function(i,n){
                    uploadMoreFile('remark_'+ n.id,'remark');
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
                url: "${pageContext.request.contextPath}/gencode/mantable/update" ,//url
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
                    tt += '<td><input type="text" name="child_name" id="name_'+index+'" value="子内容" lay-verify="required" autocomplete="off" placeholder="名称" class="layui-input"></td>';
                    tt += '<td>';
                    tt += '<div id="div-'+index+'-content">';
                                tt += '<input type="checkbox" checked name="div-'+index+'-content" value="0" lay-skin="primary" title="北京" lay-verify="">';
                                tt += '<input type="checkbox" name="div-'+index+'-content" value="1" lay-skin="primary" title="上海" lay-verify="">';
                                tt += '<input type="checkbox" name="div-'+index+'-content" value="2" lay-skin="primary" title="深圳" lay-verify="">';
                    tt += '</div>';
                    tt += '<input type="hidden" name="child_content" id="content_'+index+'" value="0" />';
                    tt += '</td>';
                    tt += '<td><input type="text" name="child_order_by" id="order_by_'+index+'" value="" lay-verify="" autocomplete="off" placeholder="排序" class="layui-input"></td>';
                    tt += '<td>';
                    tt += '<div style="margin-top:5px;">';
                    tt += '<input type="hidden" name="child_remark" id="fileIds_remark_'+index+'" value="" class="layui-input">';
                    tt += '<button type="button" class="layui-btn layui-btn-xs" id="upload_file_remark_'+index+'">选择附件</button>';
                    tt += '<table class="layui-table">';
                    tt += '<thead>';
                    tt += '<tr><th>附件名称</th><th>操作</th></tr>';
                    tt += '</thead>';
                    tt += '<tbody id="tbody_file_remark_'+index+'">';
                    tt += '</tbody>';
                    tt += '</table>';
                    tt += '</div>';
                    tt += '</td>';
        tt += '<td style="width: 78px;"><input type="hidden" name="c_ids" value=""><div class="layui-btn-group"><button type="button" onclick="addLine();" class="layui-btn layui-btn-xs"><i class="layui-icon"></i></button><button type="button" onclick="delLine(\''+index+'\');" class="layui-btn layui-btn-xs layui-btn-danger"><i class="layui-icon"></i></button></div></td>';
        tt += '</tr>';
        $("#child_table tr:last").before(tt);

        //初始化
                    uploadMoreFile('remark_'+index,'remark');
        form.render();
    }


    function delLine(index){
        if(index.indexOf('ls')!=-1){
            var id = index.substring(2);
            //删库
        $.ajax({
                type: "GET",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/gencode/mantable/delChild?ids="+id,//url
                data: "",
                success: function (res) {
                    if (res.success) {
                        $("#child_tr_"+index).remove();
                        layer.msg("数据删除成功。", {time: 2000});
                    }else{
                        if(res.loseSession=='loseSession'){
                            loseSession(res.msg,res.url)
                        }else{
                            layer.msg(res.msg, {time: 2000});
                        }
                    }

                },
                error : function() {
                    layer.msg("数据删除失败。", {time: 2000});
                }
            });
        }else{
            $("#child_tr_"+index).remove();
        }
    }


</script>

<%@include file="../../system/admin/bottom.jsp"%>