<%@ page import="java.sql.*,com.cl.msg.*,java.math.*,java.io.*,com.jspsmart.upload.*" errorPage="/msg/MSGErrorPage.jsp"%> 
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl"%>
<%--
  -- Filename:	 Uploader.jsp
  -- Author:     Shilpa Arora
  -- Create Date:16th April 2002 
  --%>


<%--
  -- Change History
  -- Date 6 June 2002
  -- Parameters- privilege, values, displays retrieved and forwarded
  --%>

<%
String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
%>


<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />

<%
	int cat = 0;
	mySmartUpload.initialize(pageContext);
	mySmartUpload.upload();
	com.jspsmart.upload.Request req = mySmartUpload.getRequest();

	try
	{
		cat = Integer.parseInt(req.getParameter("cat"));
	}
	catch(NumberFormatException nfe)
	{	cat = 0;	}

	String user = (cat == 0) ? "CUSTOMER" : "EMPLOYEE";
	String message = "";
%>
	<cl:CLValidateSessionTag userType="<%=user%>"/>

	<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
	<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="Systems" scope="application" class="com.cl.CLSystems"/>
	
	
	<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
	<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="msg" class="com.cl.msg.MSGMessage" scope="session" />
	<jsp:setProperty name="msg" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="wpayload" class="com.cl.msg.MSGTextPayload" scope="session" />
	<jsp:setProperty name="wpayload" property="errorFileName" value="<%=logFile %>"/>


<%
	String source		= req.getParameter("source");
	String receiver		= req.getParameter("receiver");
	String reply		= req.getParameter("reply");
	String displays		= req.getParameter("displays");
	String privilege	= req.getParameter("privilege");
	String values		= req.getParameter("values");
	String parentMsgID	= req.getParameter("parentMsgID");
	String receiverID	= req.getParameter("receiverID");
	String receiverDestID = req.getParameter("receiverDestID");
	String saveToSentItems = req.getParameter("savemsg");


	request.setAttribute("cat",Integer.toString(cat));
	request.setAttribute("jspname","/msg/payload/1/Uploader.jsp");


	String error = null;

	//String path="/u03/resin-2.0.5/doc/cl/msg/tmp/";
	//String path="\\\\Web_server\\d\\sis_msg\\tmp\\";
	String path = application.getRealPath("/msg") + java.io.File.separator 
					+ "tmp" + java.io.File.separator;
	java.io.File dirs = new java.io.File(path);
	dirs.mkdirs();

	Files files = mySmartUpload.getFiles();
	int countOfFiles = files.getCount();
	com.jspsmart.upload.File[] allFile = new com.jspsmart.upload.File[countOfFiles];
	String[] fileNames = new String[countOfFiles];

	int actualCount = 0;
	String fileLocation = "";

	for(int i=0;i<fileNames.length;i++)
	{
		int temp = i+1;
		allFile[i] = files.getFile(i);
		fileNames[i] = allFile[i].getFileName();
		if(fileNames[i] == null || fileNames[i].length() == 0)
			break;
		java.io.File file = new java.io.File(allFile[i].getFilePathName());
		if(!file.exists())
			message = "<font color=\"red\">The file <b>\"" + fileNames[i] + "\"</b> does not exist. Could not attach file.</font>";
		else
		{
			if(file.length() == 0)
				message = "<font color=\"red\">The file <b>\"" + fileNames[i] + "\"</b> is of zero bytes. Could not attach file.</font>";
		}
		if(allFile[i].getSize()>0)
		{
			actualCount++;
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
			
			basePath = application.getRealPath("/msg/attch/" + agent.getAgentID() + "_" 
							+ agent.getDestID()) + java.io.File.separator;
			
			wpayload.setFilename(fileNames[i]); 
			allFile[i].saveAs(basePath + fileNames[i]);
			wpayload.setAttached(true);
			message = "<font color=\"blue\">File <b>\"" + fileNames[i] + "\"</b> attached successfully.</font>";
		}		
		//wpayload.setAttachmentFromFile(new java.io.File(fileLocation),"lol");
	}
%>

<jsp:forward page="<%=source %>" >
<jsp:param name="pid" value="<%=msg.getPayloadID() %>" />
<jsp:param name="qid" value="<%=msg.getQueueID() %>" />
<jsp:param name="receiver" value='<%=receiver %>' />
<jsp:param name="displays" value="<%=displays %>" />
<jsp:param name="values" value="<%=values %>" />
<jsp:param name="privilege" value="<%=privilege %>" />
<jsp:param name="reply" value="<%=reply %>" />
<jsp:param name="parentMsgID" value="<%=parentMsgID %>" />
<jsp:param name="receiverID" value="<%=receiverID %>" />
<jsp:param name="receiverDestID" value="<%=receiverDestID %>" />
<jsp:param name="message" value="<%=message%>" />
<jsp:param name="savemsg" value="<%=saveToSentItems%>" />
</jsp:forward>
