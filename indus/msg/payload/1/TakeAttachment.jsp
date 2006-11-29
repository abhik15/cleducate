<%@ page import="java.sql.Connection,com.cl.sql.PoolManager"  errorPage="/msg/MSGErrorPage.jsp"%>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl"%>
<%--
  -- Filename:	 TakeAttachment.jsp
  -- Author:     Shilpa Arora
  -- Create Date:16th April 2002 
  --%>

<%--
  -- Change History
  -- 1) The source, privilege, displays, values parameter is taken from the request.
  --
  --%>

<%
	int cat = 0;

	try
	{
		cat= Integer.parseInt(request.getParameter("cat"));
	}
	catch(NumberFormatException nfe)
	{
		cat=0;
	}


	String user = (cat == 0) ? "CUSTOMER" : "EMPLOYEE";
%>
	<cl:CLValidateSessionTag userType="<%=user%>"/>

<%
	request.setAttribute("cat",Integer.toString(cat));
	request.setAttribute("jspname","/msg/payload/1/TakeAttachment.jsp");

	String logFile = application.getRealPath("/logs/error/")+"MSGErrorLog.log";
	String privilege	= request.getParameter("privilege");
	String values		= request.getParameter("values");
	String displays		= request.getParameter("displays");
	String receiver		= "";
	String reply		= "";
	String source		= "";
	String parentMsgID	= "";
	String receiverID	= "";
	String receiverDestID = "";
	String saveToSentItems = "";

	reply			= request.getParameter("reply");
	source			= request.getParameter("source");
	receiver		= request.getParameter("receiver");
	receiverID		= request.getParameter("receiverID");
	parentMsgID		= request.getParameter("parentMsgID");
	receiverDestID	= request.getParameter("receiverDestID");
	saveToSentItems = request.getParameter("savemsg");

	if(source==null || source.equals(""))
	{
		if(cat==1)
			source="/msg/MSGStaffCompose.jsp";
		else 
			source="/msg/MSGStudentCompose.jsp";
	}

%>


	<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
	<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="inbox" class="com.cl.msg.MSGInbox" scope="page" />
	<jsp:setProperty name="inbox" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
	<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="msg" class="com.cl.msg.MSGMessage" scope="session" />
	<jsp:setProperty name="msg" property="*" />
	<jsp:setProperty name="msg" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="wpayload" class="com.cl.msg.MSGTextPayload" scope="session" />
	<jsp:setProperty name="wpayload" property="*" />
	<jsp:setProperty name="wpayload" property="errorFileName" value="<%=logFile %>"/>
<%
	/**
	 * The variable @Message is used to display any message it got as a parameter as a result of any previous action causing
	 * the forward or include of this page. Hence, the use is to display the status of any previous action before this page.
	 * The variable is always obtained by request.getParameter("Message"); and this is used as a standard throughout the sis
	 * for displaying the status of the earlier task.
	 */
		String Message="";
		int qID=0;
		int payloadID=0;


		Message = request.getParameter("message");
		if(Message == null)
			Message="";
		try
		{
			qID= Integer.parseInt(request.getParameter("qid"));
			payloadID= Integer.parseInt(request.getParameter("pid"));
		}
		catch(NumberFormatException nfe)
		{
			qID=0;
			payloadID=0;
		}
%>
<html>
<head>
<title>Attach File</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="/styles/style.css" type="text/css">
<SCRIPT LANGUAGE="javascript">
<!--
	function composeMessage()
	{
		document.cancelForm.submit();
	}
	function showWindow(winname,url)
	{
		win = window.open(url,winname,"toolbar=0,location=0,directories=0,status=1,menubar=0,scrollbars=1,resizable=0,width=500,height=380,left=20,top=20");
	}
// -->
</SCRIPT>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!-- Add top.js for top band -->
<script language="javascript" src="/jscript/top.js"></script>
<table border="0" width="100%" cellspacing="0" cellpadding="3">
<%	String clSrc = (cat==1) ? "/msg/MSGStaffCompose.jsp" : "/msg/MSGStudentCompose.jsp";
	PoolManager clmsPool = PoolManager.getInstance();
	Connection conn = null;
	try
	{
		conn = clmsPool.getConnection("erp");
%>
<tr valign="top"><td bgcolor="DFE1BC" width="21%" valign="top">
	<cl:CLMsgSisLeftBandTag connObj="<%=conn%>" category="<%=Integer.toString(cat)%>" level="1"/>
</td>
<td width="79%" valign="top">

	<!-- TOP BAND START -->
	<table align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td bgcolor="B4BC6D">
		<table border="0" cellspacing="0" cellpadding="0">
		<tr><td bgcolor="B4BC6D" height="32" width="10">
				<img src="/img/blank.gif" width="1" height="28">
			</td>
			<td><font class="cntblu"><a href="/" class="lnkblu">Home</a><font class="cntblu"> &gt; </font><%=cat==1?"<a href=\"/clzone/login/CLZone.jsp\" class=\"lnkblu\">CL Zone Home</a>":"<a href=\"/sis/student/SIS.jsp\" class=\"lnkblu\">SIS page</a>"%> &gt; <a href="javascript: composeMessage()" class="lnkblu">Compose Message</a> &gt; File Attachement</font>
			</td>
		</tr>
		</table>
	</td></tr></table>
	<!-- TOP BAND END -->

	<table border=0 bordercolor=red width="100%" cellpadding="3" cellspacing="0">
	<tr><td><img src="/img/blank.gif" width="5" height="10"></td></tr>
	<tr><td>
		<cl:writeChannels agentID="<%=agent.getAgentID() %>" destID="<%=agent.getDestID() %>" clSource="<%=clSrc%>" connObj="<%=conn%>" sisSource="/msg/admin/MSGPickStudents.jsp"/>
<%
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
%>
	</td></tr>
	<form name="uploadForm" method="POST" action="Uploader.jsp" enctype="multipart/form-data" method="post" >
	<tr><td>	
	    <font class="cntnormal"><b>File Attachment</b></font>
		<font class="cnt"><ol style="margin-top: 5px;">
	    	<li>Click <b>"Browse"</b> to select the file, or type the path to the file in the box below.
	    	<li>Move the file to the server by clicking <b>"Attach"</b>. File Transfer times vary (30 seconds up to 10 minutes depending on the file size and internet speed).
	    </ol>
		<div style="margin-left: 15px; margin-right:5px;">
		<b><u>Note:</u></b><br>Click on <b>"Cancel"</b> button to return to Compose page without attaching a file.<br><br>
		File Location:</font>&nbsp;&nbsp;
			<input type="file" name="file1">&nbsp;&nbsp;
			<input type="submit" name="file1" value="Attach"></div>
		</font>
	    </td>
	</tr>
	<tr><td><font class="cnt">
    </td></tr>
	    <input type="hidden" name="source" value="<%=source %>" >
	    <input type="hidden" name="privilege" value="<%=privilege %>" >
	    <input type="hidden" name="displays" value="<%=displays %>" >
	    <input type="hidden" name="values" value="<%=values %>" >
   	    <input type="hidden" name="reply" value="<%=reply %>" >
   	    <input type="hidden" name="receiver" value='<%=receiver %>' >
		<input type="hidden" name="parentMsgID" value="<%=parentMsgID %>" >
		<input type="hidden" name="receiverID" value="<%=receiverID %>" >
		<input type="hidden" name="receiverDestID" value="<%=receiverDestID%>" >
		<input type="hidden" name="cat" value="<%=cat%>" >
		<input type="hidden" name="savemsg" value="<%=saveToSentItems%>">
		
	</form>
	<form name="cancelForm" action="<%=source%>" method="post">
	<input type="hidden" name="source" value="<%=source%>">
	<input type="hidden" name="pid" value="<%=msg.getPayloadID()%>">
	<input type="hidden" name="qid" value="<%=msg.getQueueID()%>"/>
	<input type="hidden" name="receiver" value='<%=receiver%>'/>
	<input type="hidden" name="displays" value="<%=displays%>"/>
	<input type="hidden" name="values" value="<%=values%>"/>
	<input type="hidden" name="privilege" value="<%=privilege%>"/>
	<input type="hidden" name="reply" value="<%=reply%>"/>
	<input type="hidden" name="parentMsgID" value="<%=parentMsgID%>"/>
	<input type="hidden" name="receiverID" value="<%=receiverID%>"/>
	<input type="hidden" name="receiverDestID" value="<%=receiverDestID%>"/>
	<input type="hidden" name="cat" value="<%=cat%>">
	<input type="hidden" name="message" value=" "/>
	<input type="hidden" name="savemsg" value="<%=saveToSentItems%>">
	<tr><td align="center"><br>
	<input type="submit" value="Cancel">
	</td></tr>
	</form>
	</table>
</td></tr></table>
</body>
</html>