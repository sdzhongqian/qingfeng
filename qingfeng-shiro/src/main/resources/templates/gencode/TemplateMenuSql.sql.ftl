<#list menuList as obj>
<#if obj.type == 'menu'>
-- 生成菜单
</#if>
<#if obj.type == 'button'>
<#if obj.code == 'add'>
-- 生成添加按钮
</#if>
<#if obj.code == 'edit'>
-- 生成编辑按钮
</#if>
<#if obj.code == 'del'>
-- 生成删除按钮
</#if>
<#if obj.code == 'info'>
-- 生成详情按钮
</#if>
<#if tablePd.more_add == '1'>
<#if obj.code == 'addMore'>
-- 生成批量添加按钮
</#if>
<#if (obj.code == 'setStatus') && (tablePd.status_type == '0' || tablePd.status_type == '1')>
-- 生成状态管理按钮
</#if>
</#if>
</#if>
insert into system_menu (id,menu_cascade,name,code,parent_id,url,icon,type,level_num,order_by,remark,create_time,create_user,create_organize)
	values
	('${obj.id}','${obj.menu_cascade}','${obj.name}','${obj.code}','${obj.parent_id}','${obj.url}','${obj.icon}','${obj.type}','${obj.level_num}','${obj.order_by}','${obj.remark}','${obj.create_time}','${obj.create_user}','${obj.create_organize}');
</#list>
