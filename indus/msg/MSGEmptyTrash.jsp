<%@ page language="java" import="org.apache.log4j.Category,oracle.jdbc.driver.OracleTypes,java.sql.*,com.cl.sql.CLMSPoolManager" errorPage="/msg/MSGErrorPage.jsp"%> 
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
	request.setAttribute("jspname","/msg/MSGEmptyTrash.jsp");

	String user = (cat == 0) ? "CUSTOMER" : "EMPLOYEE";
%>

<cl:CLValidateSessionTag userType="<%=user%>"/> 

<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>

<% 
	Category logCategory = null;
	CLMSPoolManager pool = CLMSPoolManager.getInstance();
	Connection conn = null;
	CallableStatement cstmt = null;

	try
	{
		conn = pool.getConnection("erp");
		cstmt = conn.prepareCall("{call erp.sis_msg.empty_trash(?)}");
		cstmt.setInt(1,agent.getAgentID());
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
				logCategory = Category.getInstance("clsite.msg.MSGEmptyTrash");
			logCategory.error(sqle.toString());
		}
		/* # # # # # # # Pool Impl # # # # # # # */
		pool.freeConnection("erp",conn);
	}
	// value will be totrash
	String fwdPage = request.getParameter("fwd");
	if(fwdPage == null)
		response.sendRedirect("/msg/MSGManageFolder.jsp?cat=" + cat);
	else
		response.sendRedirect("/msg/MSGInbox.jsp?cat=" + cat + "&fid=S3&fldr=" + java.net.URLEncoder.encode("Trash Can"));
%>