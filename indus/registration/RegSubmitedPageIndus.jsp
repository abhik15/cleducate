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
<link rel="stylesheet" href="/styles/indus.css" type="text/css">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<center>
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="1" align="left" valign="top" bgcolor="#E0E0E0"><img src="/ananda/img/1x1.gif" width="1" height="1" /></td>
    <td align="left" valign="top"><img src="/img/learner.gif" width="175" height="152" border="0" usemap="#Map2" /></td>
    <td width="602" align="left" valign="top"><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="602" height="152">
      <param name="movie" value="/swf/learner.swf">
      <param name="quality" value="high">
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
<map name="Map2" id="Map2">
  <area shape="rect" coords="4,92,165,148" href="/index.html" />
  <area shape="rect" coords="7,6,63,24" href= "javascript:NewWindow=window.open('/location/1/contact.html','newWin','width=350,height=225,left=0,top=0, toolbar=No,location=No,scrollbars=No,status=No,resizable=No,fullscreen=No');NewWindow.focus(); void(0);" />
  <area shape="rect" coords="77,5,135,25" href="/common/aboutus.html" />
</map>
<map name="MapMap" id="MapMap">
  <area shape="rect" coords="13,3,46,32" href="/index.html" />
</map>
<table width="778" border="0" cellspacing="0" cellpadding="0" align="center" class="runningtext">
    <tr>
      <td width="1" bgcolor="#999999"></td>
      <td colspan="3">&nbsp;</td>
      <td width="1" bgcolor="#999999"></td>
    </tr>
    <tr>
      <td bgcolor="#999999"></td>
      <td width="17%">&nbsp;</td>
      <td><strong>Dear Parents,</strong></td>
      <td>&nbsp;</td>
      <td bgcolor="#999999"></td>
    </tr>
    <tr>
      <td bgcolor="#999999"></td>
      <td colspan="3"><center>
          <br>
          <IMG SRC="/img/smiley.gif" WIDTH="95" HEIGHT="95" BORDER="0" ALT=""> <br>
          <br>
          <BR>
          <b>Thank you for registering at Indus. Our office will shortly be in touch with you. </b><br>
          <br>
          <BR>
          <A HREF="javascript:window.history.back()">Back</A>
		  <br><br>
      </center></td>
      <td bgcolor="#999999"></td>
    </tr>
    <tr>
      <td></td>
      <td height="1" colspan="3" bgcolor="#999999"></td>
      <td></td>
    </tr>
</table>
  <tr><td><tr><td valign="top" align="left"><tr>
    <td valign="top" align="left">
    
</body>
</html>