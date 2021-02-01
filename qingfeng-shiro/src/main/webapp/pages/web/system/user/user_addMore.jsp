<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>

<form class="layui-form" action="" id="form">
    <div style="height: 32px;line-height: 32px;">
        <span class="layui-badge layui-bg-green" style="margin: 4px 10px;padding: 5px 10px">所属组织：${pd.organize_name}</span>
        <span style="padding-left: 5px;line-height: 32px;color: red">批量添加用户的初始密码为：123456</span>
    </div>
    <table class="layui-table">
        <thead>
        <tr>
            <th>登录名称<span style="color: red">*</span></th>
            <th>姓名<span style="color: red">*</span></th>
            <th>性别</th>
            <th>手机号</th>
            <th>电子邮箱</th>
            <%--<th>出生日期<span style="color: red">*</span></th>--%>
            <%--<th>居住地<span style="color: red">*</span></th>--%>
            <%--<th>籍贯地址<span style="color: red">*</span></th>--%>
            <%--<th>座右铭<span style="color: red">*</span></th>--%>
            <th>排序</th>
            <th>备注</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody id="table">
        <tr>
            <td><input type="text" name="login_name" lay-verify="required|field_len50" autocomplete="off" placeholder="请输入登录名称" class="layui-input"></td>
            <td><input type="text" name="name" lay-verify="required|field_len50" autocomplete="off" placeholder="请输入姓名" class="layui-input"></td>
            <td>
                <select name="sex" id="sex" placeholder="请选择性别">
                    <option value="1">男</option>
                    <option value="2">女</option>
                </select>
            </td>
            <td><input type="text" name="phone" lay-verify="phone" autocomplete="off" placeholder="请输入手机号" class="layui-input"></td>
            <td><input type="text" name="email" lay-verify="email" autocomplete="off" placeholder="请输入电子邮箱" class="layui-input"></td>
            <%--<td><input type="text" name="birth_date" lay-verify="required|field_len50" autocomplete="off" placeholder="请输入出生日期" class="layui-input"></td>--%>
            <%--<td><input type="text" name="live_address" lay-verify="required|field_len50" autocomplete="off" placeholder="请输入居住地" class="layui-input"></td>--%>
            <%--<td><input type="text" name="birth_address" lay-verify="required|field_len50" autocomplete="off" placeholder="请输入籍贯地址" class="layui-input"></td>--%>
            <%--<td><input type="text" name="motto" lay-verify="required|field_len50" autocomplete="off" placeholder="请输入座右铭" class="layui-input"></td>--%>
            <td><input type="text" name="order_by" lay-verify="field_len50|intNumber" autocomplete="off" placeholder="请输入排序" class="layui-input"></td>
            <td><textarea name="remark" placeholder="请输入备注" class="layui-textarea" style="min-height: 40px;"></textarea></td>
            <td style="width: 78px;"><div class="layui-btn-group"><button onclick="addLine();" type="button" class="layui-btn layui-btn-xs"><i class="layui-icon"></i></button></div></td>
        </tr>
        </tbody>
        <tr>
            <td style="text-align: center; padding-top: 10px;" colspan="12">
                <div class="layui-form-item">
                    <input type="hidden" name="login_password" value="123456">
                    <input type="hidden" name="organize_id" value="${pd.organize_id}">
                    <input type="hidden" name="organize_name" value="${pd.organize_name}">
                    <button type="button" class="layui-btn layui-btn-sm" id="submit_button" lay-submit="" lay-filter="submit_form">保存</button>
                    <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" id="cancel">取消</button>
                </div>
            </td>
        </tr>
    </table>
</table>
</form>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/layui/layui.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfPassValue.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfAjaxReq.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfverify.js"></script>
<script>
    var form,layer, $,laydate;
    layui.use(['form','laydate'], function(){
        form = layui.form;
        layer = layui.layer;
        $ = layui.$;
        laydate = layui.laydate;

        //初始化日期
//        initDateType("rq",true);
        //初始化时间
//        initTimeType("sj",true);

        $('#cancel').on('click',function (){
            var index = parent.layer.getFrameIndex(window.name);
            parent.layer.close(index);
        })

        //自定义验证规则
        form.verify(form_verify);
        //监听提交
        form.on('submit(submit_form)', function(data){
            layer.msg('正在保存数据。');
            $("#submit_button").attr('disabled',true);
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/system/user/saveMore" ,//url
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
        tt += '<td><input type="text" name="login_name" lay-verify="required|field_len50" autocomplete="off" placeholder="请输入登录名称" class="layui-input"></td>';
        tt += '<td><input type="text" name="name" lay-verify="required|field_len50" autocomplete="off" placeholder="请输入姓名" class="layui-input"></td>';
        tt += '<td><select name="sex" id="sex" placeholder="请选择性别">' +
                '<option value="1">男</option>' +
                '<option value="2">女</option>' +
                '</select></td>';
        tt += '<td><input type="text" name="phone" lay-verify="phone" autocomplete="off" placeholder="请输入手机号" class="layui-input"></td>';
        tt += '<td><input type="text" name="email" lay-verify="email" autocomplete="off" placeholder="请输入电子邮箱" class="layui-input"></td>';
//        tt += '<td><input type="text" name="birth_date" lay-verify="required|field_len50" autocomplete="off" placeholder="请输入出生日期" class="layui-input"></td>';
//        tt += '<td><input type="text" name="live_address" lay-verify="required|field_len50" autocomplete="off" placeholder="请输入居住地" class="layui-input"></td>';
//        tt += '<td><input type="text" name="birth_address" lay-verify="required|field_len50" autocomplete="off" placeholder="请输入籍贯地址" class="layui-input"></td>';
//        tt += '<td><input type="text" name="motto" lay-verify="required|field_len50" autocomplete="off" placeholder="请输入座右铭" class="layui-input"></td>';
        tt += '<td><input type="text" name="order_by" lay-verify="field_len50|intNumber" autocomplete="off" placeholder="请输入排序" class="layui-input"></td>';
        tt += '<td><textarea name="remark" placeholder="请输入备注" class="layui-textarea" style="min-height: 40px;"></textarea></td>';
        tt += '<td style="width: 78px;"><div class="layui-btn-group"><button type="button" onclick="addLine();" class="layui-btn layui-btn-xs"><i class="layui-icon"></i></button><button type="button" onclick="delLine(\''+index+'\');" class="layui-btn layui-btn-xs layui-btn-danger"><i class="layui-icon"></i></button></div></td>';
        tt += '</tr>';
        $("#table tr:last").after(tt);
        form.render();
    }

    function delLine(index){
        $("#tr_"+index).remove();
    }

</script>

<%@include file="../../system/admin/bottom.jsp"%>