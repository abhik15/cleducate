<%@ page language="java" import="oracle.jdbc.driver.OracleTypes,org.apache.log4j.Category,java.sql.*,com.cl.sql.PoolManager" errorPage="/msg/MSGErrorPage.jsp"%> 
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
	int folderId = Integer.parseInt(request.getParameter("fid"));
	int agentId = agent.getAgentID();
	CallableStatement cstmt = null;
	Connection conn = null;
	PoolManager pool = PoolManager.getInstance();
	Category logCategory = null;

	try
	{
		conn = pool.getConnection("erp");
		cstmt = conn.prepareCall("{call erp.sis_msg.delete_folder(?,?)}");
		cstmt.setInt(1,folderId);
		cstmt.setInt(2,agentId);

		cstmt.execute();
		conn.commit();
	}
	finally
	{
		if(cstmt!=null)
		{
			try
			{
				cstmt.close();
			}
			catch(SQLException sqle)
			{
				logCategory = Category.getInstance("clsite.msg.MSGDeleteFolder");
				logCategory.error(sqle.toString());
			}
			cstmt = null;
		}
		/* # # # # # # # Pool Impl # # # # # # # */
		pool.freeConnection("erp",conn);
	}
	response.sendRedirect("/msg/MSGManageFolder.jsp?cat=" + cat);
%>