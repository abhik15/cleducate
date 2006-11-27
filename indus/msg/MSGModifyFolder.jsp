<%@ page language="java" import="oracle.jdbc.driver.OracleTypes,org.apache.log4j.Category,java.sql.*,com.cl.sql.CLMSPoolManager" errorPage="/msg/MSGErrorPage.jsp"%> 
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>


<%
	String logFile = application.getRealPath("/logs/error/")+"MSGErrorLog.log";
	int cat = 0;
	try
	{
		cat = Integer.parseInt(request.getParameter("cat"));
	}
	catch(NumberFormatException nfe)
	{
		cat = 0;
	}
	request.setAttribute("cat",Integer.toString(cat));
	request.setAttribute("jspname","/msg/MSGInbox.jsp");

	String user = (cat == 0) ? "CUSTOMER" : "EMPLOYEE";
%>

<cl:CLValidateSessionTag userType="<%=user%>"/> 

<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>

<% 
	CallableStatement cstmt = null;
	Connection conn = null;
	CLMSPoolManager pool = CLMSPoolManager.getInstance();
	Category logCategory = null;

	String task = request.getParameter("tk");	//task will be either del [Delete Folder] or ren [Rename Folder]
	int folderId = Integer.parseInt(request.getParameter("fid"));
	int agentId = agent.getAgentID();
	String folderName = request.getParameter("fldr");

	String renameResult = "";
	if(task.equals("del"))	// delete folder
	{
		try
		{
			conn = pool.getConnection("erp");
			cstmt = conn.prepareCall("{call erp.sis_msg.delete_folder(?,?)}");
			cstmt.setInt(1,folderId);
			cstmt.setInt(2,agentId);

			cstmt.execute();
			conn.commit();
			cstmt.close();
		}
		finally
		{
			try
			{
				if(cstmt != null)
					cstmt.close();
			}
			catch(SQLException sqle)
			{
				if(logCategory == null)
					logCategory = Category.getInstance("clsite.msg.MSGModifyFolder");
				logCategory.error(sqle.toString());
			}
			/* # # # # # # # Pool Impl # # # # # # # */
			pool.freeConnection("erp",conn);
		}
	}
	else if(task.equals("ren") && folderName != null && folderName.length() > 0)	// rename folder
	{
		try
		{
			conn = pool.getConnection("erp");
			cstmt = conn.prepareCall("{call erp.sis_msg.rename_folder(?,?,?,?)}");
			cstmt.setInt(1,folderId);
			cstmt.setInt(2,agentId);
			cstmt.setString(3,folderName);
			cstmt.registerOutParameter(4,OracleTypes.VARCHAR);

			cstmt.execute();
			renameResult = cstmt.getString(4);
			conn.commit();
			cstmt.close();
		}
		finally
		{
			try
			{
				if(cstmt != null)
					cstmt.close();
			}
			catch(SQLException sqle)
			{
				logCategory = Category.getInstance("clsite.msg.MSGModifyFolder");
				logCategory.error(sqle.toString());
			}
			/* # # # # # # # Pool Impl # # # # # # # */
			pool.freeConnection("erp",conn);
		}
	}
	response.sendRedirect("/msg/MSGManageFolder.jsp?cat=" + cat + "&ec=" + renameResult);
%>