<%@ page import="com.cl.sql.PoolManager,java.sql.Connection,com.cl.msg.*"%>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>
<%!
// return current time to proxy server request
public long getLastModified(HttpServletRequest request) {
	return System.currentTimeMillis();
}
%>

<%--
  -- Filename:	 MSGInbox.jsp
  -- Author:     Shilpa Arora
  -- Create Date:11th April 2002 
  --%>

<%

response.setHeader( "Cache-Control", "no-cache" );
response.setHeader( "Pragma", "no-cache" );
response.setIntHeader( "Expires", 0 );

MSGMessage[] messagesArray = null;
//CLMSPoolManager clmsPool = CLMSPoolManager.getInstance();
PoolManager clmsPool = PoolManager.getInstance();
Connection conn = null;

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

	<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
	<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
	<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="inbox" class="com.cl.msg.MSGInbox" scope="page" />
	<jsp:setProperty name="inbox" property="errorFileName" value="<%=logFile %>"/>

	<%
	/**
	 * The variable @Message is used to display any message it got as a parameter as a result of any previous action causing
	 * the forward or include of this page. Hence, the use is to display the status of any previous action before this page.
	 * The variable is always obtained by request.getParameter("Message"); and this is used as a standard throughout the sis
	 * for displaying the status of the earlier task.
	 */
		String Message="";
		int pageNo=1;
		int recNo = 20;
		// Folder id will either start with S [System Folder] or U [User Folder]. 
		String folderId = "";
		String folderType = "";	// if starts with S denotes its a System folder
		String folderName = "";

		folderId = request.getParameter("fid");
		folderName = request.getParameter("fldr");
		if(folderId.startsWith("S"))
			folderType = "SYSTEM";
		else 
			folderType = "USER";
		
		folderId = folderId.substring(1);

		try
		{
			pageNo=Integer.parseInt(request.getParameter("pn"));
		}
		catch(NumberFormatException nfe)
		{
			pageNo=1;
		}
	%>


	<html>
	<head>
	<title>Folder: <%=java.net.URLDecoder.decode(folderName)%></title>
	<!-- <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache"> -->

	<link rel="stylesheet" href="/styles/style.css" type="text/css">

	<link href="/styles/indus.css" rel="stylesheet" type="text/css" /> 

	<script language="javascript" >
	function showMsgs(page)
	{
		document.inboxForm.pn.value=page;
		document.inboxForm.submit();
	}

	function isAnyMessageChecked()
	{
		checked =0;
		for(i=0;i<document.messageForm.elements.length;i++)
		{
			if(document.messageForm.elements[i].type=="checkbox" && document.messageForm.elements[i].checked==true)
			{
				checked++;	
			}
		}
		if(checked > 0)
			return true;
		else
			return false;
	}

	function moveMessage()
	{
		if(document.messageForm.tofid.options[document.messageForm.tofid.selectedIndex].value == 0)
		{
			document.messageForm.tofid.selectedIndex = 0;	
			return false;
		}
		document.messageForm.action = "/msg/MSGMoveMessage.jsp";
		if(isAnyMessageChecked())
			document.messageForm.submit();
		else
		{
			alert("Please select at least one message to move.");
			document.messageForm.tofid.selectedIndex = 0;	
		}
	}

	function deleteMsg()
	{
		if(isAnyMessageChecked())
		{
			document.messageForm.action = "/msg/MSGDeleteMessage.jsp";
			var result=confirm("Are you sure you want to delete the selected message(s).");
			if(result==true)
				document.messageForm.submit();
		}
		else
		{
			alert("Please select at least one message for deletion.");
		}
	}
	function toggleSelectAllMessages()
	{
		for(var i=0;i<document.messageForm.elements.length;i++)
		{
			if(document.messageForm.elements[i].type == "checkbox")
				document.messageForm.elements[i].checked = document.messageForm.toggleCheckbox.checked
		}
	}


	function updateToggle(val)
	{
		if (!val)
			document.messageForm.toggleCheckbox.checked=false;
	}


	function popup(mid){
	tagpopup= window.open("/msg/admin/MSGShowReplies.jsp?mid="+mid,"Members","status=no,toolbar=no,scrollbars=yes,width=450,height=460,top=10,left=10,resizable=yes");
	}


	</script>
	
	</head>
	<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
	<!-- Add top.js for top band -->
	<script language="javascript" src="/jscript/top.js"></script>
	<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="1" align="left" valign="top" bgcolor="#E0E0E0"><img src="/img/1x1.gif" width="1" height="1" /></td>
    
<%
	String clSrc = "";
	try
	{
		conn = clmsPool.getConnection("erp");
		//System.out.println(conn);
		clSrc = (cat == 1)? "/msg/MSGStaffCompose.jsp" : "/msg/MSGStudentCompose.jsp";
%>
	<td width="174" align="left" valign="top" bgcolor="#999933">
		<cl:CLMsgSisLeftBandTag connObj="<%=conn%>" category="<%=Integer.toString(cat)%>" level="1"/>
	</td>

	<td>
	<%--
	  -- Form used to call the next and back of the inbox for displaying the pagewize messages
	  --%>
	<form style="margin-top: 0px; margin-bottom: 0px;" name="inboxForm" method="post" action="MSGInbox.jsp">
	<input type="hidden" name="pn" value="1">
	<input type="hidden" name="cat" value="<%=cat %>">
	</form>
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
							   : "<a href=\"/sis/sis.jsp\" class=\"lnkblu\">SIS page</a>" %> &gt; <%= java.net.URLDecoder.decode(folderName) %></font>
			</td>
		</tr>
		</table>
	</td></tr></table>
	<!-- TOP BAND END -->

	<table width="100%" cellpadding="3" cellspacing="0">
	<tr><td>
		<font class="cntnormal">Hi <font class="arlbld"><%=agent.getAgentName()%></font>, 
		Welcome to the SIS Messaging System</font>
	</td></tr>
	
	<tr><td>
		<table width="100%" cellspacing="0" cellpadding="0" bgcolor="#C0D9F5" border="0">
		<!-- <tr><td colspan="2">
			<cl:writeChannels agentID="<%=agent.getAgentID() %>" destID="<%=agent.getDestID() %>" clSource="<%=clSrc%>" connObj="<%=conn%>" sisSource="/msg/admin/MSGPickStudents.jsp"/>
		</td></tr> -->

		<tr><td bgcolor="#ffffff" colspan="3"><img src="/img/blank.gif" height="5" width="5"></td></tr>

		<tr><td rowspan="5"><img src="/img/blank.gif" width="10" height="3"></td>
			<td bgcolor="#ffffff"><img src="/msg/img/blue.gif"></td>
		</tr>
<%
			
		queues.loadQueues(conn);
		messagesArray = inbox.getMessages(conn,agent.getAgentID(),agent.getDestID(),pageNo,10,Integer.parseInt(folderId),folderType);
		//in case you have 21 messages, 10 messages being displayed per page
		//you will have 3 pages with 1 message on the third page
		//if you delete the last (21st) message then you need to throw the user
		// to the second page
		if((messagesArray == null || messagesArray.length == 0) && pageNo > 1)
		{
			pageNo--;
			messagesArray = inbox.getMessages(conn,agent.getAgentID(),agent.getDestID(),pageNo,10,Integer.parseInt(folderId),folderType);
		}
		if(messagesArray == null || messagesArray.length == 0)
		{
%>
	<tr><td><br><font class="cntblu">Folder 
		<font class="lnkbld"><%= java.net.URLDecoder.decode(folderName)%></font> is empty.</font></td></tr>
	<tr><td><img src="/img/blank.gif" width="5" height="10"></td></tr>
<%
		}
		else
		{
			String folderMessageCount = Integer.toString(inbox.getTotalMessageCount(conn,agent.getAgentID(),agent.getDestID(),Integer.parseInt(folderId),folderType));

			if(folderType.equals("SYSTEM"))
				folderId = "S" + folderId;
			else
				folderId = "U" + folderId;
%>
		<tr><td align="center">
			<cl:MessageBoxHeadTag category="<%=Integer.toString(cat)%>" cpage="<%=Integer.toString(pageNo)%>" rpage="10" agentId="<%=Integer.toString(agent.getAgentID())%>" destId="<%=Integer.toString(agent.getDestID())%>" folderId="<%=folderId%>" folderName="<%=folderName%>" folderMessageCount="<%=folderMessageCount%>"/>
		</td></tr>
		<tr><td align="center">
			<cl:MessageBoxTag category="<%=Integer.toString(cat)%>" cpage="<%=Integer.toString(pageNo)%>" rpage="10" agentId="<%=Integer.toString(agent.getAgentID())%>" destId="<%=Integer.toString(agent.getDestID())%>" msgArray="<%=messagesArray%>" folderId="<%=folderId%>" folderName="<%=folderName%>" folderMessageCount="<%=folderMessageCount%>" connObj="<%=conn%>"/>
		</td><tr>
		<tr><td align="center">
			<cl:MessageBoxHeadTag category="<%=Integer.toString(cat)%>" cpage="<%=Integer.toString(pageNo)%>" rpage="10" agentId="<%=Integer.toString(agent.getAgentID())%>" destId="<%=Integer.toString(agent.getDestID())%>" folderId="<%=folderId%>" folderName="<%=folderName%>" folderMessageCount="<%=folderMessageCount%>"/>
		</td></tr>
<%		}
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
%>
		</table>
	</td></tr></table>
	</td></tr>
	</table>
	</body>
	</html>


