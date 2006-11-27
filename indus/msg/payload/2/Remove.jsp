<%@ page import="com.cl.msg.*,java.io.*" %>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl"%>
<%--
  -- Filename:	 Remove.jsp
  -- Author:     Shilpa Arora
  -- Create Date:29 jan 2003
  --%>

<%--
     -- This file removes the attached files from the message and deletes it physically
     -- from the  hard disk as well.
     --%>


<%
String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
%>

<%
	int cat = 0;

	try
	{
		cat = Integer.parseInt(request.getParameter("cat"));
	}
	catch(NumberFormatException nfe)
	{	cat = 0;	}

	String user = (cat == 0) ? "CUSTOMER" : "EMPLOYEE";
	String message = "";
%>
	<cl:CLValidateSessionTag userType="<%=user%>"/>
	<jsp:useBean id="msg" class="com.cl.msg.MSGMessage" scope="session" />
	<jsp:setProperty name="msg" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="w2payload" class="com.cl.msg.MSGXTextPayload" scope="session" />
	<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
	<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>


<%
	String name		= request.getParameter("name");
	String source		= request.getParameter("source");
	String receiver		= request.getParameter("receiver");
	String reply		= request.getParameter("reply");
	String displays		= request.getParameter("displays");
	String privilege		= request.getParameter("privilege");
	String values		= request.getParameter("values");
	String parentMsgID	= request.getParameter("parentMsgID");
	String receiverID	= request.getParameter("receiverID");
	String receiverDestID 	= request.getParameter("receiverDestID");
	String saveToSentItems = request.getParameter("savemsg");
	String fwd = request.getParameter("fwd");

	request.setAttribute("cat",Integer.toString(cat));
	request.setAttribute("jspname","/msg/payload/2/Remove.jsp");

	w2payload.removeAttachedFile(name);
	String attchFolderPath = "";
	attchFolderPath = application.getRealPath("/msg/attch") + File.separator + agent.getAgentID() + "_" + agent.getDestID() + File.separator;
	File f = new File(attchFolderPath+name);
	if (f.exists())
		f.delete();
	message = "<font class=\"cntblu\">Attachment \""+name+"\" removed successfuly.</font>";
%>
<%
if (parentMsgID!=null)
{
%>
	<jsp:forward page="/msg/payload/2/TakeAttachment.jsp" >
	<jsp:param name="source" value="<%=source %>" />
	<jsp:param name="cat" value="<%=cat %>"/>
	<jsp:param name="pid" value="<%=msg.getPayloadID() %>" />
	<jsp:param name="qid" value="<%=msg.getQueueID() %>" />
	<jsp:param name="receiver"  value="<%=receiver %>" />
	<jsp:param name="displays"  value="<%=displays %>" />
	<jsp:param name="values"    value="<%=values %>" />
	<jsp:param name="privilege" value="<%=privilege %>" />
	<jsp:param name="reply"       value="<%=reply %>" />
	<jsp:param name="fwd"       value="<%=fwd %>" />

	<jsp:param name="parentMsgID" value="<%=parentMsgID %>" />

	<jsp:param name="receiverID"     value="<%=receiverID %>" />
	<jsp:param name="receiverDestID" value="<%=receiverDestID %>" />
	<jsp:param name="message" value="<%=message%>" />
	<jsp:param name="savemsg" value="<%=saveToSentItems%>" />
	</jsp:forward>
<%
}
else
{
%>
	<jsp:forward page="/msg/payload/2/TakeAttachment.jsp" >
	<jsp:param name="source" value="<%=source %>" />
	<jsp:param name="cat" value="<%=cat %>"/>
	<jsp:param name="pid" value="<%=msg.getPayloadID() %>" />
	<jsp:param name="qid" value="<%=msg.getQueueID() %>" />
	<jsp:param name="receiver"  value="<%=receiver %>" />
	<jsp:param name="displays"  value="<%=displays %>" />
	<jsp:param name="values"    value="<%=values %>" />
	<jsp:param name="privilege" value="<%=privilege %>" />
	<jsp:param name="reply"       value="<%=reply %>" />
	<jsp:param name="fwd"       value="<%=fwd %>" />
	<jsp:param name="receiverID"     value="<%=receiverID %>" />
	<jsp:param name="receiverDestID" value="<%=receiverDestID %>" />
	<jsp:param name="message" value="<%=message%>" />
	<jsp:param name="savemsg" value="<%=saveToSentItems%>" />
	</jsp:forward>
<%
}
%>