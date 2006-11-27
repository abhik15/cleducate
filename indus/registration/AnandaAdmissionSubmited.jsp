<!-- 
	 Author: Kamal Singh Deori
     Filename: AnandaAdmission.html
     Date: 21 Nov 05
	 Desc: For Use of Ananda Admission Registration
-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="expires" content="0">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">
<title>Ananda Admission Submit</title>
<link rel="stylesheet" href="../styles/ananda.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<table width="100%" border="0" cellspacing="3" cellpadding="0" align="left" class="runningtext">
  <tr><td align=center><b><u>REGISTRATION FORM</u></b><br><br></td></tr>
  <tr> 
    <td>
	<center>
			<%
				String registrationId = request.getParameter("registrationId");
			%>
			Your data successfully submited & your Registration Id is <%=registrationId%><br><br>
			<IMG SRC="../img/smiley.gif" WIDTH="95" HEIGHT="95" BORDER="0" ALT=""><BR><BR>
			<A HREF="anandaAdmission.html">Back</A>
		</center>
 </td>
 </tr>
</table>
</body>
</html>