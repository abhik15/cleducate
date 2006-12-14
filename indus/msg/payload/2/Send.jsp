<%@ page import="java.io.File,java.sql.SQLException,java.sql.Connection,com.cl.sql.PoolManager,com.cl.msg.*,java.math.*,java.util.*,org.apache.log4j.*,com.cl.common.*,com.cl.msg.list.*" %>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl"%>

<%--
  -- Filename:	 Send.jsp
  -- Author:     Shilpa Arora
  -- Create Date:27 Jan 2003
  --%>

<%--
     -- Sends the payload message, does all the checks and finally calls the overloaded methods
     -- of the classes MSGMessage and MSGStudentMessage for this particular payload
     -- to send the message
     --%>

<%
	String logFile = application.getRealPath("/logs/error/")+"MSGErrorLog.log";
	int cat = 0;
	try
	{
		cat = Integer.parseInt(request.getParameter("cat"));
	}
	catch(NumberFormatException nfe)
	{	cat = 0;	}
	String user = (cat == 0) ? "CUSTOMER" : "EMPLOYEE";
%>

	<cl:CLValidateSessionTag userType="<%=user%>"/>
	<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
	<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>

	<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
	<jsp:useBean id="book" class="com.cl.msg.list.MSGMemberBook" scope="page" />

<%
	int StudentSend = 1;
	String privilege = "";
	String values = "";
	String saveToSentItems = request.getParameter("savemsg");

	
	privilege = request.getParameter("privilege");
	values = request.getParameter("values");
	if(privilege == null || privilege.equals("")|| privilege.equals("null"))
		StudentSend = -1;
	
%>
	<jsp:useBean id="msg" class="com.cl.msg.MSGMessage" scope="session" />
	<jsp:setProperty name="msg" property="*" />
	<jsp:setProperty name="msg" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="msgStudent" class="com.cl.msg.admin.MSGStudentMessage" scope="session" />
	<jsp:setProperty name="msgStudent" property="*" />
	<jsp:setProperty name="msgStudent" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="w2payload" class="com.cl.msg.MSGXTextPayload" scope="session" />
	<jsp:setProperty name="w2payload" property="*" />

<%
		request.setAttribute("cat",Integer.toString(cat));
		request.setAttribute("jspname","/msg/payload/1/Send.jsp");
		String source = request.getParameter("source");


		if(msg.getSubject().trim() == null || msg.getSubject().trim().equals(""))
			msg.setSubject("[no subject]");
		if(msgStudent.getSubject().trim()==null || msgStudent.getSubject().trim().equals(""))
			msgStudent.setSubject("[no subject]");


		String receiver = "";
		String error = null;
		String bookError = null;//error for nicknames
		String rList = "";
		boolean reply = false;
		boolean fwd = false;
		int parentMsgID = 0;
		int receiverID = 0;
		int receiverDestID = 0;
		int payloadID = 1;
		int ids[] = null;
		try
		{
			reply = (request.getParameter("reply") != null) 
					? (request.getParameter("reply").equalsIgnoreCase("y") ? true : false) 
					: false;
			fwd = (request.getParameter("fwd") != null)
					? (request.getParameter("fwd").equalsIgnoreCase("y") ? true : false)
					: false;
			parentMsgID = Integer.parseInt(request.getParameter("parentMsgID"));
			receiverID = Integer.parseInt(request.getParameter("receiverID"));
			receiverDestID = Integer.parseInt(request.getParameter("receiverDestID"));			
		}
		catch(NumberFormatException nfe)
		{}


		PoolManager clmsPool = PoolManager.getInstance();
		Connection conn = null;
		try
		{
			conn = clmsPool.getConnection("erp");
			if(reply)
			{
				OtMsgAgent oma[] = new OtMsgAgent[1];
				oma[0] = new OtMsgAgent();
				//INCASE receiverID not received its obtained from database
				if(receiverID==0 || receiverDestID==0)
				{
					receiver = request.getParameter("receiver");
					String tmpResult = queues.validateForQueue(conn,receiver,msg.getQueueID(),4);
					msg.setSentToList(queues.getSentToListFound());

					int ctr = 0;
					int ctrPos = 0;
					
					while(tmpResult.indexOf("#",ctrPos) > -1)
					{
						ctr++; 
						ctrPos = tmpResult.indexOf("#",ctrPos) + 1;
					}
					if(ctr == 1)
					{
						error="<font color=\"red\">Reply Cannot be sent, no recepient name set with the message</font>";
					}

					StringTokenizer tokenizer = new StringTokenizer(tmpResult, "#");
					while(tokenizer.hasMoreElements())
					{
						StringTokenizer tokens = new StringTokenizer(tokenizer.nextToken(),"|");
						if(tokens.hasMoreElements())
						{
							receiverID = Integer.parseInt(tokens.nextToken());
						}
						if(tokens.hasMoreElements())
							receiverDestID = Integer.parseInt(tokens.nextToken());
						
						if(tokens.hasMoreElements())
						{
							if(receiverID==0)
								if(error == null)
									error = "<font color=\"red\">Sorry!! Message cannot be sent. The receiver has the following problem-</font><br>" + tokens.nextToken();
								else 
									error+=", " + tokens.nextToken();
							//else   rList+= tokens.nextToken()+"<br>";
						}
					}//end of while						
					
					
				}//end of if
					else
				{
					msg.setSentToList(null);
				}

				oma[0].setDestId(new BigDecimal(""+receiverDestID));
				oma[0].setAgentId(new BigDecimal(""+receiverID));
				MSGAgentList agentList= new MSGAgentList();
				agentList.setArray(oma);
				msg.setAgentList(agentList);
				msg.setParentMsgID(parentMsgID);
			}
			else if(StudentSend>-1)
				{
					int ctr=0; int ctrPos=0;
					while(values.indexOf("|",ctrPos)>-1){
						ctr++; 
						ctrPos= values.indexOf("|",ctrPos)+1;
						}
					if(ctr==1){
						error="Sorry! the message cannot be sent as no recepient(s) got detected for your message";
						}
					
					ids= new int[ctr-1];
					ctr=0;
					StringTokenizer tokens= new StringTokenizer(values, "|");
					while(tokens.hasMoreElements()){
						ids[ctr]=Integer.parseInt(tokens.nextToken());
						ctr++;
					}

			}
			else if(queues.getQueue(msg.getQueueID()).getQType().equals("POINT-TO-POINT")){
				outer:{
					receiver= request.getParameter("receiver");

					// verifies the nicknames from member book
					MSGMemberBook.BookResult result = book.verifyMembers(conn,msg.getQueueID(), agent.getAgentID(), agent.getDestID(), receiver);
					//receivers list doesnt contain the invalid nicknames		
					
					receiver = result.receivers;
					bookError = result.error;

					
					String tmpResult=queues.validateForQueue(conn,receiver,msg.getQueueID(), 4) ;
					
					
					
					// The list contains value only if any keywords being used while sending the message
					msg.setSentToList(queues.getSentToListFound());
					

					int ctr=0; int ctrPos=0;
					while(tmpResult.indexOf("#",ctrPos)>-1)
					{
						ctr++; 
						ctrPos= tmpResult.indexOf("#",ctrPos)+1;
					}
					if(ctr==1)
					{
						receiver = "";
						if (request.getParameter("receiver")== null || request.getParameter("receiver").trim().length() ==0 )
							error="<font class=\"new\">Sorry!! Message cannot be sent. Please enter recepient(s) for your message</font>";
						break outer;
					}

					OtMsgAgent oma[]= new OtMsgAgent[ctr-1];
					int tmpAgent=0;
					int cntr=0;

					
					StringTokenizer tokenizer= new StringTokenizer(tmpResult, "#");
					while(tokenizer.hasMoreElements()){
						StringTokenizer tokens= new StringTokenizer(tokenizer.nextToken(),"|");
						if(tokens.hasMoreElements()){
							oma[cntr]= new OtMsgAgent();
							tmpAgent= Integer.parseInt(tokens.nextToken());
							oma[cntr].setAgentId(new BigDecimal(Integer.toString(tmpAgent)));
							}
						if(tokens.hasMoreElements())
							oma[cntr].setDestId(new BigDecimal(tokens.nextToken()));
						if(tokens.hasMoreElements()){
							if(tmpAgent==0)
								if(error==null)
									error="<font color=\"red\">Sorry!! Message cannot be sent. Please check your receiver(s) list for the following error(s)-</font><br>"+tokens.nextToken();
								else 
									error+=", "+tokens.nextToken();
							//else   rList+= tokens.nextToken()+"<br>";
							}
							
						cntr++;
						}
				


					MSGAgentList agentList= new MSGAgentList();
					agentList.setArray(oma);
					msg.setAgentList(agentList);
					}//end of outer
			}
		}
		finally
		{
			clmsPool.freeConnection("erp",conn);
		}

				//concatination of two errors
		if (bookError!=null)
		{
			if (error!= null)
				error += "," +bookError;
			else
				error = "<font color=\"red\">Sorry!! Message cannot be sent. Please check your receiver(s) list for the following error(s)-</font><br>"+  bookError;
		}

		if(error!=null) 
		{
			receiver= request.getParameter("receiver");
		%>
		<jsp:forward page="<%=source %>" >
		<jsp:param name="message" value="<%=error %>" />
		<jsp:param name="receiver" value="<%=receiver %>" />
		<jsp:param name="pid" value="<%=msg.getPayloadID() %>" />
		<jsp:param name="qid" value="<%=msg.getQueueID() %>" />
		</jsp:forward>
		<%
		}
		%>
	<html>
	<head>
	<title>Sent Message Confirmation</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" href="/styles/style.css" type="text/css">
	<link href="/styles/indus.css" rel="stylesheet" type="text/css" /> 
	<script LANGUAGE="JavaScript" src="/msg/list/MSGBookJscript.js"></script>
	<script language="javascript">
	function hideIt(){
		alert("called");
		if(navigator.appName != "Netscape"){
			document.div_1.style.visibility= "hidden"; 
			}
		else{
			document.layers[0].visibility= "hide";
			}
		}

	function showWindow(winname,url){
	win = window.open(url,winname,"toolbar=0,location=0,directories=0,status=1,menubar=0,scrollbars=1,resizable=0,width=500,height=380,left=20,top=20");
	}


	function submitBookForm(type)
	{
		var cntr =0;
		document.bookForm.membersString.value = "|"
		for(i=1;i<document.bookForm.elements.length;i++)
		{
			if(document.bookForm.elements[i].type=="checkbox")
			{
				//if the checkbox is selected, not disabled and the value doesnt exist in receivers then Add-->
				if(document.bookForm.elements[i].checked==true)
				{
					if(!validateNickName(document.bookForm.elements[i-1].value))
					{
						document.bookForm.elements[i-1].focus();
						return;
					}

					cntr ++;
					if(type =='SYSTEM')	
					{
						document.bookForm.membersString.value+=document.bookForm.elements[i].value+"-"+document.bookForm.elements[i-1].value+"|";
					}
					else
					{
						document.bookForm.membersString.value+=document.bookForm.elements[i].value+"-"+document.bookForm.group.value+"|";
					
					}
				}
			}
		}
		if (cntr>0)
		{
			document.bookForm.type.value = type;
			document.bookForm.submit();
		}
		else
		{
			alert('No members selected to add');
			return;
		}
	}

	</script>
	<!-- Add top.js for top band -->

	</head>
	<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  > 
	<script language="javascript" src="/jscript/top.js"></script>
	<table border="0" width="100%" cellspacing="0" cellpadding="3">
<%
	String clSrc = (cat == 1) ? "/msg/MSGStaffCompose.jsp" : "/msg/MSGStudentCompose.jsp";
	String sendResult = "";
	try
	{
		conn = clmsPool.getConnection("erp");
%>
	<tr valign="top"><td bgcolor="#999933" width="21%" valign="top">
		<cl:CLMsgSisLeftBandTag connObj="<%=conn%>" category="<%=Integer.toString(cat)%>" level="1"/>
	</td>

	<%
	if(source.equals("/msg/admin/MSGCompose4Students.jsp"))
		source="/msg/MSGStaffCompose.jsp";
	%>
	</td>
	<td width="79%" valign="top">
	<!-- TOP BAND START -->
	<table align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td bgcolor="B4BC6D">
		<table border="0" cellspacing="0" cellpadding="0">
		<tr><td bgcolor="B4BC6D" height="32" width="10">
				<img src="/img/blank.gif" width="1" height="28">
			</td>
			<td><font class="cntblu">
				<a href="/" class="lnkblu">Home</a><font class="cntblu"> &gt; </font><%=cat==1?"<a href=\"/clzone/login/CLZone.jsp\" class=\"lnkblu\">CL Zone Home</a>":"<a href=\"/sis/student/SIS.jsp\" class=\"lnkblu\">SIS page</a>"%> &gt;  Message Sent</font>
			</td>
		</tr>
		</table>
	</td></tr></table>
	<!-- TOP BAND END -->

	<table width="100%" cellpadding="3" cellspacing="0">
	<tr><td><img src="/img/blank.gif" width="5" height="10"></td></tr>
	<!-- <tr><td>
		<cl:writeChannels agentID="<%=agent.getAgentID() %>" destID="<%=agent.getDestID() %>" clSource="<%=clSrc%>" connObj="<%=conn%>" sisSource="/msg/admin/MSGPickStudents.jsp"/>
	</td></tr> -->
<%
		msg.setCreateStatus(reply?"REP":fwd?"FWD":"NEW");
		//will hold the path where attachments will be saved before they are uploaded to the database.
		String attchFolderPath = "";
		attchFolderPath = application.getRealPath("/msg/attch") + File.separator + agent.getAgentID() + "_" + agent.getDestID() + File.separator;
		if(attchFolderPath == null)
		{
			File f = new File(application.getRealPath("/msg/attch") + File.separator +  agent.getAgentID() + "_" + agent.getDestID());
			f.mkdir();
		}
		attchFolderPath = application.getRealPath("/msg/attch") + File.separator + agent.getAgentID() + "_" + agent.getDestID() + File.separator;
		/* * * * * * * * * * * * * * *
		 * In case of forward message we will download the file from the 
		 * database and re-upload with the new message
		 */


		// this try catch block is required because at times the method wpayload.getFilename()
		// throws a null pointer exception.
		String attchFileNames[] = null;
		try
		{
			attchFileNames = w2payload.getAttachedFiles();
			if(fwd && attchFileNames.length > 0)
			{
				w2payload.getFilesFromBlob(conn,parentMsgID, attchFolderPath);
				//parentMsgID passed to retrieve any attachments
			}
		}
		catch(NullPointerException nlp)
		{
			w2payload.setAttachments(new OtFiles());
			attchFileNames = null;
			attchFolderPath = "";
		}
		if(error==null)
		{
			if(StudentSend==-1)
			{
				msg.send(conn,w2payload, attchFolderPath, saveToSentItems);
			}
			else
			{
				try
				{
					sendResult = msgStudent.send(conn,w2payload,attchFolderPath, privilege, ids,saveToSentItems);
					msg.setMsgID(msgStudent.getMsgID());
				}
				catch(SQLException sqle)
				{
					if (sqle.getErrorCode()==20900)
						msg.setMsgID(-1);
				}
			}
			/* we remove the following folders under /msg/attch
			 *	/msg/attch/agentId_destId
			 */
			if(attchFolderPath != null && attchFolderPath.length() > 0)
			{
				try
				{
					File file = new File(attchFolderPath);
					//before removing the folder check for any files present and remove them
					File[] fileList = (file == null) ? null : file.listFiles();
					if(fileList != null)
					{
						for(int i=0; i<fileList.length; i++)
						{
							fileList[i].delete();
						}
					}
					if(file != null)
						file.delete();
				}
				catch(Exception ex)
				{
					//we just log this exception as we do not want to stop the send operation
					Category logCat = Category.getInstance("clsite.msg.payload.1");
					logCat.error("Unable to delete attachment folder " + attchFolderPath + " "  + ex.toString());
				}
			}
		}
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
		if(sendResult == null)
			sendResult = " ";
%>
			
	  <tr> 
	    <td align="left" height="30"><font class="cnt">
		<%=	msg.getMsgID()>0 ? "Your Message has been sent successfully."+ sendResult 
			:(msg.getMsgID() == -1 
				? "<font class=\"new\">Sorry!</font> There are no students for your message, please check your message sending criteria."
				:"Your message cannot be sent due to some problem") %></font></td>
	  </tr>

	<%
	// displays the member book status
		if(StudentSend==-1 && cat==1)
		{
			receiver= request.getParameter("receiver");
		%>
		<jsp:include page="/msg/list/MSGMemberBookStatus.jsp" flush="true" >
		<jsp:param name="receiver" value="<%=receiver %>"/>
		<jsp:param name="qid" value="<%=msg.getQueueID() %>"/>
		</jsp:include>
		<%
		}

	
	%>


	</table>
	</td></tr></table>
	</body>
	</html>

<%
msg.setSubject("");
msg.reset();
w2payload.reset();
%>
