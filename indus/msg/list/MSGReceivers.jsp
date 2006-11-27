<%-- 
  -- FileName MSGReceivers.jsp
  -- Author Shilpa Arora
  -- Date 26th april 2002
  --%>
<%
String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
%>

<%@ page import="com.cl.msg.*,java.sql.Connection,com.cl.sql.CLMSPoolManager" errorPage="/msg/MSGErrorPage.jsp"%>
<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>

<%
	int qID = 0;
	String locIDs = "";
	String receiver=request.getParameter("receiver");
	try
	{
		qID		= Integer.parseInt(request.getParameter("qid"));
		locIDs	= request.getParameter("lids");
	}
	catch(NumberFormatException nfe)
	{
		qID = 0;
	}

	if(receiver==null)
		receiver="";

	MSGAgent[] agents = null;
	CLMSPoolmanager clmsPool = CLMSPoolManager.getInstance();
	Connection conn = null;
	try
	{
		conn = clmsPool.getConnection("erp");
		agents = queues.getRecepients(conn, qID, 1,"|1|2|3|4|5|");
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}

%>


<html>
<head>
<meta http-equiv="expires" content="0">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">
<link rel="stylesheet" href="/styles/style.css" type="text/css">

<title>Receivers List</title>

<link rel="stylesheet" href="/styles/style.css" type="text/css">

<script language="javascript">

function record(){
for(i=1;i<document.agentForm.elements.length;i++){
	if(document.agentForm.elements[i].type=="checkbox" && document.agentForm.elements[i].checked==true){
		if(window.opener.document.payload.receiver.value!=""){
			window.opener.document.payload.receiver.value+=", ";
			}
		window.opener.document.payload.receiver.value+=document.agentForm.elements[i].value;
		}
	}
window.close();
}

function checkIt(){

if (document.agentForm.elements[0].checked==true){
	for(i=1;i<document.agentForm.elements.length;i++){
		if(document.agentForm.elements[i].type=="checkbox" ){
		document.agentForm.elements[i].checked=true;
		}
	}
}
else{
	for(i=1;i<document.agentForm.elements.length;i++){
		if(document.agentForm.elements[i].type=="checkbox" ){
		document.agentForm.elements[i].checked=false;
		}
	}
}

}
</script>



</head>

<body>
<table>
<tr>
<td>
<p align="center"><font class="verbld">CLMS Members -&nbsp;&nbsp;</font>
<font class="new">New!</font><a href="/msg/MSGLocationTree.jsp?qid=<%=qID%>&receiver=<%=receiver %>" class="lnkblu"> Try the Location Tree</a></p>
</td>
</tr>
<tr>
<td>
<font class="verbld"><%=qID>0?"<img src=\""+queues.getQueue(qID).getIconURL()+"\" align=\"absmiddle\">":"" %>&nbsp;Channel :</font> <font class="cnt"><%=qID>0?queues.getQueue(qID).getQDescr():"" %></font>
</td>
</tr>
</table>

<p><font class="cnt">Choose the receiver(s) of your Message from here and press the OK Button</font></p>

<form method="POST" name="agentForm">
  <table border="1" width="100%" bordercolorlight="gray" cellspacing="0" cellpadding="0" bordercolordark="white">
    <tr>
      <td width="6%"><input type="checkbox" name="C2" value="ON" OnClick="javascript:checkIt()"></td>
      <td width="32%"><font class="verbld">All CLites of this channel</font></td>
      <td width="62%"><font class="verbld">Work Location</font></td>
    </tr>
  </table>
<%
for(int i=0;i<agents.length; i++){
%>
  <table border="1" width="100%" bordercolorlight="gray" cellspacing="0" cellpadding="0" bordercolordark="white">
    <tr>
      <td width="6%"><input type="checkbox" name="agents" value="<%=agents[i].getAgentName() %>"></td>
      <td width="32%"><font class="cnt"><%=agents[i].getAgentName() %></font></td>
      <td width="62%"><font class="cnt"><%=agents[i].getLocation() %></font></td>
    </tr>
   </table>
<%
}
%>
  <table border="1" width="100%" bordercolorlight="gray" cellspacing="0" cellpadding="0" bordercolordark="white">
    <tr>
      <td width="100%" colspan="3">
        <p align="center"><input type="button" value="OK" name="B1" onClick="javascript: record()"><input type="reset" value="Reset" name="B2"></td>
    </tr>
  </table>
  <p>&nbsp;</p>
</form>
</body>

</html>
