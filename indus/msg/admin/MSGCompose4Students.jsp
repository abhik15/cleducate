<%@ page import="java.sql.Connection,com.cl.sql.CLMSPoolManager"  errorPage="/msg/MSGErrorPage.jsp"%>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl"%>
<%--
  -- Filename:	 MSGCompose4Students.jsp
  -- Author:     Shilpa Arora
  -- Create Date:25th April 2002 
  --%>

<%
	CLMSPoolManager clmsPool = CLMSPoolManager.getInstance();
	Connection conn = null;
	int cat = 1;
	String logFile = application.getRealPath("/logs/error/")+"MSGErrorLog.log";
%>
	<cl:CLValidateSessionTag />
	<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
	<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="Systems" scope="application" class="com.cl.CLSystems"/>
	<jsp:useBean id="inbox" class="com.cl.msg.MSGInbox" scope="page" />
	<jsp:setProperty name="inbox" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
	<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="msg" class="com.cl.msg.MSGMessage" scope="session" />
	<jsp:setProperty name="msg" property="errorFileName" value="<%=logFile %>"/>

<%
	String Message="";
	int qID = 0;
	int payloadID = 0;
	boolean reply = false;
	int msgID = 0;
	String ddmmyy = new java.util.Date().toLocaleString();//displaying current time to the user
	String receiver = "";
	String privilege = request.getParameter("privilege");
	int size = 0;
	String values = "|";
	String displays = null;
	try
	{
		size = Integer.parseInt(request.getParameter("plength"));
	}
	catch(NumberFormatException nfe)
	{	size=0;	}
	for(int i=0;i<size;i++)
	{
		if(request.getParameter("ids"+i)!=null && !request.getParameter("ids"+i).equals(""))
		{
			values += request.getParameter("ids"+i)+"|";
			if(displays==null)
				displays=request.getParameter("display"+i);
			else	
				displays+=", "+request.getParameter("display"+i);
		}
	}
		
	if(displays==null || displays.equals(""))
		displays= request.getParameter("displays");
	if(values==null || values.equals("|"))
		values= request.getParameter("values");
	request.setAttribute("cat",Integer.toString(cat));
	request.setAttribute("jspname","/msg/MSGCompose4Students.jsp");

	Message = request.getParameter("message");
	if(Message==null)Message="";
		receiver=request.getParameter("receiver");
	if(receiver==null)receiver="";
		try
		{
			qID = Integer.parseInt(request.getParameter("qid"));
			payloadID = Integer.parseInt(request.getParameter("pid"));
			reply = request.getParameter("reply") != null ? request.getParameter("reply").equalsIgnoreCase("y") ? true : false : false;
			
		}
		catch(NumberFormatException nfe)
		{
			qID = 0;
			payloadID = 0;
		}
		if(reply)
			try
			{
				msgID= Integer.parseInt(request.getParameter("mid"));// ERROR PRONE
			}
			catch(NumberFormatException nfe)
			{	msgID = 0;	}
		
	try
	{
		conn = clmsPool.getConnection("erp");
		if(reply && msgID > 0)
		{
			msg.read(conn,agent.getAgentID(), agent.getDestID(), msgID, payloadID);
			msg.setQueueType(queues.getQueue(msg.getQueueID()).getQType());
		}
	%>
	<html>
	<head>
	<title>Compose Message for Students</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache">

	<link rel="stylesheet" href="/styles/style.css" type="text/css">
<%
	if(qID > 0 && payloadID > 0)
	{
%>
	<script LANGUAGE="JavaScript" src="/msg/payload/<%=payloadID %>/jscript.js"></script> 
<%
	}
%>
	<script language="javascript">
	function popup(qid)
	{
		tagpopup= window.open("/msg/MSGReceivers.jsp?qid="+qid,"registration","status=no,resize=yes,toolbar=no,scrollbars=yes,width=300,height=250");
	}
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
			<td><font class="cntblu"><a href="/" class="lnkblu">Home</a><font class="cntblu"> &gt; </font><a href="/clzone/login/CLZone.jsp" class="lnkblu">CL Zone Home</a> &gt; <a href="/msg/MSGStaffCompose.jsp" class="lnkblu">Compose Message</a> &gt; <a href="/msg/admin/MSGPickStudents.jsp?pid=<%=payloadID%>&qid=<%=qID%>">Criteria Selection</a></font>
			</td>
		</tr>
		</table>
	</td></tr></table>
	<!-- TOP BAND END -->

	<table width="100%" cellpadding="3" cellspacing="0">
	<tr><td colspan="2"><img src="/img/blank.gif" height="10" width="5"></td></tr>

	<tr><td>
		<cl:writeChannels agentID="<%=agent.getAgentID() %>" destID="<%=agent.getDestID() %>" clSource="/msg/MSGStaffCompose.jsp" connObj="<%=conn%>" sisSource="/msg/admin/MSGPickStudents.jsp"/>
	</td></tr>
<%
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
	    String includePage = "";
	    if(qID==0 || payloadID==0)
		{
		    includePage="/msg/MSGWriteQueues.jsp";
		}	
	    else
		{
		    includePage="/msg/payload/"+payloadID+"/Compose.jsp";
%>
		<tr><td>
		<table width="100%" border="0" bordercolor=blue cellspacing="0" cellpadding="0">
			<form method="POST" action="/msg/payload/<%=payloadID %>/Send.jsp" name="payload" onSubmit="return validate(this)">
		  	<tr>
				<td><img src="/img/blank.gif" width="5" height="10"></td>
				<td><font class="cnt"><%=Message %></font></td>
			</tr>

			<tr> 
				<td bgcolor="#C0D9F5"><img src="/img/blank.gif" width="5" height="10"></td>
				<td valign="bottom"><img src="/msg/img/blue.gif"></td>
			</tr>

			<tr><td colspan="2" bgcolor="#C0D9F5"><img src="/img/blank.gif" width="5" height="10"></td></tr>

			<tr> 
				<td bgcolor="#C0D9F5"><img src="/img/blank.gif" width="3" height="10"></td>
				<td bgcolor="#C0D9F5">
				  <input type="hidden" name="source" value="/msg/admin/MSGCompose4Students.jsp" >	
				  <input type="hidden" name="cat" value="<%=cat %>" >	
				  <!-- GREY BORDER TABLE START -->
				  <table align="center" width="95%" border="1" cellspacing="0" cellpadding="3" bordercolorlight="#999999" bordercolordark="#C0D9F5">
					<tr><td bgcolor="#C0D9F5" valign="top"> 
					<table width="100%" border="0" cellspacing="0" cellpadding="3">
					<tr><td valign="top" width="5%">
						<img src="<%=queues.getQueue(qID).getIconURL() %>" align="absmiddle"></td>
						<td rowspan="7" valign="top"><img src="/img/blank.gif" width="5" height="5"></td>
						<td><font class="verbld">Channel</font></td>
						<td rowspan="5" valign="top"><img src="/img/blank.gif" width="5" height="5"></td>
						<td><font class="cnt"><%=queues.getQueue(qID).getQDescr() %></font>
							<input type="hidden" name="queueID" value="<%=qID %>" >
							<input type="hidden" name="queueType" value="<%=queues.getQueue(qID).getQType() %>" > 
							<input type="hidden" name="payloadID" value="<%=payloadID %>" >
						</td>
					</tr>
					<tr><td valign="top"><img src="/img/blank.gif" width="5" height="5"></td>
						<td><font class="verbld">Sender</font></td>
						<td><font class="cnt"><%=agent.getAgentName() %></font></td>
						<input type="hidden" name="senderID" value="<%=agent.getAgentID() %>">
						<input type="hidden" name="senderDestID" value="<%=agent.getDestID() %>">
						<input type="hidden" name="sender" value="<%=agent.getAgentName() %>">
					</tr>
					<tr valign="top">
						<td><img src="/img/blank.gif" width="5" height="5"></td>
						<td><font class="verbld">To</font></td>
						<td class="cnt"><%=displays %>
							<input type="hidden" name="receiver" value="<%=values %>">
							<input type="hidden" name="values" value="<%=values %>">
							<input type="hidden" name="displays" value="<%=displays %>">
							<input type="hidden" name="privilege" value="<%=privilege %>">
							<input type="hidden" name="receiverID" value="<%=msg.getSenderID() %>">
							<input type="hidden" name="receiverDestID" value="<%=msg.getSenderDestID() %>">						
						</td>
					</tr>
					<tr> 
						<td valign="top"><img src="/img/blank.gif" width="5" height="5"></td>
						<td><font class="verbld">Subject</font></td>
						<td><input type="text" name="subject" size="30" <%=reply && msgID>0?"value=\"Re: "+msg.getSubject()+"\"":"" %> <%=((!reply && msg!=null)||(reply && msgID==0))?" value=\""+ msg.getSubject()+"\"":""%> ></td>
					</tr>
					<tr> 
						<td valign="top"><img src="/img/blank.gif" width="5" height="5"></td>
						<td><font class="verbld">Date</font></td>
						<td><font class="cnt"><%=ddmmyy %></font></td>
					</tr>
					<tr valign="top"> 
						<td><img src="/img/blank.gif" width="5" height="5"></td>
						<td colspan="3"><input title="Check to Save this message to your sent items folder." type="checkbox" name="savemsg" value="yes">
							<font class="verbld">Save to Sent Items</font></td>
					</tr>
					<tr> 
						<td valign="top"><img src="/img/blank.gif" width="5" height="5"></td>
						<td colspan="3"> 
<%
		}
		String rep= reply?"y":"n";
%>
					<jsp:include page="<%=includePage %>" flush="true">
					<jsp:param name="source" value="/msg/admin/MSGCompose4Students.jsp"/>
					<jsp:param name="reply" value="<%=rep %>" />
					<jsp:param name="msgID" value="<%=msgID %>" />
					</jsp:include>

<%
	    if(!(qID==0 || payloadID==0))
		{
%>
						</td>
					</tr>
		            </form>
				    </table>
				  </td></tr>
			      </table>
				  <!-- GREY BORDER TABLE END -->
			<tr><td colspan="3" bgcolor="#C0D9F5"><img src="/img/blank.gif" width="5" height="15"></td></tr>
			</td></tr></table>
<%
	    }
%>
	    </td>
	  </tr>
	</table>
	</body>
	</html>
