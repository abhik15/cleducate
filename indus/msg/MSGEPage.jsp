<%--
  -- Filename:	 MSGErrorPage.jsp
  -- Author:     Shilpa Arora
  -- Create Date:24th April 2002 
  --%>

<%
String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
int cat=0;
try{
cat= Integer.parseInt((String)request.getAttribute("cat"));
}catch(Exception nfe){cat=0;}
%>

<%@ page isErrorPage="true" %>
<% 
String filename=(String)request.getAttribute("jspname");
if(filename==null)filename="Not Set";
%>
<jsp:useBean id="SISExp" scope="application" class="com.cl.sis.exception.SISException"/>
<jsp:setProperty name="SISExp" property="fileName" value="<%=filename%>"/>
<jsp:setProperty name="SISExp" property="errorFileName" value="<%=logFile %>"/>

<html>
<head>
<title>We are sorry</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="/styles/style.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="60%" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr> 
    <td align="left"><font class="cnt" >
			There seems to be some problem in the system which is not allowing your 
			request to be served. Please try again after 15 minutes, if the problem 
			persists you could mail us at <B><A href="mailto:administrator@careerlauncher.com">administrator@careerlauncher.com</A></B> with your username, time and the action that caused the error.</font></td>
  </tr>
  <tr> 
    <td align="left" height="30">
<%
	StringWriter sw = new StringWriter();
	PrintWriter pw = new PrintWriter(sw);
	exception.printStackTrace(pw);
	StringBuffer errorString = new StringBuffer();
	errorString.append(sw);

	org.apache.log4j.Category logCategory = org.apache.log4j.Category.getInstance("clsite.msg");
	logCategory.error(errorString.toString());	
	SISExp.writeLog(errorString.toString());
%>

    
    </td>
  </tr>
</table>
</body>
</html>