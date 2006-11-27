<%--
  -- Filename:	 MSGStaffCompose.jsp
  -- Author:     Shilpa Arora
  -- Create Date:25th April 2002 
  --%>

<%
int cat=1;
int payloadID= 0;
try
{
	payloadID =  Integer.parseInt(request.getParameter("pid"));
}
catch(NumberFormatException nfe)
{
	payloadID = 0;
}
String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
request.setAttribute("cat",Integer.toString(cat));
request.setAttribute("jspname","/msg/MSGStaffCompose.jsp");
%>
<%@ page import="java.sql.Connection,com.cl.sql.CLMSPoolManager"  errorPage="/msg/MSGErrorPage.jsp"%>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>

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
	<jsp:useBean id="wpayload" class="com.cl.msg.MSGTextPayload" scope="session" />
	<jsp:setProperty name="wpayload" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="w2payload" class="com.cl.msg.MSGXTextPayload" scope="session" />
<%

	/**
	 * The variable @Message is used to display any message it got as a parameter as a result of any previous action causing
	 * the forward or include of this page. Hence, the use is to display the status of any previous action before this page.
	 * The variable is always obtained by request.getParameter("Message"); and this is used as a standard throughout the sis
	 * for displaying the status of the earlier task.
	 */
		String Message="";
		int qID=0;
		boolean reply=false;
		boolean fwd=false;
		int msgID=0;

		java.text.SimpleDateFormat formatter= new java.text.SimpleDateFormat ("MMMMM dd, yyyy hh:mm");
		java.util.Date currentTime_1 = new java.util.Date();
		String ddmmyy = formatter.format(currentTime_1);
 
		String receiver="";
		int parentMsgID=0;
		int receiverID=0;
		int receiverDestID=0;

		String saveToSentItems = request.getParameter("savemsg");
		if(saveToSentItems == null)
			saveToSentItems = "";
		
		try
		{
			parentMsgID= Integer.parseInt(request.getParameter("parentMsgID"));
		}
		catch(NumberFormatException nfe)
		{
			parentMsgID=0;
		}

		try
		{
			receiverID= Integer.parseInt(request.getParameter("receiverID"));
		}
		catch(NumberFormatException nfe)
		{
			receiverID=0;
		}

		try
		{
			receiverDestID= Integer.parseInt(request.getParameter("receiverDestID"));
		}
		catch(NumberFormatException nfe)
		{
			receiverDestID=0;
		}

		Message=request.getParameter("message");
		if(Message==null)Message="";
		if(Message.equals(""))
		{
			msg.setSubject("");
			msg.reset();
			if(payloadID==1)
				wpayload.reset();
			else if(payloadID==2)
				w2payload.reset();
		}

		receiver = request.getParameter("receiver");
		if(receiver == null)
			receiver="";
		try
		{
			qID = Integer.parseInt(request.getParameter("qid"));
			reply = (request.getParameter("reply") != null) 
						? request.getParameter("reply").equalsIgnoreCase("y")
							? true : false
						: false;
			fwd = (request.getParameter("fwd") != null) 
						? (request.getParameter("fwd").equalsIgnoreCase("y"))
							? true : false
						: false;
		}
		catch(NumberFormatException nfe)
		{
			qID = 0;
			payloadID = 0;
			//reply=false;//added as a correction on 6th may 2002
		}
		if(reply || fwd)
		try
		{
			msgID= Integer.parseInt(request.getParameter("mid"));// ERROR PRONE
		}
		catch(NumberFormatException nfe)
		{
			msgID=0;
		}
		
	%>
	<html>
<head>
<title>CLMS - Compose Message</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="expires" content="0">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">
<link rel="stylesheet" href="/styles/style.css" type="text/css">
<!-- Add top.js for top band -->
<%
	if(qID>0 && payloadID>0){
	%>
<script LANGUAGE="JavaScript" src="/msg/payload/<%=payloadID %>/jscript.js"></script>
<%
	}
	%>
<script language="javascript">
	function popup(qid)
	{
		fileUrl="";
		type=""; // for Address Book
		listType = document.payload.listType[document.payload.listType.selectedIndex].value;
		if (listType == "1")
		{
			fileUrl ="/msg/list/MSGLocationTree.jsp" ;
		}
		else if (listType == "2")
		{
			fileUrl="/msg/list/MSGMemberBook.jsp";
			type = "SYSTEM";
		}
		else if(listType == "4")
		{
			fileUrl="/msg/list/MSGMemberBook.jsp";
			type = "USER";
		}
		else
		{
			fileUrl="/msg/list/MSGReceivers.jsp"
		}
		tagpopup= window.open(fileUrl+"?qid="+qid+"&type="+type+"&receiver="+document.payload.receiver.value,"Members","status=no,toolbar=no,scrollbars=yes,width=450,height=460,top=10,left=10,resizable=yes");
	}

	</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script language="javascript" src="/jscript/top.js"></script>
<%
	String includePage="";
	String includePage2="";
	CLMSPoolManager clmsPool = CLMSPoolManager.getInstance();
	Connection conn = null;
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
			<td><font class="cntblu">
					<a href="/" class="lnkblu">Home</a> <font class="cntblu">&gt;</font> 
					<a href="/clzone/login/CLZone.jsp" class="lnkblu">
					CL Zone Home</a> &gt; 
					Compose Message</font>
			</td>
		</tr>
		</table>
	</td></tr></table>
	<!-- TOP BAND END -->
<%
		if(( reply || fwd) && msgID>0)
		{
			msg.read(conn,agent.getAgentID(), agent.getDestID(), msgID, payloadID);
			msg.setQueueType(queues.getQueue(msg.getQueueID()).getQType());
		}

		if(qID==0 || payloadID==0)
		{
			includePage="/msg/MSGWriteQueues.jsp";
			includePage2="/msg/admin/MSGChannel4Students.jsp";
		}	
		else
		{
			includePage="/msg/payload/"+payloadID+"/Compose.jsp";

%>
	<!-- MAIN TABLE AFTER TOP BAND START -->
	<table width="100%" cellpadding="3" cellspacing="0" BORDER=0>
	<tr><td><font class="cnt"><%=Message %>&nbsp;</font></td></tr>
	<tr><td>
		<cl:writeChannels agentID="<%=agent.getAgentID() %>" destID="<%=agent.getDestID() %>" connObj="<%=conn%>" clSource="/msg/MSGStaffCompose.jsp" sisSource="/msg/admin/MSGPickStudents.jsp"/>
	</td></tr>
	<tr><td>
	<!-- TABLE FOR COMPOSE BOX AND blue.gif START -->
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr> 
		<td rowspan="3" bgcolor="#C0D9F5"><img src="/img/blank.gif" width="10" height="5"></td>
		<td valign="bottom"><img src="/msg/img/blue.gif"></td>
	</tr>
	<tr bgcolor="#C0D9F5"><td><img src="/img/blank.gif" width="10" height="20"></td></tr>
	<tr>
		<td bgcolor="#C0D9F5" colspan="2" valign="top" align="left"> 
		<form method="post" action="/msg/payload/<%=payloadID %>/Send.jsp" name="payload" onSubmit="return validate(this)">
        <input type="hidden" name="source" value="/msg/MSGStaffCompose.jsp" >
        <input type="hidden" name="cat" value="<%=cat %>" >
        <input type="hidden" name="queueID" value="<%=qID %>" >
		<input type="hidden" name="queueType" value="<%=queues.getQueue(qID).getQType() %>" >
        <input type="hidden" name="payloadID" value="<%=payloadID %>" >
		<!-- GREY BORDER TABLE START -->
        <table width="98%" border="1" cellspacing="0" cellpadding="3" bordercolorlight="#999999" bordercolordark="#C0D9F5">
        <tr> 
			<td valign="top" align="left"> 

            <table width="100%" bgcolor="#C0D9F5" border="0" bordercolor=green cellspacing="0" cellpadding="0">
<%
			if(queues.getQueue(qID).getQType().equals("POINT-TO-POINT"))
			{	
%>
			<tr valign="center"> 
				
                <td align="right" colspan="3">
				<font class="new"><i>CLMS Location Keywords</i>- All, Head Office, Delhi, Mumbai, Noida, Faridabad, Thane, Chandigarh, Pune, Bangalore, Hyderabad, Patna, Kolkata, Network</font><br><font class="cnt">&nbsp;<a href="/msg/list/MSGCreateMemberBook.jsp?type=SYSTEM&display=full&cat=1" class="lnkblubld">My Address Book</a> &nbsp;<a href="/msg/list/MSGCreateMemberBook.jsp?type=USER&display=full&cat=1" class="lnkblubld">My Group List<a></font>
				
				</td>
            </tr>
<%
			}	
%>
			<tr valign="center"> 
				<td align="left" bgcolor="#C0D9F5"><img src="<%=queues.getQueue(qID).getIconURL()%>"></td>
                <td width="15%"><font class="verbld">&nbsp;Channel</font></td>
                <td><font class="cnt">&nbsp;<%=queues.getQueue(qID).getQDescr() %></font></td>
            </tr>
            <tr valign="top"> 
				<td><img src="/img/blank.gif" width="15" height="20"></td>
                <td><font class="verbld">&nbsp;Sender</font></td>
                <td><font class="cnt">&nbsp;<%=agent.getAgentName()%></font></td>
				<input type="hidden" name="senderID" value="<%=agent.getAgentID() %>">
				<input type="hidden" name="senderDestID" value="<%=agent.getDestID() %>">
				<input type="hidden" name="sender" value="<%=agent.getAgentName() %>">
			</tr>
<% 
			if(reply)
			{
%>
				<input type="hidden" name="reply" value="y">
				<input type="hidden" name="parentMsgID" value="<%=(parentMsgID > 0) ? Integer.toString(parentMsgID) : Integer.toString(msgID)%>">
				<input type="hidden" name="receiverID" value="<%=(msgID > 0) ? Integer.toString(msg.getSenderID()) : Integer.toString(receiverID)%>">
				<input type="hidden" name="receiverDestID" value="<%=(msgID > 0) ? Integer.toString(msg.getSenderDestID()) : Integer.toString(receiverDestID)%>">
				<input type="hidden" name="receiver" value="<%=(msgID > 0) ? msg.getSender() : receiver%>">
			<tr valign="top"> 
				<td><img src="/img/blank.gif" width="15" height="20"></td>
                <td><font class="verbld">&nbsp;Reply to</font></td>
				<td><font class="cnt">&nbsp;<%=(msgID > 0) ? msg.getSender() : receiver%></font></td>
			</tr>
<%
			}
			else if(queues.getQueue(qID).getQType().equals("POINT-TO-POINT"))
			{
%>
				<input type="hidden" name="receiverID" value="<%=msg.getSenderID() %>">
				<input type="hidden" name="receiverDestID" value="<%=msg.getSenderDestID() %>">
			<tr valign="top"> 
				<td><img src="/img/blank.gif" width="15" height="20"></td>
				<td><font class="verbld">&nbsp;To</font></td>
				<td class="cnt">
				&nbsp;<input type="text" size="27" name="receiver" value='<%=receiver%>' class="cnt" title="CLMS Location Keywords- All, Head Office, Delhi, Mumbai, Noida, Faridabad, Thane, Chandigarh, Pune, Bangalore, Hyderabad, Patna, Kolkata, Network">
				<a href="javascript:popup(<%=qID%>)" title="Click to choose receivers for <%=queues.getQueue(qID).getQDescr() %>">
					<img src="/msg/img/sel_names.gif" align="absmiddle" border="0"></a>&nbsp; 
					<%
						//the select contains the drop down for the user to choose between the location tree and his member list to select receivers for the message
					%>
					<select name="listType"  class="cntblu" title="Which list you want to choose your Receivers from?">
						<option value="2">from My Address Book</option>
						<option value="4">from My Group List</option>
						<option value="1">from Location Tree</option>

					</select><br><font size="1">
					[To send the message enter Location Keywords, CLMS Names, Nick Names (within ""), Group Names (within "") or enter by clicking on the <b>Select Names</b> button with the right choice from the drop down i.e. My Address Book/ My Group List/ Location Tree]</font>
					</td>
			</tr>
<%
			}
			else 
			{
%>
                <input type="hidden" name="receiver" value="##">
<%
			}
		
			if(fwd)
			{
%>
                <input type="hidden" name="fwd" value="y">
                <input type="hidden" name="parentMsgID" value="<%=(parentMsgID > 0) ? Integer.toString(parentMsgID) : Integer.toString(msgID)%>">
<%
			}
%>
			<tr valign="top"> 
				<td><img src="/img/blank.gif" width="15" height="20"></td>
                <td><font class="verbld">&nbsp;Subject</font></td>
<%
			String sub="";
			if(reply && msgID>0)
				sub="Re: ";
			if(fwd && msgID>0)
				sub="Fwd: ";
			if(msg != null) 
				sub += msg.getSubject();

%>    <td>&nbsp;<input type="text" name="subject" size="27" value="<%=sub%>" maxlength="50" class="cnt"></td>
            </tr>
			<tr valign="top"> 
				<td><img src="/img/blank.gif" width="15" height="20"></td>
				<td><font class="verbld">&nbsp;Date</font></td>
                <td><font class="cnt">&nbsp;<%=ddmmyy %></font></td>
            </tr>
			<tr valign="top"> 
				<td><img src="/img/blank.gif" width="15" height="20"></td>
				<td colspan="2">
<%
			if(saveToSentItems.equals("yes"))
			{
%>
					<input title="Check to Save this message to your sent items folder." type="checkbox" name="savemsg" value="yes" CHECKED>
<%			}
			else
			{
%>
					<input title="Check to Save this message to your sent items folder." type="checkbox" name="savemsg" value="yes">
<%			}
%>
					<font class="verbld">Save to Sent Items</font></td>
            </tr>
			<tr> 
				<td><img src="/img/blank.gif" width="15" height="10"></td>
				<td colspan="2"> 
<%
		}
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
	String rep = (reply) ? "y" : "n";
	String fw  = (fwd) ? "y" : "n";
%>
    <jsp:include page="<%=includePage %>" flush="true"> 
    <jsp:param name="source" value="MSGStaffCompose.jsp"/>
    <jsp:param name="reply" value="<%=rep%>" />
    <jsp:param name="fwd" value="<%=fw%>" />
    <jsp:param name="msgID" value="<%=msgID%>" />
    <jsp:param name="cat" value="<%=cat%>"/>
    </jsp:include>
<%
	    if(!(qID==0 || payloadID==0))
		{
%>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </form>
    </td>
  </tr>
</table>
</td></tr></table>
<%
	    }

		if (includePage2!=null && !includePage2.equals("")){
%>
<jsp:include page="<%=includePage2 %>" flush="true"> 
<jsp:param name="source" value="MSGStaffCompose.jsp"/>
<jsp:param name="reply" value="<%=rep %>" />
<jsp:param name="msgID" value="<%=msgID %>" />
<jsp:param name="cat" value="<%=cat %>"/>
</jsp:include>
<%
}	
%>
</td>
</tr>
</table>
</body>
</html>
