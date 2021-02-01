<%@ page contentType="text/html;charset=UTF-8" language="java" %>

</body>
<script>

    function loseSession(msg,url){
        layer.msg(msg,{
            offset:['30%'],
            time: 2000 //2秒关闭（如果不配置，默认是3秒）
        },function(){
            outLogin(url);
        });
    }

    function outLogin(url){
        window.open (url,'_top')
    }

</script>
</html>