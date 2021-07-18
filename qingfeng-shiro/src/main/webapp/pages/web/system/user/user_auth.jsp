<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/plugins/doublebox/css/bootstrap.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/plugins/doublebox/css/doublebox-bootstrap.css" />
<style>
    .layui-form-label{
        width: 100%;
    }
    .col-md-5{    width: 260px !important; margin-bottom: 10px; }
    .col-md-5 select{height: 200px !important;}
    .dis{display: none !important;}
    hr {
         height: 1px !important;
    }
</style>
<form class="layui-form" action="${pageContext.request.contextPath}/system/user/update" id="form">
    <table width="95%" style="margin: 0 auto">
        <tr>
            <td colspan="4">
                <blockquote class="layui-elem-quote" style="margin-top: 10px;">角色权限分配</blockquote>
            </td>
        </tr>
        <tr>
            <td width="20%" align="right"><label class="layui-form-label">角色分配：</label></td>
            <td colspan="3">
                <select lay-ignore multiple="multiple" size="10" style="" class="demo dis">
                </select>
            </td>
        </tr>
        <tr>
            <td colspan="4">
                <blockquote class="layui-elem-quote" style="margin-top: 10px;">数据权限配置</blockquote>
            </td>
        </tr>
        <tr>
            <td width="20%" align="right"><label class="layui-form-label">数据权限配置：</label></td>
            <td colspan="3">
                <div style="margin-top: 10px;width: 80%">
                    <select name="organize_id" id="organize_id" lay-filter="selectOrganize" placeholder="请选择组织信息">
                        <c:forEach items="${orgList}" var="var" varStatus="status">
                            <option value="${var.organize_id}">${var.organize_name}</option>
                        </c:forEach>
                    </select>
                </div>
                <hr class="layui-bg-green">
                <table class="layui-table layui-form layui-anim" id="tree-table" lay-size="sm"></table>
            </td>
        </tr>
        <tr id="operate_button">
            <td style="text-align: center; padding-top: 10px;" colspan="4">
                <div class="layui-form-item">
                    <input type="hidden" name="id" value="${pd.id}">
                    <input type="hidden" name="role_ids" id="role_ids" value="" />

                    <input type="hidden" name="authOrgIds" id="authOrgIds" value="" />
                    <input type="hidden" name="authParams" id="authParams" value="" />
                    <input type="hidden" name="authOrgCascade" id="authOrgCascade" value="" />

                    <button type="button" id="submit_button" value="1" class="layui-btn layui-btn-sm" lay-submit="" lay-filter="submit_form">保存</button>
                    <button type="button" id="submit_button2" value="2" class="layui-btn layui-btn-sm" lay-submit="" lay-filter="submit_form">保存并关闭</button>
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

        //选择事件
        form.on('select(selectOrganize)', function (obj) {
            var organize_id = obj.value;
            $("#authOrgIds").val("");
            $("#authParams").val("");
            findOrganizeTableList(organize_id);
            form.render();
            return false;
        });

        //初始化查询
        var organize_id = $("#organize_id option:selected").val();
        findOrganizeTableList(organize_id);


        //监听提交
        form.on('submit(submit_form)', function(data){
            var nos = [];
            $(".demo option:selected").each(function() {
                if ($(this).is(':checked')) {
                    nos.push($(this).val());
                }
            });
            $("#role_ids").val(nos.join(","));
            //处理数据权限
            var authOrgIds = [];
            var authOrgCascade=[];
            $('input[id^="authIds_"]').each(function () {
                if ($(this).prop('checked')) {
                    authOrgIds.push($(this).val());
                    authOrgCascade.push($(this).attr("lay-data"));
                }
            });
            var authParams = [];
            for(var i=0;i<authOrgCascade.length;i++){
                if ($('#authParams_'+authOrgCascade[i]).prop('checked')) {
                    authParams.push(authOrgIds[i]+':Y');
                }else{
                    authParams.push(authOrgIds[i]+':N');
                }
            }
            $("#authOrgIds").val(authOrgIds.join(','));
            $("#authParams").val(authParams.join(','));
            $("#authOrgCascade").val(authOrgCascade.join(','));
            layer.msg('正在分配权限。');
            $("#submit_button").attr('disabled','disabled');
            $("#submit_button2").attr('disabled','disabled');
            $.ajax({
                type: "POST",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/system/user/updateAuth" ,//url
                data: $('#form').serialize(),
                beforeSend: function (XMLHttpRequest) {
                    XMLHttpRequest.setRequestHeader("httpToken", '${csrfToken}');
                },
                success: function (res) {
                    if (res.success) {
                        layer.msg("权限分配成功。", {time: 2000},function(){
                            if(data.elem.value=='2'){
                                var index = parent.layer.getFrameIndex(window.name);
                                parent.layer.close(index);
                            }else{
                                $("#submit_button").attr('disabled',false);
                                $("#submit_button2").attr('disabled',false);
                            }
                        });
                    }else{
                        $("#submit_button").attr('disabled',false);
                        $("#submit_button2").attr('disabled',false);
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


        //监听选择组织
        form.on('checkbox(checkOrgIds)', function(obj){
            if ($("#"+obj.elem.id).prop('checked')) {
                $('input[id^="'+obj.elem.id+'"]').each(function () {
                    $(this).prop("checked", true);
                });

                //选择上级
                var org_cascade = obj.elem.id;
                var org_cascades = org_cascade.substring(0,org_cascade.length-1);
                var index = org_cascades.split('_').length-2;
                var ls_org = org_cascades;
                for(var i=0;i<index;i++){
                    ls_org=ls_org.substring(0,ls_org.lastIndexOf('_'));
                    checkOrgIds(0,ls_org+"_",index+1-i);
                }
            }else{
                $('input[id^="'+obj.elem.id+'"]').each(function () {
                    $(this).prop("checked", false);
                });

                //选择上级
                var org_cascade = obj.elem.id;
                var org_cascades = org_cascade.substring(0,org_cascade.length-1);
                var index = org_cascades.split('_').length-2;
                var ls_org = org_cascades;
                for(var i=0;i<index;i++){
                    ls_org=ls_org.substring(0,ls_org.lastIndexOf('_'));
                    checkOrgIds(1,ls_org+"_",index+1-i);
                }
            }
            form.render('checkbox');
            return false;
        });

        //监听选择组织
        form.on('checkbox(checkOrgParams)', function(obj){
            if ($("#"+obj.elem.id).prop('checked')) {
                $('input[id^="'+obj.elem.id+'"]').each(function () {
                    $(this).prop("checked", true);
                });

                //选择上级
                var org_cascade = obj.elem.id;
                var org_cascades = org_cascade.substring(0,org_cascade.length-1);
                var index = org_cascades.split('_').length-2;
                var ls_org = org_cascades;
                for(var i=0;i<index;i++){
                    ls_org=ls_org.substring(0,ls_org.lastIndexOf('_'));
                    checkOrgParams(0,ls_org+"_",index+1-i);
                }
            }else{
                $('input[id^="'+obj.elem.id+'"]').each(function () {
                    $(this).prop("checked", false);
                });

                //选择上级
                var org_cascade = obj.elem.id;
                var org_cascades = org_cascade.substring(0,org_cascade.length-1);
                var index = org_cascades.split('_').length-2;
                var ls_org = org_cascades;
                for(var i=0;i<index;i++){
                    ls_org=ls_org.substring(0,ls_org.lastIndexOf('_'));
                    checkOrgParams(1,ls_org+"_",index+1-i);
                }
            }
            form.render('checkbox');
            return false;
        });

    });


    function findOrganizeTableList(organize_id){
        $.ajax({
            type: "GET",//方法类型
            dataType: "json",//预期服务器返回的数据类型
            url: "${pageContext.request.contextPath}/system/user/findTreeTableList?organize_id="+organize_id+"&user_id=${pd.id}",//url
            data: {
            },
            success: function (res) {
                console.log(res);
                if (res.success) {
                    //数据权限配置
                    var authParams = res.object.authParams;
                    var authOrgIds = res.object.authOrgIds;
                    var authOrgCascade = res.object.authOrgCascade;
                    re = treeTable.render({
                        elem: '#tree-table',
                        data: res.data,
                        icon_key: 'title',
                        primary_key: 'id',
                        parent_key: 'pid',
//                        is_checkbox: true,
//                        checked: {
//                            key: 'id',
//                            data: authOrgIds.split(','),
//                        },
                        end: function(e){
                            var authOrgCascades = (authOrgCascade||"").split(',');
                            for(var i=0;i<authOrgCascades.length;i++){
                                $("#authIds_"+authOrgCascades[i]).prop("checked", true);
                            }
                            var params = (authParams||"").split(',');
                            for(var i=0;i<params.length;i++){
                                var kv = params[i].split(':');
                                if(kv[1]=='Y'){
                                    $("#authParams_"+authOrgCascades[i]).prop("checked", true);
                                }
                            }
                            form.render();
                        },
                        cols: [
                            {
                                key: 'title',
                                title: '名称',
                                width: '400px'
                            },
                            {
                                title: '查看授权',
                                width: '140px',
                                align: 'center',
                                template: function(item){
                                    return ' <input type="checkbox" value="'+item.id+'" lay-data="'+item.org_cascade+'" name="authIds" id="authIds_'+item.org_cascade+'" lay-filter="checkOrgIds" lay-skin="primary" title="">';
                                }
                            },
                            {
                                title: '操作(编辑/删除)授权',
                                width: '140px',
                                align: 'center',
                                template: function(item){
                                    return ' <input type="checkbox" value="'+item.id+'" lay-data="'+item.org_cascade+'" name="authParams" id="authParams_'+item.org_cascade+'"  lay-filter="checkOrgParams" lay-skin="primary" title="">';
                                }
                            }
                        ]
                    });
                    //打开全部折叠
                    treeTable.openAll(re);

                }else{
                    if(res.loseSession=='loseSession'){
                        loseSession(res.msg,res.url)
                    }else{
                        layer.msg(res.msg, {time: 2000});
                    }
                }
            }
        });
    }


    function checkOrgIds(check,org_cascade,num){
        if(check==0){
            var bol = true;
            $('input[id^="'+org_cascade+'"]').each(function () {
                var ids = $(this).attr("id");
                var id = ids.substring(0,ids.length-1)
                if(id.split('_').length==num+1){
                    console.log(id+":"+$("#"+ids).prop('checked'));
                    if (!$("#"+ids).prop('checked')) {
                        bol = false;
                    }
                }
            });
            if(bol){
                $("#"+org_cascade).prop("checked", true);
            }
        }else if(check==1){
            var bol = true;
            $('input[id^="'+org_cascade+'"]').each(function () {
                var ids = $(this).attr("id");
                var id = ids.substring(0,ids.length-1)
                if(id.split('_').length==num+1){
                    if ($("#"+ids).prop('checked')) {
                        bol = false;
                    }
                }
            });
            if(bol){
                $("#"+org_cascade).prop("checked", false);
            }
        }

    }

    function checkOrgParams(check,org_cascade,num){
        if(check==0){
            var bol = true;
            $('input[id^="'+org_cascade+'"]').each(function () {
                var ids = $(this).attr("id");
                var id = ids.substring(0,ids.length-1)
                if(id.split('_').length==num+1){
                    console.log(id+":"+$("#"+ids).prop('checked'));
                    if (!$("#"+ids).prop('checked')) {
                        bol = false;
                    }
                }
            });
            if(bol){
                $("#"+org_cascade).prop("checked", true);
            }
        }else if(check==1){
            var bol = true;
            $('input[id^="'+org_cascade+'"]').each(function () {
                var ids = $(this).attr("id");
                var id = ids.substring(0,ids.length-1)
                if(id.split('_').length==num+1){
                    if ($("#"+ids).prop('checked')) {
                        bol = false;
                    }
                }
            });
            if(bol){
                $("#"+org_cascade).prop("checked", false);
            }
        }
    }


</script>

<%@include file="../admin/bottom.jsp"%>