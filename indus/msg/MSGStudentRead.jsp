<%--
  -- Filename:	 MSGStaffCompose.jsp
  -- Author:     Shilpa Arora
  -- Create Date:25th April 2002 
  --%>

<%
int cat=0;
String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
%>
<%@ page import="java.sql.Connection,com.cl.sql.PoolManager,com.cl.sis.exception.*,com.cl.msg.MSGMessage"%> 
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>
	<cl:CLValidateSessionTag userType="CUSTOMER"/>
	<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
	<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
	<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="rMsg" class="com.cl.msg.MSGMessage" scope="session" />
	<jsp:setProperty name="rMsg" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="inbox" class="com.cl.msg.MSGInbox" scope="page" />
	<jsp:setProperty name="inbox" property="errorFileName" value="<%=logFile %>"/>

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
		System.out.println("1");
		request.setAttribute("cat",Integer.toString(cat));
		request.setAttribute("jspname","/msg/MSGStudentRead.jsp");

		PoolManager clmsPool = PoolManager.getInstance();
		Connection conn = null;
		String folderId = request.getParameter("fid");
		String folderName = request.getParameter("fldr");
		String msgCount = request.getParameter("msgcnt");
		String includePage = "";
		Message=request.getParameter("message");
		int messageSequence = 0;
		int rPage = 0;
		try
		{
			conn = clmsPool.getConnection("erp");
			System.out.println("conn:"+conn);
			if(Message==null)Message="";
				queues.loadQueues(conn);
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
				pn = Integer.parseInt(request.getParameter("pn"));
			}
			catch(NumberFormatException nfe)
			{
				pn=1;
			}

			rMsg.read(conn,agent.getAgentID(), agent.getDestID(), msgID, payloadID);
			rMsg.setQueueType(queues.getQueue(rMsg.getQueueID()).getQType());
		
			//will be used to set the pageNo for next message and prev message links
			messageSequence = Integer.parseInt(request.getParameter("seq"));
			rPage = Integer.parseInt(request.getParameter("rpage"));
			includePage="/msg/payload/"+payloadID+"/Read.jsp";
	%>
	<html>
	<head>
	<title>SIS- Read Message</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache">
	<link href="/styles/indus.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="/styles/style.css" type="text/css">
	<script LANGUAGE="JavaScript" src="/msg/payload/<%=payloadID %>/jscript.js"></script> 
	<script>
		function newWindow()
		{			window.open('/clzone/apps/cat/ExamCLHome.jsp?uid=<%=session.getAttribute("uid")%>',"catexam","toolbar=no,location=no,status=no,scrollbars=yes,menubar=no,width=500,height=400");
			return false;
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
	
	<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="1" align="left" valign="top" bgcolor="#E0E0E0"><img src="/img/1x1.gif" width="1" height="1" /></td>
	<tr valign="top">
	<td width="174" align="left" valign="top" bgcolor="#999933">
		<cl:CLMsgSisLeftBandTag connObj="<%=conn%>" category="<%=Integer.toString(cat)%>" level="1"/>
	</td>
	<td valign="top">
	
	<!-- TOP BAND START -->
	<table align="center" width="100%" cellspacing="0" cellpadding="0">
	<tr><td bgcolor="B4BC6D">
		<table border="0" cellspacing="0" cellpadding="0">
		<tr><td bgcolor="B4BC6D" height="32" width="10">
				<img src="/img/blank.gif" width="1" height="28">
			</td>
			<td><font class="cntblu"><a href="/" class="lnkblu">home</a><font class="cntblu"> &gt; </font><a href="/sis/sis.jsp" class="lnkblu">SIS Page</a> &gt; <a href="/msg/MSGInbox.jsp?cat=0&fid=<%=folderId%>&fldr=<%=folderName%>" class="lnkblu"><%=java.net.URLDecoder.decode(folderName)%></a> &gt; Read Message</font>
			</td>
		</tr>
		</table>
	</td></tr></table>
	<!-- TOP BAND END -->

	<!-- MAIN TABLE AFTER TOP BAND START -->
	<table width="100%" cellpadding="3" cellspacing="0">
	<tr><td bgcolor="#ffffff"><img src="/img/blank.gif" width="10" height="10"></td></tr>
	<tr><td>
	  <cl:writeChannels agentID="<%=agent.getAgentID() %>" destID="<%=agent.getDestID() %>" clSource="/msg/MSGStudentCompose.jsp" connObj="<%=conn%>" sisSource="/"/>
	</td></tr>
	<tr><td>
	
	<table width="100%" BORDER=0 cellspacing="0" cellpadding="0">
	<tr> 
		<td rowspan="3" bgcolor="#C0D9F5"><img src="/msg/img/blank.gif" width="15" height="5"></td>
		<td valign="bottom"><img src="/msg/img/blue.gif"></td>
	</tr>
	<tr><td bgcolor="#C0D9F5"><img src="/msg/img/blank.gif" width="15" height="15"></td></tr>

	<tr><td bgcolor="#C0D9F5" valign="top"> 
		<%--
		  -- Form used for the deletion of message
		  --%>
		<form method="POST" name="messageForm" >
		<input type="hidden" name="source" value="/msg/MSGInbox.jsp" >	    
		<input type="hidden" name="pn" value="<%=pn %>" >
		<input type="hidden" name="cat" value="0" >
		<input type="hidden" name="totMsg" value="1" >
		<input type="hidden" name="msgs" value="<%=rMsg.getMsgID() %>" >	    
		<input type="hidden" name="fid" value="<%=folderId%>">
		<input type="hidden" name="fldr" value="<%=folderName%>">

		<table width="97%" border="1" cellspacing="0" cellpadding="0" bordercolorlight="#999999" bordercolordark="#C0D9F5">
<%
	if(rMsg.getStatus() != -1)
	{
%>
		<tr><td bgcolor="#C0D9F5" valign="top" align="left"> 
			<table width="100%" border="0" cellspacing="0" cellpadding="3">
			<tr><td width="5%" valign="top">
				<img src="<%=queues.getQueue(rMsg.getQueueID()).getIconURL() %>" align="absmiddle">
				</td>
				<td width="12%"><font class="verbld">Channel</font></td>
				<td width="38%"><font class="cnt"><%=queues.getQueue(rMsg.getQueueID()).getQDescr() %></font></td>
				<td width="45%" valign="top" rowspan="5" align="right">

				<table border="0" cellspacing="0" cellpadding="3">
				<tr> 
					<td><a href="javascript: deleteMessage()"><img src="/msg/img/delete.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
<%	if(rMsg.getQueueType().equals("POINT-TO-POINT"))
	{ 
%>						<a class="lnkblubld" href="/msg/MSGStudentCompose.jsp?mid=<%=rMsg.getMsgID()%>&pid=<%=rMsg.getPayloadID()%>&qid=<%=rMsg.getQueueID()%>&reply=y">
						<img src="/msg/img/reply.gif" align="absmiddle" width="70" height="29" border="0"></font></a>&nbsp;&nbsp;
<%	} %>			
				</td></tr>
				<tr><td>
				<jsp:include page="/msg/MSGFolderDropDown.jsp" flush="true">
				<jsp:param name="fid" value="<%=folderId.substring(1)%>" />
				</jsp:include>
				</td></tr>
				</table>
				
				
				
				
				</td>
			</tr>
			<tr> 
				<td><img src="/img/blank.gif" width="5" height="5"></td>
				<td><font class="verbld">Sender</font></td>
				<td><font class="cnt"><%=rMsg.getSender() %></font></td>
			</tr>
			<tr> 
				<td><img src="/img/blank.gif" width="5" height="5"></td>
				<td><font class="verbld">Sent To</font></td>
				<td><font class="cnt"><%=rMsg.getSentToList()%></font></td>
			</tr>
			<tr> 
				<td><img src="/img/blank.gif" width="5" height="5"></td>
				<td><font class="verbld">Subject</font></td>
				<td><font class="cnt"><%=rMsg.getSubject() %></font></td>
			</tr>
			<tr> 
				<td><img src="/img/blank.gif" width="5" height="5"></td>
				<td><font class="verbld">Date</font></td>
				<td><font class="cnt"><%=rMsg.getCreateDate() %></font></td>
			</tr>
			<tr> 
				<td><img src="/img/blank.gif" width="5" height="5"></td>
				<td colspan="3"> <hr>
					<jsp:include page="<%=includePage %>" flush="true">
					<jsp:param name="source" value="MSGStudentRead.jsp"/>
					</jsp:include>
				</td>
			</tr>
		    </form>
		</table>
		</td></tr>
		<tr><td align="center">
			<cl:MessageBoxHeadTag category="<%=Integer.toString(cat)%>" cpage="<%=Integer.toString(pn)%>" rpage="10" agentId="<%=Integer.toString(agent.getAgentID())%>" destId="<%=Integer.toString(agent.getDestID())%>" msgSeq="<%=Integer.toString(messageSequence)%>" folderId="<%=folderId%>" folderName="<%=folderName%>" folderMessageCount="<%=msgCount%>"/>
		</td></tr>
<%
	}
	else
	{
%>
		<tr><td align="center">
			<cl:MessageBoxHeadTag category="<%=Integer.toString(cat)%>" cpage="<%=Integer.toString(pn)%>" rpage="10" agentId="<%=Integer.toString(agent.getAgentID())%>" destId="<%=Integer.toString(agent.getDestID())%>" msgSeq="<%=Integer.toString(messageSequence)%>" folderId="<%=folderId%>" folderName="<%=folderName%>" folderMessageCount="<%=msgCount%>"/>
		</td></tr>
		<tr><td class="verbld" align="center"><font color="red"><br>You have attempted to read a deleted message<br><br></font></td></tr>
<%	}
%>
	  </table>
			    </td>
			  </tr>
		</td></tr>
		<!-- GREY BORDER TABLE END -->
<%	if(rMsg.getStatus() != -1)
	{
%>
		<tr bgcolor="#C0D9F5"><td colspan="2" align="right">
<%
	
		int fid = Integer.parseInt(folderId.substring(1));
		String folderType = (folderId.startsWith("S")) ? "SYSTEM" : "USER";
		MSGMessage tmp = inbox.getMessageInSequence(conn,agent.getAgentID(), agent.getDestID(), msgID, "prev",fid,folderType); 
		if(tmp.getMsgID()>0)
			out.println("<a href=\"/msg/MSGStudentRead.jsp?fid=" + folderId + "&fldr=" + folderName + "&msgcnt=" + msgCount + "&msgID=" + tmp.getMsgID() + "&pID="+queues.getQueue(tmp.getQueueID()).getPayloadID()+ "&pn=" + ((messageSequence==1)? (pn -1) : pn) + "&seq=" + ((messageSequence==1)? rPage : (messageSequence - 1)) + "&rpage=" + rPage + "\" class=\"lnkblu\" title=\"Read previous message.\">Previous Message</a>&nbsp;") ;
	
		if(messageSequence == rPage)
		{
			pn++;
			messageSequence = 0;
		}
		tmp = inbox.getMessageInSequence(conn,agent.getAgentID(), agent.getDestID(), msgID, "next",fid,folderType); 
		if(tmp.getMsgID()>0)
			out.println("&nbsp;<a href=\"/msg/MSGStudentRead.jsp?fid=" + folderId + "&fldr=" + folderName + "&msgcnt=" + msgCount + "&msgID=" + tmp.getMsgID() + "&pID=" + queues.getQueue(tmp.getQueueID()).getPayloadID()+ "&pn=" + pn + "&seq=" + (messageSequence+1) + "&rpage=" + rPage + "\" class=\"lnkblu\" title=\"Read next message.\">Next Message</a>"); 
%>
		
		&nbsp;&nbsp;&nbsp;</td></tr>
<%	
	}
}
finally
{
	clmsPool.freeConnection("erp",conn);
}
%>
		<tr bgcolor="#C0D9F5"><td colspan="2"><img src="/img/blank.gif" width="5" height="10"></td></tr>
			</table>
	</td>
	</tr>
	</table>
	</td></tr></table>
	</body>
	</html>
