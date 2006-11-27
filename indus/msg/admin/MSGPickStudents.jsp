<%@ page import="java.sql.Connection,com.cl.sql.CLMSPoolManager"  errorPage="/msg/MSGErrorPage.jsp"%>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl"%>
<cl:CLValidateSessionTag />
<%--
  -- Filename:	 MSGPickStudents.jsp
  -- Author:     Shilpa Arora
  -- Create Date:5th June 2002 
  --%>

<%
	int cat=1;
	request.setAttribute("cat",Integer.toString(cat));
	request.setAttribute("jspname","/msg/MSGPickStudents.jsp");
	String logFile = application.getRealPath("/logs/error/") + "MSGErrorLog.log";
%>
	<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
	<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="studentPicker" class="com.cl.msg.admin.MSGStudentPicker" scope="page" />
	<jsp:setProperty name="studentPicker" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="appPrivilege" scope="session" type="com.cl.clzone.login.AppPrivilege"/>
<%
	//int qID = 0;
	//int payloadID = 0;
	//boolean reply = false;
	//int msgID = 0;
	//String receiver = "";
	String privilege[][] = null;
	CLMSPoolManager clmsPool = CLMSPoolManager.getInstance();
	Connection conn = null;

	request.setAttribute("cat",Integer.toString(cat));
	request.setAttribute("jspname","/msg/MSGSPickStudents.jsp");
	String qid = request.getParameter("qid");
	String pid = request.getParameter("pid");
	try
	{
		conn = clmsPool.getConnection("erp");
		privilege= studentPicker.getPrivileges(conn,agent.getPkID());
	if(privilege.length == 1)
	{
%>
		<jsp:forward page="/msg/admin/MSGDisplayPrivilege.jsp">
		<jsp:param name="privilege" value="<%=privilege[0][0] %>" />
		</jsp:forward>
<%
	}
	else
	{
%>
	<html>
	<head>
	<title>Choose Your criteria</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache">

	<link rel="stylesheet" href="/styles/style.css" type="text/css">
	<script language="javascript">
	<!--
		function popup(qid)
		{
			tagpopup= window.open("/msg/MSGReceivers.jsp?qid="+qid,"registration","status=no,resize=yes,toolbar=no,scrollbars=yes,width=300,height=250");
		}
	// -->
	</script>
	</head>
	<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
	<!-- Add top.js for top band -->
	<script language="javascript" src="/jscript/top.js"></script>
	<table border="0" width="100%" cellspacing="0" cellpadding="3">
	<tr valign="top"><td bgcolor="DFE1BC" width="21%" valign="top">
		<cl:CLMsgSisLeftBandTag connObj="<%=conn%>" category="<%=Integer.toString(cat)%>" level="1"/>
	</td>
	<td width="79%" valign="top">
	<!-- TOP BAND START -->
	<table align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td bgcolor="B4BC6D">
		<table border="0" cellspacing="0" cellpadding="0">
		<tr><td bgcolor="B4BC6D" height="32" width="10">
				<img src="img/blank.gif" width="1" height="28">
			</td>
			<td><font class="cntblu"><a href="/" class="lnkblu">Home</a><font class="cntblu"> &gt; </font><a href="/clzone/login/CLZone.jsp" class="lnkblu">CL Zone Home</a> &gt; <a href="/msg/MSGStaffCompose.jsp" class="lnkblu">Compose Message</a> &gt; Criteria Selection</font>
			</td>
		</tr>
		</table>
	</td></tr></table>
	<!-- TOP BAND END -->

	<table width="100%" cellpadding="3" cellspacing="0" border=0 bordercolor=red>
	<tr><td colspan="2"><img src="/img/blank.gif" height="10" width="5"></td></tr>
	<tr><td colspan="2">
	  <cl:writeChannels connObj="<%=conn%>" agentID="<%=agent.getAgentID() %>" destID="<%=agent.getDestID() %>" clSource="/msg/MSGStaffCompose.jsp" sisSource="/msg/admin/MSGPickStudents.jsp"/>
	</td></tr>
	<tr><td colspan="2">
		<font class="cnt">To send a message to students, please tell the system by
		which criteria you will send the message.</font>
	</td></tr>
	<form method="POST" action="/msg/admin/MSGDisplayPrivilege.jsp">
<% 
		String scope_batch = appPrivilege.checkPrivilege("ERP#CLMS#SEND_SCHED_ANNOU_BATCHES");
		String scope_center = appPrivilege.checkPrivilege("ERP#CLMS#SEND_SCHED_ANNOU_CENTER");
		String scope_acad = appPrivilege.checkPrivilege("ERP#CLMS#CLMS_ACAD_HEAD");
		//for (int i=0;i<privilege.length;i++)
		//{		
		if(scope_batch!= null)
		{
%>
	<tr>
	  <td width="5%"><input type="radio" value="LOC_BATCHES" name="privilege"></td>
	  <td class="cnt">Send message to your <B><%=scope_batch.toLowerCase()%></B> center(s) batches
	   </td>
	</tr>
<%
		}
		if(scope_center != null)
		{
%>
	<tr>
	  <td width="5%"><input type="radio" value="ALL_CENTERS" name="privilege" checked></td>
	  <td class="cnt">Send message to your <B><%=scope_center.toLowerCase()%></B> Center(s) student
	  </td>
	</tr>
<%
		}
		if(scope_acad != null)
		{
%>
	<tr>
	  <td width="5%"><input type="radio" value="ALL_PRODS" name="privilege" checked></td>
	  <td class="cnt">Send message to all student in your(s) product
	  </td>
	</tr>
<%
		}
		else
		{
%>		 
	<tr>
	  <td colspan="2" class="lnkbld">You donnt have any privilege, If you want any, please contact your acads head.
	  </td>
	</tr>
<%
		}
%>
		  <input type="hidden" name="qid" value="<%= qid %>">
		  <input type="hidden" name="pid" value="<%= pid %>">
	<tr><td colspan="2">
		  <input type="submit" value="Next" name="B1">
	</td></tr>
		</form>
	</table>

</td></tr></table>
</body>
</html>
<%
		}//end of more than privilege condition(if privilege.length>1)
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
%>
