<%@ page import="org.apache.log4j.*" errorPage="/epage/anandaError.jsp"%>


<% 
	String message=request.getParameter("message");
	if(message==null)message="";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Indus - Indore</title>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}

.admission {
	font-family: "Arial";
	font-size:11.7pt;
	color:#2C5665;
	font-weight: bold;
}

.sub_admission {
	font-family: "Arial";
	font-size:11.7pt;
	color:#5E93A4;
	font-weight: bold;
}

.careers {	font-family: "Arial";
	font-size:11.7pt;
	color:#4A6208;
	font-weight: bold;
}

.events {
	font-family: "Arial";
	font-size: 11.7pt;
	color:#6D1D1D;
	font-weight: bold;
}


-->

</style>
<link href="/styles/indus.css" rel="stylesheet" type="text/css" /> 
<style type="text/css">
<!--
.style2 {font-family: "Arial";
	font-size: 11.7pt;
	color:#D99C29;
	font-weight: bold;
	line-height:30px;
}
.admission1 {font-family: "Arial";
	font-size:11.7pt;
	color:#48B6FF;
	font-weight: bold;
}
-->
</style>
<script LANGUAGE="JavaScript" src="/jscript/cl_functions.js"></script>
<SCRIPT LANGUAGE="JavaScript" SRC="/jscript/calendar.js"></SCRIPT>
<Script Language="JavaScript">
function chkSelect()
{
	if (ChkBlank("form1.uname","Please enter Username.") == false) return false;
	if (ChkBlank("form1.pwd","Please enter your password.") == false) return false;
	
	else
	return true;
}
</SCRIPT>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="1" align="left" valign="top" bgcolor="#E0E0E0"><img src="/ananda/img/1x1.gif" width="1" height="1" /></td>
    <td align="left" valign="top"><img src="/img/learner.gif" width="175" height="152" border="0" usemap="#Map2" /></td>
    <td width="602" align="left" valign="top"><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="602" height="152">
      <param name="movie" value="/swf/learner.swf" />
      <param name="quality" value="high" />
      <embed src="/swf/learner.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="602" height="152"></embed>
    </object></td>
  </tr>
</table>
<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="1" align="left" valign="top" bgcolor="#E0E0E0"><img src="/img/green_dot.gif" width="1" height="1" /></td>
    <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td align="left" valign="middle" bgcolor="#0090EC"><img src="/ananda/img/1x1.gif" width="174" height="1" /></td>
        <td align="left" valign="top"></td>
        <td align="left" valign="top" bgcolor="#68169C"><img src="/ananda/img/1x1.gif" width="174" height="1" /></td>
        <td align="left" valign="top"></td>
        <td align="left" valign="top" bgcolor="#DF6400"><img src="/ananda/img/1x1.gif" width="174" height="1" /></td>
        <td align="left" valign="top"></td>
        <td align="left" valign="top" bgcolor="#9C163B"><img src="/ananda/img/1x1.gif" width="174" height="1" /></td>
        <td align="left" valign="top"></td>
        <td align="left" valign="top" bgcolor="#363A90"></td>
      </tr>
      <tr>
        <td width="174" height="40" align="left" valign="middle" bgcolor="#0090EC"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="10" height="5" align="left" valign="top"></td>
            <td ></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td align="left" valign="top"><font class="global_nav"><a href="/common/learner/learner.html" class="global_nav">Me - The Learner</a></font></td>
          </tr>
          <tr>
            <td height="5" align="left" valign="top"></td>
            <td></td>
          </tr>
        </table></td>
        <td width="1" align="left" valign="top"><img src="/img/1x1.gif" width="1" height="1" /></td>
        <td width="174" align="left" valign="middle" bgcolor="#68169C"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="10" height="5" align="left" valign="top"></td>
            <td ></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td align="left" valign="top"><font class="global_nav"><a href="/common/curriculum/curriculum.html" class="global_nav">Curriculum</a></font></td>
          </tr>
          <tr>
            <td height="5" align="left" valign="top"></td>
            <td></td>
          </tr>
        </table></td>
        <td width="1" align="left" valign="top"><img src="/img/1x1.gif" width="1" height="1" /></td>
        <td width="174" align="left" valign="middle" bgcolor="#DF6400"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="10" height="5" align="left" valign="top"></td>
            <td ></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td align="left" valign="top"><font class="global_nav"><a href="/common/parents/parents.html" class="global_nav">Parents</a></font></td>
          </tr>
          <tr>
            <td height="5" align="left" valign="top"></td>
            <td></td>
          </tr>
        </table></td>
        <td width="1" align="left" valign="top"><img src="/img/1x1.gif" width="1" height="1" /></td>
        <td width="174" align="left" valign="middle" bgcolor="#9C163B"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="10" height="5" align="left" valign="top"></td>
            <td ></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td align="left" valign="top"><font class="global_nav"><a href="/common/mentor/mentor.html" class="global_nav">Mentor</a></font></td>
          </tr>
          <tr>
            <td height="5" align="left" valign="top"></td>
            <td></td>
          </tr>
        </table></td>
        <td width="1" align="left" valign="top"><img src="/img/1x1.gif" width="1" height="1" /></td>
        <td align="center" valign="middle" bgcolor="#363A90"><img src="/img/home_logo.gif" width="55" height="34" border="0" usemap="#MapMap"/></td>
      </tr>
    </table></td>
    <td width="1" align="left" valign="top" bgcolor="#E0E0E0"><img src="/img/green_dot.gif" width="1" height="1" /></td>
  </tr>
</table>
<map name="MapMap" id="MapMap">
  <area shape="rect" coords="13,3,46,32" href="/index.html" />
</map>
<map name="Map2" id="Map2">
  <area shape="rect" coords="4,92,165,148" href="/index.html" />
  <area shape="rect" coords="7,6,63,24" href= "javascript:NewWindow=window.open('/location/3/contact.html','newWin','width=350,height=225,left=0,top=0, toolbar=No,location=No,scrollbars=No,status=No,resizable=No,fullscreen=No');NewWindow.focus(); void(0);" />
  <area shape="rect" coords="78,4,136,24" href="/common/aboutus.html" />
</map>
<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="1" align="left" valign="top" bgcolor="#E0E0E0"><img src="/img/1x1.gif" width="1" height="1" /></td>
    <td width="159" align="left" valign="top">
	<table width="174" border="0" cellpadding="0" cellspacing="0" bgcolor="#0077C6">
      <tr>
        <td align="left" valign="top">&nbsp;</td>
        <td align="left" valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td width="10" align="left" valign="top">&nbsp;</td>
        <td align="left" valign="top"><span class="highlighttext"><strong>IWS Indore Home</strong> </span></td>
      </tr>
      <tr>
        <td height="5" align="left" valign="top"></td>
        <td align="left" valign="top"></td>
      </tr>
      <tr>
        <td align="left" valign="top">&nbsp;</td>
        <td align="left" valign="top"><font class="highlighttext"><a href= "javascript:NewWindow=window.open('/location/3/location_map.html','newWin','width=600,height=650,left=0,top=0, toolbar=No,location=No,scrollbars=No,status=No,resizable=No,fullscreen=No');NewWindow.focus(); void(0);" class="highlighttext" ><strong><u>Location Map</u></strong></a></font></td>
      </tr>
      <tr>
        <td height="5" align="left" valign="top"></td>
        <td align="left" valign="top"></td>
      </tr>
      <tr>
        <td align="left" valign="top">&nbsp;</td>
        <td align="left" valign="top"><font class="highlighttext"><a href="/brochure/indus_brochure.pdf" class="highlighttext"><strong>View Brochure</strong></a> </font></td>
      </tr>
      <tr>
        <td align="left" valign="top">&nbsp;</td>
        <td align="left" valign="top">&nbsp;</td>
      </tr>
    </table>
    <table width="174" border="" cellpadding="0" cellspacing="0">
        <tr>
          <td height="1" align="left" valign="top" bgcolor="#FFFFFF"></td>
        </tr>
        
        <tr>
          <td height="1" align="left" valign="top" bgcolor="#FFFFFF"></td>
        </tr>
      </table>
	<table width="174" border="0" cellpadding="0" cellspacing="0" bgcolor="#005995">
      <tr>
        <td align="left" valign="top">&nbsp;</td>
        <td align="left" valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td width="10" align="left" valign="top">&nbsp;</td>
        <td align="left" valign="top" class="admission1"><a href="/location/3/admission.html" class="admission1">Admission</a></td>
      </tr>
      <tr>
        <td height="3" align="left" valign="top"></td>
        <td height="3" align="left" valign="top" class="admission1"></td>
      </tr>
      <tr bgcolor="#CCD27D">
        <td align="left" valign="top" bgcolor="#005995">&nbsp;</td>
        <td align="left" valign="top" bgcolor="#005995"><font class="highlighttext">Admissions are currently open for Classes 1 to 4 </font></td>
      </tr>
      <tr bgcolor="#CCD27D">
        <td height="8" align="left" valign="top" bgcolor="#005995"></td>
        <td height="8" align="left" valign="top" bgcolor="#005995"></td>
      </tr>
      <tr bgcolor="#CCD27D">
        <td align="left" valign="top" bgcolor="#005995">&nbsp;</td>
        <td align="left" valign="top" bgcolor="#005995"><a href="/registration/SchoolAdmissionIndus_indore.jsp?schoolId=3" class="highlighttext"><font class="highlighttext"><strong>Register Online </strong></font></a></td>
      </tr>
      <tr bgcolor="#CCD27D">
        <td height="5" align="left" valign="top" bgcolor="#005995"></td>
        <td align="left" valign="top" bgcolor="#005995"></td>
      </tr>
      <tr bgcolor="#CCD27D">
        <td align="left" valign="top" bgcolor="#005995">&nbsp;</td>
        <td align="left" valign="top" bgcolor="#005995"><font class="highlighttext"><a href="/registration/indus_registration_form.pdf" class="highlighttext"><strong><u>Download Form</u></strong></a></font></td>
      </tr>
      <tr>
        <td align="left" valign="top">&nbsp;</td>
        <td align="left" valign="top">&nbsp;</td>
      </tr>
    </table>
    <table width="174" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td height="1" align="left" valign="top" bgcolor="#FFFFFF"></td>
        </tr>
        
        <tr>
          <td height="1" align="left" valign="top" bgcolor="#FFFFFF"></td>
        </tr>
      </table>
      <table width="174" border="0" cellpadding="0" cellspacing="0" bgcolor="#9ABD3A">
        <tr>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
        </tr>
        <tr>
          <td width="10" align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top"><span class="careers"><a href="/common/careers.html" class="careers">Careers</a></span></td>
        </tr>
        <tr>
          <td height="3" align="left" valign="top"></td>
          <td align="left" valign="top"></td>
        </tr>
        <tr>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top"><font class="highlighttext">If you possess the<br />
            generous joy of learning &hellip;come   meet with us</font></td>
        </tr>
        <tr>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
        </tr>
      </table>
	  <table width="174" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td height="1" align="left" valign="top" bgcolor="#FFFFFF"></td>
        </tr>
        
        <tr>
          <td height="1" align="left" valign="top" bgcolor="#FFFFFF"></td>
        </tr>
      </table>
      <table width="174" border="0" cellpadding="0" cellspacing="0" bgcolor="#E1AC0B">
        <tr>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
        </tr>
        <tr>
          <td width="10" align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top"><span class="events"><a href="/location/3/events.html" class="events">Events</a></span></td>
        </tr>
        <tr>
          <td height="3" align="left" valign="top"></td>
          <td align="left" valign="top"></td>
        </tr>
        <tr>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top"><font class="highlighttext">Join us in celebrating the Indus philosophy</font></td>
        </tr>
        <tr>
          <td height="8" align="left" valign="top"></td>
          <td align="left" valign="top"></td>
        </tr>
        <tr>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top"><a href="/location/3/news.html" class="highlighttext"><font class="highlighttext"><strong>Indus in the news</strong></font></a></td>
        </tr>
        <tr>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
        </tr>
      </table>
      <table width="175" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="9" align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td width="1" align="left" valign="top" bgcolor="#E0E0E0"><img src="/img/1x1.gif" width="1" height="1" /></td>
        </tr>
        <tr>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td width="1" align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td width="1" align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td width="1" align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td width="1" align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td width="1" align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr bgcolor="#FFFFFF">
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td width="1" align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr bgcolor="#FFFFFF">
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr bgcolor="#FFFFFF">
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr bgcolor="#FFFFFF">
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr bgcolor="#FFFFFF">
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr bgcolor="#FFFFFF">
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr bgcolor="#FFFFFF">
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr bgcolor="#FFFFFF">
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr bgcolor="#FFFFFF">
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr bgcolor="#FFFFFF">
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr bgcolor="#FFFFFF">
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr bgcolor="#FFFFFF">
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr bgcolor="#FFFFFF">
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr bgcolor="#FFFFFF">
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
        <tr bgcolor="#FFFFFF">
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" bgcolor="#E0E0E0"></td>
        </tr>
      </table></td>
    <td width="10" align="left" valign="top">&nbsp;</td>
    <td width="588" align="left" valign="top"><table width="96%" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td height="21" align="left" valign="top">&nbsp;</td>
      </tr>
      <tr>
        <td align="left" valign="top"><table border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td align="center" valign="top">
				
			</td>
          </tr>
        </table>
		<center>
			<font class="new"><b><%=message %></b></font>
		</center>
				<FORM name= "form1" METHOD="POST" ACTION="auth.jsp" onSubmit="return chkSelect()">
					<TABLE border="0" cellspacing="3" cellpadding="0" class="runningtext">
					<TR>
						<TD>User Name:</TD>
						<TD><INPUT TYPE="text" NAME="uname" class="inpBrd" maxlength="12"></TD>
					</TR>
					<TR>
						<TD>Password:</TD>
						<TD><INPUT TYPE="password" NAME="pwd" class="inpBrd" maxlength="12"></TD>
					</TR>
					<TR>
						<TD colspan="2" align="right"><INPUT TYPE="submit" class="inpBrd" value=" Login "></TD>
					</TR>
					</TABLE>
					</FORM>
		  </td>
            </tr>
			<tr>
				<td><a href="#" onclick="javascript: OpenWindow('/sis/register/forgotpassword.html','forgotpassword','450','400')" class="smallbluelink">
				Forgot your password?</a></td>
			</tr>
			<tr>
				<td><br><a href="/sis/register/SISlogincidanddob.html" class="smallbluelink">
				Need a Login/password?</a></td>
			</tr>
          </table></td>
      </tr>
    </table></td>
    <td width="1" align="left" valign="top" bgcolor="#E0E0E0"><img src="/img/1x1.gif" width="1" height="1" /></td>
  </tr>
  <tr>
    <td colspan="5" valign="top" bgcolor="#E0E0E0"><img src="/img/1x1.gif" width="1" height="1" /></td>
  </tr>
</table>
</body>
</html>
