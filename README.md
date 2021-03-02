# 青锋管理系统是一个后台系统脚手架，使用springboot、layui前端框架、quartz定时任务、druid数据连接池、多数据源、代码生成等多种丰富的功能。并对菜单权限、功能（按钮）权限、数据权限做了很好的处理。

#### 介绍
青锋后台管理系统是一款基于springboot、layui、activiti工作流，实现了代码生成器、自定义表单、拖拽可视化报表大屏的后台脚手架系统，包含基础架构的常用功能，可以拿来即用的脚手架系统。 声明：代码开源之处难免不足之处，还望大家多多指教。

预览地址
[http://xinlingge.cn:8181/qingfeng](http://xinlingge.cn:8181/qingfeng)

账号密码：
admin/123456

项目使用及代码开发-视频教程
https://edu.51cto.com/course/26169.html

文章分享：[今日头条](https://www.toutiao.com/c/user/token/MS4wLjABAAAAIza_5ghlkgfgqnFEcA31C_AtdZX3-H4vg1ig19FUzGY/)

#### 各版本说明
 **一、Shiro版（本版本开源）【持续更新】：** 
1、采用技术：
springboot、layui、Thymeleaf、自定义权限（菜单、功能按钮、数据）、quartz、swagger、druid连接处、多数据源、shiro、redis等技术。
2、功能介绍：
系统管理：用户管理、组织管理、角色管理、菜单管理、字典管理、地区管理、用户组管理。
quartz定时器：Cron表达式生成器、quartz任务管理、业务案例介绍。
日志信息：登录日志、文件日志。
监控管理：数据源监控、服务监控、在线用户。
代码生成器：单表、主子表、树表代码生成。
其他功能：主题设置、swagger接口、新闻公告信息、其他案例信息等。

 **二、Thymeleaf版（开源）【持续更新】：** 
1、采用技术：
springboot、layui、Thymeleaf、自定义权限（菜单、功能按钮、数据）、quartz、swagger、druid连接处、多数据源等技术。
2、功能介绍：
系统管理：用户管理、组织管理、角色管理、菜单管理、字典管理、地区管理、用户组管理。
quartz定时器：Cron表达式生成器、quartz任务管理、业务案例介绍。
日志信息：登录日志、文件日志。
监控管理：数据源监控、服务监控、在线用户。
代码生成器：单表、主子表、树表代码生成。
其他功能：主题设置、swagger接口、新闻公告信息、其他案例信息等。
[去下载](https://gitee.com/msxy/qingfengThymeleaf)

 **三、VUE版（开源）【持续更新】：** 
1、采用技术：
后台接口采用技术：springboot、layui、自定义权限（菜单、功能按钮、数据）、quartz、swagger、druid连接处、多数据源等技术。
VUE版采用框架：基于vue ant design。
2、功能介绍：
系统管理：用户管理、组织管理、角色管理、菜单管理、字典管理、地区管理、用户组管理。
quartz定时器：Cron表达式生成器、quartz任务管理、业务案例介绍。
日志信息：登录日志。
监控管理：数据源监控、服务监控、在线用户。
代码生成器：单表、树表代码生成。
其他功能：主题设置、swagger接口、其他案例信息等。
[去下载](https://gitee.com/msxy/qingfeng-vue)

 **四、activiti版（收费版）【持续更新】：** 
说明：因服务器、空间等需要购买支撑工作，还望理解，不喜勿喷。官方标价：299元，需要者加微信（QF_qingfeng1024）。
1、采用技术：
springboot、layui、Thymeleaf、自定义权限（菜单、功能按钮、数据）、quartz、swagger、druid连接处、多数据源、自定义表单、拖拽echarts报表、activiti工作流等技术。
2、基础功能介绍：
系统管理：用户管理、组织管理、角色管理、菜单管理、字典管理、地区管理、用户组管理。
quartz定时器：Cron表达式生成器、quartz任务管理、业务案例介绍。
日志信息：登录日志、文件日志。
监控管理：数据源监控、服务监控、在线用户。
代码生成器：单表、主子表、树表代码生成。
其他功能：主题设置、swagger接口、新闻公告信息、其他案例信息等。
3、特有功能介绍
可视化数据报表：拖拽设计、静态数据+动态数据配置、支持内外链访问、多主题设置等。
自定义表单管理：数据表分类、自定义数据表、自定义表单、自定义模块、相关案例（无需开发通过配置实现业务功能模块）。
4、activiti工作流
流程设置：流程模型管理、流程定义管理、流程实例管理、流程任务管理。
历史流程：历史流程实例管理、历史流程任务管理。
流程办理：代办任务、已办任务、我发起的任务。
5、核心知识点
自定义表单+activiti工作流整合，无需开发，通过配置即可实现流程业务功能。
基础用户任务流转、网关任务办理、多表单任务管理（根据节点配置表单）、多实例任务管理等。

 **五、青锋家谱系统版（开源版）：** 
基于springboot、orgtree的家谱树管理系统，将纸质版的家谱进行电子化、信息化，建立家族的家谱血脉联系。
项目预览下载地址：[去下载](https://gitee.com/msxy/qingfeng-gen)


#### 软件架构
采用技术：
    springboot
    layui前端框架
    mysql数据库
    druid数据连接池
    多数据源处理
    quartz动态定时器
    freemarker模板
    Shiro权限管理
    redis数据持久化等技术。

#### 安装教程

1、下载项目（在Git中搜索：青锋后台管理系统xxx） 或者打开网址：https://gitee.com/msxy 
![输入图片说明](https://images.gitee.com/uploads/images/2020/1127/134456_8d689b32_395948.png "图片1.png")
2、项目下载
![输入图片说明](https://images.gitee.com/uploads/images/2020/1127/134507_fada01f8_395948.png "图片2.png")
3、将项目导入的本地IDEA 
![输入图片说明](https://images.gitee.com/uploads/images/2020/1127/134516_4543f55e_395948.png "图片3.png")	
4、设置本地maven 
	【file->setting】搜索maven 
![输入图片说明](https://images.gitee.com/uploads/images/2020/1127/134523_1573c581_395948.png "图片4.png")
5、修改数据库连接
![输入图片说明](https://images.gitee.com/uploads/images/2020/1127/134529_938ad7e2_395948.png "图片5.png")
![输入图片说明](https://images.gitee.com/uploads/images/2020/1127/134536_ad465186_395948.png "图片6.png")
6、修改quartz数据源连接
![输入图片说明](https://images.gitee.com/uploads/images/2020/1127/134541_9122aeb4_395948.png "图片7.png")
7、运行说明
![输入图片说明](https://images.gitee.com/uploads/images/2020/1127/134629_0fc0385d_395948.png "图片8.png")
8、shiro版中使用了redis,需要启动redis服务

![输入图片说明](https://images.gitee.com/uploads/images/2020/1127/135457_96004e74_395948.png "图片11.png")

#### 使用说明

为了大家的交流，特建立青锋项目交流群，欢迎大家的加入讨论，**项目中数据库脚本需要加群获取** 。
QQ交流群

![输入图片说明](https://images.gitee.com/uploads/images/2020/1127/134817_654af53d_395948.png "图片9.png")


青锋微信（拉您进群，微信群经常失效！！！）

![输入图片说明](https://images.gitee.com/uploads/images/2020/1213/213839_55ba7bfa_395948.png "qunzhu.png")


