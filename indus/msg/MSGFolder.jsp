<%@ page import=",org.apache.log4j.Category,java.sql.*,com.cl.sql.CLMSPoolManager" errorPage="/msg/MSGErrorPage.jsp"%> 
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
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rset = null;
	CLMSPoolManager pool = CLMSPoolManager.getInstance();
	Category logCategory = null;

	int folderCount = 0;
	try
	{
		conn = pool.getConnection("erp");
		pstmt = conn.prepareStatement("select count(*) from msg_user_folders where agent_id = ?");
		pstmt.setInt(1,agent.getAgentID());
		
		rset = pstmt.executeQuery();

		rset.next();
		folderCount = rset.getInt("count(*)");
		rset.close();
		pstmt.close();
%>

<html>
<head>
<title>CL Messaging System 2.1 - Create Folder</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="expires" content="0">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">

<link rel="stylesheet" href="/styles/style.css" type="text/css">

</head>
<%
	//put this check here as in case the user has created 10 folders the create folder text box
	// will not be displayed and in that case the onload is not required.
	if(folderCount < 10)
	{
%>
<body onLoad="javascript: document.folderForm.foldername.focus()" bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%	}
	else
	{
%>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%	}%>
<!-- Add top.js for top band -->
<script language="javascript" src="/jscript/top.js"></script>
<table border="0" width="100%" cellspacing="0" cellpadding="3">
<tr valign="top"><td bgcolor="DFE1BC" width="21%" valign="top">
	<cl:CLMsgSisLeftBandTag connObj="<%=conn%>" category="<%=Integer.toString(cat)%>" level="1"/>
</td>
<%
	}
	finally
	{
		pool.freeConnection("erp",conn);
	}
%>
<td width="79%">
	<!-- TOP BAND START -->
	<table align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td bgcolor="B4BC6D">
		<table border="0" cellspacing="0" cellpadding="0">
		<tr><td bgcolor="B4BC6D" height="32" width="10">
				<img src="/img/blank.gif" width="1" height="28">
			</td>
			<td><font class="cntblu">
				<a href="/" class="lnkblu">Home</a><font class="cntblu"> &gt; </font>
				<%= (cat == 1) ? "<a href=\"/clzone/login/CLZone.jsp\" class=\"lnkblu\">CL Zone Home</a>" 
							   : "<a href=\"/sis/SIS.jsp\" class=\"lnkblu\">SIS page</a>" %> &gt; Create New Folder</font>
			</td>
		</tr>
		</table>
	</td></tr></table>
	<!-- TOP BAND END -->

	<form name="folderForm" action="/msg/MSGCreateFolder.jsp" method="post">
	<input type="hidden" name="cat" value="<%=cat%>">
	<table width="85%" cellpadding="3" cellspacing="0" border="0">	
<%
	String errorCode = request.getParameter("ec");
	String folderName = request.getParameter("foldername");
	String errorMessage = "";

	if(errorCode != null && errorCode.equals("DUPLICATE"))
		errorMessage = "Folder <b>" + folderName + "</b> already exits. Please choose another folder name.";
	else if(errorCode != null && errorCode.equals("EMPTY"))
		errorMessage = "Folder Name not provided. Please do not leave Folder Name empty.";
	else if(errorCode != null && errorCode.equals("CREATED"))
		errorMessage = "<font color=\"blue\"><b>Folder Name created successfully.</b></font>";
	else
		errorMessage = "<img src=\"/img/blank.gif\" width=\"2\" height=\"2\">";

	if(folderCount >= 10)
	{
%>
	<tr><td class="cntblu">
			You have reached the maximum number of folders that can be created. 
	</td></tr>
<%	}
	else
	{
%>
	<tr><td class="cnt">
		New Folder Name: <input type="text" name="foldername" size="25" maxlength="25" title="Enter new folder name to create.">
		&nbsp;&nbsp;&nbsp;<input type="submit" value="Create Folder" title="Click here to create new folder.">
	</td></tr>
	<tr><td class="cnt">
		<font color="red"><%=errorMessage%></font>
	</td></tr>
<%	}%>
	</table>
</td></tr>
</table>
</body>
</html>


