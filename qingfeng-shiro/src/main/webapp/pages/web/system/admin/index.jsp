<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html class="x-admin-sm">
<head>
    <meta charset="UTF-8">
    <title>青锋系统管理平台</title>
    <meta name="renderer" content="webkit|ie-comp|ie-stand">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,user-scalable=yes, minimum-scale=0.4, initial-scale=0.8,target-densitydpi=low-dpi" />
    <meta http-equiv="Cache-Control" content="no-siteapp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/xadmin/css/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/xadmin/css/xadmin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/scroll/smallscroll.css">
    <c:if test="${loginUser.theme_type==''||loginUser.theme_type==null}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/xadmin/css/theme1.css">
    </c:if>
    <c:if test="${loginUser.theme_type=='0'}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/xadmin/css/${loginUser.theme_file_name}.css">
    </c:if>
    <c:if test="${loginUser.theme_type=='1'}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/xadmin/css/theme/${loginUser.theme_file_name}.css">
    </c:if>
    <script src="${pageContext.request.contextPath}/resources/plugins/xadmin/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/plugins/xadmin/lib/layui/layui.js" charset="utf-8"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/xadmin/js/xadmin.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfPassValue.js"></script>
    <!-- 让IE8/9支持媒体查询，从而兼容栅格 -->
    <!--[if lt IE 9]>
    <script src="https://cdn.staticfile.org/html5shiv/r29/html5.min.js"></script>
    <script src="https://cdn.staticfile.org/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <script>
        // 是否开启刷新记忆tab功能
        // var is_remember = false;
    </script>
    <style>
    </style>
</head>
<body class="index">
<!-- 顶部开始 -->
<div class="container">
    <div class="logo">
        <a href="${pageContext.request.contextPath}/resources/plugins/xadmin/indexbak.html">青锋系统管理平台</a></div>
    <div class="left_open">
        <a><i title="展开左侧栏" class="iconfont">&#xe699;</i></a>
    </div>
    <ul id="mainMenu" class="layui-nav left fast-add" lay-filter="">
        <%--<c:if test="${fn:length(list)>8}">--%>
            <c:forEach items="${menuList}" var="var" varStatus="status">
                <c:if test="${status.index<6}">
                    <li id="li_${var.id}" class="layui-nav-item">
                        <a style="cursor: pointer" onclick="findMenu('${var.id}','${var.child_num}','${var.url}','${var.name}');"><i class="layui-icon">${var.icon}</i><span style="padding-left: 4px;">${var.name}</span></a>
                    </li>
                </c:if>
            </c:forEach>
        <%--</c:if>--%>
    </ul>
    <c:if test="${fn:length(menuList)>6}">
        <div class="left_menu" onmouseover="showMoreMenu()" onmouseout="closeMoreMenu()">
            <a><i class="layui-icon" style="padding-right: 5px;">&#xe653;</i>更多</a>
        </div>
    </c:if>
    <ul class="layui-nav right" lay-filter="">
        <li class="layui-nav-item to-index">
            <a href="/">前台首页</a>
        </li>
        <li class="layui-nav-item">
            <a href="javascript:;"><i class="layui-icon">&#xe624;</i>弹框示例</a>
            <dl class="layui-nav-child">
                <!-- 二级菜单 -->
                <dd>
                    <a onclick="xadmin.open('最大化','http://www.baidu.com','','',true)">
                        <i class="iconfont">&#xe6a2;</i>弹出最大化</a></dd>
                <dd>
                    <a onclick="xadmin.open('弹出自动宽高','http://www.baidu.com')">
                        <i class="iconfont">&#xe6a8;</i>弹出自动宽高</a></dd>
                <dd>
                    <a onclick="xadmin.open('弹出指定宽高','http://www.baidu.com',500,300)">
                        <i class="iconfont">&#xe6a8;</i>弹出指定宽高</a></dd>
                <dd>
                    <a onclick="xadmin.add_tab('在tab打开','http://www.baidu.com')">
                        <i class="iconfont">&#xe6b8;</i>在tab打开</a></dd>
                <dd>
                    <a onclick="xadmin.add_tab('在tab打开刷新','http://www.baidu.com',true)">
                        <i class="iconfont">&#xe6b8;</i>在tab打开刷新</a></dd>
            </dl>
        </li>
        <li class="layui-nav-item">
            <a href="javascript:;"><i class="layui-icon">&#xe66f;</i>${loginUser.name}</a>
            <dl class="layui-nav-child">
                <!-- 二级菜单 -->
                <dd>
                    <a onclick="xadmin.open('个人信息','${pageContext.request.contextPath}/system/user/toMyUpdate',800,500)"><i class="layui-icon">&#xe612;</i>个人信息</a>
                </dd>
                <dd>
                    <a onclick="xadmin.open('密码修改','${pageContext.request.contextPath}/system/user/toMyResetPwd',600,280)"><i class="layui-icon">&#xe60f;</i>密码修改</a>
                </dd>
                <dd>
                    <a style="cursor: pointer" onclick="switchOrganize();"><i class="layui-icon">&#xe613;</i>组织切换</a>
                </dd>
                <dd>
                    <a style="cursor: pointer" onclick="switchTheme()"><i class="layui-icon">&#xe66a</i>主题切换</a>
                </dd>
                <dd>
                    <a href="${pageContext.request.contextPath}/system/login/login"><i class="layui-icon">&#xe682;</i>退出</a>
                </dd>
            </dl>
        </li>

    </ul>
</div>
<div id="moreMenu" class="moreMenu container" onmouseover="showMoreMenu()" onmouseout="closeMoreMenu()" style="display: none;height: auto">
    <div class="" style="width: 80%;margin: 0 auto;padding: 10px 0; ">
        <c:forEach items="${menuList}" var="var" varStatus="status">
            <c:if test="${status.index>=6}">
                <button type="button" id="btn_${var.id}" class="layui-btn layui-btn-item" onclick="findMenu('${var.id}','${var.child_num}','${var.url}','${var.name}');"><i class="layui-icon">${var.icon}</i>${var.name}</button>
            </c:if>
        </c:forEach>
    </div>
</div>
<!-- 顶部结束 -->
<!-- 中部开始 -->
<!-- 左侧菜单开始 -->
<div class="left-nav" id="left">
    <div id="side-nav">
        <ul id="nav">
            <%--<li id="last_li">--%>
                <%--<a href="javascript:;">--%>
                    <%--<i class="iconfont left-nav-li" lay-tips="会员管理">&#xe6b8;</i>--%>
                    <%--<cite>系统管理</cite>--%>
                    <%--<i class="iconfont nav_right">&#xe697;</i></a>--%>
                <%--<ul class="sub-menu">--%>
                    <%--<li>--%>
                        <%--<a onclick="xadmin.add_tab('用户管理','${pageContext.request.contextPath}/system/user/index',true)">--%>
                            <%--<i class="iconfont">&#xe6a7;</i>--%>
                            <%--<cite>用户管理</cite></a>--%>
                    <%--</li>--%>
                    <%--<li>--%>
                        <%--<a onclick="xadmin.add_tab('组织管理','${pageContext.request.contextPath}/system/organize/index')">--%>
                            <%--<i class="iconfont">&#xe6a7;</i>--%>
                            <%--<cite>组织管理</cite></a>--%>
                    <%--</li>--%>
                    <%--<li>--%>
                        <%--<a onclick="xadmin.add_tab('角色管理','${pageContext.request.contextPath}/system/role/index')">--%>
                            <%--<i class="iconfont">&#xe6a7;</i>--%>
                            <%--<cite>角色管理</cite></a>--%>
                    <%--</li>--%>
                    <%--<li>--%>
                        <%--<a onclick="xadmin.add_tab('字典管理','${pageContext.request.contextPath}/system/dictionary/index')">--%>
                            <%--<i class="iconfont">&#xe6a7;</i>--%>
                            <%--<cite>字典管理</cite></a>--%>
                    <%--</li>--%>
                    <%--<li>--%>
                        <%--<a onclick="xadmin.add_tab('菜单管理','${pageContext.request.contextPath}/system/menu/index')">--%>
                            <%--<i class="iconfont">&#xe6a7;</i>--%>
                            <%--<cite>菜单管理</cite></a>--%>
                    <%--</li>--%>
                    <%--<li>--%>
                        <%--<a onclick="xadmin.add_tab('地区管理','${pageContext.request.contextPath}/system/area/index')">--%>
                            <%--<i class="iconfont">&#xe6a7;</i>--%>
                            <%--<cite>地区管理</cite></a>--%>
                    <%--</li>--%>
                    <%--<li>--%>
                        <%--<a onclick="xadmin.add_tab('用户组管理','${pageContext.request.contextPath}/system/group/index')">--%>
                            <%--<i class="iconfont">&#xe6a7;</i>--%>
                            <%--<cite>用户组管理</cite></a>--%>
                    <%--</li>--%>
                    <%--<li>--%>
                        <%--<a onclick="xadmin.add_tab('日志管理','${pageContext.request.contextPath}/system/logger/index')">--%>
                            <%--<i class="iconfont">&#xe6a7;</i>--%>
                            <%--<cite>日志管理</cite></a>--%>
                    <%--</li>--%>
                <%--</ul>--%>
            <%--</li>--%>
        </ul>
    </div>
</div>
<!-- <div class="x-slide_left"></div> -->
<!-- 左侧菜单结束 -->
<!-- 右侧主体开始 -->
<div class="page-content" id="right">
    <div class="layui-tab tab" lay-filter="xbs_tab" lay-allowclose="false">
        <ul class="layui-tab-title">
            <li class="home">
                <i class="layui-icon">&#xe68e;</i>我的桌面</li></ul>
        <div class="layui-unselect layui-form-select layui-form-selected" id="tab_right">
            <dl style="width: 140px">
                <dd data-type="this"><i class="layui-icon tab">&#x1006;</i>关闭当前</dd>
                <dd data-type="other"><i class="layui-icon tab">&#xe64e;</i>关闭其它</dd>
                <dd data-type="left"><i class="layui-icon tab">&#xe603;</i>关闭左侧</dd>
                <dd data-type="right"><i class="layui-icon tab">&#xe602;</i>关闭右侧</dd>
                <dd data-type="all"><i class="layui-icon tab">&#x1007;</i>关闭全部</dd>
                <hr class="layui-bg-green">
                <dd data-type="full"><i class="layui-icon tab">&#xe622;</i>全屏显示</dd>
                <dd data-type="refresh"><i class="layui-icon tab">&#xe9aa;</i>刷新页面</dd>
                <dd data-type="newOpen"><i class="layui-icon tab">&#xe622;</i>新窗口打开</dd>
            </dl>
        </div>
        <div class="layui-tab-content">
            <div class="layui-tab-item layui-show">
                <iframe src='${pageContext.request.contextPath}/system/admin/index' frameborder="0" scrolling="yes" class="x-iframe"></iframe>
            </div>
        </div>
        <div id="tab_show"></div>
    </div>
</div>
<div class="page-content-bg"></div>
<style id="theme_style"></style>
<!-- 右侧主体结束 -->
<!-- 中部结束 -->

<style>
    #tool{
        position: fixed;
        height: 300px;
        width: 100%;
        bottom: 0px;
        background: #fff;
        border-top: 5px solid #019587;
        overflow: auto;
        background: #E3E3E3;
        padding-top: 15px;
        box-sizing: border-box;
        display: none;
        z-index: 999;
        /*padding-right: 250px;*/
    }
    body{
        height: 100%;overflow: hidden;
    }
    #save{
        position: fixed;
        bottom:30px;
        right: 30px;
        z-index: 999;
    }
    .layui-form-switch{
        margin-top: 0px;
    }
</style>
<script src="${pageContext.request.contextPath}/resources/plugins/xadmin/js/FileSaver.js"></script>
<script src="${pageContext.request.contextPath}/resources/plugins/xadmin/js/html2canvas.min.js"></script>
<script>
    var save_out_url = "${pageContext.request.contextPath}/system/theme/saveTheme";
    var theme_url = "${pageContext.request.contextPath}/system/theme/index?menuAuthId=bba6e6292dc14d59a598ab1912b23e02";
</script>
<form class="layui-form" action="/index/theme/add.html" method="post">
    <div id="tool" class="layui-fluid" style="display: none;">
        <div class="layui-row layui-col-space15">
            <div class="layui-col-sm6 layui-col-md2">
                <div class="layui-card">
                    <div class="layui-card-header">
                        首页背景
                        <input type="checkbox" lay-skin="switch" lay-filter="turn" lay-text="关闭|渐变" name="" />
                        <div class="layui-unselect layui-form-switch" lay-skin="_switch">
                            <em>渐变</em>
                            <i></i>
                        </div>
                    </div>
                    <div class="layui-card-body layuiadmin-card-list result" selecter_name="body.index" selecter_name_attr="background">
                        <div class="layui-show-md-inline-block">
                            <div class="selecter layui-inline" id="index_bg">
                                <div class="layui-unselect layui-colorpicker">
                                    <span class="layui-colorpicker-trigger-bgcolor"><span class="layui-colorpicker-trigger-span" lay-type="rgba" style=""><i class="layui-icon layui-colorpicker-trigger-i layui-icon-close"></i></span></span>
                                </div>
                            </div>
                            <input type="hidden" name="index_bg[0]" value="" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-col-sm6 layui-col-md2">
                <div class="layui-card">
                    <div class="layui-card-header">
                        顶部背景
                        <input type="checkbox" lay-skin="switch" lay-filter="turn" lay-text="关闭|渐变" name="" />
                        <div class="layui-unselect layui-form-switch" lay-skin="_switch">
                            <em>渐变</em>
                            <i></i>
                        </div>
                    </div>
                    <div class="layui-card-body layuiadmin-card-list result" selecter_name=".container" selecter_name_attr="background">
                        <div class="layui-show-md-inline-block">
                            <div class="selecter layui-inline" id="top_bg">
                                <div class="layui-unselect layui-colorpicker">
                                    <span class="layui-colorpicker-trigger-bgcolor"><span class="layui-colorpicker-trigger-span" lay-type="rgba" style="background: rgb(34, 34, 34)"><i class="layui-icon layui-colorpicker-trigger-i layui-icon-down"></i></span></span>
                                </div>
                            </div>
                            <input type="hidden" name="top_bg[0]" value="rgb(34, 34, 34)" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-col-sm6 layui-col-md2">
                <div class="layui-card">
                    <div class="layui-card-header">
                        顶部触发颜色
                    </div>
                    <div class="layui-card-body layuiadmin-card-list result" selecter_name=".container .layui-nav-bar" selecter_name_attr="background">
                        <div class="layui-show-md-inline-block">
                            <div class="selecter layui-inline" id="top_border_bg">
                                <div class="layui-unselect layui-colorpicker">
                                    <span class="layui-colorpicker-trigger-bgcolor"><span class="layui-colorpicker-trigger-span" lay-type="rgba" style="background: rgb(95, 184, 120)"><i class="layui-icon layui-colorpicker-trigger-i layui-icon-down"></i></span></span>
                                </div>
                            </div>
                            <input type="hidden" name="top_border_bg[0]" value="rgb(95, 184, 120)" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-col-sm6 layui-col-md2">
                <div class="layui-card">
                    <div class="layui-card-header">
                        LOGO背景
                    </div>
                    <div class="layui-card-body layuiadmin-card-list result" selecter_name=".container .logo a" selecter_name_attr="background">
                        <div class="layui-show-md-inline-block">
                            <div class="selecter layui-inline" id="logo_bg">
                                <div class="layui-unselect layui-colorpicker">
                                    <span class="layui-colorpicker-trigger-bgcolor"><span class="layui-colorpicker-trigger-span" lay-type="rgba" style=""><i class="layui-icon layui-colorpicker-trigger-i layui-icon-close"></i></span></span>
                                </div>
                            </div>
                            <input type="hidden" name="logo_bg[0]" value="" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-col-sm6 layui-col-md2">
                <div class="layui-card">
                    <div class="layui-card-header">
                        LOGO颜色
                    </div>
                    <div class="layui-card-body layuiadmin-card-list result" selecter_name=".container .logo a" selecter_name_attr="color">
                        <div class="layui-show-md-inline-block">
                            <div class="selecter layui-inline" id="logo_color">
                                <div class="layui-unselect layui-colorpicker">
                                    <span class="layui-colorpicker-trigger-bgcolor"><span class="layui-colorpicker-trigger-span" lay-type="rgba" style="background: rgb(255, 255, 255)"><i class="layui-icon layui-colorpicker-trigger-i layui-icon-down"></i></span></span>
                                </div>
                            </div>
                            <input type="hidden" name="logo_color[0]" value="rgb(255, 255, 255)" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-col-sm6 layui-col-md2">
                <div class="layui-card">
                    <div class="layui-card-header">
                        左侧背景
                    </div>
                    <div class="layui-card-body layuiadmin-card-list result" selecter_name=".left-nav" selecter_name_attr="background">
                        <div class="layui-show-md-inline-block">
                            <div class="selecter layui-inline" id="left_bg">
                                <div class="layui-unselect layui-colorpicker">
                                    <span class="layui-colorpicker-trigger-bgcolor"><span class="layui-colorpicker-trigger-span" lay-type="rgba" style="background: rgb(238, 238, 238)"><i class="layui-icon layui-colorpicker-trigger-i layui-icon-down"></i></span></span>
                                </div>
                            </div>
                            <input type="hidden" name="left_bg[0]" value="rgb(238, 238, 238)" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-col-sm6 layui-col-md2">
                <div class="layui-card">
                    <div class="layui-card-header">
                        左侧默认文字
                    </div>
                    <div class="layui-card-body layuiadmin-card-list result" selecter_name=".left-nav a" selecter_name_attr="color">
                        <div class="layui-show-md-inline-block">
                            <div class="selecter layui-inline" id="left_a_color">
                                <div class="layui-unselect layui-colorpicker">
                                    <span class="layui-colorpicker-trigger-bgcolor"><span class="layui-colorpicker-trigger-span" lay-type="rgba" style="background: rgb(51, 51, 51)"><i class="layui-icon layui-colorpicker-trigger-i layui-icon-down"></i></span></span>
                                </div>
                            </div>
                            <input type="hidden" name="left_a_color[0]" value="rgb(51, 51, 51)" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-col-sm6 layui-col-md2">
                <div class="layui-card">
                    <div class="layui-card-header">
                        左侧列表背景
                        <input type="checkbox" lay-skin="switch" lay-filter="turn" lay-text="关闭|渐变" name="" />
                        <div class="layui-unselect layui-form-switch" lay-skin="_switch">
                            <em>渐变</em>
                            <i></i>
                        </div>
                    </div>
                    <div class="layui-card-body layuiadmin-card-list result" selecter_name=".left-nav a:hover,.left-nav a.active" selecter_name_attr="background">
                        <div class="layui-show-md-inline-block">
                            <div class="selecter layui-inline" id="left_li_bg">
                                <div class="layui-unselect layui-colorpicker">
                                    <span class="layui-colorpicker-trigger-bgcolor"><span class="layui-colorpicker-trigger-span" lay-type="rgba" style="background: rgb(0, 150, 136)"><i class="layui-icon layui-colorpicker-trigger-i layui-icon-down"></i></span></span>
                                </div>
                            </div>
                            <input type="hidden" name="left_li_bg[0]" value="rgb(0, 150, 136)" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-col-sm6 layui-col-md2">
                <div class="layui-card">
                    <div class="layui-card-header">
                        左侧列表文字
                    </div>
                    <div class="layui-card-body layuiadmin-card-list result" selecter_name=".left-nav a:hover,.left-nav a.active" selecter_name_attr="color">
                        <div class="layui-show-md-inline-block">
                            <div class="selecter layui-inline" id="left_li_a_bg">
                                <div class="layui-unselect layui-colorpicker">
                                    <span class="layui-colorpicker-trigger-bgcolor"><span class="layui-colorpicker-trigger-span" lay-type="rgba" style="background: rgb(255, 255, 255)"><i class="layui-icon layui-colorpicker-trigger-i layui-icon-down"></i></span></span>
                                </div>
                            </div>
                            <input type="hidden" name="left_li_a_bg[0]" value="rgb(255, 255, 255)" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-col-sm6 layui-col-md2">
                <div class="layui-card">
                    <div class="layui-card-header">
                        左侧列表边框
                    </div>
                    <div class="layui-card-body layuiadmin-card-list result" selecter_name=".left-nav a:hover,.left-nav a.active" selecter_name_attr="border-color">
                        <div class="layui-show-md-inline-block">
                            <div class="selecter layui-inline" id="left_li_a_order_color">
                                <div class="layui-unselect layui-colorpicker">
                                    <span class="layui-colorpicker-trigger-bgcolor"><span class="layui-colorpicker-trigger-span" lay-type="rgba" style="background: rgb(4, 86, 78)"><i class="layui-icon layui-colorpicker-trigger-i layui-icon-down"></i></span></span>
                                </div>
                            </div>
                            <input type="hidden" name="left_li_a_order_color[0]" value="rgb(4, 86, 78)" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-col-sm6 layui-col-md2">
                <div class="layui-card">
                    <div class="layui-card-header">
                        内页背景
                    </div>
                    <div class="layui-card-body layuiadmin-card-list son" selecter_name="body" selecter_name_attr="background">
                        <div class="layui-show-md-inline-block">
                            <div class="selecter layui-inline" id="iframe_bg">
                                <div class="layui-unselect layui-colorpicker">
                                    <span class="layui-colorpicker-trigger-bgcolor"><span class="layui-colorpicker-trigger-span" lay-type="rgba" style="background: rgb(241, 241, 241)"><i class="layui-icon layui-colorpicker-trigger-i layui-icon-down"></i></span></span>
                                </div>
                            </div>
                            <input type="hidden" name="iframe_bg[0]" value="rgb(241, 241, 241)" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--<style id="theme_style"></style>--%>
    <c:if test="${loginUser.type=='0'}">
        <div id="save" class="layui-col-space15" style="bottom: 30px;">
            <input type="hidden" id="index_style" name="index_style" />
            <input type="hidden" id="iframe_style" name="iframe_style" />
            <input type="hidden" id="img_data" name="img" />
            <input type="hidden" id="title" name="title" />
            <img src="" style="display: none;" id="demo" alt="" />
            <span class="layui-btn layui-btn-normal" id="show_create">创作</span>
            <button type="button" class="layui-btn" lay-submit="" lay-filter="add" id="add">保存</button>
            <button type="button" class="layui-btn layui-btn-danger" lay-submit lay-filter="save_out">导出</button>
        </div>
    </c:if>
</form>

<script src="${pageContext.request.contextPath}/resources/plugins/xadmin/js/create.js?id=34"></script>
<link href="${pageContext.request.contextPath}/resources/plugins/xadmin/css/jquery.enjoyhint.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/plugins/xadmin/js/enjoyhint.min.js"></script>

<script>
    $(document).ready(function(){
        var menu = layui.data('menu');
        var menuParam = menu.menuParam;
        if(menuParam!=''&&menuParam!=null){
            menuParam = menuParam.split(",");
            findMenu(menuParam[0],menuParam[1],menuParam[2],menuParam[3]);
            //选中
            $("#li_"+menuParam[0]).addClass("layui-this");
        }else{
            $("#mainMenu").children().children().first().click();
        }
    });


    function showMoreMenu(){
        $("#moreMenu").show();
    }
    function closeMoreMenu(){
        $("#moreMenu").hide();
    }

    //查询菜单
    function findMenu(id,child_num,url,name){
        //切换主菜单清除tab页
        $('.layui-tab-title li[lay-id]').find('.layui-tab-close').click();
        layui.data('menu', {
            key: 'menuParam'
            ,value: id+","+child_num+","+url+","+name
        });
        if(child_num==0){//没有子菜单，直接打开
            $("#left").hide();
            $("#right").attr("style","left:0px");
            if(url.indexOf("http")!=-1){
                xadmin.add_tab(name,url,true);
//                $('.x-iframe').attr('src', url);
            }else{
                xadmin.add_tab(name,"${pageContext.request.contextPath}"+url,true);
                <%--$('.x-iframe').attr('src', "${pageContext.request.contextPath}"+url);--%>
            }
        }else{//获取子菜单数据
            $("#left").show();
            $("#left").attr("style","width:220px");
            $("#right").attr("style","left:220px");
            //查询左侧菜单
            $.ajax({
                type: "GET",//方法类型
                dataType: "json",//预期服务器返回的数据类型
                url: "${pageContext.request.contextPath}/system/menu/findMenuList?id="+id ,//url
                data: {},
                success: function (res) {
                    if (res.success) {
                        var tt = '';
                        $.each(res.data, function (i, n) { //遍历第一个 level_num=2
                            if(n.level_num=='2'){//遍历等级=2的菜单
                                if(n.child_num==0){
                                    var n_url = n.url;
                                    if(n_url.indexOf("http")==-1){
                                        n_url = "${pageContext.request.contextPath}"+n.url;
                                        if(n_url.indexOf("?")!=-1){
                                            n_url = n_url+'&menuAuthId='+ n.id;
                                        }else{
                                            n_url = n_url+'?menuAuthId='+ n.id;
                                        }
                                    }
                                    tt += '<li>';
                                    tt += '<a onclick="xadmin.add_tab(\''+ n.name+'\',\''+ n_url+'\')">';
                                    tt += ' <i class="layui-icon">'+ n.icon+'</i>';
                                    tt += '<cite>'+ n.name+'</cite></a>';
                                    tt += '</li>';
                                }else{
                                    tt += '<li><a href="javascript:;"> <i class="layui-icon" lay-tips="'+ n.name+'">'+ n.icon+'</i>';
                                    tt += '<cite>'+ n.name+'</cite>';
                                    tt += '<i class="iconfont nav_right">&#xe697;</i></a>';
                                    tt += '<ul class="sub-menu">';
                                    $.each(res.data, function (j, m) { //遍历第二个 level_num=3
                                        if(m.level_num=='3' && m.parent_id==n.id){
                                            if(m.child_num==0){
                                                var m_url = m.url;
                                                if(m_url.indexOf("http")==-1){
                                                    m_url = "${pageContext.request.contextPath}"+m.url;
                                                    if(m_url.indexOf("?")!=-1){
                                                        m_url = m_url+'&menuAuthId='+ m.id;
                                                    }else{
                                                        m_url = m_url+'?menuAuthId='+ m.id;
                                                    }
                                                }
                                                tt += '<li>';
                                                tt += '<a onclick="xadmin.add_tab(\''+ m.name+'\',\''+ m_url+'\')">';
                                                tt += ' <i class="layui-icon">'+ m.icon+'</i>';
                                                tt += '<cite>'+ m.name+'</cite></a>';
                                                tt += '</li>';
                                            }else{
                                                tt += '<li><a href="javascript:;"> <i class="layui-icon" lay-tips="'+ m.name+'">'+ m.icon+'</i>';
                                                tt += '<cite>'+ m.name+'</cite>';
                                                tt += '<i class="iconfont nav_right">&#xe697;</i></a>';
                                                tt += '<ul class="sub-menu">';

                                                $.each(res.data, function (k, v) { //遍历第三个 level_num=4
                                                    if(v.level_num=='4' && v.parent_id== m.id){
                                                        var v_url = v.url;
                                                        if(v_url.indexOf("http")==-1){
                                                            v_url = "${pageContext.request.contextPath}"+v.url;
                                                            if(v_url.indexOf("?")!=-1){
                                                                v_url = v_url+'&menuAuthId='+ v.id;
                                                            }else{
                                                                v_url = v_url+'?menuAuthId='+ v.id;
                                                            }
                                                        }
                                                        tt += '<li>';
                                                        tt += '<a onclick="xadmin.add_tab(\''+ v.name+'\',\''+ v_url+'\')">';
                                                        tt += ' <i class="layui-icon">'+ v.icon+'</i>';
                                                        tt += '<cite>'+ v.name+'</cite></a>';
                                                        tt += '</li>';
                                                    }
                                                });

                                                tt += '</ul>';
                                                tt += '</li>';

                                            }
                                        }
                                    });
                                    tt += '</ul>';
                                    tt += '</li>';

                                }
                            }
                        });
                        $("#nav").html(tt);
//                        $("#last_li").before(tt);
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
    }

    //切换组织
    function switchOrganize(){
        parent.layer.open({
            id:'switchOrganize',
            //skin: 'layui-layer-molv',
            title: '组织切换',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/system/user/toSwitchOrganize',
            area: ['600px', '280px'],
            end: function () {
                var val = getOpenCloseParam();
                if(val=="reload"){
                    //切换主菜单清除tab页
                    $('.layui-tab-title li[lay-id]').find('.layui-tab-close').click();
                    window.location.reload();
                }
            }
        });
    }

    function switchTheme(){
        parent.layer.open({
            id:'switchOrganize',
            //skin: 'layui-layer-molv',
            title: '组织主题',
            maxmin: true,
            type: 2,
            content: '${pageContext.request.contextPath}/system/user/toSwitchTheme',
            area: ['800px', '500px'],
            end: function () {
                var val = getOpenCloseParam();
                if(val=="reload"){
                    window.location.reload();
                }
            }
        });
    }

    function showCreate(){
        $("#show_create").click();
    }
</script>
</body>

</html>