<%@ page import="java.sql.Connection,com.cl.sql.CLMSPoolManager"  errorPage="/msg/MSGErrorPage.jsp"%>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>

<%--
  -- Filename:	 MSGChangeSubscription.jsp
  -- Author:     Shilpa Arora
  -- Create Date:17th April 2002 
  --%>

<%
	int cat=0;
	try
	{
		cat= Integer.parseInt(request.getParameter("cat"));
	}
	catch(NumberFormatException nfe)
	{	cat=0;	}
	
	String logFile = application.getRealPath("/logs/error/")+"MSGErrorLog.log";
	String user = (cat == 0) ? "CUSTOMER" : "EMPLOYEE";
%>

<cl:CLValidateSessionTag userType="<%=user%>"/>
	<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
	<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="Systems" scope="application" class="com.cl.CLSystems"/>
	<jsp:useBean id="aq" class="com.cl.msg.MSGAgentQueue" scope="page" />
	<jsp:setProperty name="aq" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
	<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>

<%
	int totalQueues=0;
	int oldAccess[]=null;
	int newAccess[]=null;
	int queueArray[]=null;

	String result="You didn't request any change for subscription";

	request.setAttribute("cat",Integer.toString(cat));
	request.setAttribute("jspname","/msg/MSGChangeSubscription.jsp");

	int action=0;

	action      = Integer.parseInt(request.getParameter("action"));
	totalQueues = Integer.parseInt(request.getParameter("totCnt"));

	oldAccess  = new int[totalQueues];
	newAccess  = new int[totalQueues];
	queueArray = new int[totalQueues];

	boolean changed = false;
		
	for(int i=0;i<totalQueues;i++)
	{
		oldAccess[i] = (action == 0)? 1 : 0;
		newAccess[i] = action;
		try
		{
			queueArray[i] = Integer.parseInt(request.getParameter("q"+(i+1)));
		}
		catch(NumberFormatException nfe)
		{
			queueArray[i] = 0;
		}

		if(queueArray[i] > 0)
		{
			CLMSPoolManager pool = CLMSPoolManager.getInstance();
			Connection conn  = null;
			try
			{
				conn = pool.getConnection("erp");
				aq.changeSubscription(conn,agent.getAgentID(), agent.getDestID(),
									queueArray[i], (newAccess[i] == 1) ? true : false);
			}
			finally
			{
				pool.freeConnection("erp",conn);
			}
		}
	}
%>
	<jsp:forward page="/msg/MSGChannels.jsp" >
	<jsp:param name="cat" value="<%=cat %>" />
	</jsp:forward>
