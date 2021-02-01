<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../system/admin/top.jsp"%>
<style>
    .layui-table td {
         padding: 10px;
    }
    .layui-table td, .layui-table th {
        border-width: 0px;
        border-style: solid;
        border-color: #e6e6e6;
        border-bottom: 1px solid #e6e6e6;
        padding-left: 10px;
    }

</style>
<div class="x-nav">
            <span class="layui-breadcrumb">
                <a><cite>监控管理</cite></a>
                <a><cite>服务监控</cite></a>
            </span>
    <a class="layui-btn layui-btn-sm" style="line-height:1.6em;margin-top:3px;float:right" href="javascript:location.reload();" title="刷新">
        <i class="layui-icon layui-icon-refresh" style="line-height:30px"></i>
    </a>
</div>
<div style="padding: 10px; background-color: #F2F2F2;">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-md6">
            <div class="layui-card">
                <div class="layui-card-header">CPU</div>
                <div class="layui-card-body">
                    <table class="layui-table">
                        <colgroup>
                            <col width="150">
                            <col width="150">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>属性</th>
                            <th>值</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>核心数</td>
                            <td>${server.cpu.cpuNum}0个</td>
                        </tr>
                        <tr>
                            <td>用户使用率</td>
                            <td>${server.cpu.used}%</td>
                        </tr>
                        <tr>
                            <td>系统使用率</td>
                            <td>${server.cpu.sys}%</td>
                        </tr>
                        <tr>
                            <td>当前空闲率</td>
                            <td>${server.cpu.free}%</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="layui-col-md6">
            <div class="layui-card">
                <div class="layui-card-header">内存</div>
                <div class="layui-card-body">
                    <table class="layui-table">
                        <colgroup>
                            <col width="150">
                            <col width="150">
                            <col width="150">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>属性</th>
                            <th>内存</th>
                            <th>JVM</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>总内存</td>
                            <td>${server.mem.total}GB</td>
                            <td>${server.jvm.total}MB</td>
                        </tr>
                        <tr>
                            <td>已用内存</td>
                            <td>${server.mem.used}GB</td>
                            <td>${server.jvm.used}MB</td>
                        </tr>
                        <tr>
                            <td>剩余内存</td>
                            <td>${server.mem.free}GB</td>
                            <td>${server.jvm.free}MB</td>
                        </tr>
                        <tr>
                            <td>使用率</td>
                            <td <c:if test="${server.mem.usage gt 80}"> style="color: red" </c:if>>${server.mem.usage}%</td>
                            <td <c:if test="${server.jvm.usage gt 80}"> style="color: red" </c:if>>${server.jvm.usage}%</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-header">服务器信息</div>
                <div class="layui-card-body">
                    <table class="layui-table">
                        <colgroup>
                            <col width="150">
                            <col width="150">
                            <col width="150">
                            <col width="150">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>服务器名称</th>
                            <th>服务器IP</th>
                            <th>操作系统</th>
                            <th>系统架构</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>${server.sys.computerName}</td>
                            <td>${server.sys.osName}</td>
                            <td>${server.sys.computerIp}</td>
                            <td>${server.sys.osArch}</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-header">Java虚拟机信息</div>
                <div class="layui-card-body">
                    <table class="layui-table">
                        <tbody>
                        <tr>
                            <td>Java名称</td>
                            <td>${server.jvm.name}</td>
                            <td>Java版本</td>
                            <td>${server.jvm.version}</td>
                        </tr>
                        <tr>
                            <td>启动时间</td>
                            <td>${server.jvm.startTime}</td>
                            <td>运行时长</td>
                            <td>${server.jvm.runTime}</td>
                        </tr>
                        <tr>
                            <td>安装路径</td>
                            <td>${server.jvm.home}</td>
                            <td>项目路径</td>
                            <td>${server.sys.userDir}</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-header">磁盘状态</div>
                <div class="layui-card-body">
                    <table class="layui-table">
                        <colgroup>
                            <col width="150">
                            <col width="150">
                            <col width="150">
                            <col width="150">
                            <col width="150">
                            <col width="150">
                            <col width="150">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>盘符路径</th>
                            <th>文件系统</th>
                            <th>盘符类型</th>
                            <th>总大小</th>
                            <th>可用大小</th>
                            <th>已用大小</th>
                            <th>已用百分比</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                        <c:forEach items="${server.sysFiles}" var="sysFile" varStatus="status">
                        <tr>
                            <td>${sysFile.dirName}</td>
                            <td>${sysFile.sysTypeName}</td>
                            <td>${sysFile.typeName}</td>
                            <td>${sysFile.total}</td>
                            <td>${sysFile.free}</td>
                            <td>${sysFile.used}</td>
                            <td>${sysFile.usage}%</td>
                        </c:forEach>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>
</div>


<%@include file="../../system/admin/bottom.jsp"%>