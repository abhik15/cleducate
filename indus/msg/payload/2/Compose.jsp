<%
String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
%>
<%--
     -- Provides the interface to compose the payload
     --%>

<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>
<jsp:useBean id="w2payload" class="com.cl.msg.MSGXTextPayload" scope="session" />
<jsp:useBean id="msg" class="com.cl.msg.MSGMessage" scope="session" />
<jsp:setProperty name="msg" property="errorFileName" value="<%=logFile %>"/>

<%@ page import="java.sql.Connection,com.cl.sql.PoolManager"%>
<%
	boolean reply=false;
	boolean fwd=false;
	int msgID=0;
	int payloadID=1;
try
{
	reply= request.getParameter("reply")!=null?request.getParameter("reply").equalsIgnoreCase("y")? true:false:false;
	fwd= request.getParameter("fwd")!=null?request.getParameter("fwd").equalsIgnoreCase("y")? true:false:false;
	msgID= Integer.parseInt(request.getParameter("msgID"));
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
		w2payload.readPayload(conn,msgID);
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
	if(reply && msgID>0 && w2payload.getAttachedFiles()!=null && w2payload.getAttachedFiles().length>0)
	{
		addToMsg="\n\n\n\n";
		for(int i=0;i<w2payload.getAttachedFiles().length;i++)
			addToMsg+="<< "+(w2payload.getAttachedFiles())[i]+" >>";
		w2payload.setAttachments(null);
	}
}
catch(NullPointerException npe)
{}

%>
	<table border="0" width="90%" cellspacing="0" cellpadding="0">
	<tr>
		<td>
<%
	String textareaValue = "";
	try
	{
		if((reply || fwd) && msgID > 0)
		{
			textareaValue = "\n\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\nOn "
							+ msg.getCreateDate() + " " + msg.getSender() + " wrote: \n";
			textareaValue += w2payload.replace(w2payload.getBody(),"\n","\n>") + addToMsg;
		}
		else
		{
			textareaValue = w2payload.getBody();
		}
	if (textareaValue==null)
		textareaValue = "";
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
		String attachedFiles[] = w2payload.getAttachedFiles();
		if (attachedFiles!=null && attachedFiles.length>0)
		{
			out.println("<font class=\"cnt\"><b>");
			for(int i=0 ;i< attachedFiles.length;i++)
				out.println(attachedFiles[i]+"&nbsp;&nbsp;");
			out.println("</b>  ("+attachedFiles.length+" File(s) attached)</font>");
		}
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
