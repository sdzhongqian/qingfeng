<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>
<style>
    hr {
        margin: 0 0 10px 0;
    }
</style>
<form class="layui-form" action="" id="form">
    <div style="height: 32px;padding-left:10%;line-height: 32px;">
        <span style="padding-left: 5px;line-height: 32px;color: red">标注：批量添加用户的初始密码为：123456</span>
    </div>
    <hr class="layui-bg-green">
    <table width="95%" style="margin: 0 auto">
        <tr>
            <td width="15%" align="right"><label class="layui-form-label">登录账号：<span style="color: red">*</span></label></td>
            <td><input type="text" name="login_name" id="login_name"  lay-verify="required|field_len50|minLength" autocomplete="off" placeholder="登录账号" class="layui-input"></td>
            <td width="15%" align="right"><label class="layui-form-label">姓名：<span style="color: red">*</span></label></td>
            <td><input type="text" name="name" id="name"  lay-verify="required|field_len50" autocomplete="off" placeholder="姓名" class="layui-input"></td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">登录密码：<span style="color: red">*</span></label></td>
            <td><input type="password" name="login_password" id="password"  lay-verify="required|pass" autocomplete="off" placeholder="登录密码" class="layui-input"></td>
            <td align="right"><label class="layui-form-label">确认密码：<span style="color: red">*</span></label></td>
            <td><input type="password" name="confirm_password" id="confirm_password"  lay-verify="required|confirmPass|confirmPwd" autocomplete="off" placeholder="确认密码" class="layui-input"></td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">性别：</label></td>
            <td>
                <select name="sex" id="sex">
                    <option value="1">男</option>
                    <option value="2">女</option>
                </select>
            </td>
            <td align="right"><label class="layui-form-label">手机号：</label></td>
            <td><input type="text" name="phone" id="phone"  lay-verify="phone" autocomplete="off" placeholder="手机号" class="layui-input"></td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">邮箱：</label></td>
            <td><input type="text" name="email" id="email"  lay-verify="email" autocomplete="off" placeholder="邮箱" class="layui-input"></td>
            <td align="right"><label class="layui-form-label">出生日期：</label></td>
            <td><input type="text" name="birth_date" id="birth_date"  lay-verify="field_len50" autocomplete="off" placeholder="出生日期" class="layui-input"></td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">座右铭：</label></td>
            <td><input type="text" name="motto" id="motto"  lay-verify="field_len50" autocomplete="off" placeholder="座右铭" class="layui-input"></td>
            <td align="right"><label class="layui-form-label">排序号：</label></td>
            <td><input type="text" name="order_by" id="order_by"  lay-verify="field_len50|intNumber" autocomplete="off" placeholder="排序号" class="layui-input"></td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">居住地址：</label></td>
            <td><input type="text" name="live_address" id="live_address"  lay-verify="field_len120" autocomplete="off" placeholder="居住地址" class="layui-input"></td>
            <td align="right"><label class="layui-form-label">出生地址：</label></td>
            <td><input type="text" name="birth_address" id="birth_address"  lay-verify="field_len120" autocomplete="off" placeholder="出生地址" class="layui-input"></td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">头像地址：</label></td>
            <td colspan="3">
                <div class="layui-upload">
                    <button type="button" class="layui-btn layui-btn-xs" id="button_head_address">上传图片</button>
                    <div>
                        <img class="layui-upload-img" id="head_address_url" width="100px;">
                        <p id="demoText"></p>
                    </div>
                </div>
            </td>
        </tr>
        <tr id="button_tr">
            <td width="20%" align="right"><label class="layui-form-label">用户组织</label></td>
            <td colspan="3">
                <div style="width:98%; overflow:auto;">
                    <table class="layui-table" style="width:98%;">
                        <thead>
                        <tr>
                            <th style="width: 80px">类型</th>
                            <th>组织名称<span style="color: red">*</span></th>
                            <th>职务</th>
                            <th style="width: 50px">排序</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody id="table">
                        <tr>
                            <td><input type="hidden" name="type" lay-verify="field_len50" value="0" autocomplete="off" class="layui-input">主组织</td>
                            <td>
                                <div style="float: left">
                                    <input type="hidden" name="organize_id" id="organize_id_1" title="${pd.organize_name}" lay-verify="field_len50" value="${pd.organize_id}" autocomplete="off" class="layui-input">
                                    <input type="text" name="organize_name" id="organize_name_1" lay-verify="required|field_len50" value="${pd.organize_name}" autocomplete="off" placeholder="请输入组织名称" class="layui-input">
                                </div>
                                <div style="float: left">
                                    <button style="margin-top: 4px;margin-left: 10px;" type="button" onclick="selectOneOrganize('1')" class="layui-btn layui-btn-xs layui-btn-normal">选择</button>
                                </div>
                            </td>
                            <td><input type="text" name="position" lay-verify="field_len50" value="" autocomplete="off" placeholder="请输入职务" class="layui-input"></td>
                            <td><input type="text" name="child_order_by" lay-verify="field_len8" autocomplete="off" placeholder="请输入排序号" value="1" class="layui-input"></td>
                            <td style="width: 78px;"><div class="layui-btn-group"><button onclick="addLine();" type="button" class="layui-btn layui-btn-xs"><i class="layui-icon"></i></button></div></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td align="right"><label class="layui-form-label">备注：</label></td>
            <td colspan="3"><textarea name="remark" placeholder="请输入备注" class="layui-textarea"></textarea></td>
        </tr>
        <tr>
            <td style="text-align: center; padding-top: 10px;" colspan="4">
                <div class="layui-form-item">
                    <input type="hidden" name="head_address" id="head_address" value="" />
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
    var form,layer,layedit,laydate;
    layui.use(['form', 'layedit', 'laydate'], function(){
        form = layui.form;
        layer = layui.layer;
        layedit = layui.layedit;
        laydate = layui.laydate;

        $('#cancel').on('click',function (){
            var index = parent.layer.getFrameIndex(window.name);
            parent.layer.close(index);
        })

        //自定义验证规则
        form.verify(form_verify);

        //初始化出生日期
        initDateType("birth_date",false);

        //监听提交
        form.on('submit(submit_form)', function(data){
            layer.msg('正在提交数据。');
            $("#submit_button").attr('disabled',true);
            //判断组织是否选择重复
            var organize_ids = [];
            var bol = true;
            var organize_names = [];
            $('input[id^="organize_id_"]').each(function () {
                if(organize_ids.indexOf($(this).val())!=-1){
                    bol = false;
                    if(organize_names.indexOf($(this).attr("title"))==-1){
                        organize_names.push($(this).attr("title"))
                    }
                }else{
                    organize_ids.push($(this).val())
                }
            });
            if(bol){
                $.ajax({
                    type: "POST",//方法类型
                    dataType: "json",//预期服务器返回的数据类型
                    url: "${pageContext.request.contextPath}/system/user/save" ,//url
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
            }else{
                $("#submit_button").attr('disabled',false);
                layer.msg(organize_names.join('')+"不可重复设置。", {time: 2000});
//                var aa = "abcdef";
//                console.log(aa.replaceAll('a','1'))
            }
            return false;
        });

    });


    var index = 1;
    function addLine(){
        index ++;
        var tt = '<tr id="tr_'+index+'">';
        tt += '<td><input type="hidden" name="type" lay-verify="field_len50" value="1" autocomplete="off" class="layui-input">兼职组织</td>';
        tt += '<td>' +
                '<div style="float: left">' +
                '<input type="hidden" name="organize_id" id="organize_id_'+index+'" title="" lay-verify="field_len50" value="" autocomplete="off" class="layui-input">' +
                '<input type="text" name="organize_name" id="organize_name_'+index+'" lay-verify="required|field_len50" value="" autocomplete="off" placeholder="请选择组织" class="layui-input">' +
                '</div>' +
                '<div style="float: left">' +
                '<button style="margin-top: 4px;margin-left: 10px;" type="button" onclick="selectOneOrganize(\''+index+'\')" class="layui-btn layui-btn-xs layui-btn-normal">选择</button>' +
                '</div>';
        tt += '<td><input type="text" name="position" lay-verify="field_len50" value="" autocomplete="off" placeholder="请输入职务" class="layui-input"></td>';
        tt += '<td><input type="text" name="child_order_by" lay-verify="title" autocomplete="off" placeholder="请输入排序号" value="'+index+'" class="layui-input"></td>';
        tt += '<td style="width: 78px;"><div class="layui-btn-group"><button type="button" onclick="addLine();" class="layui-btn layui-btn-xs"><i class="layui-icon"></i></button><button type="button" onclick="delLine(\''+index+'\');" class="layui-btn layui-btn-xs layui-btn-danger"><i class="layui-icon"></i></button></div></td>';
        tt += '</tr>';
        $("#table tr:last").after(tt);
    }

    function delLine(index){
        $("#tr_"+index).remove();
    }

    //单选组织
    function selectOneOrganize(index){
        var ids = $("#organize_id_"+index).val();
        var names = $("#organize_name_"+index).val();
        sessionStorage.setItem('ids', ids);
        sessionStorage.setItem('names', names);
        parent.layer.open({
            //skin: 'layui-layer-molv',
            title: '选择组织',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/system/organize/selectOneOrganize',
            area: ['800px', '520px'],
            end: function () {
                var val = getOpenCloseParam();
                if(val=="reload"){
                    $("#organize_id_"+index).val(sessionStorage.getItem("ids"));
                    $("#organize_name_"+index).val(sessionStorage.getItem("names"));
                    $("#organize_id_"+index).attr("title",sessionStorage.getItem("names"));
                    sessionStorage.removeItem("ids");
                    sessionStorage.removeItem("names");
                }
            }
        });
    }


</script>

<%@include file="../admin/bottom.jsp"%>