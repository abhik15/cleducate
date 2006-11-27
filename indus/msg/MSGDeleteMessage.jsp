<%@ page import="java.sql.*,com.cl.sql.PoolManager" errorPage="/msg/MSGErrorPage.jsp"%> 
<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />

<%--
  -- Filename:	 MSGDeleteMessage.jsp
  -- Author:     Shilpa Arora
  -- Create Date:15th April 2002 
  --%>

<%
	String logFile = application.getRealPath("/logs/error/")+"MSGErrorLog.log";
	int cat=0;
	try
	{
		cat = Integer.parseInt(request.getParameter("cat"));
	}
	catch(NumberFormatException nfe){cat=0;}
	String user = (cat == 0) ? "CUSTOMER" : "EMPLOYEE";
%>

	<cl:CLValidateSessionTag userType="<%=user%>"/>
	<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="msg" class="com.cl.msg.MSGMessage" scope="page" />
	<jsp:setProperty name="msg" property="errorFileName" value="<%=logFile %>"/>

	<%
	request.setAttribute("cat",Integer.toString(cat));
	request.setAttribute("jspname","/msg/MSGDeleteMessage.jsp");

	PoolManager pool = PoolManager.getInstance();
	Connection connection = pool.getConnection("erp");

		String source= request.getParameter("source");
		int pn=1;
		try{
			pn= Integer.parseInt(request.getParameter("pn"));
			}catch(NumberFormatException nfe){
				pn=1;
			}
	try
	{

		String[] msgIds = request.getParameterValues("msgs");
		if(msgIds != null)
		{
			for(int i=0; i< msgIds.length; i++)
			{
				try
				{
					int msgId = Integer.parseInt(msgIds[i]);
					msg.deleteMessage(connection, agent.getAgentID(), agent.getDestID(), msgId);
				}
				catch(NumberFormatException nfe){}//simply ignore the absence of msgID
			}
		}
	}	
	finally
	{
		pool.freeConnection( "erp", connection);
	}
	%>
	<jsp:forward page="<%=source %>" >
	<jsp:param name="pn" value="<%=pn %>" />
	<jsp:param name="cat" value="<%=cat %>" />
	</jsp:forward>
