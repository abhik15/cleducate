<!-- 
	 Author: Kamal Singh Deori
     Filename: RegSubmitedPageIndus.jsp
     Date: 25 Nov 05
	 Desc: For Use of Indus Admission Registration & Order Brochure
-->
<%@ page language="java" import ="javax.servlet.http.HttpSession"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="expires" content="0">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">
<title>Indus Admission Submit</title>
<link href="/styles/indus.css" rel="stylesheet" type="text/css" />
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td ></td>
    <td height="3" ></td>
  </tr>
  <tr valign="top">
    <td width="1" align="left" bgcolor="#999999"><img src="../img/1x1.gif" width="1" height="1" /></td>
    <td height="25" align="left" bgcolor="#86CF18"><img src="../img/admission_nav.gif" width="780" height="25" border="0" usemap="#Map" /></td>
    <td bgcolor="#999999" align="left"><img src="../img/1x1.gif" width="1" height="1" /></td>
  </tr>
  <tr valign="top">
    <td width="1" align="left" bgcolor="#999999"></td>
    <td align="left">&nbsp;</td>
    <td width="1" bgcolor="#999999" align="left"></td>
  </tr>
  <tr valign="top">
    <td width="1" align="left" bgcolor="#999999"></td>
    <td align="left"><table width="95%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="12%" valign="top">&nbsp;</td>  
          <td valign="top" align="left" width="88%"><font class="runningtext"> <strong>Dear Parents,</strong>                      <br />
<table width="100%" border="0" cellspacing="3" cellpadding="0" align="left" class="runningtext">
  
  <tr> 
    <td>
	<center>
			<%
				String registrationId = (String)session.getAttribute("regId");
				if(registrationId == null)
				{
					out.println("There are some Problem, Please <a href=SchoolAdmissionIndus.html>Registration</a> again");
				}
				else
				{
			%>
	 			<FORM METHOD=POST ACTION="UpdBrochure.jsp" name="form">
				<input type="hidden" name=registrationId value=<%=registrationId%>>
				Thank you for submitting your information. Your Registration Id is <%=registrationId%><br>We will be informing you soon regarding the next steps in the admission process.<br><BR>
				<IMG SRC="/img/smiley.gif" WIDTH="95" HEIGHT="95" BORDER="0" ALT=""><br><br>
				Price : 300 Rs.<br><INPUT TYPE="submit" name=submit value=" Order Brochure " CLASS=inpBrd>
				</form>
				<BR><BR> 
				<A HREF="/">Back</A>
			<%
				}
			%>
		</center>
 </td>
 </tr>
</table>
</body>
</html>