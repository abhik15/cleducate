<html>
<head>
<title>Change password</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="/styles/style.css" type="text/css">

<SCRIPT LANGUAGE="JavaScript">

agree = 0;

function validatePwd()
{
	var invalid = " "; // Invalid character is a space
	var minLength = 4; // Minimum length
	var pw1 = document.form1.newpassword.value;
	var pw2 = document.form1.confirmnewpassword.value;
	// check for a value in both fields.
	if (pw1 == '' || pw2 == '')
	{
		alert('Please enter new password twice.');
		document.form1.confirmnewpassword.focus();

		return false;
		}
	
	// check for minimum length
	if (document.form1.newpassword.value.length < minLength)
	{
		alert('Your new password must be at least ' + minLength + ' characters long. Try again.');
		document.form1.confirmnewpassword.focus();
		return false;
	}

	// check for spaces
	if (document.form1.newpassword.value.indexOf(invalid) > -1)
	{
		alert("Sorry, spaces are not allowed.");
		document.form1.confirmnewpassword.focus();
		return false;
	}

	else
	{
		if (pw1 != pw2) {
		alert ("New Passwords do not match. Please re-enter your password.");
		document.form1.confirmnewpassword.focus();
		return false;
	}
}
}


function validate(form)
{
			
		if (form.login.value=="")
		{
			alert("Please Enter User Name")
			form.login.focus();
			return(false);
		}	
	
		if (form.oldpassword.value=="")
		{
			alert("Please Enter Old Password")
			form.oldpassword.focus();
			return(false);
		}
		return true;
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="21%" border="0" cellspacing="0" cellpadding="0" align="left">
  <tr bgcolor="#FFFFFF"> 
    <td height="3" colspan="2"><img src="/img/blank.gif" height="3"></td>
  </tr>
  <tr> 
    <td bgcolor="DFE1BC" colspan="2"><img src="/img/blank.gif" height="10"></td>
  </tr>
  
  <tr> 
    <td bgcolor="DFE1BC" width="17" align="left" valign="top">&nbsp;</td>
    <td bgcolor="DFE1BC" valign="top" align="left"><br>

	</td>
	</tr>
  <tr> 
    <td bgcolor="DFE1BC" width="17" align="left" valign="top">&nbsp;</td>
    <td bgcolor="DFE1BC" height="275" valign="top" align="left">&nbsp;</td>
  </tr>
</table>
<table width="79%" border="0" cellspacing="3" cellpadding="0" align="left">
  <tr> 
    <td colspan="2" bgcolor="B4BC6D"> 
      <table border="0" cellspacing="0" cellpadding="0" align="left">
        <tr> 
          <td bgcolor="B4BC6D"  width="8" align="left" valign="top" height="32"><img src="/img/blank.gif" width="1" height="32"></td>
          <td align="left" valign="middle"><font class="cntblu"><a href="/" class="lnkblu">Home</a>
		  <font class="cntblu">&gt;</font>Change password
          </a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td bgcolor="BACFE5"> 
      <table border="0" cellspacing="0" cellpadding="0">
        
        <tr> 
          <td width="8">&nbsp;</td>
          <td class="headblubld" height="34" valign="center">Change password&nbsp;&nbsp;&nbsp;></td>
        </tr>
        
      </table>
    </td>
    <td rowspan="2" width="21%" align="left" valign="top">
	
    </td>
  </tr>
  <tr> 
    <td height="23">
<form  method="POST" action="ChangePassword.jsp" name="form1" onSubmit="return validatePwd()">
	 <center>
		 <table border="0" width="100%" cellspacing="0" cellpadding="3">    
			<tr class="pcnt">
				<td align="right">User Name</td>
				<td> : </td>
				<td><input type="text" name="login" size="20" maxlength="12"></td>
			</tr>
			
			<tr class="pcnt">
				<td align="right">Old Password</td>
				<td> : </td>
      			<td><input type="password" name="oldpassword" size="20" maxlength="12"></td>
			</tr>
			<tr>
				<td align="right"><font  class="pcnt">New Password</font></td>
				<td> : </td>
				<td><input type="password" name="newpassword" size="20" maxlength="12"><br>
				<font class="new">(Password must be at least four (4)characters long.)</font></td>
			</tr>
			<tr class="pcnt">
				<td align="right">Confirm New Password</td>
				<td> : </td>
				<td><input type="password" name="confirmnewpassword" size="20" maxlength="12"></td>
			</tr>
			<tr>
			
			<td align="right"></td>
			<td></td>
			<td align="left">
			<input type="Submit" value="Submit" name="B1" onClick="return validate(this.form)">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="reset" value="Reset" name="B2"></td>
			
			</tr>
			</table>
	</form>
</body>
</html>
