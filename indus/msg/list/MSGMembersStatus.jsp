<%--
  -- Author Shilpa Arora
  -- Filename MSGMembersStatus.jsp
  -- Date 15, March 2003:1712 hrs
  --%>

<%--
  -- The code provides a User Interface to add the passed users to the 
  -- address book or Group List
  --%>

<%@ page import="org.apache.log4j.Category,java.sql.Connection,com.cl.sql.CLMSPoolManager" %> 
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>
<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />

<%
	int cat = 1;
	request.setAttribute("cat",Integer.toString(cat));
	request.setAttribute("jspname","/msg/list/MSGCreateMemberBook.jsp");

	String user = (cat == 0) ? "CUSTOMER" : "EMPLOYEE";
%>

<cl:CLValidateSessionTag userType="<%=user%>"/> 


<html>
<head>
<title>CLMS- Add Members to your Address Book/Group List</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="expires" content="0">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">

<link rel="stylesheet" href="/styles/style.css" type="text/css">

<script LANGUAGE="JavaScript" src="/msg/list/MSGBookJscript.js"></script>

<script language="javascript">
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

</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

<script language="javascript" src="/jscript/top.js"></script>
<table border="0" width="100%" cellspacing="0" cellpadding="3">
<tr valign="top"><td bgcolor="DFE1BC" width="21%" valign="top">
	<cl:CLMsgSisLeftBandTag category="<%=Integer.toString(cat)%>" level="1"/>
</td>
<td width="79%">
	<!-- TOP BAND START -->
	<table align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td bgcolor="B4BC6D">
		<table border="0" cellspacing="0" cellpadding="0">
		<tr><td bgcolor="B4BC6D" height="32" width="10">
				<img src="/img/blank.gif" width="1" height="28">
			</td>
			<td><font class="cntblu">
				<a href="/" class="lnkblu">Home</a><font class="cntblu"> &gt; </font>
				<%= (cat == 1) ? "<a href=\"/clzone/login/CLZone.jsp\" class=\"lnkblu\">CL Zone Home</a>" 
							   : "<a href=\"/sis/SIS.jsp\" class=\"lnkblu\">SIS page</a>" %> &gt; Add members to your Address Book/Group List</font>
			</td>
		</tr>
		</table>
	</td></tr></table>
	<!-- TOP BAND END -->

	<table width="100%" cellpadding="3" cellspacing="0" border="0">	
		<tr><td>
<%
	String clSrc = (cat == 1) ? "/msg/MSGStaffCompose.jsp" : "/msg/MSGStudentCompose.jsp";
	CLMSPoolManager clmsPool = CLMSPoolManager.getInstance();
	Connection conn = null;
	try
	{
		conn = clmsPool.getConnection("erp");
%>
		<cl:writeChannels agentID="<%=agent.getAgentID() %>" destID="<%=agent.getDestID() %>" clSource="<%=clSrc%>" connObj="<%=conn%>" sisSource="/msg/admin/MSGPickStudents.jsp"/>
	</td></tr>

	<tr><td class="cnt">

<%
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
		int qID		= 0;
		int msgID	= 0;
		int msgcnt	= 0;
		int pID		= 0;
		int pn		= 0;
		int seq		= 0;
		int rpage	= 0;
		String fid	= "";
		String fldr = "";
		String receiver = request.getParameter("receiver");
		qID = Integer.parseInt(request.getParameter("qid"));
		try
		{
			msgID	= Integer.parseInt(request.getParameter("msgID"));
			msgcnt	= Integer.parseInt(request.getParameter("msgcnt"));
			pID		= Integer.parseInt(request.getParameter("pID"));
			pn		= Integer.parseInt(request.getParameter("pn"));
			seq		= Integer.parseInt(request.getParameter("seq"));
			rpage	= Integer.parseInt(request.getParameter("rpage"));
			fid		= request.getParameter("fid");
			fldr	= request.getParameter("fldr");
		}
		catch(NumberFormatException nfe)
		{
			msgID = 0;
		}
	%>
	<% 
		if(msgID>0) 
		{
	%>
			<jsp:include page="/msg/list/MSGMemberBookStatus.jsp" flush="true" >
				<jsp:param name="receiver" value="<%=receiver==null?"":receiver %>"/>
				<jsp:param name="qid" value="<%=qID %>"/>
				<jsp:param name="mid" value="<%=msgID %>"/>
				<jsp:param name="cat" value="<%=cat %>"/>
				<jsp:param name="msgcnt" value="<%=msgcnt %>"/>
				<jsp:param name="pID" value="<%=pID %>"/>
				<jsp:param name="pn" value="<%=pn %>"/>
				<jsp:param name="seq" value="<%=seq %>"/>
				<jsp:param name="rpage" value="<%=rpage %>"/>
				<jsp:param name="fid" value="<%=fid %>"/>
				<jsp:param name="fldr" value="<%=fldr %>"/>
			</jsp:include>
	<%
		}			
		else
		{
	%>
			<jsp:include page="/msg/list/MSGMemberBookStatus.jsp" flush="true" >
				<jsp:param name="receiver" value="<%=receiver==null?"":receiver %>"/>
				<jsp:param name="qid" value="<%=qID %>"/>
			</jsp:include>
	<%
		}
	%>
	</td></tr>
	</table>
</td></tr>
</table>
</body>
</html>
