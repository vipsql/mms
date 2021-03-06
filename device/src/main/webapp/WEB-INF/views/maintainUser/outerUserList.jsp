<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title></title>
<%@ include file="/WEB-INF/views/include/easyui.jsp"%>
<script src="${ctx}/static/plugins/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
</head>
<body>
<div id="tb" style="padding:5px;height:auto">
        <div>
        	<form id="searchFrom" action="">
       	        <input type="text" name="filter_LIKES_name" class="easyui-validatebox" data-options="width:150,prompt: '昵称'"/>
       	        <input type="text" name="filter_LIKES_phone" class="easyui-validatebox" data-options="width:150,prompt: '电话'"/>
		        <input type="text" id="startDate" name="filter_GTD_createDate" class="easyui-my97" datefmt="yyyy-MM-dd" data-options="width:150,prompt: '开始日期(创建)'" />
		        - <input type="text" id="endDate" name="filter_LTD_createDate" class="easyui-my97" datefmt="yyyy-MM-dd" data-options="width:150,prompt: '结束日期(创建)'"/>
		        <span class="toolbar-item dialog-tool-separator"></span>
		        <a href="javascript(0)" class="easyui-linkbutton" iconCls="icon-search" plain="true" onclick="cx()">查询</a>
			</form>
			
	       	<shiro:hasPermission name="sys:user:add">
	       		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="add();">添加</a>
	       		<span class="toolbar-item dialog-tool-separator"></span>
	       	</shiro:hasPermission>
	       	<shiro:hasPermission name="sys:user:delete">
	            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" data-options="disabled:false" onclick="del()">删除</a>
	        	<span class="toolbar-item dialog-tool-separator"></span>
	        </shiro:hasPermission>
	        <shiro:hasPermission name="sys:user:update">
	            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="upd()">修改</a>
	            <span class="toolbar-item dialog-tool-separator"></span>
	        </shiro:hasPermission>
	        <shiro:hasPermission name="sys:user:roleView">
        		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-hamburg-suppliers" plain="true" onclick="userForRole()">用户角色</a>
        	</shiro:hasPermission>
        	<shiro:hasPermission name="sys:user:orgView">
        		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cologne-home" plain="true" onclick="userForOrg()">用户所属机构</a>
        		<span class="toolbar-item dialog-tool-separator"></span>
        	</shiro:hasPermission>
        	<shiro:hasPermission name="sys:user:resetPwd">
        		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cologne-home" plain="true" onclick="resetPwd()">初始化密码</a>
        	</shiro:hasPermission>
        	    <a href="javascript:void(0)" class="easyui-menubutton" plain="true" data-options="menu:'#exportExcel',iconCls:'icon-standard-page-excel'">Excel</a>
        </div> 
        <div id="exportExcel">
			<div data-options="iconCls:'icon-standard-page-excel'">导入Excel</div>
			<div data-options="iconCls:'icon-standard-page-excel'">导出Excel</div>
		</div>
  </div>
<table id="dg"></table>
<div id="dlg"></div>  
<script type="text/javascript">
var dg;
var d;
$(function(){   
	dg=$('#dg').datagrid({    
	method: "POST",
    url:'${ctx}/device/user/json', 
    fit : true,
	fitColumns : true,
	border : false,
	idField : 'id',
	striped:true,
	pagination:true,
	rownumbers:true,
	pageNumber:1,
	pageSize : 20,
	pageList : [ 10, 20, 30, 40, 50 ],
	singleSelect:true,
    columns:[[    
        {field:'id',title:'id',hidden:true},    
        {field:'loginName',title:'用户名',sortable:true,width:100},    
        {field:'name',title:'昵称',sortable:true,width:100},
        {field:'gender',title:'性别',sortable:true,
        	formatter : function(value, row, index) {
       			return value==1?'男':'女';
        	}
        },
        {field:'email',title:'email',sortable:true,width:100},
        {field:'phone',title:'电话',sortable:true,width:100},
        {field:'loginCount',title:'登录次数',sortable:true},
        {field:'previousVisit',title:'上一次登录',sortable:true,formatter: function(value,row,index){
        	return formatDate(value,"yyyy-MM-dd HH:mm:ss")
        }}
    ]],
    headerContextMenu: [
        {
            text: "冻结该列", disabled: function (e, field) { return dg.datagrid("getColumnFields", true).contains(field); },
            handler: function (e, field) { dg.datagrid("freezeColumn", field); }
        },
        {
            text: "取消冻结该列", disabled: function (e, field) { return dg.datagrid("getColumnFields", false).contains(field); },
            handler: function (e, field) { dg.datagrid("unfreezeColumn", field); }
        }
    ],
    enableHeaderClickMenu: true,
    enableHeaderContextMenu: true,
    enableRowContextMenu: false,
    toolbar:'#tb'
	});
	
	initDateFilter("startDate","endDate");
});

//弹窗增加
function add() {
	d=$("#dlg").dialog({   
	    title: '添加用户',    
	    width: 380,    
	    height: 380,    
	    href:'${ctx}/device/user/create',
	    maximizable:true,
	    modal:true,
	    buttons:[{
			text:'确认',
			handler:function(){
				$("#mainform").submit(); 
			}
		},{
			text:'取消',
			handler:function(){
					d.panel('close');
				}
		}]
	});
}
function resetPwd(id){
	var row = dg.datagrid('getSelected');
	if(rowIsNull(row)) return;
	parent.$.messager.confirm("提示","是否确认初始化密码？",function(data){
		if(data){
			$.ajax({
				type:'get',
				url:"${ctx}/device/user/resetPwd/"+row.id,
				success: function(data){
					var result=data.result;
					var message=data.message;
					
					if(result=='success'){
						if(dg!=null)
							dg.datagrid('reload');
						if(d!=null)
							d.panel('close');
						parent.$.messager.show({ title : "提示",width:350,msg: message, position: "topCenter" });
						return true;
					}else{
						parent.$.messager.alert(messag);
						return false;
					}  
				}
			});
		}
	});
}

//删除
function del(){
	var row = dg.datagrid('getSelected');
	if(rowIsNull(row)) return;
	parent.$.messager.confirm('提示', '删除后无法恢复您确定要删除？', function(data){
		if (data){
			$.ajax({
				type:'get',
				url:"${ctx}/device/user/delete/"+row.id,
				success: function(data){
					successTip(data,dg);
					dg.treegrid('clearSelections');
				}
			});
		} 
	});
}

//弹窗修改
function upd(){
	var row = dg.datagrid('getSelected');
	if(rowIsNull(row)) return;
	d=$("#dlg").dialog({   
	    title: '修改用户',    
	    width: 380,    
	    height: 340,    
	    href:'${ctx}/device/user/update/'+row.id,
	    maximizable:true,
	    modal:true,
	    buttons:[{
			text:'修改',
			handler:function(){
				$('#mainform').submit(); 
			}
		},{
			text:'取消',
			handler:function(){
					d.panel('close');
				}
		}]
	});
}

//用户角色弹窗
function userForRole(){
	var row = dg.datagrid('getSelected');
	if(rowIsNull(row)) return;
	$.ajaxSetup({type : 'GET'});
	d=$("#dlg").dialog({   
	    title: '用户角色管理',    
	    width: 580,    
	    height: 350,  
	    href:'${ctx}/device/user/'+row.id+'/userRole',
	    maximizable:true,
	    modal:true,
	    buttons:[{
			text:'确认',
			handler:function(){
				saveUserRole();
				d.panel('close');
			}
		},{
			text:'取消',
			handler:function(){
					d.panel('close');
			}
		}]
	});
}
//用户机构弹窗
function userForOrg(){
	var row = dg.datagrid('getSelected');
	if(rowIsNull(row)) return;
	$.ajaxSetup({type : 'GET'});
	d=$("#dlg").dialog({   
	    title: '供应商或运维人员隶属机构管理',    
	    width: 580,    
	    height: 350,  
	    href:'${ctx}/device/user/'+row.id+'/userOrg',
	    maximizable:true,
	    modal:true,
	    buttons:[{
			text:'确认',
			handler:function(){
				saveUserOrg();
				d.panel('close');
			}
		},{
			text:'取消',
			handler:function(){
					d.panel('close');
			}
		}]
	});
}

//查看
function look(){
	var row = dg.datagrid('getSelected');
	if(rowIsNull(row)) return;
	d=$("#dlg").dialog({   
	    title: '修改供应商或运维人员',    
	    width: 380,    
	    height: 340,    
	    href:'${ctx}/device/user/update/'+row.id,
	    maximizable:true,
	    modal:true,
	    buttons:[{
			text:'取消',
			handler:function(){
					d.panel('close');
				}
		}]
	});
}

//创建查询对象并查询
function cx(){
	var obj=$("#searchFrom").serializeObject();
	dg.datagrid('load',obj); 
}


//权限移交
function transmit(){
	var row = dg.datagrid('getSelected');
	if(rowIsNull(row)) return;
	parent.$.messager.confirm("提示","是否确认权限移交？",function(data){
		if(data){
			$.ajax({
				type:'get',
				url:"${ctx}/device/user/transmit/"+row.id,
				success: function(data){
					var result=data.result;
					var message=data.message;
					
					if(result=='success'){
						if(dg!=null)
							dg.datagrid('reload');
						if(d!=null)
							d.panel('close');
						parent.$.messager.show({ title : "提示",width:350,msg: message, position: "topCenter" });
						parent.window.mainpage.mainTabs.refCurrentTab();
						return true;
					}else{
						parent.$.messager.alert(message);
						return false;
					}  
				}
			});
		}
	});
}

//权限移交撤销
function cancelTransmit(){
	parent.$.messager.confirm("提示","是否确认撤销权限移交？",function(data){
		if(data){
			$.ajax({
				type:'get',
				url:"${ctx}/device/user/cancelTransmit",
				success: function(data){
					var result=data.result;
					var message=data.message;
					
					if(result=='success'){
						if(dg!=null)
							dg.datagrid('reload');
						if(d!=null)
							d.panel('close');
						parent.$.messager.show({ title : "提示",width:350,msg: message, position: "topCenter" });
						parent.window.mainpage.mainTabs.refCurrentTab();
						return true;
					}else{
						parent.$.messager.alert(message);
						return false;
					}  
				}
			});
		}
	});
}

</script>
</body>
</html>