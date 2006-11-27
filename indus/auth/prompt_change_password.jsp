<html>
<head>
<script language="JavaScript"> src="/jscript/cl_functions.js"</script>
<title>Change your password</title>
<script language="JavaScript">
function validatePwd()
{
	var invalid = " "; // Invalid character is a space
	var minLength = 4; // Minimum length
	var pw1 = document.changepwdform.newpassword.value;
	var pw2 = document.changepwdform.cnewpassword.value;
	// check for a value in both fields.
	if (pw1 == '' || pw2 == '')
	{
		alert('Please enter new password twice.');
		document.changepwdform.cnewpassword.focus();
		return false;
		}
	
	// check for minimum length
	if (document.changepwdform.newpassword.value.length < minLength)
	{
		alert('Your new password must be at least ' + minLength + ' characters long. Try again.');
		document.changepwdform.cnewpassword.focus();
		return false;
	}

	// check for spaces
	if (document.changepwdform.newpassword.value.indexOf(invalid) > -1)
	{
		alert("Sorry, spaces are not allowed.");
		document.changepwdform.cnewpassword.focus();
		return false;
	}

	else
	{
		if (pw1 != pw2) {
		alert ("New Passwords do not match. Please re-enter your password.");
		document.changepwdform.cnewpassword.focus();
		return false;
	}
}
}
function validate(form)
{
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
<body>
<form name="changepwdform" action="change_password.jsp" method="post" onSubmit="return validatePwd()">
<label for=old_password>Old Password:</label>
<input type="password" name="oldpassword" id=old_password</input>
<label for=new_password>New Password:</label>
<input type="password" name="newpassword" id="new_password"</input>
<label for=c_password>Confirm Password:</label>
<input type="password" name="cnewpassword" id="c_password"</input>
<input type="submit" name="submit" value="submit" onClick="return validate(this.form)"</input>
</form>
</body>
</html>