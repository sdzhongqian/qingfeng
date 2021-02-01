<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../admin/top.jsp"%>
<style>
    .layui-tab {
        margin: 0;
        text-align: left!important;
    }
    .data{
        margin-left: 4px;
        float: left;
        width: 18%;
    }
    .layui-form-radio {
        line-height: 28px;
        margin: 4px 0 0 0;
        padding-right: 10px;
        cursor: pointer;
        font-size: 0;
    }
    .badge{
        margin: 4px;
        float: left;
    }
    .layui-badge {
        height: 28px;
        line-height: 28px;
    }
    .label-a{
        color: #FFF;
        padding-left: 5px;
        cursor: pointer;
    }
</style>
<form class="layui-form" action="" id="form">
    <div>
        <blockquote id="search" class="layui-elem-quote">
            <div class="layui-inline">
                <label class="layui-form-lab" style="width: auto">登录名称</label>
                <input type="text" name="login_name" id="login_name" style="width: 160px;height: 32px;display: inline" placeholder="请输入登录名称" class="layui-input">
            </div>
            <div class="layui-inline">
                <label class="layui-form-lab" style="width: auto">姓名</label>
                <input type="text" name="name" id="name" style="width: 160px;height: 32px;display: inline" placeholder="请输入用户名称" class="layui-input">
            </div>
            <div class="layui-inline">
                <label class="layui-form-lab" style="width: auto">手机号码</label>
                <input type="text" name="login_name" id="phone" style="width: 160px;height: 32px;display: inline" placeholder="请输入手机号码" class="layui-input">
            </div>
            <button type="button" class="layui-btn layui-btn-sm"  onclick="reloadData('');">
                <i class="layui-icon">&#xe615;</i>
            </button>
            <button type="button" class="layui-btn layui-btn-sm"  onclick="clearData();">
                <i class="layui-icon">&#xe639;</i>
            </button>
        </blockquote>
    </div>
    <div align="center">
        <div style="float: left;width: 25%;height: 320px;background-color: #eee;">
            <div class="layui-tab layui-tab-brief" lay-filter="docDemoTabBrief">
                <ul class="layui-tab-title">
                    <li class="layui-this">组织</li>
                </ul>
                <div class="layui-tab-content" style="height: 100px;">
                    <div class="layui-tab-item layui-show">
                        <ul id="treeDemo" class="ztree more_text"></ul>
                        <input type="hidden" name="tree_id" id="tree_id" value="" />
                        <input type="hidden" id="tree_name" value="" />
                        <input type="hidden" id="tree_level" value="" />
                        <input type="hidden" id="tree_cascade" value="" />
                        <input type="hidden" name="code" id="code" value="" />
                    </div>
                </div>
            </div>
        </div>
        <div style="float: left;width: 73%;height: 320px;">
            <div style="height: 40px;line-height: 40px;" align="left">
                全部组织
            </div>
            <div style="border: 1px solid #5FB878;height: 198px;border-radius:4px;" align="left">
                <ul id="listUser">
                </ul>
            </div>
            <div id="label_user" style="height: 88px;border: 1px solid #5FB878;margin-top: 2px;border-radius:4px;overflow-y:scroll;" align="left">
            </div>
        </div>
        <div style="clear: both"></div>
    </div>
    <div align="center" style="padding-top: 10px;">
        <button type="button" class="layui-btn layui-btn-sm" onclick="define()">确定</button>
        <button type="button" class="layui-btn layui-btn-danger layui-btn-sm" id="cancel">取消</button>
    </div>
</form>

<div id="menuContent" class="menuContent" style="display:none; position: absolute; background-color: #eaeaea; height: 300px;width:180px; ">
    <ul id="selectOrgZtree" class="ztree" style="margin-top:0; width:180px; height: 300px;"></ul>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/ztree/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/ztree/js/jquery.ztree.all.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css" />
<%@include file="../organize/organize_ztree.jsp" %>
<script>
    var form, $,element;
    layui.use(['form','element'], function(){
        form = layui.form;
        $ = layui.jquery;
        element = layui.element; //Tab的切换功能，切换事件监听等，需要依赖element模块

        //取消
        $('#cancel').on('click',function (){
            var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
            parent.layer.close(index);
        })

        //选择
        form.on('radio(selectData)', function (obj) {
            var id = obj.value.split("#")[0];
            var name = obj.value.split("#")[1];
            checkData(id,name);
            form.render();
            return false;
        });

        //回显
        var ids = sessionStorage.getItem("ids");
        var names = sessionStorage.getItem("names");
        sessionStorage.removeItem("ids");
        sessionStorage.removeItem("names");
        if(ids!=''&&ids!=null){
            checkData(ids,names);
        }

    });

    //回车键事件
    $(document).keyup(function(event){
        if(event.keyCode ==13){
            reloadData('');
        }
    });

    //查询用户信息
    function reloadData(id){
        var login_name = $("#login_name").val();
        var name = $("#name").val();
        var phone = $("#phone").val();
        $.ajax({
            type: "GET",
            url: "${pageContext.request.contextPath}/system/user/findList?organize_id="+id+"&login_name="+login_name+"&name="+name+"&phone="+phone,
            dataType: "json",
            success: function (res) {
                if(res.success){
                    var tt ='';
                    $.each(res.data,function(i,n){
                        tt+='<li class="data more_text"><input type="radio" id="user_'+ n.id+'" name="user"  value="'+n.id+'#'+n.name+'" lay-filter="selectData" title="'+n.name+'"></li>';
                    });
                    $("#listUser").html(tt);
                    for(var i=0; i< ids.length; i++) {
                        if (ids[i] != '' && ids[i] != null) {
                            $("#user_" + ids[i]).attr("checked", true);
                        }
                    }
                    form.render();
                }else{
                    if(res.loseSession=='loseSession'){
                        loseSession(res.msg,res.url)
                    }else{
                        layer.msg(result.msg, {time: 2000});
                    }
                }
            }
        });
    }

    //选择用户
    var ids = [];
    var names = [];
    function checkData(id,name){
        ids = [];
        ids.push(id);
        names = [];
        names.push(name);
        var tt = '<span id="span_'+id+'" class="layui-badge layui-bg-green badge">'+ name+'<a class="label-a" onclick="delUser(\''+id+'\');"><i class="layui-icon layui-icon-close label-icon"></i></a></span>';
        $("#label_user").html(tt);
    }

    //删除选择
    function delUser(id){
        ids = [];
        names = [];
        $("#span_"+id).remove();
        $("#user_"+id).removeAttr('checked');
        form.render();
    }

    //确定
    function define(){
        setOpenCloseParam("reload");
        sessionStorage.setItem('ids', ids);
        sessionStorage.setItem('names', names);
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        parent.layer.close(index);
    }

    //清除数据
    function clearData(){
        $("#login_name").val("");
        $("#name").val("");
        $("#phone").val("");
    }

</script>

<%@include file="../admin/bottom.jsp"%>