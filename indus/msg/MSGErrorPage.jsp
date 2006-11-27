<%--
  -- Filename:	 MSGErrorPage.jsp
  -- Author:     Shilpa Arora
  -- Create Date:24th April 2002 
  --%>
<%@ page import="java.io.*" isErrorPage="true" %>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>

<%
String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
int cat=0;
try{
	cat= Integer.parseInt((String)request.getAttribute("cat"));
}catch(Exception nfe){cat=1;}
%>

<% 
String filename=(String)request.getAttribute("jspname");
if(filename==null)filename="Not Set";
%>
<jsp:useBean id="SISExp" scope="application" class="com.cl.sis.exception.SISException"/>
<jsp:setProperty name="SISExp" property="fileName" value="<%=filename%>"/>
<jsp:setProperty name="SISExp" property="errorFileName" value="<%=logFile %>"/>

<html>
<head>
<title>Error Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="/styles/style.css" type="text/css">
<!-- Add top.js for top band -->
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script language="javascript" src="/jscript/top.js"></script>
<table border="0" width="100%" cellspacing="0" cellpadding="0">
	<tr valign="top"><td bgcolor="DFE1BC" width="21%" valign="top">&nbsp;
	</td>
<td width="79%" valign="top">
<table width="100%" border="0" cellspacing="3" cellpadding="0" align="left">
<tr>
<td bgcolor="B4BC6D">
<table border="0" cellspacing="0" cellpadding="0">
<tr> 
          <td bgcolor="B4BC6D" height="32" width="10"><img src="/msg/img/blank.gif" width="1" height="28"></td>
          <td><font class="cntblu"><a href="/" class="lnkblu">Home</a><font class="cntblu"> &gt; </font><%=cat==1?"<a href=\"/clzone/login/CLZone.jsp\" class=\"lnkblu\">CL Zone Home</a>":"<a href=\"/sis/SIS.jsp\" class=\"lnkblu\">SIS page</a>"%> &gt; Error Page</font></td>
</tr>
</table>
</td>
</tr>
</table>
<br>
<br>
<table width="79%" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr> 
    <td width="1" rowspan="3"></td>
    <td rowspan="3" width="10"><img src="/msg/img/blank.gif" width="1"></td>
    <td align="left" height="5"></td>
    <td rowspan="4" valign="top">&nbsp;</td>
  </tr>
  <br>
  <tr> 
    <td align="left"><font class="cnt" >
			There seems to be some problem in the system which is not allowing your 
			request to be served. Please try again after 15 minutes, if the problem 
			persists you could mail us at <B><A href="mailto:administrator@careerlauncher.com">administrator@careerlauncher.com</A></B></td>
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
    </td>
  </tr>
</table>
</body>
</html>