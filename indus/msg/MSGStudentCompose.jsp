<%@ page import="java.sql.*,com.cl.sql.PoolManager,oracle.jdbc.driver.*"%>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>

<%--
  -- Filename:	 MSGStaffCompose.jsp
  -- Author:     Shilpa Arora
  -- Create Date:25th April 2002 
  --%>

<%
	int cat = 0;
	int payloadID = 0;
	try
	{
//		payloadID = Integer.parseInt(request.getParameter("pid"));
		payloadID= 2;
System.out.println("PayloadId is " + payloadID);
	}
	catch(NumberFormatException nfe)
	{
		payloadID = 0;
	}
	String logFile = application.getRealPath("/logs/error/")+"MSGErrorLog.log";
%>
	<cl:CLValidateSessionTag userType="CUSTOMER"/>
	<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
	<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="inbox" class="com.cl.msg.MSGInbox" scope="page" />
	<jsp:setProperty name="inbox" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
	<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="msg" class="com.cl.msg.MSGMessage" scope="session" />
	<jsp:setProperty name="msg" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="aq" class="com.cl.msg.MSGAgentQueue" scope="page" />
	<jsp:setProperty name="aq" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="wpayload" class="com.cl.msg.MSGTextPayload" scope="session" />
	<jsp:setProperty name="wpayload" property="errorFileName" value="<%=logFile %>"/>

	<jsp:useBean id="w2payload" class="com.cl.msg.MSGXTextPayload" scope="session" />

	<%
	/**
	 * The variable @Message is used to display any message it got as a parameter as a result of any previous action causing
	 * the forward or include of this page. Hence, the use is to display the status of any previous action before this page.
	 * The variable is always obtained by request.getParameter("Message"); and this is used as a standard throughout the sis
	 * for displaying the status of the earlier task.
	 */
		String Message = "";
		int qID = 0;
		boolean reply = false;
		int msgID = 0;

		java.text.SimpleDateFormat formatter= new java.text.SimpleDateFormat ("MMMMM dd, yyyy hh:mm");
		java.util.Date currentTime_1 = new java.util.Date();
		String ddmmyy = formatter.format(currentTime_1);

		String receiver = "";

		String inboxURL = (String)session.getValue("inboxURL");
		if(inboxURL== null || inboxURL.equals("null") || inboxURL.equals(""))
			inboxURL = "/msg/MSGInbox.jsp";

		request.setAttribute("cat",Integer.toString(cat));
		request.setAttribute("jspname","/msg/MSGStudentCompose.jsp");
		Message=request.getParameter("message");
		String saveToSentItems = request.getParameter("savemsg");
		if(saveToSentItems == null)
			saveToSentItems = "";

		if(Message==null)
			Message="";
		if(Message.equals(""))
		{
			msg.setSubject("");
			msg.reset();
			if(payloadID==1)
				wpayload.reset();
			else if(payloadID==2)
				w2payload.reset();
		}
		receiver = request.getParameter("receiver");
		if(receiver == null)
			receiver="";
		try
		{
//			qID = Integer.parseInt(request.getParameter("qid"));
			qID = 1;
			reply = (request.getParameter("reply") != null)
						? request.getParameter("reply").equalsIgnoreCase("y") ? true : false 
						: false;
			
		}
		catch(NumberFormatException nfe)
		{
				qID= 0;
				payloadID= 0;
		}
		if(reply)
			try
			{
				msgID = Integer.parseInt(request.getParameter("mid"));
			}
			catch(NumberFormatException nfe)
			{	msgID=0;	}

	%>
	<html>
	<head>
	<title>SIS - Compose Message</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache">

	<link rel="stylesheet" href="/styles/style.css" type="text/css">
	<link href="/styles/indus.css" rel="stylesheet" type="text/css" />
	<!-- Add top.js for top band -->
<%
	if(qID>0 && payloadID>0)
	{
%>
	<script LANGUAGE="JavaScript" src="/msg/payload/<%=payloadID %>/jscript.js"></script> 
<%
	}
%>
	<script language="javascript">
	function popup(qid)
	{
	tagpopup= window.open("/msg/MSGReceivers.jsp?qid="+qid,"registration","status=no,resize=yes,toolbar=no,scrollbars=yes,width=300,height=250");
	}

	function showWindow(winname,url){
	win = window.open(url,winname,"toolbar=0,location=0,directories=0,status=1,menubar=0,scrollbars=1,resizable=0,width=500,height=380,left=20,top=20");
	}

	</script>
	</head>
	<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
	<script language="javascript" src="/jscript/top.js"></script>
<%
	String includePage="";
	PoolManager clmsPool = PoolManager.getInstance();
	Connection conn = null;
	/* try block will end after the WriteChannels page */
	try
	{
		conn = clmsPool.getConnection("erp");
%>
	<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="1" align="left" valign="top" bgcolor="#E0E0E0"><img src="/img/1x1.gif" width="1" height="1" /></td>
	<td width="174" align="left" valign="top" bgcolor="#999933">
		<cl:CLMsgSisLeftBandTag connObj="<%=conn%>" category="<%=Integer.toString(cat)%>" level="1"/>
	</td>
	<td valign="top">
	<!-- TOP BAND START -->
	<table align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td bgcolor="B4BC6D">
		<table border="0" cellspacing="0" cellpadding="0">
		<tr><td bgcolor="B4BC6D" height="32" width="10">
				<img src="/img/blank.gif" width="1" height="28">
			</td>
			<td><font class="cntblu"><a href="/" class="lnkblu">Home</a><font class="cntblu"> &gt; </font><a href="/sis/sis.jsp" class="lnkblu">SIS Page</a> &gt; Compose Message</font>
			</td>
		</tr>
		</table>
	</td></tr>
	<tr bgcolor="#ffffff"><td><img src="/img/blank.gif" width="5" height="15"></td></tr></table>
	<!-- TOP BAND END -->

<%		if(reply && msgID>0)
		{
			msg.read(conn,agent.getAgentID(), agent.getDestID(), msgID, payloadID);
			msg.setQueueType(queues.getQueue(msg.getQueueID()).getQType());
		}

		if(qID==0 || payloadID==0)
		{
			includePage="/msg/MSGWriteQueues.jsp";
		}	
		else
		{
			includePage="/msg/payload/"+payloadID+"/Compose.jsp";
%>
		<table width="100%" cellpadding="3" cellspacing="0" border="0">
		<tr><td><font class="cnt"><%=Message %></font></td></tr>
		<tr><td>
			<cl:writeChannels agentID="<%=agent.getAgentID() %>" destID="<%=agent.getDestID() %>" clSource="/msg/MSGStudentCompose.jsp" connObj="<%=conn%>" sisSource="/"/>
		</td></tr>
		<tr><td>
			<table width="100%" border="0" bordercolor=green cellspacing="0" cellpadding="0">
			<tr> 
    			<td rowspan="4" bgcolor="#c0d9f5"><img src="/img/blank.gif" width="5" height="5"></td>
				<td valign="bottom"><img src="/msg/img/blue.gif"></td>
			</tr>
			<tr bgcolor="#C0D9F5">
				<td colspan="2"><img src="/img/blank.gif" width="5" height="10"></td>
			</tr>
			<tr> 
				<td bgcolor="#C0D9F5" colspan="2" valign="top" align="left"> 
					<form method="POST" action="/msg/payload/<%=payloadID %>/Send.jsp" name="payload" onSubmit="return validate(this)">
					<input type="hidden" name="source" value="/msg/MSGStudentCompose.jsp" >	
<!--					<input type="hidden" name="cat" value="<%=cat %>" >	-->
					<!-- GREY BORDER TABLE START -->
					<table width="98%" border="1" cellspacing="0" cellpadding="3" bordercolorlight="#999999" bordercolordark="#C0D9F5">
						<tr><td bgcolor="#C0D9F5" valign="top" align="left"> 
					    <!-- INNER TABLE TO DISPLAY REQUIRED INFO START -->
							<table width="100%" border="0" bordercolor=red cellspacing="0" cellpadding="3">
						    <tr> 
								<td width="5%" valign="top">
									<img src="<%=queues.getQueue(qID).getIconURL() %>" align="absmiddle">
								</td>
								<td width="15%"><font class="verbld">Channel</font></td>
								<td><font class="cnt"><%=queues.getQueue(qID).getQDescr()%></font>
									<input type="hidden" name="queueID" value="<%=qID %>" >
									<input type="hidden" name="queueType" value="<%=queues.getQueue(qID).getQType() %>" > 
									<input type="hidden" name="payloadID" value="<%=payloadID %>" >
								</td>
							</tr>
						    <tr> 
								<td><img src="/img/blank.gif" width="5" height="5"></td>
								<td><font class="verbld">Sender</font></td>
								<td><font class="cnt"><%=agent.getAgentName() %></font></td>
								<input type="hidden" name="senderID" value="<%=agent.getAgentID()%>">
								<input type="hidden" name="senderDestID" value="<%=agent.getDestID()%>">
								<input type="hidden" name="sender" value="<%=agent.getAgentName()%>">
							</tr>
<% 
				if(reply)
				{
%>
						    <tr> 
								<td><img src="/img/blank.gif" width="5" height="5"></td>
								<td><font class="verbld">Reply to</font></td>
								<td><font class="cnt"><%=msgID>0?msg.getSender():receiver %></font></td>
								<input type="hidden" name="reply" value="y">
								<input type="hidden" name="parentMsgID" value="<%=msgID>0?Integer.toString(msg.getMsgID()):Integer.toString(msg.getParentMsgID()) %>">
								<input type="hidden" name="receiverID" value="<%=msgID>0?Integer.toString(msg.getSenderID()):Integer.toString(0) %>">
								<input type="hidden" name="receiverDestID" value="<%=msgID>0?Integer.toString(msg.getSenderDestID()):Integer.toString(0) %>">
								<input type="hidden" name="receiver" value="<%=msgID>0?msg.getSender():receiver %>">
							</tr>
<%
				}
				else if(queues.getQueue(qID).getQType().equals("POINT-TO-POINT"))
				{
%>
							<input type="hidden" name="receiverID" value="<%=msg.getSenderID() %>">
							<input type="hidden" name="receiverDestID" value="<%=msg.getSenderDestID() %>">
<%
					String chkReceivers= aq.getLocationReaders(conn,agent.getPkID(), agent.getAgentCatID(),qID);
					if(!chkReceivers.equals("#"))
					{
						out.println("<input type=\"hidden\" name=\"receiver\" value=\""+ chkReceivers +"\">");	
					}
					else
					{
						CallableStatement call = null;
						ResultSet rs = null;
						try
						{
							call=conn.prepareCall("{CALL SIS_MSG.GET_SCHOOL_RECEIVERS(?,?)}");
							call.setInt(1,agent.getAgentID());
							call.registerOutParameter(2,OracleTypes.CURSOR);
							call.execute();
							rs=(ResultSet)call.getObject(2);
/*							rs=st.executeQuery("SELECT DISTINCT B.AGENT_NAME FROM CL_EMPLOYEE A,MSG_AGENT B,MSG_Q_ACL C WHERE A.LOC_ID =(select service_loc_id from cl_enroll enroll, cl_cust_login login, msg_agent agent where enroll.cust_id = login.cust_id and login.user_id = agent.pk_value and agent.agent_id ="+agent.getAgentID()+") AND  A.EMP_ID = B.PK_VALUE AND B.AGENT_ID = C.AGENT_ID AND C.Q_ID = 10 ORDER BY AGENT_NAME");
*/							
						
%>
							<tr> 
								<td><img src="/img/blank.gif" width="5" height="5"></td>
								<!--<td><font class="verbld"><a href="javascript:popup(<%=qID %>)">To</a></font></td>-->
								<TD font class="verbld">TO</TD>
								<td><SELECT NAME="receiver">
<%
								while(rs.next())
								{
%>
									<OPTION VALUE="<%=rs.getString("AGENT_NAME")%>"><%=rs.getString("AGENT_NAME")%></OPTION>
<%
								}
%>
								</SELECT></td>
								<!--<td><input type="text" name="receiver" value="<%=receiver %>"></td>-->
							</tr>
<%
						}
						finally
						{

							try{
								call.close();
								rs.close();
							}catch(Exception e)
							{}
						}
					}//end of no location readers found
				}
				else 
				{
%>
							<input type="hidden" name="receiver" value="##">
<%
				}
%>
							<tr> 
								<td><img src="/img/blank.gif" width="5" height="5"></td>
								<td><font class="verbld">Subject</font></td>
								<td><input type="text" name="subject" size="35" <%=reply && msgID>0?"value=\"Re: "+msg.getSubject()+"\"":"" %> <%=((!reply && msg!=null)||(reply && msgID==0))?" value=\""+ msg.getSubject()+"\"":""%> maxlength="50"></td>
							</tr>
							<tr> 
								<td><img src="/img/blank.gif" width="5" height="5"></td>
								<td><font class="verbld">Date</font></td>
								<td><font class="cnt"><%=ddmmyy %></font></td>
							</tr>
							<tr valign="top"> 
								<td><img src="/img/blank.gif" width="15" height="20"></td>
								<td colspan="2">
<%
				if(saveToSentItems.equals("yes"))
				{
%>
								<input title="Check to Save this message to your sent items folder." type="checkbox" name="savemsg" value="yes" CHECKED>
<%
				}
				else
				{
%>
								<input title="Check to Save this message to your sent items folder." type="checkbox" name="savemsg" value="yes">
<%				}%>
								<font class="verbld">Save to Sent Items</font></td>
				            </tr>
							<tr> 
								<td><img src="/img/blank.gif" width="5" height="5"></td>
								<td height="3" colspan="2" width="408"> 
<%
		}
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
		String rep= reply?"y":"n";
%>
								<jsp:include page="<%=includePage %>" flush="true">
								<jsp:param name="source" value="MSGStudentCompose.jsp"/>
								<jsp:param name="reply" value="<%=rep %>" />
								<jsp:param name="msgID" value="<%=msgID %>" />
								<jsp:param name="cat" value="<%=cat %>"/>
								</jsp:include>

<%
	    if(!(qID==0 || payloadID==0))
		{
%>
								</td>
							</tr>
					        </form>
						</table><!-- END OF INNER TABLE  -->
						</td>
						</tr>
					</table><!-- END OF TABLE WITH GREY BORDER -->
				    </td></tr>
				<tr bgcolor="#C0D9F5"><td><img src="/img/blank.gif" width="5" height="10"></td></tr>
				</table>
			</td></tr>
			</table>
<%
	    }
%>
	</td>
	</tr>
	</table>
	</td></tr></table>
	</body>
	</html>
