<%@ page import="java.sql.Connection,com.cl.sql.PoolManager" errorPage="/msg/MSGErrorPage.jsp"%>
<%
	Connection conn = null;
	PoolManager clmsPool = PoolManager.getInstance();
	String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
%>
<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>
<jsp:useBean id="agentQueue" class="com.cl.msg.MSGAgentQueue" scope="page" />
<jsp:setProperty name="agentQueue" property="errorFileName" value="<%=logFile %>"/>
<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
<jsp:useBean id="queueMaster" class="com.cl.msg.MSGQueueMaster" scope="page" />

<br>
<table border="0" align="center" width="95%" cellpadding="5" cellspacing="0">
<tr><td colspan="2">
<%
	request.setAttribute("jspname","/msg/MSGWriteQueues.jsp");
	String source= request.getParameter("source");
	String cat=request.getParameter("cat");
	int queueIDs[] = null;
	try
	{
		conn = clmsPool.getConnection("erp");
		queues.loadQueues(conn);

		queueIDs = agentQueue.getWriteQueues(conn,agent.getAgentID(), agent.getDestID());
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}

	if(queueIDs!=null && queueIDs.length>0)
	{
%>
		<p><font class="cnt">The channels to which you can send mails are listed below.<br>To compose a message please click on the channel through which you want to send it.</font></p>
<%
	}
	else
	{
%>
		<p class="cnt">Sorry! you are not subscribed to any channel through which you can send a message.<br> Please go to <a href="/msg/MSGChannels.jsp?cat=<%=cat%>" class="lnkblu">Choose your Channels</a> link to subscribe to any of the existing channels.</p>
<%
	}
%>
</td></tr>
<%
/*	for(int i=0; i<queueIDs.length; i++)
	{
		queueMaster= queues.getQueue(queueIDs[i]);
		out.println("<tr><td bgcolor=\"#C0D9F5\" width=\"10%\"><img src=\""+queueMaster.getIconURL()+" \"></td><td bgcolor=\"#C0D9F5\"><font class=\"cnt\"><a class=\"lnkblu\" href=\""+source+"?qid="+queueMaster.getQID()+"&pid="+queueMaster.getPayloadID()+"\">"+queueMaster.getQDescr()+"</a></font></td></tr>");	
	}
*/
	queueMaster= queues.getQueue(queueIDs[0]);
	out.println("<tr><td bgcolor=\"#C0D9F5\" width=\"10%\"><img src=\""+queueMaster.getIconURL()+" \"></td><td bgcolor=\"#C0D9F5\"><font class=\"cnt\"><a href=\"/msg/MSGStudentCompose.jsp?qid=1&pid=2\" class=\"lnkblu\">Contact Your Teacher</a></td></tr>");

	queueMaster= queues.getQueue(queueIDs[1]);
	out.println("<tr><td bgcolor=\"#C0D9F5\" width=\"10%\"><img src=\""+queueMaster.getIconURL()+" \"></td><td bgcolor=\"#C0D9F5\"><font class=\"cnt\"><a href=\"/msg/MSGStudentCompose.jsp?qid=28&pid=1\" class=\"lnkblu\">Principal's Desk</a></td></tr>");
%>
</table>