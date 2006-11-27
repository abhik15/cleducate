<%
	String qsiRespCodeDesc = java.net.URLDecoder.decode(request.getParameter("qsiRespCodeDesc"));
	String enrollId = request.getParameter("eid");
%>
<HTML>
<HEAD>
<title>Ananda Admission Submit</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="/styles/ananda.css" type="text/css">
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
                  <td valign="top" align="left"><font class="runningtext">

<table width="77%" border="0" cellpadding="0" cellspacing="0" align="center">
  
  <%
	if(session.getAttribute("user") != null)
	{
%>
  <tr> 
    <td>&nbsp;</td>
    <td> 
      <table width="95%" border="0" cellpadding="0" cellspacing="0">
        <tr height="20"> 
          <td valign="top" width="70%"><a href="http://www.anandaschool.com/registration/SchoolAdmission.jsp"><b><u>Go 
            Back To Your Member Page</u></b></a>
          <td> 
          <td valign="top" align="right">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
  <%
	}
%> 
  <tr> 
    <td height="7" colspan="2"><img src="../img/blank.gif"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr valign="top"> 
                
            <td height="95" colspan="2" class="runningtext"> 
              <table width="88%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td></td>
                </tr>
                <tr> 
                  <td align="left" valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr valign="top"> 
                        <td height="95" colspan="2" class="runningtext"> 
                          <table width="88%" border="0" cellspacing="0" cellpadding="10">
                            <tr> 
                              <td  width="70%" class="runningtext"> 
                                <p><b><%=qsiRespCodeDesc%></b><br>
                              </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                    </table>
                    <br><font class="runningtext">Unfortunately, your transaction was not successful.<br>
                  For more information you can contact Giten at <A HREF="mailto:customersupport@anandaschool.com">customersupport@anandaschool.com</A> 
                  or call him at 91-11-5161 5343. Please mention your enrollment 
                  id: <font color="red"><b><%=enrollId%></b></font> in the mail 
                  for faster processing.</font><br>
                  <br>
					<font class="runningtext"><b>We have saved your details in our database. You can come back any time and do the transaction again. <br><br>
					HOW TO DO PENDING TRANSACTIONS<br>
					Click on "Enroll Now" from the home page, and login with your username and password, which you chose while registering, Follow the instructions on the screen.</b></font>
					</td>
                </tr>
                <tr> 
                  <td align="left" valign="top">&nbsp;</td>
                </tr>
<!-- 12/2/2005 by kamal deori				<tr><td class="runningtext">
				<cbox_taglib:cbSendMailTag 	title="Transaction Failed <font class=smallblktext>(Please mention your enrollment id in the message.)</font>" toMailId="customersupport@anandaschool.com" responseMsg="Your message has been sent." location="window" mailSubject="CC Transaction Failed" mimeType="text/plain"/>
				Customer Support Team,<br>
                  www.anandaschool.com</td>
              </tr>
 -->              </table>
            </td>
                    </tr>
					</table>
                </td>
  </tr>
  <tr> 
    <td><img src="../img/blank.gif"></td>
    <td>&nbsp;</td>
  </tr>
  </table>
</body>
</html>

