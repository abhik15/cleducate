<%@ page language="java"  import="java.sql.*,org.apache.log4j.Category" errorPage="/msg/MSGErrorPage.jsp"%>
<%@ page import="oracle.jdbc.driver.OracleTypes,com.cl.sql.PoolManager" %>

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

<jsp:useBean id="agent" type="com.cl.msg.MSGAgent" scope="session" />

<% 
	PoolManager pool = PoolManager.getInstance();
	Connection conn = null;
	CallableStatement cstmt = null;

	Category logCategory = null;
	String PKG_NAME = "clsite.msg.MSGMoveMessage.jsp";

	String srcFolderId = request.getParameter("fid");
	String srcFolderName = request.getParameter("fldr");
	String category = request.getParameter("cat");
	if(category == null)
		category = "0";

	String pageNo = request.getParameter("pn");

	String[] msgIds = request.getParameterValues("msgs");
	String folderId = request.getParameter("tofid");
	String folderType = (folderId.startsWith("S")) ? "SYSTEM" : "USER";
	try
	{
		conn = pool.getConnection("erp");
		for(int i=0; i<msgIds.length; i++)
		{
			cstmt = null;
			cstmt = conn.prepareCall("{call erp.sis_msg.move_message(?,?,?,?)}");
			cstmt.setInt(1,Integer.parseInt(msgIds[i]));
			cstmt.setInt(2,agent.getAgentID());
			cstmt.setInt(3,Integer.parseInt(folderId.substring(1)));
			cstmt.setString(4,folderType);

			cstmt.execute();
			conn.commit();

			cstmt.close();
		}
	}
	finally
	{
		try
		{
			if(cstmt != null)
				cstmt.close();
		}
		catch(SQLException sql)
		{
			if(logCategory == null)
				logCategory = Category.getInstance("clsite.msg.MSGFolderDropDown");
			logCategory.error(sql.toString());
		}
		pool.freeConnection("erp",conn);
	}
	response.sendRedirect("/msg/MSGInbox.jsp?cat=" + category + "&fid=" + srcFolderId + "&fldr=" + srcFolderName + "&pn=" + pageNo);
%>
