<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>青锋系统管理平台</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,user-scalable=yes, minimum-scale=0.4, initial-scale=0.8,target-densitydpi=low-dpi" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/xadmin/css/font.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/plugins/xadmin/css/xadmin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/com.qingfeng.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/scroll/smallscroll.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-1.9.1.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/xadmin/lib/layui/layui.js" charset="utf-8"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/xadmin/js/xadmin.js"></script>
    <!--[if lt IE 9]>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/xadmin/js/html5.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/plugins/xadmin/js/respond.min.js"></script>
    <![endif]-->
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfCommon.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/qfPassValue.js"></script>
    <input type="hidden" id="ctxValue" value="${pageContext.request.contextPath}">
</head>

<body>