<%@ page import="java.sql.Connection,com.cl.sql.CLMSPoolManager,com.cl.msg.*,java.util.*"  errorPage="/msg/MSGErrorPage.jsp"%>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>


<%--
  -- Filename:	 MSGRetrievalUtility.jsp
  -- Author:     Shilpa Arora
  -- Create Date:16th Jan 2003
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
	<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
	<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="util" class="com.cl.msg.util.MSGRetrievalUtility" scope="page" />

	<%
		request.setAttribute("cat",Integer.toString(cat));
		request.setAttribute("jspname","/msg/MSGChannels.jsp");

	%>
<%
	String clSrc = (cat == 1) ? "/msg/MSGStaffCompose.jsp" : "/msg/MSGStudentCompose.jsp";
%>
<html>
<head>
<title> CLMS Message Retrieval Utility</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="expires" content="0">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">

<link rel="stylesheet" href="/styles/style.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!-- Add top.js for top band -->
<script language="javascript" src="/jscript/top.js"></script>
<table border="0" width="100%" cellspacing="0" cellpadding="3">
<%
	CLMSPoolManager clmsPool = CLMSPoolManager.getInstance();
	Connection conn = null;
	try
	{
		conn = clmsPool.getConnection("erp");
		queues.loadQueues(conn);

%>
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
			<td><font class="cntblu"><a href="/" class="lnkblu">Home</a> &gt; <%=cat==1?"<a href=\"/clzone/login/CLZone.jsp\" class=\"lnkblu\">CL Zone Home</a>":"<a href=\"/sis/SIS.jsp\" class=\"lnkblu\">SIS page</a>"%> &gt; <a href="/msg/MSGInbox.jsp?cat=<%=cat%>" class="lnkblu">Inbox</a> &gt; CLMS Message Retrieval Utility</font>
			</td>
		</tr>
		</table>
	</td></tr></table>
	<!-- TOP BAND END -->

	<table width="100%" cellpadding="3" cellspacing="0">
	<tr><td><img src="/img/blank.gif" width="5" height="10"></td></tr>
	<tr><td>
		<cl:writeChannels agentID="<%=agent.getAgentID() %>" destID="<%=agent.getDestID() %>" clSource="<%=clSrc%>" connObj="<%=conn%>" sisSource="/msg/admin/MSGPickStudents.jsp"/>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td align="left" height="30"><font class="cntnormal"><br>
		<%
		int qID = 0;
		int folderID = 0;
		String folderType = "";
		String fromDate=" ";
		String toDate=" ";
		String error = "";
		try
		{
			qID = Integer.parseInt(request.getParameter("qid"));
		}
		catch(NumberFormatException nfe)
		{
			throw new Exception("Invalid queue id passed-"+ request.getParameter("qid"));
		}
/////////////////////////////// Duration validations/processings start here
		String duration = request.getParameter("duration");
		if (duration.equals("dates"))
		{
			fromDate = request.getParameter("fromDate");
			toDate = request.getParameter("toDate");
			java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat ("dd/MM/yyyy");
			java.text.ParsePosition pos = new java.text.ParsePosition(0);
			formatter.setLenient(false);
			java.util.Date dateToDate= null;
			java.util.Date dateFromDate= null;
			try
			{
				error = "Please fill in the valid 'From Date' in the format dd/MM/<b>yyyy</b> ";
				dateFromDate= formatter.parse(fromDate);
				error = "Please fill in the valid 'To Date' in the format dd/MM/<b>yyyy</b> ";
				dateToDate= formatter.parse(toDate);
				error = "";
				if(!dateFromDate.before(dateToDate))
				{
					error = "Please check the dates you have specified('to date' is an earlier date than 'from date').";
				}
			}
			catch(java.text.ParseException exp)
			{
				//do nothing, this exception comes on the wrong user input and its applied here so that programs continues
				//the user will get informed of this in the app by checking the variable error
			}
		}
		else if (duration.equals("days"))
		{
			try
			{
				int days = Integer.parseInt(request.getParameter("days"));
				java.util.Date dateToDate= new java.util.Date();
				java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat ("dd/MM/yyyy");
				formatter.setLenient(false);
				toDate = formatter.format(dateToDate);
				java.util.Calendar cal = java.util.Calendar.getInstance();
				cal.setTime(dateToDate);
				cal.add(cal.DATE, -days);
				java.util.Date dateFromDate= cal.getTime();
				fromDate = formatter.format(dateFromDate);
			}
			catch(NumberFormatException nfe)
			{
				error = "Please fill in the number of days(digits like 4,20,37 etc.) to retreive the messages";
			}

		}
/////////////////////////////// Duration validations/processings end here
		try
		{
			String tmpFldr = request.getParameter("fid");
			folderType = (tmpFldr.substring(0,1).equals("S")?"SYSTEM":"USER");
			folderID = Integer.parseInt(tmpFldr.substring(1, tmpFldr.length()));
		}
		catch(NumberFormatException nfe)
		{
			throw new Exception("Invalid folder id passed"+request.getParameter("fid"));
		}

		if(error.equals(""))
		{
			int msgIDs[] = util.getMsgsToRetrieve(conn,qID,  agent.getAgentID(),  agent.getDestID(), agent.getAgentCatID(), fromDate,  toDate);
			if (msgIDs.length ==0 )
				out.println("<p class=\"new\">No messages were sent through the channel- "+queues.getQueue(qID).getQDescr()+" during the specified period.</p>");
			else
				out.println("<p class=\"lnkbld\">"+msgIDs.length+" message"+(msgIDs.length>1?"s were":" was")+" sent through the channel during the specified period...</p>");
			for(int i=0; i<msgIDs.length; i++)
			{
				out.println(util.retrieveMessage(conn,msgIDs[i], qID, agent.getAgentID(), agent.getDestID(), folderID, folderType)+"<br>");
			}
		}
		else
			out.println("<p class=\"new\" align=\"center\"><b>"+error+"</b></p><p align=\"center\"><form><input type=\"button\" value=\"Go Back to fill the Field(s)\" class=\"cnt\" onClick=\"javascript:window.history.back()\"></form></p>");

	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
		%>
    </td>
  </tr>
</table>
</td></tr></table>
    </td>
  </tr>
</table>

</body>
</html>

