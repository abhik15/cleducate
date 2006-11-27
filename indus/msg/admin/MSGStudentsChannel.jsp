<%--
  -- Filename:	 MSGStudentsChannel.jsp
  -- Author:     Shilpa Arora
  -- Create Date:5th June 2002 
  --%>

<%
int cat=1;
String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
%>

<%@ page import="java.sql.Connection,com.cl.sql.CLMSPoolManager"  errorPage="/msg/MSGErrorPage.jsp"%>
	<cl:CLValidateSessionTag />
	<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
	<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="Systems" scope="application" class="com.cl.CLSystems"/>
	<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
	<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="queueMaster" class="com.cl.msg.MSGQueueMaster" scope="page" />
	<jsp:useBean id="studentPicker" class="com.cl.msg.admin.MSGStudentPicker" scope="page" />
	<jsp:setProperty name="studentPicker" property="errorFileName" value="<%=logFile %>"/>
	<%!
		int qID=0;
		int payloadID=0;
		boolean reply=false;
		int msgID=0;
		String receiver="";
	%>
	<%
		request.setAttribute("cat",Integer.toString(cat));
		request.setAttribute("jspname","/msg/MSGStudentsChannel.jsp");
	%>
	
	<html>
	<head>
	<title>Channels for Students</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache">

	<link rel="stylesheet" href="/sis/styles/style.css" type="text/css">
	<!-- Add top.js for top band -->
	
	<script language="javascript">
	function popup(qid){
	tagpopup= window.open("/msg/MSGReceivers.jsp?qid="+qid,"registration","status=no,resize=yes,toolbar=no,scrollbars=yes,width=300,height=250");
	}

	</script>
	</head>
	<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
	<script language="javascript" src="/jscript/top.js"></script>
	<table border="0" width="100%" cellspacing="0" cellpadding="0">
	<tr>
	<td bgcolor="DFE1BC" width="21%" valign="top">
	<script language="javascript" src="/msg/jscript/LeftBandStaff.js"></script>
	<jsp:include page="/clzone/login/incPrivilege.jsp" flush="true"/> 
	</td>
	<td width="79%" valign="top">
	<table width="100%" border="0" cellspacing="3" cellpadding="0" align="left">
	<tr>
	<td bgcolor="B4BC6D">
	<table border="0" cellspacing="0" cellpadding="0">
	<tr> 
		  <td bgcolor="B4BC6D" height="32" width="10"><img src="/msg/img/blank.gif" width="1" height="28"></td>
		  <td><font class="cntblu"><a href="/" class="lnkblu">Home</a><font class="cntblu"> &gt; </font><a href="/clzone/clzone.jsp?tp=clZoneHome.jsp" class="lnkblu">CL Zone Home</a> &gt; Channels for Students</font></td>
	</tr>
	</table>
	</td>
	</tr>
	</table>
	<BR><BR>
	<table width="60%" border="0" cellspacing="0" cellpadding="0" align="left">
	  <tr> 
	    <td width="1" rowspan="3"></td>
	    <td rowspan="3" width="10"><img src="/msg/img/blank.gif" width="1"></td>
	    <td align="left" height="5"></td>
	    <td rowspan="4" valign="top">&nbsp;</td>
	  </tr>
	  <tr> 
	    <td align="left" valign="top">&nbsp;</td>
	  </tr>
	</table>

	    
	    





<br><br><br>
<table border="0" align="left" width="60%">
<tr>
<td>
<p><font class="cnt">The channels through which you can send message to the students are listed below. To compose a message please click on the channel through which you want to send it.</font></p>
</td>
</tr>
<tr>
<td>
<font class="cnt">
<table>

<%
	CLMSPoolManager clmsPool = CLMSPoolManager.getInstance();
	Connection conn = null;
	String source="/msg/admin/MSGPickStudents.jsp";	
	int queueIDs[] = null;
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
	for(int i=0; i<queueIDs.length; i++)
	{
		queueMaster= queues.getQueue(queueIDs[i]);
		out.println("<tr><td valign=\"top\"><img src=\""+queueMaster.getIconURL()+" \"></td><td valign=\"top\"><font class=\"cnt\"><a href=\""+source+"?qid="+queueMaster.getQID()+"&pid="+queueMaster.getPayloadID()+"\">"+queueMaster.getQDescr()+"</a></font></td><td valign=\"top\"><font class=\"cnt\">"+(queueMaster.getQType().equals("CHANNEL")?"Informative Channel(Students cannot reply you back through this)" : "Interactive Channel(Students can reply you back)")+"</font></td></tr>");	
	}

%>

</table>
</font>
</td>
</tr>
</table>



	    
	   <table width="18%" border="0" cellspacing="1" cellpadding="1">
	  <tr> 
	  <!-- Add bannar.js for right side advertisment. If u want to change advertisment then u have to change the javascript file. -->
	    <td align="left" valign="top"><script language="javascript" src="/jscript/bannar.js"></script>
	    </td>
	  </tr>
	</table>
	    </td>
	  </tr>
	</table>
	</body>
	</html>
