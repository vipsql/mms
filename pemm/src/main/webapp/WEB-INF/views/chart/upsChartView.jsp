<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>UPS统计报表</title>
<%@ include file="/WEB-INF/views/include/easyui.jsp"%>
<script type="text/javascript"
	src="${ctx }/static/plugins/echarts/dist/echarts.js"></script>
<script type="text/javascript"
	src="${ctx }/static/js/chart/upsChartView.js"></script>
	
<style type="text/css">
html, body {
	height: 100%;
	margin: 0px;
}
</style>	
</head>
<body>
	<div class="easyui-layout" data-options="fit:true">
		<div
			data-options="region:'west',title:'区域导航',iconCls:'icon-standard-map',split:true,minWidth: 200, maxWidth: 400,width:220">

			<ul id="areaInfoTree"></ul>
		</div>
		<div data-options="region:'center'" style="overflow: hidden;">
			<iframe frameborder="0" style="margin: 0" width="100%" height="100%" src="${ctx }/chart/gitInfoView">
			
			</iframe>
		</div>

	</div>
</body>
</html>