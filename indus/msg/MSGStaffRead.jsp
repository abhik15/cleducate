<%@ page import="java.sql.Connection,com.cl.sql.CLMSPoolManager,com.cl.sis.exception.*,com.cl.msg.*"%> <!-- errorPage="/msg/MSGErrorPage.jsp" -->
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>


<%--
  -- Filename:	 MSGStaffCompose.jsp
  -- Author:     Shilpa Arora
  -- Create Date:25th April 2002 
  --%>

<%
	int cat = 1;
	String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
	int pageNo = Integer.parseInt(request.getParameter("pn"));
	//will be used to set the pageNo for next message and prev message links
	int messageSequence = Integer.parseInt(request.getParameter("seq"));
	int rPage = Integer.parseInt(request.getParameter("rpage"));
	
	String folderId = request.getParameter("fid");
	String folderName = request.getParameter("fldr");
	String msgCount = request.getParameter("msgcnt");

	request.setAttribute("cat",Integer.toString(cat));
	request.setAttribute("jspname","/msg/MSGStaffRead.jsp");
%>

	<cl:CLValidateSessionTag />
	<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
	<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="Systems" scope="application" class="com.cl.CLSystems"/>
	<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
	<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="inbox" class="com.cl.msg.MSGInbox" scope="page" />
	<jsp:setProperty name="inbox" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="rMsg" class="com.cl.msg.MSGMessage" scope="session" />
	<jsp:setProperty name="rMsg" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="agentQueue" class="com.cl.msg.MSGAgentQueue" scope="page" />
	<jsp:setProperty name="agentQueue" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="queueMaster" class="com.cl.msg.MSGQueueMaster" scope="page" />
	<%!
	/**
	 * The variable @Message is used to display any message it got as a parameter as a result of any previous action causing
	 * the forward or include of this page. Hence, the use is to display the status of any previous action before this page.
	 * The variable is always obtained by request.getParameter("Message"); and this is used as a standard throughout the sis
	 * for displaying the status of the earlier task.
	 */
		String Message="";
		int msgID=0;
		int payloadID =0;
		int qID=0;
		int pn=1;
	%>
	<%
		Message = request.getParameter("message");
		if (Message == null)
			Message="";
		try
		{
			msgID	  = Integer.parseInt(request.getParameter("msgID"));
			payloadID = Integer.parseInt(request.getParameter("pID"));
		}
		catch(NumberFormatException nfe)
		{
			msgID=0;
			payloadID=0;
			throw new Exception("Page called for invalid messageID/payloadID");
		}
		try
		{
			pn= Integer.parseInt(request.getParameter("pn"));
		}
		catch(NumberFormatException nfe)
		{
			pn=1;
		}
		
	%>
	<html>
	<head>
	<title>CLMS- Read Message</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache">
	<link rel="stylesheet" href="/styles/style.css" type="text/css">
	<script LANGUAGE="JavaScript" src="/jscript/cl_functions.js"></script>
	<script LANGUAGE="JavaScript" src="/msg/payload/<%=payloadID %>/jscript.js"></script> 
	<script>
		function checkForward()
		{
			if(document.messageForm.fqid[document.messageForm.fqid.selectedIndex].value=="#")
			{
				alert('Please Choose a channel to which you want to forward this message.');
				return;
			}
			else
			{
				document.fwdForm.qid.value=document.messageForm.fqid[document.messageForm.fqid.selectedIndex].value;
				document.fwdForm.submit();
			}
		}

		function deleteMessage()
		{
			document.messageForm.action = "/msg/MSGDeleteMessage.jsp";
			document.messageForm.submit();
		}

		function moveMessage()
		{
			if(document.messageForm.tofid.options[document.messageForm.tofid.selectedIndex].value == 0)
			{
				document.messageForm.tofid.selectedIndex = 0;	
				return false;
			}
			else
			{
				document.messageForm.action = "/msg/MSGMoveMessage.jsp";
				document.messageForm.submit();
			}
		}
	</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!-- Add top.js for top band -->
<script language="javascript" src="/jscript/top.js"></script>
<%
	CLMSPoolManager clmsPool = CLMSPoolManager.getInstance();
	Connection conn = null;
	int queueIDs[] = null;
	try
	{
		conn = clmsPool.getConnection("erp");
%>
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
				<img src="/img/blank.gif" width="1" height="28">
			</td>
			<td><font class="cntblu"><a href="/" class="lnkblu">Home</a><font class="cntblu"> &gt; </font><a href="/clzone/login/CLZone.jsp" class="lnkblu">CL Zone Home</a> &gt; <a href="/msg/MSGInbox.jsp?cat=1&fid=<%=folderId%>&fldr=<%=folderName%>" class="lnkblu"><%=java.net.URLDecoder.decode(folderName)%></a> &gt; Read Message</font>
			</td>
		</tr>
		</table>
	</td></tr></table>
	<!-- TOP BAND END -->

	<!-- MAIN TABLE AFTER TOP BAND START -->
	<table width="100%" cellpadding="3" cellspacing="0" border=0 bordercolor=green>
	<%--
	  -- Form used for forwarding the message		  
	  --%>
<%		queues.loadQueues(conn);
		rMsg.read(conn,agent.getAgentID(), agent.getDestID(), msgID, payloadID);
		rMsg.setQueueType(queues.getQueue(rMsg.getQueueID()).getQType());
		qID = rMsg.getQueueID();

%>
	<form method="get" action="/msg/MSGStaffCompose.jsp" name="fwdForm">
	<input type="hidden" name="mid" value="<%=msgID%>" >
	<input type="hidden" name="pid" value="<%=payloadID %>" >
	<input type="hidden" name="qid" value="<%=qID%>" >
	<input type="hidden" name="fwd" value="y" >
	</form>
	<tr><td bgcolor="#ffffff"><img src="/img/blank.gif" width="10" height="15"></td></tr>
	<tr><td>
	  <cl:writeChannels agentID="<%=agent.getAgentID() %>" destID="<%=agent.getDestID() %>" clSource="/msg/MSGStaffCompose.jsp" connObj="<%=conn%>" sisSource="/msg/admin/MSGPickStudents.jsp"/>
	</td></tr>
<%
		queueIDs = agentQueue.getWriteQueues(conn,agent.getAgentID(), agent.getDestID());
	String includePage="/msg/payload/"+payloadID+"/Read.jsp";
%>
	<tr><td>
	<table width="100%" border="0" bordercolor=red cellspacing="0" cellpadding="0">
	<tr> 
		<td rowspan="3" bgcolor="#C0D9F5"><img src="/msg/img/blank.gif" width="10" height="5"></td>
		<td valign="bottom"><img src="/msg/img/blue.gif"></td>
	</tr>
	<tr><td bgcolor="#C0D9F5" colspan="2"><img src="/img/blank.gif" height="10" width="10"></td></tr>

	<tr bgcolor="#C0D9F5"><td>
		<!-- GREY BORDER TABLE START -->
		<table bgcolor="#C0D9F5" width="98%" border="1" cellspacing="0" cellpadding="3" bordercolorlight="#999999" bordercolordark="#C0D9F5">
	<%--
	  -- Form used for the deletion of message
	  --%>
	<form method="POST" name="messageForm" >
	<input type="hidden" name="source" value="/msg/MSGInbox.jsp" >	    
	<input type="hidden" name="pn" value="<%=pn%>">
	<input type="hidden" name="cat" value="1">
	<input type="hidden" name="totMsg" value="1">
	<input type="hidden" name="msgs" value="<%=rMsg.getMsgID()%>">	    
	<input type="hidden" name="fid" value="<%=folderId%>">
	<input type="hidden" name="fldr" value="<%=folderName%>">



<% if(rMsg.getStatus() != -1)
	{
%>
		<tr> 
		<td valign="top" colspan="3"> 
			<table width="100%" border="0" bordercolor=blue cellspacing="0" cellpadding="0">
			<tr><td width="5%" align="left" bgcolor="#C0D9F5">
					<img src="<%=queues.getQueue(rMsg.getQueueID()).getIconURL() %>"></td>
				<td width="12%"><font class="verbld">&nbsp;Channel</font></td>
				<td width="38%"><font class="cnt"><%=queues.getQueue(rMsg.getQueueID()).getQDescr()%></font></td>
				<td width="45%" rowspan="6" valign="top" align="right">

				<!-- DELETE | REPLY | FORWARD | MOVE MESSAGE Table start //-->
				<table border="0" cellspacing="0" cellpadding="3">
				<tr><td valign="top"><a href="javascript: deleteMessage()">
					<img src="/msg/img/delete.gif" border="0" alt="Delete this message"></a>&nbsp;
				<%
					if(rMsg.getQueueType().equals("POINT-TO-POINT"))
					{ 
				%>
						<a href="/msg/MSGStaffCompose.jsp?mid=<%=rMsg.getMsgID()%>&pid=<%=rMsg.getPayloadID()%>&qid=<%=rMsg.getQueueID()%>&reply=y">
						<img src="/msg/img/reply.gif" width="70" height="29" border="0" alt="Reply to this Message"></a>
<% } 
%>
					</td></tr>
					<tr><td valign="top"><a href="javascript:checkForward()">
						<img src="/msg/img/forward_button.gif" align="absmiddle" border="0" alt="Forward this message to the selected channel"></a>&nbsp;&nbsp;
					<select name="fqid" class="cntblu" title="Select Channel to forward message">
<%
		for(int i=0; i<queueIDs.length; i++)
		{
			queueMaster= queues.getQueue(queueIDs[i]);
			if(queueMaster.getPayloadID()==payloadID)
				out.println("<option value=\""+queueIDs[i]+"\" "+(rMsg.getQueueID()==queueIDs[i]?" selected":"")+">"+queueMaster.getQDescr()+"</option>");	
		}
%>
					</select>
					</td>
				</tr>
  				<tr><td>
 				<jsp:include page="/msg/MSGFolderDropDown.jsp" flush="true">
				<jsp:param name="fid" value="<%=folderId.substring(1)%>" />
				</jsp:include>
				</td></tr>
 				<%
				String membersForAddressBook ="";//string denoting members to be added
				if(rMsg.getSenderAgentCatID()==1)// clite only
				{
					membersForAddressBook=", "+rMsg.getSender();
				}

				if(rMsg.getQueueType().equals("POINT-TO-POINT") && rMsg.getSentToList() != null )
				{
					membersForAddressBook+=", "+rMsg.getSentToList();
				}


				if(membersForAddressBook.length()>1 && !membersForAddressBook.trim().equalsIgnoreCase(", "+agent.getAgentName()))// there are members to be added
				{
				%>
				<tr>
				<td>
				<a href="/msg/list/MSGMembersStatus.jsp?qid=<%=rMsg.getQueueID() %>&receiver=<%=membersForAddressBook %>&cat=<%=cat %>&msgcnt=<%=msgCount %>&msgID=<%=msgID %>&pID=<%=payloadID %>&pn=<%=pageNo %>&seq=<%=messageSequence %>&rpage=<%=rPage %>&fid=<%=folderId %>&fldr=<%=folderName %>" class="lnkblu">Save Members to Address Book/Group List</a>
				</td>
				</tr>				
				<%
				}	
				%>
				
				</table>
				<!-- DELETE | REPLY | FORWARD | MOVE MESSAGE Table end //-->

				</td>
			</tr>
			<tr> 
				<td><img src="/img/blank.gif" width="15" height="20"></td>
				<td><font class="verbld">&nbsp;Sender</font></td>
				<td><font class="cnt"><%=rMsg.getSender()%></font>&nbsp;&nbsp;
				</td>
			</tr>
			<tr valign="top"> 
				<td><img src="/img/blank.gif" width="15" height="20"></td>
				<td><font class="verbld">&nbsp;Sent To</font></td>
				<td><font class="cnt">
<% 
	if(rMsg.getSentToList() != null && rMsg.getSentToList().length()>500)
	{
%>
			<textarea rows="3" name="S1" cols="35" style="background-color: #C0D9F5; color: #000000; border-style: solid; border-color: #C0D9F5" class="cnt" onFocus="blur()"><%=rMsg.getSentToList() %></textarea>
<%
	}
	else
	{
		// the following ternary operator applied here to take care of the situation
		// when the user sends a message to himself only and selects to save the message to
		// the sent items folder in which case rMsg.getSentToList() returns null
		out.println((rMsg.getSentToList() == null) ? rMsg.getSender() : rMsg.getSentToList());
	}
%>
				</font></td>
			</tr>
			<tr> 
				<td><img src="/img/blank.gif" width="15" height="20"></td>
				<td><font class="verbld">&nbsp;Subject</font></td>
				<td><font class="cnt">[<%=rMsg.getSubject()%>]</font></td>
			</tr>
			<tr> 
				<td><img src="/img/blank.gif" width="15" height="20"></td>
				<td><font class="verbld">&nbsp;Date</font></td>
				<td><font class="cnt"><%=rMsg.getCreateDate()%></font></td>
			</tr>
			<tr> 
				<td><img src="/img/blank.gif" width="15" height="10"></td>
				<td><img src="/img/blank.gif" width="15" height="10"></td>
				<td><img src="/img/blank.gif" width="15" height="10"></td>
			</tr>

				<tr><td><img src="/img/blank.gif" width="15" height="20"></td>
					<td colspan="3"><hr></td><tr>
				<tr> 
					<td><img src="/img/blank.gif" width="15" height="20"></td>
					<td colspan="3"> 
					    <jsp:include page="<%=includePage %>" flush="true">
					    <jsp:param name="source" value="MSGStaffRead.jsp"/>
					    </jsp:include>
					</td>
				</tr>
		</table>

		</td></tr>
		<tr><td align="center">
			<cl:MessageBoxHeadTag category="<%=Integer.toString(cat)%>" cpage="<%=Integer.toString(pageNo)%>" rpage="10" agentId="<%=Integer.toString(agent.getAgentID())%>" destId="<%=Integer.toString(agent.getDestID())%>" msgSeq="<%=Integer.toString(messageSequence)%>" folderId="<%=folderId%>" folderName="<%=folderName%>" folderMessageCount="<%=msgCount%>"/>
		</td></tr>
		</table>
<%
	}
	else
	{
%>
		<tr><td align="center">
			<cl:MessageBoxHeadTag category="<%=Integer.toString(cat)%>" cpage="<%=Integer.toString(pageNo)%>" rpage="10" agentId="<%=Integer.toString(agent.getAgentID())%>" destId="<%=Integer.toString(agent.getDestID())%>" msgSeq="<%=Integer.toString(messageSequence)%>" folderId="<%=folderId%>" folderName="<%=folderName%>" folderMessageCount="<%=msgCount%>"/>
		</td></tr>
	<tr><td class="verbld" align="center"><font color="red"><br>You have attempted to read a deleted message<br><br></font></td></tr>
		</form>
		</table>
		<!-- GREY BORDER TABLE END -->
<%
	}
  if(rMsg.getStatus() != -1)
  {
%>
		<tr bgcolor="#C0D9F5"><td colspan="2" align="right">
<%
	String folderType = (folderId.startsWith("S")) ? "SYSTEM" : "USER";
	MSGMessage tmp = null;

		tmp = inbox.getMessageInSequence(conn,agent.getAgentID(), agent.getDestID(), msgID, "prev",Integer.parseInt(folderId.substring(1)),folderType); 

		if(tmp.getMsgID()>0)
			out.println("<a href=\"/msg/MSGStaffRead.jsp?fid=" + folderId + "&fldr=" + folderName 
							+ "&msgcnt=" + msgCount + "&msgID="+tmp.getMsgID() + "&pID=" 
							+ queues.getQueue(tmp.getQueueID()).getPayloadID() + "&pn=" 
							+ ((messageSequence==1)? (pageNo-1) : pageNo) + "&seq=" 
							+ ((messageSequence==1)? rPage : (messageSequence - 1)) + "&rpage=" 
							+ rPage + "\" class=\"lnkblu\" title=\"Read previous message\">" 
							+ "Previous Message</a>&nbsp;");
		
		if(messageSequence == rPage)
		{
			pageNo++;
			messageSequence = 0;
		}
		tmp = inbox.getMessageInSequence(conn,agent.getAgentID(), agent.getDestID(), msgID, "next",Integer.parseInt(folderId.substring(1)),folderType); 

	if(tmp.getMsgID()>0)
		out.println("&nbsp;<a href=\"/msg/MSGStaffRead.jsp?fid=" + folderId + "&fldr=" + folderName 
						+ "&msgcnt=" + msgCount + "&msgID=" + tmp.getMsgID() + "&pID=" 
						+ queues.getQueue(tmp.getQueueID()).getPayloadID() + "&pn=" + pageNo 
						+ "&seq=" + (messageSequence + 1) + "&rpage=" + rPage 
						+ "\" class=\"lnkblu\" title=\"Read next message\">Next Message</a>"); 
%>
&nbsp;&nbsp;</td></tr>
<%}
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
//The status 4 means read/team reply and 5 means unread/team reply
	if (rMsg.getStatus()==4 || rMsg.getStatus()==5)
	{
		%>
		<tr><td colspan="2">
		<jsp:include page="/msg/admin/MSGShowReplies.jsp" flush="true">
		<jsp:param name="mid" value="<%=msgID%>"/>
		</jsp:include>
		</td></tr>
		<%
	}
	%>

	</table>
</td></tr></table>
</td></tr></table>
	</body>
	</html>
