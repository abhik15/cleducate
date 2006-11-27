<%@ page import="java.sql.*,com.cl.sql.CLMSPoolManager"  errorPage="/msg/MSGErrorPage.jsp"%>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>


<%--
  -- Filename:	 MSGChannels.jsp
  -- Author:     Shilpa Arora
  -- Create Date:17th April 2002 
  --%>

<%
String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
int cat=0;
try{
cat= Integer.parseInt(request.getParameter("cat"));
}catch(NumberFormatException nfe){cat=0;}
String user=cat==0?"CUSTOMER":"EMPLOYEE";
%>
	<cl:CLValidateSessionTag userType="<%=user%>"/>
	<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
	<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="Systems" scope="application" class="com.cl.CLSystems"/>
	<jsp:useBean id="inbox" class="com.cl.msg.MSGInbox" scope="page" />
	<jsp:setProperty name="inbox" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
	<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="aq" class="com.cl.msg.MSGAgentQueue" scope="page" />
	<jsp:setProperty name="aq" property="errorFileName" value="<%=logFile %>"/>

	<%!
	/**
	 * The variable @Message is used to display any message it got as a parameter as a result of any previous action causing
	 * the forward or include of this page. Hence, the use is to display the status of any previous action before this page.
	 * The variable is always obtained by request.getParameter("Message"); and this is used as a standard throughout the sis
	 * for displaying the status of the earlier task.
	 */
		String Message="";
		int qIDs[]=null;
		int sqIDs[]=null;//subscribed channels
	%>
	<%
		request.setAttribute("cat",Integer.toString(cat));
		request.setAttribute("jspname","/msg/MSGChannels.jsp");
		Message=request.getParameter("message");
		if(Message==null)Message="";
		
		CLMSPoolManager pool = CLMSPoolManager.getInstance();
		Connection conn = null;
		try
		{
			conn = pool.getConnection("erp");
			queues.loadQueues(conn);
			qIDs= aq.getQueuesForSubscription(conn,agent.getAgentID(), agent.getDestID());
			sqIDs= aq.getSubscribedQueues(conn,agent.getAgentID(), agent.getDestID(),0);
%>
			<html>
			<head>
			<title>Your Channels</title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<meta http-equiv="expires" content="0">
			<meta http-equiv="pragma" content="no-cache">
			<meta http-equiv="Cache-Control" content="no-cache">

			<link rel="stylesheet" href="/styles/style.css" type="text/css">
			<script langauge="javascript">
			function callManual(callFile){
			document.manualForm.action=callFile;
			document.manualForm.submit();
			}

			function validate(formname){
				checked =0;
				for(i=0;i<formname.elements.length;i++){
					if(formname.elements[i].type=="checkbox" && formname.elements[i].checked==true){
							checked++;	
					}
				}
				if(checked==0){
					alert("Please select channel(s) to request any change in subscription");
					return false;
				}
				else{
					return true;
				}
			}

			</script>
			</head>
			<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
			<!-- Add top.js for top band -->
			<script language="javascript" src="/jscript/top.js"></script>
			<table border="0" width="100%" cellspacing="0" cellpadding="3">
				<tr valign="top"><td bgcolor="DFE1BC" width="21%" valign="top">
					<cl:CLMsgSisLeftBandTag connObj="<%=conn%>" category="<%=Integer.toString(cat)%>" level="1"/>
				</td>
				<td width="79%" valign="top">
				<!-- TOP BAND START -->
				<table align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td bgcolor="B4BC6D">
					<table border="0" cellspacing="0" cellpadding="0">
					<tr><td bgcolor="B4BC6D" height="32" width="10">
							<img src="/img/blank.gif" width="1" height="28">
						</td>
						<td><font class="cntblu"><a href="/" class="lnkblu">Home</a> &gt; <%=cat==1?"<a href=\"/clzone/login/CLZone.jsp\" class=\"lnkblu\">CL Zone Home</a>":"<a href=\"/sis/SIS.jsp\" class=\"lnkblu\">SIS page</a>"%> &gt; Choose your Channels</font>
						</td>
					</tr>
					</table>
				</td></tr></table>
				<!-- TOP BAND END -->

				<table width="100%" cellpadding="3" cellspacing="0">
				<tr><td><img src="/img/blank.gif" width="5" height="10"></td></tr>
				<tr><td>
			<%
				String clSrc = (cat == 1) ? "/msg/MSGStaffCompose.jsp" : "/msg/MSGStudentCompose.jsp";
			%>
					<cl:writeChannels agentID="<%=agent.getAgentID() %>" destID="<%=agent.getDestID() %>" clSource="<%=clSrc%>" connObj="<%=conn%>" sisSource="/msg/admin/MSGPickStudents.jsp"/>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr><td align="left" height="30"><font class="cntnormal"><br>
			<%
				if(qIDs==null || qIDs.length==0)
				{
					out.println("Sorry!! you have no channels to choose.");
				}
				else
				{
					if(sqIDs != null && sqIDs.length > 0)
					{
			%>
						<br>You are subscribed to the following channel(s) at the moment. 
						To unsubscribe from a channel just select it and press the unsubscribe button.
						<form action="MSGChangeSubscription.jsp" method="post" onSubmit="return validate(this)">
						<input type="hidden" name="totCnt" value="<%=sqIDs.length %>">
						<input type="hidden" name="action" value="0">
						<input type="hidden" name="cat" value="<%=cat %>">
						
						<table bgcolor="#C0D9F5" width="80%" cellpadding="2" cellspacing="7" border=0 align="center">
			<%
						for(int i=0;i<sqIDs.length;i++)
						{
			%>
						<tr valign="top"><td width="5%">
							<img src="<%=queues.getQueue(sqIDs[i])!=null?queues.getQueue(sqIDs[i]).getIconURL():"" %>">
						</td>
						<td width="30%"><font class="cnt">
							<%=queues.getQueue(sqIDs[i])!=null?queues.getQueue(sqIDs[i]).getQDescr():"" %>
						</font></td>
						<td width="30%"><font class="cnt">
							<%=aq.getAccessInfo(conn, sqIDs[i], agent.getAgentID(), agent.getDestID()) %>
						</font></td>
						<td width="30%"><font class="cnt">
							<%=queues.getQueue(sqIDs[i])!=null?queues.getQueue(sqIDs[i]).getQType().equals("CHANNEL")?"<a href=\"javascript:callManual('/msg/MSGManual.jsp#broadcast')\">Broadcast</a>":"<a href=\"javascript:callManual('/msg/MSGManual.jsp#point')\">"+queues.getQueue(sqIDs[i]).getQType()+"</a>":"" %>
						</font></td>
						<td width="5%" align="right">
							<input type="checkbox" name="q<%=(i+1) %>" value="<%=sqIDs[i] %>">
						</td></tr>
			<%
						}
			%>
						<tr valign="top"><td colspan="5" align="center"><input type="submit" value="Unsubscribe"></td></tr>
						</table>
						</form>
			<%
					}
					int y=0;//index for the subscribed queue array
					if(sqIDs.length<qIDs.length)
					{
			%>
				
						You are not subscribed to the following channel(s) but you can subscribe to them just by selecting them and pressing the subscribe button.
						<form action="MSGChangeSubscription.jsp" method="post" onSubmit="return validate(this)">
						<input type="hidden" name="totCnt" value="<%=qIDs.length %>">
						<input type="hidden" name="action" value="1">
						<input type="hidden" name="cat" value="<%=cat %>">
						<table bgcolor="#C0D9F5" width="80%" cellpadding="2" cellspacing="7" border=0 align="center">
			<%
						for(int i=0;i<qIDs.length;i++)
						{
							if((y<sqIDs.length && qIDs[i]!=sqIDs[y]) || y>=sqIDs.length)
							{
			%>
						<tr valign="top">
						<td width="5%"><img src="<%=queues.getQueue(qIDs[i])!=null?queues.getQueue(qIDs[i]).getIconURL():"" %>"></td>
						<td width="30%"><font class="cnt"><%=queues.getQueue(qIDs[i])!=null?queues.getQueue(qIDs[i]).getQDescr():"" %></font></td>
						<td width="30%"><font class="cnt"><%=queues.getAccessInfo(conn, qIDs[i], cat==0?2:cat) %></font></td>
						<td width="30%"><font class="cnt"><%=queues.getQueue(qIDs[i])!=null?queues.getQueue(qIDs[i]).getQType().equals("CHANNEL")?"<a href=\"javascript:callManual('/msg/MSGManual.jsp#broadcast')\">Broadcast</a>":"<a href=\"javascript:callManual('/msg/MSGManual.jsp#point')\">"+queues.getQueue(qIDs[i]).getQType()+"</a>":"" %></font></td>
						<td width="5%" align="right"><input type="checkbox" name="q<%=(i+1) %>" value="<%=qIDs[i] %>"></td>
						</tr>
			<%
							}
							else
							{
								y++;
							}
						}
			%>
						<tr valign="top"><td colspan="5" align="center"><input type="submit" value="Subscribe"></td></tr>
						</table>
						</form>
			<%
					}
			%>
				
					To send a message to the channel to which you can send message(s), subscribe for it and go to the Compose Message and click on the channel's name. 
			<%
				}
					sqIDs = aq.getSubscribedQueues(conn,agent.getAgentID(), agent.getDestID(),1);
					String userDisplay="";
					if(sqIDs.length>0)
					{
						if(qIDs.length>0)
							userDisplay="apart from the channels mentioned above";
						else 
							userDisplay="you dont have any channels to choose but";
			 %>
				<br>
				<p>
				Dear user, <%=userDisplay %> you have some <a href="javascript:callManual('/msg/MSGManual.jsp#auto')">autosubscribed channels</a> which are as follows, please note that you cannot unsubscribe from these channels</p>
						<table bgcolor="#C0D9F5" width="80%" cellpadding="2" cellspacing="7" border=0 align="center">
			<%
					for(int i=0;i<sqIDs.length;i++)
					{
			%>
					<tr valign="top">
					<td width="5%"><img src="<%=queues.getQueue(sqIDs[i])!=null?queues.getQueue(sqIDs[i]).getIconURL():"" %>"></td>
					<td width="30%"><font class="cnt"><%=queues.getQueue(sqIDs[i])!=null?queues.getQueue(sqIDs[i]).getQDescr():"" %></font></td>
					<td width="30%"><font class="cnt"><%=aq.getAccessInfo(conn, sqIDs[i], agent.getAgentID(), agent.getDestID()) %></font></td>
					<td width="30%"><font class="cnt"><%=queues.getQueue(sqIDs[i])!=null?queues.getQueue(sqIDs[i]).getQType().equals("CHANNEL")?"<a href=\"javascript:callManual('/msg/MSGManual.jsp#broadcast')\">Broadcast</a>":"<a href=\"javascript:callManual('/msg/MSGManual.jsp#point')\">"+queues.getQueue(sqIDs[i]).getQType()+"</a>":"" %></font></td>
					<td width="5%" align="right">&nbsp;</td>
					</tr>
			<%
					}
			%>
					</table>
			<%
					}
			%>
			 </font>   
				</td>
			  </tr>
			</table>
			</td></tr></table>
			<form name="manualForm" action="/msg/MSGManual.jsp" method="post">
			<input type="hidden" name="cat" value="1">
			</form>
				</td>
			  </tr>
			</table>
			</body>
			</html>
		<%
		}	
		finally
		{
			pool.freeConnection( "erp", conn);
		}
		%>