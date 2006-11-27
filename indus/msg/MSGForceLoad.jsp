<%@ page import="java.sql.Connection,com.cl.sql.CLMSPoolManager"  errorPage="/msg/MSGErrorPage.jsp"%>
<%
String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
%>
	<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
	<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>
<%
	CLMSPoolManager clmsPool = CLMSPoolManager.getInstance();
	Connection conn = null;
	try
	{
		conn = clmsPool.getConnection("erp");
		queues.forceLoad(conn);
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
%>
done
