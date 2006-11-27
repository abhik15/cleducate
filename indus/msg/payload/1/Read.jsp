<%@ page import="java.sql.Connection,com.cl.sql.PoolManager,java.io.File"%>
<%
	String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
%>

<jsp:useBean id="rMsg" class="com.cl.msg.MSGMessage" scope="session" />
<jsp:setProperty name="rMsg" property="errorFileName" value="<%=logFile %>"/>
<jsp:useBean id="payload1Read" class="com.cl.msg.MSGTextPayload" scope="session" />
<jsp:setProperty name="payload1Read" property="errorFileName" value="<%=logFile %>"/>

<%

	int msgID = 0;
	msgID = rMsg.getMsgID();
	if (msgID ==0)
	{
		try
		{
			msgID = Integer.parseInt(request.getParameter("mid"));
		}
		catch(NumberFormatException nfe)
		{
			throw new Exception("No messageID with the file");
		}
	}
	PoolManager clmsPool = PoolManager.getInstance();
	Connection conn = null;
	try
	{
		conn = clmsPool.getConnection("erp");
		payload1Read.readPayload(conn,msgID);
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
%>
	<table border="0" cellspacing="0" cellpadding="0" height="250">
    <tr><td valign="top">
        <font class="cnt"><%=payload1Read.toHTML() %></font>
	</td></tr>
	<tr><td align="left" valign="bottom" class="cnt">
<%
	try
	{
		if(payload1Read.getFilename() != null && !payload1Read.getFilename().equals(""))
		{
			String filePath = application.getRealPath("/msg/attch/" + rMsg.getSenderID() +
								"_" + rMsg.getSenderDestID() + "/" + msgID);
			File file = new File(filePath + File.separator + payload1Read.getFilename());
%>

<a href="/servlet/CLMSShowAttachments?msgid=<%=msgID%>"><img src="/msg/img/downloadfile.gif" align="absmiddle" width="70" height="29" border="0" alt="Download file- <%=payload1Read.getFilename() %>"></a> <font class="verbld"><%=payload1Read.getFilename()%></font>
<%		}
	}
	catch(NullPointerException npe)
	{}
%>
		</td>
	</tr>
	</table>
