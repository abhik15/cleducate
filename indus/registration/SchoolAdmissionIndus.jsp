<!-- 
	 Author: Kamal Singh Deori
     Filename: SchoolAdmissionIndus.html
     Date: 25 Nov 05
	 Desc: For Use of Indus Admission Registration
-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta name="" content="">
<title>Indus - Admission</title>
<link rel="stylesheet" href="/styles/ananda.css" type="text/css">
<script LANGUAGE="JavaScript" src="/jscript/cl_functions.js"></script>
<SCRIPT LANGUAGE="JavaScript" SRC="/jscript/calendar.js"></SCRIPT>
<script language="JavaScript"> 
<!-- 
function validFunc()
{
	if(ChkBlank("form1.fname","Please enter First name.") == false) return false;
	if(ChkBlank("form1.lname","Please enter Last name.") == false) return false;
	if(ChkBlank("form1.address1","Please enter Address1.") == false) return false;

	if(document.form1.std.value.length > 0 || document.form1.telephone.value.length > 0)
	{
		if(ChkBlank("form1.std","Please enter Std Code.") == false) return false;
		if(ChkNumber("form1.std","Please enter valid Std Code.") == false) return false;
		if(ChkDotInMobile("form1.std","Please enter valid Std Code","5") == false) return false;
		if(ChkMinLength("form1.std","Please enter valid STD code","3") == false) return false;
		if(ChkBlank("form1.telephone","Please enter telephone number.") == false) return false;
		if(ChkNumber("form1.telephone","Please enter valid telephone number.") == false) return false;
		if(ChkMinLength("form1.telephone","Please enter valid telephone number","5") == false) return false;
		if(ChkDotInMobile("form1.telephone","Please enter valid telephone number.","8") == false) return false;
	}

	if(ChkBlank("form1.city","Please enter City.") == false) return false;
	if(ChkBlank("form1.state","Please enter State.") == false) return false;
	if(ChkBlank("form1.zipcode","Please enter Zip code.") == false) return false;
	if(ChkNumber("form1.zipcode","Please enter valid Zip code.") == false) return false;
	if(ChkDotInMobile("form1.zipcode","Please enter valid Zip code","6") == false) return false;
	if(ChkMinLength("form1.zipcode","Please enter valid Zip code","6") == false) return false;

	if(ChkBlank("form1.mname","Please enter Mother name.") == false) return false;
	if(ChkNumber("form1.mannualincome","Please enter valid Mother's Annual income.") == false) return false;
	if(document.form1.mmobile.value.length > 0)
	{
		if(ChkNumber("form1.mmobile","Please enter valid Mother's mobile.") == false) return false;
		if(ChkMinLength("form1.mmobile","Please enter valid Mother's Mobile number should have exact 10 digits.","10") == false) return false;
		if(ChkStartWithNumber("form1.mmobile","All mobile number should start with 9.\nDo not prefix 0 or +91 with mobile number.\neg. of valid mob no: 9801010101",9) == false) return false;
		if(ChkDotInMobile("form1.mmobile","Please enter valid Mother's mobile.","10") == false) return false;
	}
	if(document.form1.memail.value.length > 0)
	{
		if(ChkEmail("form1.memail","Please Enter valid Mother's email address") == false) return false;  
	}
	if(ChkBlank("form1.ffname","Please enter Father name.") == false) return false;
	if(ChkNumber("form1.fannualincome","Please enter valid Father's Annual income.") == false) return false;
	if(document.form1.mmobile.value.length > 0)
	{
		if(ChkNumber("form1.fmobile","Please enter valid Father's mobile.") == false) return false;
		if(ChkMinLength("form1.fmobile","Please enter valid Father's Mobile number should have exact 10 digits.","10") == false) return false;
		if(ChkStartWithNumber("form1.fmobile","All mobile number should start with 9.\nDo not prefix 0 or +91 with mobile number.\neg. of valid mob no: 9801010101",9) == false) return false;
		if(ChkDotInMobile("form1.fmobile","Please enter valid Father's mobile.","10") == false) return false;
	}
	if(document.form1.femail.value.length > 0)
	{
		if(ChkEmail("form1.femail","Please Enter valid Father's email address") == false) return false;  
	}
}
//-->
</script>
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
                      Admissions are currently open for Classes 3 to Class 6.
Please refer to the table below for the age wise eligibility.
You may download, print and fill the registration form. Or you may register online.<br />
<br />
<strong>AGE CRITERIA (AS ON 01/07/2006)</strong><br />
                  <br />
                  </font>
                    <table width="93%" border="1" cellspacing="0" cellpadding="3"  bordercolordark="#FFFFFF" bordercolorlight="#BBBBBB">
                      <tr bordercolorlight="#bbbbbb" bordercolordark="#ffffff">
                        <td><font class="runningtext">CLASS 1</font></td>
                        <td><font class="runningtext">Born in Year 2000</font></td>
                        <td><font class="runningtext">Age between 5<sup>1/2</sup> to 6<sup>1/2</sup> years</font></td>
                      </tr>
                      <tr bordercolorlight="#bbbbbb" bordercolordark="#ffffff">
                        <td><font class="runningtext">CLASS 2 </font></td>
                        <td><font class="runningtext">Born in Year 1999</font></td>
                        <td><font class="runningtext">Age between 6<sup>1/2</sup> to 7<sup>1/2</sup> years</font></td>
                      </tr>
                      
                      
                      <tr>
                        <td valign="top"><font class="runningtext">CLASS 3</font></td>
                        <td valign="top"><font class="runningtext">Born in Year 1998</font></td>
                        <td valign="top"><font class="runningtext">Age between 7<sup>1/2</sup>to 8<sup>1/2</sup> years</font></td>
                      </tr>
                      <tr>
                        <td><font class="runningtext">CLASS 4</font></td>
                        <td><font class="runningtext">Born in Year 1997</font></td>
                        <td><font class="runningtext">Age between 8<sup>1/2</sup> to 9<sup>1/2</sup>  years</font></td>
                      </tr>
                      <tr>
                        <td><font class="runningtext">CLASS 5</font></td>
                        <td><font class="runningtext">Born in Year 1996</font></td>
                        <td><font class="runningtext">Age between 9<sup>1/2</sup> to 10<sup>1/2</sup> years</font></td>
                      </tr>
                      <tr>
                        <td><font class="runningtext">CLASS 6</font></td>
                        <td><font class="runningtext">Born in Year 1995</font></td>
                        <td><font class="runningtext">Age between 10<sup>1/2</sup> to 11<sup>1/2</sup> years</font></td>
                      </tr>
                    </table>
                    <br />
<%
					String schoolId = request.getParameter("schoolId");
%>                    
					<br>
					<FORM METHOD=POST ACTION="InsertAdmissionIndus.jsp" name="form1">
					<input type=hidden name=schoolId value=<%=schoolId%>>
<table WIDTH="80%" cellspacing="0" cellpadding="3" border="1" bordercolorlight="#999999" bordercolordark="#ffffff" class="runningtext">
<tr><td colspan=2 class="runningtext">
<b>DETAILS OF THE CHILD</b>
</td></tr>
<TR><TD class="runningtext">
Class applied for :
</TD>
<TD>&nbsp;<select name=classapplied CLASS=boxborder>
<option>CLASS 1</option>
<option>CLASS 2</option>
<option>CLASS 3</option>
<option>CLASS 4</option>
<option>CLASS 5</option>
<option>CLASS 6</option>
</select>
</TD>
</TR>
<TR><TD>
Child's name :
</TD>
<TD>&nbsp;<INPUT TYPE="text" NAME="fname" maxlength="20" size="15" CLASS=boxborder> <INPUT TYPE="text" NAME="lname" maxlength="20" size="15" CLASS=boxborder>
	<FONT class="new" color=red>*</FONT>
</TD>
</TR>
<TR><TD>
Date of Birth :
</TD>
<TD>&nbsp;<select name=cdate CLASS=boxborder>
<script language="JavaScript"> 
<!-- 
for(var i=1; i<=31; i++)
{
	document.write("<option>"+i+"</option>");
}
//-->
</script>
</select>
<select name=cmonth CLASS=boxborder>
<script language="JavaScript"> 
<!-- 
for(var i=1; i<=12; i++)
{
	document.write("<option>"+i+"</option>");
}
//-->
</script>
</select>
<select name=cyear CLASS=boxborder>
<script language="JavaScript"> 
<!-- 
for(var i=1994; i<=1999; i++)
{
	if(i==1997)
		document.write("<option selected>"+i+"</option>");
	else			
		document.write("<option>"+i+"</option>");
}
//-->
</script>
</select>
	<FONT class="new" color=red>*</FONT>
</TD>
</TR>
<TR><TD>Sex :</TD>
<TD>&nbsp;Male <INPUT TYPE="radio" NAME="sex" value="M" checked>&nbsp;&nbsp;&nbsp;&nbsp;
Female <INPUT TYPE="radio" NAME="sex" value="F"></TD>
</TR>
<TR><TD>Address :</TD>
<TD>&nbsp;Line1 <INPUT TYPE="text" NAME="address1" maxlength="40" size="40" CLASS=boxborder>
	<FONT class="new" color=red>*</FONT>
<br>&nbsp;Line2 <INPUT TYPE="text" NAME="address2" maxlength="40" size="40" CLASS=boxborder></TD>
</TR>
<TR><TD>Telephone :</TD>
<TD>&nbsp;STD:&nbsp;&nbsp;<INPUT TYPE="text" NAME="std" maxlength="5" size="6" CLASS=boxborder> No:&nbsp;&nbsp;<INPUT TYPE="text" NAME="telephone" maxlength="8" size="12" CLASS=boxborder>
</TD>
</TR>
<TR><TD>City :</TD>
<TD>&nbsp;<INPUT TYPE="text" NAME="city" maxlength="20" size="12" CLASS=boxborder>
	<FONT class="new" color=red>*</FONT>
</TD>
</TR>
<TR><TD>State :</TD>
<TD>&nbsp;<INPUT TYPE="text" NAME="state" maxlength="20" size="12" CLASS=boxborder>
	<FONT class="new" color=red>*</FONT>
</TD>
</TR>
<TR><TD>Postal/Zip Code :</TD>
<TD>&nbsp;<INPUT TYPE="text" NAME="zipcode" maxlength="6" size="12" CLASS=boxborder>
	<FONT class="new" color=red>*</FONT>
</TD>
</TR>
</table>
<br>
<table border=0 width=90%>
<tr valign="top"><td width=50%>
<table WIDTH="100%" cellspacing="0" cellpadding="3" border="1" bordercolorlight="#999999" bordercolordark="#ffffff" class="runningtext">
<tr><td colspan=2 align="center">
<B>Mother's particulars</B>
</td></tr>
<TR><TD width=40%>
Mother's name :
</TD>
<TD width=60%>&nbsp;<INPUT TYPE="text" NAME="mname" maxlength="20" size="12" CLASS=boxborder>
	<FONT class="new" color=red>*</FONT>
</TD>
</TR>
<TR><TD width=40%>
Date of Birth :
</TD>
<TD width=60%>&nbsp;<select name=mdate CLASS=boxborder>
<script language="JavaScript"> 
<!-- 
for(var i=1; i<=31; i++)
{
	document.write("<option>"+i+"</option>");
}
//-->
</script>
</select>
<select name=mmonth CLASS=boxborder>
<script language="JavaScript"> 
<!-- 
for(var i=1; i<=12; i++)
{
	document.write("<option>"+i+"</option>");
}
//-->
</script>
</select>
<select name=myear CLASS=boxborder>
<script language="JavaScript"> 
<!-- 
for(var i=1930; i<=1990; i++)
{
	if(i==1970)
		document.write("<option selected>"+i+"</option>");
	else			
		document.write("<option>"+i+"</option>");
}
//-->
</script>
</select>
</TD>
</TR>
<TR><TD width=40%>
Qualifications :
</TD>
<TD width=60%>&nbsp;<INPUT TYPE="text" NAME="mqualification" maxlength="20" size="12" CLASS=boxborder></TD>
</TR>
<TR><TD width=40%>
Present occupation :
</TD>
<TD width=60%>&nbsp;<INPUT TYPE="text" NAME="mpresentoccupation" maxlength="30" size="20" CLASS=boxborder></TD>
</TR>
<TR><TD width=40%>Annual income :<BR><font class="new">(in lakhs)</TD>
<TD width=60%>&nbsp;<font class="new">Rs. <INPUT TYPE="text" NAME="mannualincome" maxlength="4" size="6" CLASS=boxborder> Numeric field</TD>
</TR>
<TR><TD width=40%>Organization name :</TD>
<TD width=60%>&nbsp;<INPUT TYPE="text" NAME="mofficename" maxlength="30" size="20" CLASS=boxborder></TD>
</TR>
<TR><TD width=40%>Mobile :</TD>
<TD width=60%>&nbsp;<INPUT TYPE="text" NAME="mmobile" maxlength="10" size="15" CLASS=boxborder>
</TD>
</TR>
<TR><TD width=40%>E-Mail :</TD>
<TD width=60%>&nbsp;<INPUT TYPE="text" NAME="memail" maxlength="30" size="20" CLASS=boxborder>
</TD>
</TR>
</table>
</td>
<td width=50%>
<table WIDTH="100%" cellspacing="0" cellpadding="3" border="1" bordercolorlight="#999999" bordercolordark="#ffffff" class="runningtext">
<tr><td colspan=2 align="center">
<B>Father's particulars</B>
</td></tr>
<TR><TD width=40%>
Father's name :
</TD>
<TD width=60%>&nbsp;<INPUT TYPE="text" NAME="ffname" maxlength="20" size="12" CLASS=boxborder>
	<FONT class="new" color=red>*</FONT>
</TD>
</TR>
<TR><TD width=40%>
Date of Birth :
</TD>
<TD width=60%>&nbsp;<select name=fdate CLASS=boxborder>
<script language="JavaScript"> 
<!-- 
for(var i=1; i<=31; i++)
{
	document.write("<option>"+i+"</option>");
}
//-->
</script>
</select>
<select name=fmonth CLASS=boxborder>
<script language="JavaScript"> 
<!-- 
for(var i=1; i<=12; i++)
{
	document.write("<option>"+i+"</option>");
}
//-->
</script>
</select>
<select name=fyear CLASS=boxborder>
<script language="JavaScript"> 
<!-- 
for(var i=1930; i<=1990; i++)
{
	if(i==1970)
		document.write("<option selected>"+i+"</option>");
	else			
		document.write("<option>"+i+"</option>");
}
//-->
</script>
</select>
</TD>
</TR>
<TR><TD width=40%>
Qualifications :
</TD>
<TD width=60%>&nbsp;<INPUT TYPE="text" NAME="fqualification" maxlength="20" size="12" CLASS=boxborder></TD>
</TR>
<TR><TD width=40%>
Present occupation :
</TD>
<TD width=60%>&nbsp;<INPUT TYPE="text" NAME="fpresentoccupation" maxlength="30" size="20" CLASS=boxborder></TD>
</TR>
<TR><TD width=40%>Annual income :<BR><font class="new">(in lakhs)</TD>
<TD width=60%>&nbsp;<font class="new">Rs. <INPUT TYPE="text" NAME="fannualincome" maxlength="4" size="6" CLASS=boxborder> Numeric field</TD>
</TR>
<TR><TD width=40%>Organization name :</TD>
<TD width=60%>&nbsp;<INPUT TYPE="text" NAME="fofficename" maxlength="30" size="20" CLASS=boxborder></TD>
</TR>
<TR><TD width=40%>Mobile :</TD>
<TD width=60%>&nbsp;<INPUT TYPE="text" NAME="fmobile" maxlength="10" size="15" CLASS=boxborder>
</TD>
</TR>
<TR><TD width=40%>E-Mail :</TD>
<TD width=60%>&nbsp;<INPUT TYPE="text" NAME="femail" maxlength="30" size="20" CLASS=boxborder>
</TD>
</TR>
</table>
</td>
</tr>
</table>
<br>
<table WIDTH="80%" cellspacing="0" cellpadding="3" border="1" bordercolorlight="#999999" bordercolordark="#ffffff" class="runningtext">
<tr class="runningtext"><td>
We live in a :
</td>
<td>&nbsp;<select name=live CLASS=boxborder>
<option>Joint or extended Family</option>
<option>Nuclear Family</option>
<option>Single parent</option>
</select>
</td>
</tr>
<tr class="runningtext"><td>No. of siblings of the child :</td>
<td>&nbsp;<select name=noofsiblings CLASS=boxborder>
<option>0</option>
<option>1</option>
<option>2</option>
<option>3</option>
<option>4</option>
</select>
</td></tr>
</table>
</center>
<CENTER><br><INPUT TYPE="submit" name=submit value=" Submit " onClick="return validFunc()" CLASS=inpBrd></CENTER></form>
<BR>
                    <font class="new">(*) all fields are Mandatory</font><br>
					
                </tr>
              </table></td>
            </tr>
            <tr>
              <td valign="top" align="left"></td>
              <td valign="top" align="left">&nbsp;</td>
            </tr>
        </table></td>
        <td align="left" valign="top" bgcolor="#33CCCC"></td>
      </tr>
    </table>
    <table width="780" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td align="left" valign="top"><img src="../img/admission_bottom.gif" /></td>
      </tr>
    </table>
  </center>
  <map name="Map" id="Map">
    <area shape="rect" coords="1,0,107,31" href="parents.html" target="_self" />
  </map>
</center>
</body>
</html>
