<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="/WEB-INF/views/include/easyui.jsp" %>
<script src="${ctx}/static/plugins/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
</head>
<body>
<div id="tb" style="padding: 5px;height: auto;">
   <div>
		<form id="searchForm" action="">
       	        <input type="text" id="identifierFind" name="problemCode" class="easyui-validatebox" data-options="width:150,prompt: '问题编号'"/>
       	        <input type="text" id="problemTypeFind" name="problemTypeId" class="easyui-validatebox" data-options="width:150,prompt: '问题类型'"/>
       	        <input type="text" id="enableFind" name="enable" class="easyui-validatebox" data-options="width:150,prompt: '状态'"/>
		        <input type="text" id="startDate" name="recordTime" class="easyui-my97" datefmt="yyyy-MM-dd" data-options="width:150,prompt: '开始日期(登记)'" />
		        - <input type="text" id="endDate" name="recordEndTime" class="easyui-my97" datefmt="yyyy-MM-dd" data-options="width:150,prompt: '结束日期(登记)'"/>
		        <span class="toolbar-item dialog-tool-separator"></span>
		        <a href="javascript(0)" class="easyui-linkbutton" iconCls="icon-search" plain="true" onclick="cx()">查询</a>
			</form>
     <shiro:hasPermission name="maintenance:handling:update">
    	 <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="add();">更新处理描述</a>
     </shiro:hasPermission>
     <shiro:hasPermission name="maintenance:handling:search">
         <span class="toolbar-item dialog-tool-separator"></span>
         <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search" plain="true" onclick="view();">处理历史记录</a>
     </shiro:hasPermission>
     <shiro:hasPermission name="maintenance:handling:callback">
         <span class="toolbar-item dialog-tool-separator"></span>
         <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="callback();">打回</a>
     </shiro:hasPermission>
   </div>
</div>
   <table id="dg"></table>
   <div id="dlg"></div>
<script type="text/javascript">
	var dg;
	var dlg;
	$(function(){
		dg=$('#dg').datagrid({
			  method:"get",
			  url:'${ctx}/maintenance/handling/problem',
			  fit:true,
			  fitColumns:true,
		      animate:true,
		      striped:true,
		  	  pagination:true,
			  rownumbers:true,
			  pageNumber:1,
			  pageSize : 20,
			  pageList : [ 10, 20, 30, 40, 50 ],
		      singleSelect:true,
		      columns:[[
		          {
		        	  field:'id',
		        	  title:'id',
		        	  hidden:true
		        }, {
		        	field:'problemCode',
		        	title:'问题编号',
		        	sortable:true,
		        	width:100
		        }, {
		        	field:'problemType',
		        	title:'问题类型',
		        	sortable:true,
		        	width:100
		        }, {
		        	field:'deviceName',
		        	title:'设备名称',
		        	sortable:true,
		        	width:100
		        }, {
		        	field:'identifier',
		        	title:'设备编号',
		        	sortable:true,
		        	width:100
		        }, {
		        	field:'orgName',
		        	title:'所属网点',
		        	sortable:true,
		        	width:100
		        }, {
		        	field:'recordUserName',
		        	title:'登记人',
		        	sortable:true,
		        	width:100
		        }, {
		        	field:'recordTime',
		        	title:'登记时间',
		        	sortable:true,
		        	formatter : function(value, row, index) {
		        		return formatDate(value,"yyyy-MM-dd HH:mm:ss");
		        	}
		        }, {
		        	field:"reportWay",
		        	title:"上报渠道",
		        	width:100,
		        	formatter : function(value, row, index) {
		        		return value.name;
		        	}
		        }, {
		        	field:'enable',
		        	title:'问题状态',
		        	sortable:true,
		        	width:100,
		        	formatter : function(value, row, index) {
		        		return value.name;
		        	}
		        }, {
		        	field:'resolveUserName',
		        	title:'解决人',
		        	sortable:true,
		        	width:100
		        }
		      ]],
		      toolbar:'#tb'
		  });
		
		$.ajax({
			url:'${ctx}/maintenance/problemType/list',
			type : "get",
			dataType : "json",
			success : function(data) {
				var json = {"id":"","name":"—全部—"};
				data.push(json);
				data.reverse();
				$('#problemTypeFind').combobox({
					  valueField:'id',
					  textField:'name',
					  data : data
				  });
			}
		});
		
		
		$('#enableFind').combobox({
			  method:"get",
			  url:'${ctx}/maintenance/problem/enable/handle/true/search/true',
			  valueField:'problemStatus',
			  textField:'name'
		  });
		
		
		initDateFilter("startDate","endDate");
	});
	
	 //添加弹窗
	function add(){
		var row=dg.datagrid('getSelected');
		  if(rowIsNull(row)) return;
		  dlg=$('#dlg').dialog({
			  title:'更新问题处理过程',
			  iconCls:'icon-edit',
			  width:350,
			  height:350,
			  href:'${ctx}/maintenance/handling/create/problemId/' + row.id,
			  modal:true,
			  buttons:[{
				  text:'确认',
				  handler:function(){
					 $('#mainform').submit();
				  }
			   },
			   {
				  text:'取消',
				  handler:function(){
					  dlg.panel('close');
				  }
			    }]
		  })
	  }
	  
	  //修改弹窗
	  function view(){
		  var row=dg.datagrid('getSelected');
		  if(rowIsNull(row)) return;
			  dlg=$('#dlg').dialog({
				  title:'问题处理过程记录',
				  width:800,
				  height:500,
				  iconCls:'icon-search',
				  href:'${ctx}/maintenance/handling/list/problemId/'+row.id,
				  modal:true,
				  buttons:[{
						text:'关闭',
						handler:function(){
							 dlg.panel('close');
					    }
					}]
				});
		}
	  
	  function cx(){
			var obj=$("#searchForm").serializeObject();
			dg.datagrid('load',obj); 
		}
	  
	  function callback(){
		  var row=dg.datagrid('getSelected');
		  if(rowIsNull(row)) return;
			  parent.$.messager.confirm('提示','您确定要打回吗？',function(data){
				  if(data){
					  $.ajax({
						  type:'post',
						  url:'${ctx}/maintenance/handling/create',
						  data : {
							  		"problemId" : row.id,
									"enable" : "CALLBACK",
									"description" : "打回问题"
								},
						  success:function(data){
							  if(data=='success'){
									parent.$.messager.show({ title : "提示",msg: "操作成功！", position: "bottomRight" });
									dg.datagrid('reload');
							 }
						  }
					  });
				  }
			  });
	  }
	  
	  /* function reset(){
		  $("#identifierFind").val("");
		  $("#problemTypeFind").combobox().clear;
		  $("#enableFind").combobox().clear;
		  $("#startDate").my97("setValue","");
		  $("#endDate").my97("setValue","");
	  } */
	
</script>

</body>
</html>
	
	
	
	
	
	
	
	
	
	
	
	
	
	