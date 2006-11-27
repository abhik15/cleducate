<%--
     -- Author Shilpa Arora
     -- Date 12 Dec 02
     -- Filename MSGShowReplies.jsp
     --%>


<%@ page import="com.cl.msg.*,org.apache.log4j.*,java.sql.Connection,com.cl.sql.CLMSPoolManager" %>
<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
<jsp:useBean id="rMsg" class="com.cl.msg.MSGMessage" scope="session" />

<%
Category logCategory = null;
String PKG_NAME = "clsite.msg.admin";
Connection conn = null;
CLMSPoolManager clmsPool = CLMSPoolManager.getInstance();
MSGMessage[] msgs = null;

int msgID = 0;
try
{
	msgID = Integer.parseInt(request.getParameter("mid"));
}
catch(NumberFormatException nfe)
{
	throw new Exception("Invalid messageID passed");
}


	try
	{
		conn = clmsPool.getConnection("erp");
		msgs = rMsg.getReplies(conn,msgID);
%>

<p class="lnkbld">The message was followed up <%=msgs.length%> time(s).</p>

<%
if(logCategory == null)
	logCategory = Category.getInstance(PKG_NAME);

for (int i=0;i< msgs.length; i++)
{
	rMsg.setMsgID(msgs[i].getMsgID());
%>


<!--
  -- The message initials, including the icons to show the reply and forwd status
  -->
<p class="lnkblu">Follow Up: <b><%= (i+1)%>(<%=msgs[i].getCreateStatus().equals("REP")?"Replied":(msgs[i].getCreateStatus().equals("FWD")?"Forwarded":"")%>)</b></p>
		<table bgcolor="#C0D9F5" width="100%" border="1" cellspacing="0" cellpadding="3" bordercolorlight="#999999" bordercolordark="#C0D9F5">
		<tr>
		<td rowspan="7" valign="top" bgcolor="white" width="50">
		<img src="/msg/img/<%=msgs[i].getCreateStatus().equals("REP")?"left":(msgs[i].getCreateStatus().equals("FWD")?"right":"")%>Arrow.gif">
		<img src="/msg/img/<%=msgs[i].getCreateStatus().equals("REP")?"left":(msgs[i].getCreateStatus().equals("FWD")?"right":"")%>Arrow.gif">

		</td>
		</tr>
		<tr>
			<td valign="top" colspan="3">
			<table width="100%" border="0" bordercolor=blue cellspacing="0" cellpadding="0">
			<tr><td width="5%" align="left" bgcolor="#C0D9F5">
				<img src="<%=queues.getQueue(msgs[i].getQueueID()).getIconURL() %>"></td>
				<td width="20%"><font class="verbld">&nbsp;Channel</font></td>
				<td><font class="cnt"><%=queues.getQueue(msgs[i].getQueueID()).getQDescr()%></font></td>
			</tr>
			<tr>
				<td><img src="/img/blank.gif" width="15" height="20"></td>
				<td><font class="verbld">&nbsp;Sender</font></td>
				<td><font class="cnt"><%=msgs[i].getSender()%></font></td>
			</tr>
			<tr valign="top">
				<td><img src="/img/blank.gif" width="15" height="20"></td>
				<td><font class="verbld">&nbsp;Sent To</font></td>
				<td><font class="cnt">
<%
	msgs[i].getMessageRecepients(conn,msgs[i].getMsgID());
	if(msgs[i].getSentToList().length()>500)
	{
%>
			<textarea rows="3" name="S1" cols="45" style="background-color: #C0D9F5; color: #000000; border-style: solid; border-color: #C0D9F5" class="cnt" onFocus="blur()"><!%=msgs[i].getSentToList() %></textarea>
<%
	}
	else
	{
		out.println(msgs[i].getSentToList());
	}
%>
				</font></td>
			</tr>
			<tr>
				<td><img src="/img/blank.gif" width="15" height="20"></td>
				<td><font class="verbld">&nbsp;Subject</font></td>
				<td><font class="cnt">[<%=msgs[i].getSubject()%>]</font></td>
			</tr>
			<tr>
				<td><img src="/img/blank.gif" width="15" height="20"></td>
				<td><font class="verbld">&nbsp;Date</font></td>
				<td><font class="cnt"><%=msgs[i].getCreateDate()%></font></td>
			</tr>
			<tr>
				<td colspan="3"><hr></td>
			</tr>

			<!--
  			-- The message body is included
  			-->
			<%
				String source = "/msg/payload/" + msgs[i].getPayloadID() +"/Read.jsp";
				//diff sources for diff payloads is included
			%>

			<tr><td width="35">&nbsp;</td><td colspan="2">
	    			<jsp:include page="<%=source %>" flush="true">
	    			<jsp:param name="source" value="MSGStaffRead.jsp"/>
	    			<jsp:param name="mid" value="<%=msgs[i].getMsgID() %>" />
	    			</jsp:include>
			</td></tr>
		</table>
</table>
<%
}
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
%>
