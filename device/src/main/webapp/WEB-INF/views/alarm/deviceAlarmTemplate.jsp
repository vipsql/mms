<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>设备告警业务模板</title>
<%@ include file="/WEB-INF/views/include/easyui.jsp"%>
<script type="text/javascript" src="${ctx }/static/js/alarm/deviceAlarmTemplate.js">


</script>
<style type="text/css">
.formTable td {
	line-height: 30px;
}
.formTable {
	margin: 0px;
	padding: 10px;
}
.condition_a{
	text-decoration:none;
	color:black;
}
</style>


</head>
<body>
	<div class="easyui-layout" data-options="fit:true">
		<div data-options="region:'west',split:true,width:500,title:'设备告警模板'">
			<div id="template_tb">
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addTemplate();">添加</a> 
				<span class="toolbar-item dialog-tool-separator"></span> 
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" data-options="disabled:false" onclick="delTemplate()">删除</a> 
				<span class="toolbar-item dialog-tool-separator"></span>
				<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="updateTemplate()">修改</a>
			</div>
			<div id="template_dg"></div>
			<div id="template_dlg"></div>
		</div>
		<%-- <div data-options="region:'center',href :'${ctx }/system/deviceAlarmRule',title:'设备告警规则'" >
		
		</div> --%>
		<div data-options="region:'center'">
			<div class="easyui-layout" data-options="fit:true" id="right_panel">
			</div>
		</div>
	</div>
</body>
</html>