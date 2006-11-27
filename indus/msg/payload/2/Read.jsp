<%@ page import="java.sql.Connection,com.cl.sql.PoolManager,java.io.File"%>
<%
	String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
%>
<%--
     -- Reads the payload from the database
     --%>
<jsp:useBean id="rMsg" class="com.cl.msg.MSGMessage" scope="session" />
<jsp:setProperty name="rMsg" property="errorFileName" value="<%=logFile %>"/>
<jsp:useBean id="payload2Read" class="com.cl.msg.MSGXTextPayload" scope="page" />

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
		payload2Read.readPayload(conn,msgID);
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}

%>
	<table border="0" cellspacing="0" cellpadding="0" width="100%">

	<tr><td align="left" valign="top" class="cnt">
<%
	try
	{
		if(payload2Read.getAttachedFiles() != null && payload2Read.getAttachedFiles().length>0)
		{
			%>
			<font class="verbld">Attachment<%=(payload2Read.getAttachedFiles().length>1)?"s":""%></font>
			<%
			for (int i=0;i<payload2Read.getAttachedFiles().length;i++)
			{
			%>
			&nbsp;&nbsp;<a href="/servlet/MSGXTextDownloads?mid=<%=msgID%>&name=<%=payload2Read.getAttachedFiles()[i]%>" class="lnkbld"><%=payload2Read.getAttachedFiles()[i]%></a>
			<%
			}
			out.println("<font class=\"cntblu\">(Click on the filename to download it.)</font><br><hr>");
		}
	}
	catch(NullPointerException npe)
	{}

%>

		</td>
	</tr>
    <tr><td valign="top" height="250">
        <font class="cnt"><%=payload2Read.toHTML() %></font>
	</td></tr>

	</table>
