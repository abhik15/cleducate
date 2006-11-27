<%@ page isErrorPage="true" import="java.io.*,java.util.*,org.apache.log4j.*"%>
<HTML>
<HEAD>
<title>Ananda : Error Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/styles/ananda.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="79%" border="0" cellspacing="3" cellpadding="0" align="left" class="runningtext">
<tr> 
<td> 
<table border="0" cellspacing="0" cellpadding="0" align="left" class="runningtext">
<tr> 
<td align="left" valign="middle"><a href="#" class="lnkblu">Home</a>
&gt; Error Page</td>
</tr>
</table>
</td>
</tr>
<tr> 
<td> 
<table border="0" cellspacing="0" cellpadding="0">
<tr> 
<td width="8">&nbsp;</td>
<td height="28" valign="bottom">Error Page &nbsp;&nbsp;&nbsp;<img src="/img/arrow.gif" align="absmiddle"></td>
</tr>
</table>
</td>
<td rowspan="2" width="21%" align="left" valign="top">
<script language="javascript" src="/jscript/bannar.js"></script>
</td>
</tr>
<tr> 
<td>
<font class="cnt">
There seems to be some problem in the system which is not allowing your 
request to be served. Please try again after 15 minutes, if the problem 
persists you could mail us at <B><A HREF="mailto:administrator@careerlauncher.com">administrator@careerlauncher.com</A></B>
<br></font><br><br>			
</td>
</tr>
</table>
<%
StringWriter sw = new StringWriter();
PrintWriter pw = new PrintWriter(sw);
exception.printStackTrace(pw);
StringBuffer errorString = new StringBuffer();
errorString.append(sw);
Category logCategory = Category.getInstance("school.epage");
logCategory.error(errorString.toString());
%>
</BODY>
</HTML>