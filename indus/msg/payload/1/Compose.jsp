<%
	String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
%>
<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>
<jsp:useBean id="wpayload" class="com.cl.msg.MSGTextPayload" scope="session" />
<jsp:setProperty name="wpayload" property="errorFileName" value="<%=logFile %>"/>
<jsp:useBean id="msg" class="com.cl.msg.MSGMessage" scope="session" />
<jsp:setProperty name="msg" property="errorFileName" value="<%=logFile %>"/>

<%@ page import="java.sql.Connection,com.cl.sql.PoolManager"%>
<%
	boolean reply = false;
	boolean fwd	  = false;
	int msgID	  = 0;
	int payloadID = 1;
try
{
	reply = (request.getParameter("reply") != null) 
				?	request.getParameter("reply").equalsIgnoreCase("y")
					? true : false
				: false;
	fwd = (request.getParameter("fwd") != null) 
				?	request.getParameter("fwd").equalsIgnoreCase("y")
					? true : false
				: false;
	msgID = Integer.parseInt(request.getParameter("msgID"));	
}
catch(NumberFormatException nfe)
{
	msgID=0;
}

if((reply || fwd) && msgID>0)
{
	PoolManager clmsPool = PoolManager.getInstance();
	Connection conn = null;
	try
	{
		conn = clmsPool.getConnection("erp");
		wpayload.readPayload(conn,msgID);
		msg.read(conn,agent.getAgentID(), agent.getDestID(), msgID, payloadID);
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
}

String addToMsg="";
try
{
	if(reply && msgID>0)
	{
		addToMsg="\n\n\n\n<< "+wpayload.getFilename()+" >>";
		wpayload.setFilename("");
	}
}
catch(NullPointerException npe)
{}

%>
	<table border="0" width="90%" cellspacing="0" cellpadding="0">
	<tr>
		<td><font class="new">[Maximum 2000 characters allowed]</font><br>
<% 
	String textareaValue = "";
	try
	{
		if((reply || fwd) && msgID > 0)
		{
			textareaValue = "\n\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\nOn " 
							+ msg.getCreateDate() + " " + msg.getSender() + " wrote: \n";
			textareaValue += wpayload.replace(wpayload.getBody(),"\n","\n>") + addToMsg;
		}
		else
		{
			textareaValue = wpayload.getBody();
		}
	}
	catch(NullPointerException npe){} 
%>
		<textarea name="body" cols="75" class="cnt" rows="15"><%=textareaValue%></textarea></td>
     </tr>
	<tr><td><img src="/img/blank.gif" height="10" width="10"></td></tr>
     <tr> 
		<td align="right"><font class="lnkblubld"><a href="javascript:send(document.payload)">
			<img src="/msg/img/send.gif" align="absmiddle" width="70" height="29" border="0" alt="Click here to send this message"></a></font>&nbsp;&nbsp;
			<font class="lnkblubld"><a href="javascript:attach(document.payload)">
			<img src="/msg/img/attach.gif" align="absmiddle" width="70" height="29" border="0" alt="Click here to attach a file to this message"></a></font><br>
<%	try
	{ 
%>
			<font class="cnt"><b><%=(wpayload.getFilename() != null) ? wpayload.getFilename() : ""%></b>
			<%=(wpayload.getFilename().length() > 0) ? "(1 file attached)" : ""%> </font>
<%
	}
	catch(NullPointerException npe){} 
%>		</td>
	</tr>
	<tr>
		<td class="new" width="60%"><div style="text-align:justify">
			<b><u>Note:</u></b><br>The system logs you out after 20 minutes of inactivity. It will not send the message if you take longer than that to compose your message. Save your message in a temporary file before you hit send if you are not sure.
			</div>
			</td>
		</tr>
</table>