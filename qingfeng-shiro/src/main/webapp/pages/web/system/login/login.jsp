<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>青锋系统平台登录</title>
<meta name="renderer" content="webkit|ie-comp|ie-stand">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width,user-scalable=yes, minimum-scale=0.4, initial-scale=0.8,target-densitydpi=low-dpi" />
<meta http-equiv="Cache-Control" content="no-siteapp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/xadmin/css/font.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/xadmin/css/login.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/xadmin/css/xadmin.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/xadmin/lib/layui/layui.js" charset="utf-8"></script>
<!--[if lt IE 9]>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/xadmin/js/html5.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/xadmin/js/respond.min.js"></script>
<![endif]-->
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/verify/js/verify.js" ></script>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/plugins/verify/css/verify.css">
</head>
<body class="login-bg">

<div class="login layui-anim layui-anim-up">
    <div class="message">青锋系统平台登录</div>
    <div id="darkbannerwrap"></div>

    <form method="post" class="layui-form" id="form">
        <input name="login_name" id="login_name" placeholder="用户名"  type="text" lay-verify="required|login_name" class="layui-input" >
        <hr class="hr15">
        <input name="password" id="password" lay-verify="required|pass" placeholder="密码"  type="password" class="layui-input">
        <hr class="hr15">
        <div id="yzm"></div>
        <hr class="hr15">
        <input type="checkbox" name="remember" id="remember" lay-skin="primary" title="记住密码">
        <hr class="hr15">
        <input type="hidden" name="my_remember" id="my_remember" value="false">
        <button id="submit_button" class="layui-btn" value="登录" lay-submit lay-filter="login" style="width:100%;font-size: 18px;height: 45px" type="submit">登录</button>
        <hr class="hr20" >
    </form>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfverify.js"></script>
<script>
    var verify_yzm = false;
    $(function  () {
        layui.use('form', function(){
            var form = layui.form;
            //初始化
            var storage = window.localStorage;
            if(storage.getItem("login_name")!=''){
                $("#login_name").val(storage.getItem("login_name"));//推荐使用
                $("#password").val(storage.getItem("password"));
                $("#remember").prop("checked",true);
                form.render();
            }
            kickout();

            //自定义验证规则
            form.verify(form_verify);
            //监听提交
            form.on('submit(login)', function(data){
                if(verify_yzm){
                    $("#submit_button").attr('disabled',true);
                    if($("#remember").prop("checked")){
                        $("#my_remember").val(true);
                    }else{
                        $("#my_remember").val(false);
                    }
                    $.ajax({
                        type: "POST",//方法类型
                        dataType: "json",//预期服务器返回的数据类型
                        url: "${pageContext.request.contextPath}/system/login/login" ,//url
                        data: $('#form').serialize(),
                        success: function (res) {
                            if (res.success) {
                                layer.msg("登录成功。", {time: 1000},function(){

                                    if($("#remember").prop("checked")){
                                        if(!window.localStorage){
//                                        "浏览器不支持localStorage";
                                        }else{
                                            var storage = window.localStorage;
                                            storage.setItem("login_name",$("#login_name").val());//推荐使用
                                            storage.setItem("password",$("#password").val());
                                        }
                                    }else{
                                        var storage = window.localStorage;
                                        storage.setItem("login_name","");//推荐使用
                                        storage.setItem("password","");
                                    }


                                    window.location.href="../../../../../"
                                });
                            }else{
                                $("#submit_button").attr('disabled',false);
                                layer.msg(res.msg, {time: 2000});
                            }
                        },
                        error : function() {
                            $("#submit_button").attr('disabled',false);
                            layer.msg("异常！");
                        }
                    });
                }else{
                    layer.msg("请滑动验证码完成验证", {time: 2000});
                }
                return false;
            });
        });

        $('#yzm').slideVerify({
            type : 1,		//类型
            vOffset : 5,	//误差量，根据需求自行调整
            barSize : {
                width : '100%',
                height : '45px',
            },
            ready : function() {
            },
            success : function() {
                verify_yzm = true;
            },
            error : function() {
                //alert('验证失败！');
            }

        });

    })

    //回车事件
    document.onkeydown = function (event) {
        var e = event || window.event;
        if (e && e.keyCode == 13) { //回车键的键值为13
            $("#submit_button").submit();
        }
    };

    function kickout(){
        var href=location.href;
        if(href.indexOf("kickout")>0){
            layer.msg("您的账号在另一台设备上登录,如非本人操作，请立即修改密码！", {time: 2000});
        }
    }

</script>
<!-- 底部结束 -->
</body>
</html>