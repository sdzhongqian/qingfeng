<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no"/>
    <title>图片水印案例</title>
</head>
<body>
<div align="center">
    <h3>默认图片</h3>
    <img class="sample1" data-img2blob="${pageContext.request.contextPath}/resources/images/img2blob/1.png" />
    <img class="sample1" data-img2blob="${pageContext.request.contextPath}/resources/images/img2blob/2.png" />
    <hr>
    <h3>添加水印之后的图片</h3>
    <img class="sample2" data-img2blob="${pageContext.request.contextPath}/resources/images/img2blob/1.png" />
    <img class="sample2" data-img2blob="${pageContext.request.contextPath}/resources/images/img2blob/2.png" />
</div>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/img2blob.js"></script>
<script type="text/javascript">
    $(function() {
        // default
        $(".sample1").img2blob();
        // with watermark
        $(".sample2").img2blob({
            watermark: '青锋剑在手,天下任我走',
            fontStyle: 'Microsoft YaHei,Arial',
            fontSize: '18', // px
            fontColor: '#fff', // default 'black'
            fontX: 180, // The x coordinate where to start painting the text
            fontY: 280 // The y coordinate where to start painting the text
        });
    });
</script>
</body>
</html>
