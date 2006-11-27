<%@ page import="java.sql.Connection,com.cl.sql.CLMSPoolManager"  errorPage="/msg/MSGErrorPage.jsp"%>
<%--
  -- Filename:	 MSGChannel4Students.jsp
  -- Author:     Shilpa Arora
  -- Create Date:5th June 2002 
  --%>

<%
	int cat = 1;
	String logFile = application.getRealPath("/logs/error/") + "MSGErrorLog.log";
%>

<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
<jsp:useBean id="Systems" scope="application" class="com.cl.CLSystems"/>
<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>
<jsp:useBean id="queueMaster" class="com.cl.msg.MSGQueueMaster" scope="page" />
<jsp:useBean id="studentPicker" class="com.cl.msg.admin.MSGStudentPicker" scope="page" />
<jsp:setProperty name="studentPicker" property="errorFileName" value="<%=logFile %>"/>

<%
		int qID = 0;
		int payloadID = 0;
		boolean reply = false;
		int msgID = 0;
		String ddmmyy = new java.util.Date().toLocaleString();//displaying current time to the user
		String receiver = "";

		request.setAttribute("cat",Integer.toString(cat));
		request.setAttribute("jspname","/msg/MSGStudentsChannel.jsp");
		String source="/msg/admin/MSGPickStudents.jsp";	
		int queueIDs[] = null;
		CLMSPoolManager clmsPool = CLMSPoolManager.getInstance();
		Connection conn = null;
		try
		{
			conn = clmsPool.getConnection("erp");
			queues.loadQueues(conn);
			queueIDs = studentPicker.getWriteQueues(conn,agent.getAgentID(), agent.getDestID());
		}
		finally
		{
			clmsPool.freeConnection("erp",conn);
		}

		if(queueIDs!=null && queueIDs.length>0)
		{
%>
	<table border="0" align="center" width="95%" cellpadding="5" cellspacing="0">
	<tr><td colspan="2">
		<p><font class="cnt">The channels through which you can send message to the <b>Students</b> are listed below. <br>To compose a message please click on the channel through which you want to send it.</font></p>
	</td></tr>

<%
	for(int i=0; i<queueIDs.length; i++)
	{
		queueMaster= queues.getQueue(queueIDs[i]);
		out.println("<tr><td bgcolor=\"#C0D9F5\" width=\"10%\" valign=\"center\"><img src=\""+queueMaster.getIconURL()+" \"></td><td bgcolor=\"#C0D9F5\"><font class=\"cnt\"><a class=\"lnkblu\" href=\""+source+"?qid="+queueMaster.getQID()+"&pid="+queueMaster.getPayloadID()+"\">"+queueMaster.getQDescr()+"</a></font></td></tr>");	
	}
%>


	</table>
<%
	}
%>