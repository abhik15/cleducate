<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>
<cl:CLValidateSessionTag userType="CUSTOMER"/>

<%@ page import="java.sql.*,oracle.jdbc.driver.*,java.io.*" %>
<%@ page import="com.cl.sql.PoolManager,org.apache.log4j.*" errorPage="/epage/anandaError.jsp"%>

<% 
	Category logCategory = Category.getInstance("school.sis");
	String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
	String fname = (String)session.getValue("fname");//request.getParameter("fname");
	String lname = (String)session.getValue("lname");//request.getParameter("lname");
	int userId = Integer.parseInt((String)session.getValue("uid"));//Integer.parseInt(request.getParameter("uid"));
	int locId = Integer.parseInt((String)session.getValue("locId"));

	String inboxURL="/msg/MSGInbox.jsp?fid=S1&fldr=Inbox";
	int destID=1;
	PoolManager poolManager = PoolManager.getInstance();
	Connection connection = null;
%>
<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />		
<jsp:useBean id="inbox" class="com.cl.msg.MSGInbox" scope="page" />

<jsp:useBean id="agentQueue" class="com.cl.msg.MSGAgentQueue" scope="page" />
<jsp:setProperty name="agentQueue" property="errorFileName" value="<%=logFile %>"/>

<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>

<jsp:useBean id="queueMaster" class="com.cl.msg.MSGQueueMaster" scope="page" />

<%
	int agentID = 0;
	int unread  = 0;
	int total   = 0;
	int queueIDs[] = null;
	boolean showInbox=true;
	int schoolId = 0;
	int EnrollId = 0;
	
	try
	{
		connection = poolManager.getConnection("erp");

		agentID = agent.findAgentID(connection,userId,destID,2);
		if(agentID==0)
		{
			agentID = agent.createAgentID(connection,userId,destID,2,fname+" "+lname);
		}
		unread = inbox.getUnreadMessageCount(connection,agentID, destID,1,"SYSTEM");
		total = inbox.getTotalMessageCount(connection,agentID, destID,1,"SYSTEM");
		queues.loadQueues(connection);
		queueIDs = agentQueue.getWriteQueues(connection,agent.getAgentID(), agent.getDestID());

		showInbox = true;
		inboxURL = "/msg/MSGInbox.jsp?fid=S1&fldr=Inbox";

		session.putValue("inboxURL",inboxURL);
	}
	catch(Exception ex)
	{
		logCategory.error(ex);
		throw ex;    
	}
	finally
	{
		poolManager.freeConnection("erp", connection);
	}

	callableStatement call=null;


	try
	{
		connection = poolManager.getConnection("erp");
		call = connection.prepareCall("{CALL ERP_USER_PKG.GET_ENROLL_ID(?,?,?)}");
		call.setInt(1,userId);
		call.registerOutParameter(2,enrollId);
		call.registerOutParameter(3,schoolId);
		call.execute();
		enrollId = call.getInt(2);
		schoolId = call.getInt(3);
		
	}
	catch(Exception ex)
	{
		logCategory.error(ex);
		throw ex;    
	}
	finally
	{
		poolManager.freeConnection("erp", connection);
	}


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="/styles/style.css" type="text/css">

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Indus - Indore</title>
</style>
<link href="/styles/indus.css" rel="stylesheet" type="text/css" /> 
<style type="text/css">
<!--
.style1 {
	font-family: "Arial";
	font-size: 11.7pt;
	color:#808000;
	font-weight: bold;
	line-height:30px;
}

.style2 {
	font-family: "Arial";
	font-size: 10pt;
	color:#808000;
	font-weight: bold;
	line-height:30px;
}

.admission1 {font-family: "Arial";
	font-size:11.7pt;
	color:#2C5665;
	font-weight: bold;
}
.admission11 {font-family: "Arial";
	font-size:11.7pt;
	color:#48B6FF;
	font-weight: bold;
}
</style>
<script LANGUAGE="JavaScript" src="/jscript/cl_functions.js"></script>
<SCRIPT LANGUAGE="JavaScript" SRC="/jscript/calendar.js"></SCRIPT>
<Script Language="JavaScript">
function chkSelect()
{
	if (ChkBlank("form1.userName","Please enter Username.") == false) return false
	if (ChkBlank("form1.password","Please enter your password.") == false) return false
	else
	{
		document.form1.submit();
	}
}
</SCRIPT>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="1" align="left" valign="top" bgcolor="#E0E0E0"><img src="/ananda/img/1x1.gif" width="1" height="1" /></td>
    <td align="left" valign="top"><img src="/img/learner.gif" width="175" height="152" border="0" usemap="#Map2" /></td>
    <td width="602" align="left" valign="top"><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="602" height="152">
      <param name="movie" value="/swf/learner.swf" />
      <param name="quality" value="high" />
      <embed src="/swf/learner.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="602" height="152"></embed>
    </object></td>
  </tr>
</table>
<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="1" align="left" valign="top" bgcolor="#E0E0E0"><img src="/img/green_dot.gif" width="1" height="1" /></td>
    <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td align="left" valign="middle" bgcolor="#0090EC"><img src="/ananda/img/1x1.gif" width="174" height="1" /></td>
        <td align="left" valign="top"></td>
        <td align="left" valign="top" bgcolor="#68169C"><img src="/ananda/img/1x1.gif" width="174" height="1" /></td>
        <td align="left" valign="top"></td>
        <td align="left" valign="top" bgcolor="#DF6400"><img src="/ananda/img/1x1.gif" width="174" height="1" /></td>
        <td align="left" valign="top"></td>
        <td align="left" valign="top" bgcolor="#9C163B"><img src="/ananda/img/1x1.gif" width="174" height="1" /></td>
        <td align="left" valign="top"></td>
        <td align="left" valign="top" bgcolor="#363A90"></td>
      </tr>
      <tr>
        <td width="174" height="40" align="left" valign="middle" bgcolor="#999933">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="10" height="5" align="left" valign="top"></td>
            <td ></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td align="left" valign="top"><font class="global_nav"></td>
          </tr>
          <tr>
            <td height="5" align="left" valign="top"></td>
            <td></td>
          </tr>
        </table></td>
        <td width="1" align="left" valign="top"><img src="/img/1x1.gif" width="1" height="1" /></td>
        <td width="174" align="left" valign="middle" bgcolor="#68169C"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="10" height="5" align="left" valign="top"></td>
            <td ></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td align="left" valign="top"><font class="global_nav"><a href="javascript:NewWindow=window.open('/common/curriculum/curriculum.html','newWin');NewWindow.focus(); void(0);" class="global_nav">Curriculum</a></font></td>
          </tr>
          <tr>
            <td height="5" align="left" valign="top"></td>
            <td></td>
          </tr>
        </table></td>
        <td width="1" align="left" valign="top"><img src="/img/1x1.gif" width="1" height="1" /></td>
        <td width="174" align="left" valign="middle" bgcolor="#DF6400"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="10" height="5" align="left" valign="top"></td>
            <td ></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td align="left" valign="top"><font class="global_nav"><a  href="javascript:NewWindow=window.open('/common/parents/parents.html','newWin');NewWindow.focus(); void(0);" class="global_nav">Parents</a></font></td>
          </tr>
          <tr>
            <td height="5" align="left" valign="top"></td>
            <td></td>
          </tr>
        </table></td>
        <td width="1" align="left" valign="top"><img src="/img/1x1.gif" width="1" height="1" /></td>
        <td width="174" align="left" valign="middle" bgcolor="#9C163B"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="10" height="5" align="left" valign="top"></td>
            <td ></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td align="left" valign="top"><font class="global_nav"><a href="javascript:NewWindow=window.open('/common/mentor/mentor.html','newWin');NewWindow.focus(); void(0);" class="global_nav">Mentor</a></font></td>
          </tr>
          <tr>
            <td height="5" align="left" valign="top"></td>
            <td></td>
          </tr>
        </table></td>
        <td width="1" align="left" valign="top"><img src="/img/1x1.gif" width="1" height="1" /></td>
        <td align="center" valign="middle" bgcolor="#363A90"><img src="/img/home_logo.gif" width="55" height="34" border="0" usemap="#MapMap"/></td>
      </tr>
    </table></td>
    <td width="1" align="left" valign="top" bgcolor="#E0E0E0"><img src="/img/green_dot.gif" width="1" height="1" /></td>
  </tr>
</table>
<map name="MapMap" id="MapMap">
  <area shape="rect" coords="13,3,46,32" href="javascript:NewWindow=window.open('/index.html','newWin');NewWindow.focus(); void(0);" />
</map>
<map name="Map2" id="Map2">
  <area shape="rect" coords="4,92,165,148" href="/index.html" />
  <area shape="rect" coords="7,6,63,24" href= "javascript:NewWindow=window.open('/location/3/contact.html','newWin','width=350,height=225,left=0,top=0, toolbar=No,location=No,scrollbars=No,status=No,resizable=No,fullscreen=No');NewWindow.focus(); void(0);" />
  <area shape="rect" coords="78,4,136,24" href="javascript:NewWindow=window.open('/common/aboutus.html','newWin');NewWindow.focus(); void(0);" />
</map>
<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="1" align="left" valign="top" bgcolor="#E0E0E0"><img src="/img/1x1.gif" width="1" height="1" /></td>
    <td width="169" align="left" valign="top" bgcolor="#999933">
<%
	try
	{
		connection = poolManager.getConnection("erp");
%>
		<cl:CLMsgSisLeftBandTag connObj="<%=connection%>" category="0" level="0"/>
<%
	}
	catch(Exception ex)
	{
		System.out.println(ex.toString());
	}
	finally
	{
		poolManager.freeConnection("erp", connection);
	}
%>
     </td>
    <td width="588">
		<table border="0" align="left" cellpadding="0" cellspacing="0">
          <tr valign="top">
		  <td width="16">&nbsp;</td>
            <td class="runningtext">
				<font  class="style1">SIS</font><br>
				<font  class="style2">Hi! <%=fname%>, Welcome to Indus World School</font><br>
				<table WIDTH="100%" cellspacing="0" cellpadding="3" border="0" bordercolorlight="#999999" bordercolordark="#ffffff" class="pcnt">
				<TR>
					<TD width="50%" bgcolor="#CCFFFF" valign="top">
						<table width="100%" cellspacing="0" cellpadding="0" border="0">
						<tr>
						<td colspan="2">
							<CENTER><B>My Message</B></CENTER>
						</td></tr>
						<tr> 
						  <td><img src="/img/blank.gif" width="7" height="1"></td>
						  <td><font class="cnt"><a href="<%=inboxURL%>" class="lnkblubld">Click here</a> to check message(s). <%=showInbox?"You have <b>"+unread+"</b> new message(s)." :"" %>
							</font></td>
						</tr>
						<tr><td colspan="2"><img src="/img/blank.gif" width="7" height="5"></td></tr>
						<tr bgcolor="#ffffff"><td colspan="2"><img src="/img/blank.gif" width="3" height="3"></td></tr>
						<tr> 
						  <td colspan="2">
<%
						if (queueIDs!=null && queueIDs.length>0)
						{
/*							for(int i=0; i<queueIDs.length; i++)
							{
								queueMaster= queues.getQueue(queueIDs[i]);				
								out.println("<tr><td height=\"17\">&nbsp;</td><td><a href=\"/msg/MSGStudentCompose.jsp?qid=" 
									+ queueMaster.getQID() + "&pid=" 
									+ queueMaster.getPayloadID() + "\" class=\"lnkblu\">" 
									+ queueMaster.getQDescr() + "</a></td></tr>");	
*/
								queueMaster= queues.getQueue(queueIDs[0]);
								out.println("<tr><td height=\"17\">&nbsp;</td><td><a href=\"/msg/MSGStudentCompose.jsp?qid=1&pid=2\" class=\"lnkblu\">Contact Your Teacher</a></td></tr>");

								queueMaster= queues.getQueue(queueIDs[1]);
								out.println("<tr><td height=\"17\">&nbsp;</td><td><a href=\"/msg/MSGStudentCompose.jsp?qid=28&pid=1\" class=\"lnkblu\">Principal's Desk</a></td></tr>");
//							}
						}
						else
							out.println("<p class=\"cnt\">Sorry! you are not subscribed to any channel through which you can send a message. Please go to <a href=\"/msg/MSGChannels.jsp?cat=0\"  class=\"lnkblu\">Choose your Channels</a> link to subscribe to any of such channel.</p>");
%>					  
						  </td>
						</tr>

						<tr><td colspan="2"><img src="/img/blank.gif" width="7" height="5"></td></tr>
					  </table>
					</TD>
					
					<TD width="50%" valign="top" bgcolor="#CCCCFF">
					<CENTER><B>View Observations from Teachers</B></CENTER><BR>
<%
					CallableStatement call = null;
					ResultSet resultset = null;
					try
					{
						connection = poolManager.getConnection("erp");

						call = connection.prepareCall("{CALL cl_feedback.get_feedback(?,?)}");
						call.registerOutParameter(1, OracleTypes.CURSOR);
						call.setInt(2,userId);

						call.execute();
						resultset = (ResultSet)call.getObject(1);
						while(resultset.next())
						{
%>
							&nbsp; <a href="#" onclick="javascript: OpenWindow('/sis/feedback/feedbackDetail.jsp?feedbackId=<%=resultset.getInt("FEEDBACK_ID")%>','feedback','650','550')" class="lnkblu"><%=resultset.getString("ACTIVITY")%></A> &nbsp;
							<FONT class="cnt"><%=resultset.getString("ACTIVITY_DATE")%></FONT><BR>
<%
						}
					}
					catch(Exception ex)
					{
						logCategory.error(ex.toString());
						throw ex;
					}
					finally
					{
						poolManager.freeConnection("erp",connection);

						try
						{
							call.close();
						}catch(Exception ex){}
					}
%>
					</TD>
					
					
				</TR>
				<tr>
					<TD valign="top" bgcolor="#CCCCFF" align="center">
						<B>My Group</B><BR><BR> 
						<a href="#" onclick="javascript: OpenWindow('/sis/student_img/ThumbShowGroupImg.jsp?locId=<%=locId%>','view_album_grp','650','550')" class="lnkblu">My Group Photo</a><BR><BR>
					</TD>
					<TD bgcolor="#CCFFFF" valign="top">
					<CENTER><B>My Photo</B></CENTER><BR>
						<TABLE>				
<%
							boolean is_File = false;
							String file="";

						file="/sis/student_img/"+userId+"/"+userId+".jpg";
						is_File = (new File(application.getRealPath(file)).exists());
						if(is_File)
						{
%>
							<TR>
							<TD>
								<a href="#" onclick="javascript: OpenWindow('/sis/student_img/showImg.jsp?userId=<%=userId%>','view_album','650','550')" class="lnkblu"><IMG SRC="<%=file%>" BORDER="0" ALT="<%=fname%>" width="112" height="102"></A>
							</TD>
							</TR>
							<TR>
							<TD align="center"><a href="#" onclick="javascript: OpenWindow('/sis/student_img/showImg.jsp?userId=<%=userId%>','view_album','650','550')" class="lnkblu"><IMG SRC="/img/my_album.gif" BORDER="0" ALT="<%=fname%>'s Album"></a></TD>
						</TR>
<%
						}
						else
						{
%>
							<CENTER><IMG SRC="student_img/noPhoto.gif" WIDTH="102" HEIGHT="112" BORDER="0" ALT="Please contact your school for uploading your photo"></CENTER> 
<%
						}
%>
						<CENTER><IMG SRC="/img/my_album.gif" BORDER="0" ALT="<%=fname%>'s Album"></CENTER>
						<TR>
							<TD><hr width="100%" color="white"></TD>
						</TR>
							
						
					</TABLE>
					</TD>
				</tr>
				</TABLE>
		  </td>
            </tr>
          </table></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td colspan="5" valign="top" bgcolor="#E0E0E0"><img src="/img/1x1.gif" width="1" height="1" /></td>
  </tr>
</table>
</body>
</html>
