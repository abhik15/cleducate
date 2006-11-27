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
	<jsp:useBean id="af" class="com.cl.msg.MSGAgentFolder" scope="page" />
	<jsp:useBean id="aq" class="com.cl.msg.MSGAgentQueue" scope="page" />


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
<SCRIPT LANGUAGE="JavaScript" SRC="/jscript/calendar.js"></SCRIPT>
<script language="JavaScript">
<!--
function callManual(callFile){
document.manualForm.action=callFile;
document.manualForm.submit();
}


function loadIt()
{
	if(document.msgForm.duration[2].checked==true)
	{
		document.msgForm.days.disabled = true;
		document.msgForm.fromDate.disabled = false;
		document.msgForm.toDate.disabled = false;
	}
	else if (document.msgForm.duration[1].checked==true)
	{
		document.msgForm.fromDate.disabled = true;
		document.msgForm.toDate.disabled = true;
		document.msgForm.days.disabled = false;
	}
	else if(document.msgForm.duration[0].checked==true)
	{
		document.msgForm.fromDate.disabled = true;
		document.msgForm.toDate.disabled = true;
		document.msgForm.days.disabled = true;
	}
	else
	{
	document.msgForm.duration[1].checked=true;
	loadIt();
	}

}
//-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="loadIt()">
<!-- Add top.js for top band -->
<script language="javascript" src="/jscript/top.js"></script>
<table border="0" width="100%" cellspacing="0" cellpadding="3">
<%
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
		<P class="lnkbld">Hello <%= agent.getAgentName()%>,</P>
		<div align="justify"><P class="cntnormal">Welcome to the Message Retreival Utility of <%=(cat==0? "SIS":"CLMS")%>. The
		utility helps you to retrieve the messages sent through a broadcast
		channel and its a great help incase you have subscribed recently to a
		channel thats being an all time popular among its users or if you just
		want to recollect some of the messages sent through it.<br>Please provide
		the small information to the system to help you Retrieve messages you want.</P></div>
		<form action="/msg/util/MSGRetrieveMsgs.jsp" method="get" name="msgForm">
		<TABLE  BORDER="0" CELLPADDING=4 CELLSPACING=3>
				<TR VALIGN=TOP>
					<TD colspan ="2">
						<P class="cntnormal">Which channel you want to retrieve the messages from</P>
					</TD>
					<TD >
						<P class="new">
						<%
						MSGQueueMaster[] allQueues = aq.getAllAgentQueues(conn,agent.getAgentID(), agent.getDestID(),"CHANNEL");
						if(allQueues.length >0 )
						 {
						%>
						<select name="qid" class="cnt">
							<%
							for(int i = 0; i<allQueues.length ; i++)
							{
							%>
							<option value="<%=allQueues[i].getQID()%>"><%=allQueues[i].getQDescr()%></option>
							<%
							}
      %>
							</select>
						<%
						}
		 				else
							out.println("You are not subscribed to any broadcast channel, "+((cat==1)?" please subscribe to any of such channel":"please contact your center about this."));
						%>
						</P>
					</TD>
				</TR>
				<TR VALIGN=TOP>
					<TD  colspan="3">
						<P class="cntnormal">Please specify the time duration of the messages that you want to retrieve</P>
					</TD>
				</TR>
				<TR VALIGN=TOP>
					<TD colspan="3">
					<P class="cntblu"><img src="/img/blank.gif"><input type="radio" name="duration" value="all" onClick="document.msgForm.days.disabled=true;document.msgForm.fromDate.disabled=true;document.msgForm.toDate.disabled=true;"> All the Messages of the channel since the channel has started<br>
						</P>
					</TD>
				</TR>
				<TR VALIGN=TOP>
					<TD colspan="3">
					<P  class="cntblu"><img src="/img/blank.gif"><input type="radio" name="duration" value="days" checked onClick="document.msgForm.days.disabled=false;document.msgForm.fromDate.disabled=true;document.msgForm.toDate.disabled=true;"> The messages sent in the last <input type="text" name="days" size="5"> days<br>
					</P>
					</TD>
				</TR>
				<TR VALIGN=TOP>
					<TD colspan="3">
					<P  class="cntblu"><img src="/img/blank.gif" ><input type="radio" name="duration" value="dates" onClick="document.msgForm.days.disabled=true;document.msgForm.fromDate.disabled=false;document.msgForm.toDate.disabled=false;"> The messages sent between <input type="text" name="fromDate" size="20" >
					<a  HREF="javascript:doNothing()" onClick="setDateField(document.msgForm.fromDate,'today');top.newWin = window.open('/jscript/calendar.html','cal','dependent=yes,width=230,height=240,screenX=200,screenY=300,titlebar=no')">
					<img src="/img/cal.gif" alt="Click on the calendar icon to enter the date."  align="absmiddle" border=0></a> and
					<input type="text" name="toDate" size="20" >
					<a  HREF="javascript:doNothing()" onClick="setDateField(document.msgForm.toDate,'today');top.newWin = window.open('/jscript/calendar.html','cal','dependent=yes,width=230,height=240,screenX=200,screenY=300,titlebar=no')">
					<img src="/img/cal.gif" alt="Click on the calendar icon to enter the date."  align="absmiddle" border=0></a>
						</P>
					</TD>
				</TR>
				<TR VALIGN=TOP>
					<TD colspan="2">
						<P  class="cntnormal">In which folder do you want to retrieve the messages
						</P>
					</TD>
					<TD >
						<P class="cnt">
						<%
						MSGFolderMaster[] systemFolders = af.getSystemFolders(conn);
						MSGFolderMaster[] userFolders = af.getAgentFolders(conn,agent.getAgentID() , agent.getDestID());
						%>
						<select name="fid"  class="cnt">
						<%
						for(int i =0; i<systemFolders.length; i++)
						{
						%>
							<option value="<%=systemFolders[i].getFolderType()+systemFolders[i].getFolderID()%>"><%=systemFolders[i].getFolderName()%></option>
						<%
						}
						for(int i =0; i<userFolders.length; i++)
						{
						%>
							<option value="<%=userFolders[i].getFolderType()+userFolders[i].getFolderID()%>"><%=userFolders[i].getFolderName()%></option>
						<%
						}
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
						%>
							</select>
							</P>
					</TD>
				</TR>
				<tr>
				<td colspan="3">
				<p class="cnt">In case you want to retrieve the messages in a new folder, please <a href="/msg/MSGFolder.jsp?cat=<%=cat%>" class="lnkblu">click here</a> to create one and then use this utility.</p>
				</td>
				</tr>
				<TR VALIGN=TOP>
					<TD colspan="3">
					<input type="hidden" name="cat" value="<%=cat %>" >
						<P><input type="submit" value="Retrieve"  class="cntblu" onClick="this.value='Please Wait...'">
						</P>
					</TD>
				</TR>
				<TR VALIGN=TOP>
					<TD colspan="3">
						<P><BR>
						</P>
					</TD>
				</TR>
		</TABLE>
		</form>
		<P><BR><BR>
		</P>
		<P><BR><BR>
		</P>


		--
    </td>
  </tr>
</table>
</td></tr></table>
    </td>
  </tr>
</table>
</body>
</html>
