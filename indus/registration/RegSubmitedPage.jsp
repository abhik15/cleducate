<!-- 
	 Author: Kamal Singh Deori
     Filename: RegSubmitedPage.jsp
     Date: 21 Nov 05
	 Desc: For Use of Ananda Admission Registration & Order Brochure
-->
<%@ page language="java" import ="javax.servlet.http.HttpSession"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="expires" content="0">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">
<title>Ananda Admission Submit</title>
<link rel="stylesheet" href="../styles/ananda.css" type="text/css">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<center>
  <table width="780" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td valign="top" align="center"><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="780" height="124">
          <param name=movie value="../swf/admission_topband.swf">
          <param name=quality value=high>
          <embed src="../swf/admission_topband.swf" quality=high pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="780" height="124">
          </embed> 
        </object></td>
    </tr>
  </table>
  <center>
    <table width="780" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td align="left" valign="top" bgcolor="#33CCCC"><img src="../img/1x1.gif" width="1" height="1" /></td>
        <td align="left" valign="top"><table width="778" border="0" cellspacing="0" cellpadding="0">
            <tr valign="top" align="left">
              <td width="14%">&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td align="left" valign="top">&nbsp;</td>
              <td valign="top" align="left" background="../img/parents_bg.gif"><img src="../img/admission.gif" hspace="8" align="absmiddle" /></td>
            </tr>
        </table></td>
        <td align="left" valign="top" bgcolor="#33CCCC"><img src="../img/1x1.gif" width="1" height="1" /></td>
      </tr>
      <tr>
        <td align="left" valign="top" bgcolor="#33CCCC"></td>
        <td><table width="778" border="0" cellspacing="0" cellpadding="0" background="../img/admission_bg.gif">
            <tr>
              <td valign="top" align="left" width="14%"><table border="0" cellspacing="3" cellpadding="0" width="100%">
                <tr valign="top" align="left">
                  <td></td>
                </tr>
                <tr valign="top" align="left">
                  <td align="right"><img src="../img/1x1.gif" width="1" height="20" /></td>
                </tr>
                <tr valign="top" align="left">
                  <td align="right">&nbsp;</td>
                </tr>
                <tr valign="top" align="left">
                  <td align="center"></td>
                </tr>
              </table></td>
              <td valign="top" align="left"><table width="95%" border="0" cellspacing="0" cellpadding="15">
                <tr>
                  <td valign="top" align="left"><font class="runningtext"><strong>Dear Parents,</strong>                      <br />
<table width="100%" border="0" cellspacing="3" cellpadding="0" align="left" class="runningtext">
  
  <tr> 
    <td>
	<center>
			<%
				String registrationId = (String)session.getAttribute("regId");
				if(registrationId == null)
				{
					out.println("There are some Problem, Please <a href=SchoolAdmission.html>Registration</a> again");
				}
				else
				{
					//int price = 300;
					int price = 1;
			%>
	 			<FORM METHOD=POST ACTION="OrderBrochure.jsp" name="form">
				<input type="hidden" name=registrationId value=<%=registrationId%>>
				<input type="hidden" name=price value=<%=price%>>
				Thank you for submitting your information. Your Registration Id is <%=registrationId%><br>We will be informing you soon regarding the next steps in the admission process.<br>
				<IMG SRC="/img/smiley.gif" WIDTH="95" HEIGHT="95" BORDER="0" ALT=""> <br><br>
				Price : <%=price%> Rs.<br><INPUT TYPE="submit" name=submit value=" Order Brochure " CLASS=inpBrd>
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