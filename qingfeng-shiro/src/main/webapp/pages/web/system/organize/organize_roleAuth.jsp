<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>
<style>
    .layui-form-label{
        width: 100%;
    }
    .col-md-5{    width: 260px !important; margin-bottom: 10px; }
    .col-md-5 select{height: 200px !important;}
    .dis{display: none !important;}
</style>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/plugins/doublebox/css/bootstrap.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/plugins/doublebox/css/doublebox-bootstrap.css" />
<form class="layui-form" action="${pageContext.request.contextPath}/system/user/update" id="form">
    <table width="90%">
        <tr>
            <td width="20%" align="right"><label class="layui-form-label">角色分配：</label></td>
            <td colspan="3">
                <select lay-ignore multiple="multiple" size="10" style="" class="demo dis">
                </select>
            </td>
        </tr>
        <tr id="operate_button">
            <td style="text-align: center; padding-top: 10px;" colspan="4">
                <div class="layui-form-item">
                    <input type="hidden" name="id" value="${pd.id}">
                    <input type="hidden" name="role_ids" id="role_ids" value="" />
                    <button type="button" id="submit_button" class="layui-btn layui-btn-sm" lay-submit="" lay-filter="submit_form">保存</button>
                    <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" id="cancel">取消</button>
                </div>
            </td>
        </tr>
    </table>
</form>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/ztree/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/ztree/js/jquery.ztree.excheck.js"></script>
<%--<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/ztree/js/jquery.ztree.excheck.js"></script>--%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/doublebox/js/bootstrap.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/doublebox/js/doublebox-bootstrap.js"></script>
<script>

    $(document).ready(function(){
        var demo2 = $('.demo').doublebox({
            nonSelectedListLabel: '选择角色',
            selectedListLabel: '授权用户角色',
            preserveSelectionOnMove: 'moved',
            moveOnSelect: false,
            nonSelectedList:${roleLs},
            selectedList:${myRoleLs},
            optionValue:"id",
            optionText:"name",
            doubleMove:true,
            filterPlaceHolder: "搜索过滤",
        });
    })

    layui.config({
        base: '${pageContext.request.contextPath}/resources/plugins/module/'
    }).extend({
        treeTable: 'treeTable/treeTable'
    });
    var form,layer,layedit,laydate, $,treeTable,re;
    layui.use(['form', 'layedit', 'laydate','treeTable'], function(){
        form = layui.form;
        layer = layui.layer;
        layedit = layui.layedit;
        laydate = layui.laydate;
        $ = layui.$;
        treeTable = layui.treeTable;

        $('#cancel').on('click',function (){
            var index = parent.layer.getFrameIndex(window.name);
            parent.layer.close(index);
        })


        //监听提交
        form.on('submit(submit_form)', function(data){
            var nos = [];
            $(".demo option:selected").each(function() {
                if ($(this).is(':checked')) {
                    nos.push($(this).val());
                }
            });
            $("#role_ids").val(nos.join(","));
            layer.msg('正在分配权限。');
            $("#submit_button").attr('disabled','disabled');
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/system/organize/updateAuth" ,//url
                data: $('#form').serialize(),
                success: function (res) {
                    if (res.success) {
                        layer.msg("权限分配成功。", {time: 2000},function(){
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


</script>

<%@include file="../admin/bottom.jsp"%>