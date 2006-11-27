<%--
  -- Filename:	 MSGManual.jsp
  -- Author:     Shilpa Arora
  -- Create Date:29th April 2002 
  --%>
<%
String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
%>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl"%>
<%@ page import="java.sql.Connection,com.cl.sql.CLMSPoolManager" errorPage="/msg/MSGErrorPage.jsp"%>


<%
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

<html><head>
<title>About CLMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="/styles/style.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!-- Add top.js for top band -->
<script language="javascript" src="/jscript/top.js"></script>
<table border="0" width="100%" cellspacing="0" cellpadding="3">
<%
	String clSrc = (cat == 1) ? "/msg/MSGStaffCompose.jsp" : "/msg/MSGStudentCompose.jsp";
	CLMSPoolManager clmsPool = CLMSPoolManager.getInstance();
	Connection conn = null;
	try
	{
		conn = clmsPool.getConnection("erp");
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
			<td><font class="cntblu"><a href="/" class="lnkblu">Home</a> &gt; <%=cat==1?"<a href=\"/clzone/login/CLZone.jsp\" class=\"lnkblu\">CL Zone Home</a>":"<a href=\"/sis/SIS.jsp\" class=\"lnkblu\">SIS page</a>"%> &gt; About CLMS</font>
			</td>
		</tr>
		</table>
	</td></tr></table>
	<!-- TOP BAND END -->

<table width="100%" border="0" cellspacing="0" cellpadding="5" align="left" class="cnt">
  <tr><td align="left"><img src="/img/blank.gif" width="5" height="10"></td></tr>
		<tr><td>

			<cl:writeChannels agentID="<%=agent.getAgentID() %>" destID="<%=agent.getDestID() %>" clSource="<%=clSrc%>" connObj="<%=conn%>" sisSource="/msg/admin/MSGPickStudents.jsp"/>
<%	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
%>
		</td></tr>
  <tr> 
    <td align="left" height="30"><font class="cnt"><br>
	<p align="center" class="verbld">CL Messaging System</p>
	<p>The CLMS or the CL Messaging System is a system to exchange Messages among the
	whole CL group be it an employee, a network franchisee or a student. The aim is
	to enhance communication in the whole CL Family.</p>
	<p><u><b>The Nomenclature<br>
	</b></u>Please go through the words described below as they are being used in
	CLMS to have a better clarity of the system.</p>
	<p><b>User<br>
	</b>Any body who is registered with the Messaging System to use it, he/she could
	be an employee, a student etc.</p>
	<p><b>Channels<br>
	</b>A broad classification of messages that are exchanged within the system
	which means that all messages are sent/received through some channel and not
	without it.</p>
	<p><a name="#broadcast"><b>Broadcast Channel</b></a><br>
	The channel where you cannot give the receivers name (The &quot;To..&quot;
	box is not shown) for your message, the system internally detects the eligible
	receivers and sends your message to them. A user cannot send a reply to the
	message that is being sent through the Broad Cast Channel.</p>
	<p><a name="#point"><b>Point-to-Point Channel</b></a><br>
	The channel where you can give the receivers name for your message and the
	message is sent to him but the receiver must have the Read Permission for the
	Channel otherwise the message cannot be sent.</p>
	<p><b>Permission for a Channel<br>
	</b>The user should have the required permissions for the channel in order to
	send/receive message(s) through it. The various permissions are described below</p>
	<p><u>Receive Message(s)</u>- A user can only receive message(s) from the channel and can
	reply back if the channel is a Point-to-Point Channel.</p>
	<p><u>Send Message(s)</u>- A user can only send message(s) to the channel.</p>
	<p><u>Send and Receive Message(s)</u>- A user can send/receive message(s) from the channel.</p>
	<p><u>Admin</u>- Apart from sending/receiving message(s) from a channel a user
	can grant permissions(not Admin) to the other users as well as delete any
	message from the channel (nobody will see it in his/her inbox after the complete
	deletion by the admin).</p>
	<p><b>Subscription to a channel</b><br>
	Subscribing to a channel means that the user grants the default permissions for
	the channel to himself, unsubscribe means the reverse.</p>
	<p><b><a name="#auto">Auto-subscribed Channels</a></b><br>
	The agent gets the default permissions for these channels when he logs in for
	the first time. He cannot subscribe/unsubscribe to an auto-subscribed channel on
	his own, though an administrator can do it.<br>
	</p>
	<p>For further clarification about the system feel free to contact <a href="mailto:administrator@careerlauncher.com">Information
	Technology, Career Launcher</a>.<br>
	</p>
	<p><a href="javascript:history.back()">&lt;&lt; Back</a></p>
	<br><br>

   
 </font>   
    </td>
  </tr>
</table>
</td></tr></table>
</body>
</html>
