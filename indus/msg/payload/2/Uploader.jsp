<%--
     -- The Uploader can be called again and again to upload various files by the TakeAttachment
     -- of the same payload, the explicit upload failures are..
     -- 1) If the attachment file has a filename thats already being attached
     -- 2) The attachment files makes the total filesize limit exceeding 1 MB
--%>

<%@ page import="java.sql.*,com.cl.msg.*,java.math.*,java.io.*" errorPage="/msg/MSGErrorPage.jsp"%>
<%@ page import = "java.util.*,com.oreilly.servlet.*,com.oreilly.servlet.multipart.*"%>

<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl"%>

<%
	String logFile = application.getRealPath("/logs/error/")+"MSGErrorLog.log";
	String message = "";
%>

	<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
	<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>

	<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
	<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="msg" class="com.cl.msg.MSGMessage" scope="session" />
	<jsp:setProperty name="msg" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="w2payload" class="com.cl.msg.MSGXTextPayload" scope="session" />

<%
	MultipartRequest req = null;
	
	String basePath = application.getRealPath("/msg") + java.io.File.separator;

	//check for existence of attch folder
	java.io.File f = new java.io.File(basePath + "attch");
	if(!f.exists())
		f.mkdir();

	basePath = application.getRealPath("/msg/attch") + java.io.File.separator;

	//Create folder with name = agentId_destId
	f = new java.io.File(basePath + java.io.File.separator + agent.getAgentID() + "_" + agent.getDestID());

	if(!f.exists())
		f.mkdir();

	basePath = application.getRealPath("/msg/attch/" + agent.getAgentID() + "_" + agent.getDestID()) + java.io.File.separator;

	req = new MultipartRequest(request, basePath, 1048576,new DefaultFileRenamePolicy());

	int cat = 0;
	try
	{
		cat = Integer.parseInt(req.getParameter("cat"));
	}
	catch(NumberFormatException nfe){cat = 0;}

	String user = (cat == 0) ? "CUSTOMER" : "EMPLOYEE";
%>

	<cl:CLValidateSessionTag userType="<%=user%>"/>

<%
	String source		= req.getParameter("source");
	String receiver		= req.getParameter("receiver");
	String reply		= req.getParameter("reply");
	String fwd 			= req.getParameter("fwd");
	String displays		= req.getParameter("displays");
	String privilege	= req.getParameter("privilege");
	String values		= req.getParameter("values");
	String parentMsgID	= req.getParameter("parentMsgID");
	String receiverID	= req.getParameter("receiverID");
	String receiverDestID = req.getParameter("receiverDestID");
	String saveToSentItems = req.getParameter("savemsg");


	request.setAttribute("cat",Integer.toString(cat));
	request.setAttribute("jspname","/msg/payload/2/Uploader.jsp");


	Enumeration en = req.getFileNames();
	String fieldName = "";
	String systemFileName = "";
	String originalFileName = "";
	File file = null;

	int i = 0;
	while(en.hasMoreElements())
	{
		fieldName = (String)en.nextElement();
		systemFileName = req.getFilesystemName(fieldName);
		originalFileName = req.getOriginalFileName(fieldName);

		//out.println(systemFileName);
		//System.out.println(originalFileName);

		file = req.getFile(fieldName);
		if(file != null)
		{
			if(file.length()>0)
			{
				String attachedFiles[] = w2payload.getAttachedFiles();

				java.io.File attFile = null;
				int size = 0;

				for(int j=0; j<attachedFiles.length; j++)
				{
					attFile = new java.io.File(application.getRealPath("/msg/attch") + java.io.File.separator + agent.getAgentID() + "_" + agent.getDestID() + java.io.File.separator + attachedFiles[i]);
					if(attFile.exists())
						size += (int)attFile.length();
					else
						size += (int)(w2payload.getAttachments().getElement(i).getContent()!=null? w2payload.getAttachments().getElement(i).getContent().length(): 0);
				}

				size += (int)file.length();

				if((((float)size) / 1048576 ) <= 1.0)
				{
					w2payload.addAttachedFile(systemFileName);
					w2payload.setAttached(true);
					message = "<font class=\"cntblu\">File <b>\"" + systemFileName + "\"</b> attached successfully.</font>";
				}
				else
				{
					message = "<font class=\"new\">Cannot Attach File <b>\"" + systemFileName + "\"</b> , this file makes the total file size more than the limit of 1 MB.</font>";
				}
			}
		}
	}

	if (parentMsgID != null) 
	{
		/*System.out.println(source);
		System.out.println(cat);
		System.out.println(msg.getPayloadID());
		System.out.println(msg.getQueueID());
		System.out.println(receiver);
		System.out.println(displays);
		System.out.println(values);
		System.out.println(privilege);

		System.out.println(privilege);
		System.out.println(reply);
		System.out.println(fwd);
		System.out.println(parentMsgID);
		System.out.println(receiverID);
		System.out.println(receiverDestID);
		System.out.println(message);
		System.out.println(saveToSentItems);
		System.out.println("End");
		*/
%>
		<jsp:forward page="/msg/payload/2/TakeAttachment.jsp" >
		<jsp:param name="source"    value="<%=source %>" />
		<jsp:param name="cat"       value="<%=cat %>"/>
		<jsp:param name="pid"       value="<%=msg.getPayloadID() %>" />
		<jsp:param name="qid"       value="<%=msg.getQueueID() %>" />
		<jsp:param name="receiver"  value='<%=receiver %>' />
		<jsp:param name="displays"  value="<%=displays %>" />
		<jsp:param name="values"    value="<%=values %>" />
		<jsp:param name="privilege" value="<%=privilege %>" />
		<jsp:param name="reply"     value="<%=reply %>" />
		<jsp:param name="fwd"       value="<%=fwd %>" />
		<jsp:param name="parentMsgID" value="<%=parentMsgID %>" />
		<jsp:param name="receiverID"     value="<%=receiverID %>" />
		<jsp:param name="receiverDestID" value="<%=receiverDestID %>" />
		<jsp:param name="message"        value="<%=message%>" />
		<jsp:param name="savemsg"        value="<%=saveToSentItems%>" />
		</jsp:forward>
<%
	}	
	else
	{
%>
		<jsp:forward page="/msg/payload/2/TakeAttachment.jsp" >
		<jsp:param name="source"    value="<%=source %>" />
		<jsp:param name="cat"       value="<%=cat %>"/>
		<jsp:param name="pid"       value="<%=msg.getPayloadID() %>" />
		<jsp:param name="qid"       value="<%=msg.getQueueID() %>" />
		<jsp:param name="receiver"  value='<%=receiver %>' />
		<jsp:param name="displays"  value="<%=displays %>" />
		<jsp:param name="values"    value="<%=values %>" />
		<jsp:param name="privilege" value="<%=privilege %>" />
		<jsp:param name="reply"     value="<%=reply %>" />
		<jsp:param name="fwd"       value="<%=fwd %>" />
		<jsp:param name="receiverID"     value="<%=receiverID %>" />
		<jsp:param name="receiverDestID" value="<%=receiverDestID %>" />
		<jsp:param name="message"        value="<%=message%>" />
		<jsp:param name="savemsg"        value="<%=saveToSentItems%>" />
		</jsp:forward>
<%
	}
%>

