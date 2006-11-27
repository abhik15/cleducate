<%@ page import="java.sql.*,com.cl.sql.CLMSPoolManager" errorPage="/msg/MSGErrorPage.jsp"%>
<%@ page import="oracle.jdbc.driver.OracleTypes,org.apache.log4j.Category" %>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>

<% 
	Connection conn = null;
	CLMSPoolManager pool = CLMSPoolManager.getInstance();
	Category logCategory = null;
	String PKG_NAME = "clsite.msg.MSGCreateFolder";

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
	int agentId = agent.getAgentID();
	String folderName = request.getParameter("foldername");
	if(folderName == null || folderName.trim().length() == 0)
	{
%>
	<jsp:forward page="/msg/MSGFolder.jsp">
		<jsp:param name="cat" value="<%=cat%>"/>
		<jsp:param name="ec" value="EMPTY"/>
	</jsp:forward>
<%
	}
	String createResult = "";
	CallableStatement cstmt = null;
	try
	{
		conn = pool.getConnection("erp");
		cstmt = conn.prepareCall("{call erp.sis_msg.create_folder(?,?,?)}");
		cstmt.setInt(1,agentId);
		cstmt.setString(2,folderName);
		cstmt.registerOutParameter(3,OracleTypes.VARCHAR);

		cstmt.execute();
		// possible values: SYSTEM_FOLDER | CREATED | DUPLICATE
		createResult = cstmt.getString(3);
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
		catch(SQLException sql)
		{
			if(logCategory == null)
				logCategory = Category.getInstance(PKG_NAME);
			logCategory.error(sql.toString());
		}
		pool.freeConnection("erp",conn);
	}
	if(createResult.equals("SYSTEM_FOLDER") || createResult.equals("DUPLICATE"))
	{
%>
	<jsp:forward page="/msg/MSGFolder.jsp">
		<jsp:param name="cat" value="<%=cat%>"/>
		<jsp:param name="ec" value="DUPLICATE"/>
	</jsp:forward>
<%	
	}
	else
	{
%>
	<jsp:forward page="/msg/MSGFolder.jsp">
		<jsp:param name="cat" value="<%=cat%>"/>
		<jsp:param name="ec" value="CREATED"/>
	</jsp:forward>
<%	}
%>