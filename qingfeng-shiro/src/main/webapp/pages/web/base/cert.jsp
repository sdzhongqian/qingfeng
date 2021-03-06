<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../system/admin/top.jsp"%>

<form class="layui-form" action="" id="form">
    <table width="95%" style="margin: 0 auto">
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">姓名：<span style="color: red">*</span></label></td>
            <td colspan="3"><input type="text" name="name" id="name" value="${pd.name}" lay-verify="required|field_len50" autocomplete="off" placeholder="姓名" class="layui-input"></td>
            <td width="15%" align="right"><label class="layui-form-label">证书编号：<span style="color: red">*</span></label></td>
            <td colspan="3"><input type="text" name="code" id="code" value="${pd.code}" lay-verify="required|field_len50" autocomplete="off" placeholder="证书编号" class="layui-input"></td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">开始日期：<span style="color: red">*</span></label></td>
            <td colspan="3"><input type="text" name="start_date" id="start_date" value="${pd.start_date}" lay-verify="required|field_len50" autocomplete="off" placeholder="开始日期" class="layui-input"></td>
            <td width="15%" align="right"><label class="layui-form-label">结束日期：<span style="color: red">*</span></label></td>
            <td colspan="3"><input type="text" name="end_date" id="end_date" value="${pd.end_date}" lay-verify="required|field_len50" autocomplete="off" placeholder="结束日期" class="layui-input"></td>
        </tr>
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">课程名称：<span style="color: red">*</span></label></td>
            <td colspan="3"><input type="text" name="kc_name" id="kc_name" value="${pd.kc_name}" lay-verify="required|field_len50" autocomplete="off" placeholder="课程名称" class="layui-input"></td>
            <td width="15%" align="right"><label class="layui-form-label">课时：<span style="color: red">*</span></label></td>
            <td colspan="3"><input type="text" name="class_time" id="class_time" value="${pd.class_time}" lay-verify="required|field_len50" autocomplete="off" placeholder="课时" class="layui-input"></td>
        </tr>
        <tr>
            <td style="text-align: center; padding-top: 10px;" colspan="8">
                <div class="layui-form-item">
                    <button type="button" class="layui-btn layui-btn-sm" id="submit_button" lay-submit="" lay-filter="submit_form">生成证书</button>
                </div>
            </td>
        </tr>
    </table>
    <div id="showCert" align="center">

    </div>
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

        //自定义验证规则
        form.verify(form_verify);

        //监听提交
        form.on('submit(submit_form)', function(data){
            layer.msg('正在生成证书。');
            $.ajax({
                type: "GET",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/common/test/createCert",//url
                data: $('#form').serialize(),
                success: function (res) {
                    console.log(res.data)
                    if (res.success) {
                        var tt = '<img width="80%" src="'+res.data.show_cert_path+'">';
                        $("#showCert").html(tt);
                    }else{
                        if(res.loseSession=='loseSession'){
                            loseSession(res.msg,res.url)
                        }else{
                            layer.msg(res.msg, {time: 2000});
                        }
                    }
                }
            });
            return false;
        });
    });
</script>

<%@include file="../system/admin/bottom.jsp"%>