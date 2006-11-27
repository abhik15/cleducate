<%@ page import="java.sql.*, java.util.*, com.cl.sql.PoolManager,oracle.jdbc.driver.*, org.apache.log4j.*" errorPage="/epage/anandaError.jsp"%> 
<%
	Connection connection = null;
	PreparedStatement stat = null;
	CallableStatement call = null;
	ResultSet  identification = null;
	PoolManager pool = PoolManager.getInstance();
	Category logCategory = Category.getInstance("SIS.register.SISselectlogin");

	String customerid = request.getParameter("customerid");	
	
	String id = request.getParameter("id");
	
	if(id== null || id.trim().length()<=0)
	{
		id = " -1 ";
	}
	String monthofbirth=request.getParameter("monthofbirth");
	String dayofbirth=request.getParameter("dayofbirth");
	String yearofbirth=request.getParameter("yearofbirth");
	String dateofbirth=dayofbirth+"/"+monthofbirth+"/"+yearofbirth;
	int schoolId=Integer.parseInt(request.getParameter("schoolId"));
	
	String userId = "";
	String userName = "";
	String password = "";
	int recordFound = 0; 
	boolean userSystemGenerated = false;

	try
	{

		connection = pool.getConnection("erp"); 
		call=connection.prepareCall("{CALL SIS_PKG.GET_CUST_USER_DETAIL(?,?,?,?,?,?,?,?)}");

		call.setInt(1, Integer.parseInt(id));
		call.setString(2, dateofbirth);
		call.setInt(3,schoolId);

		call.registerOutParameter(4,OracleTypes.VARCHAR);		
		call.registerOutParameter(5,OracleTypes.VARCHAR);		
		call.registerOutParameter(6,OracleTypes.VARCHAR);		
		call.registerOutParameter(7,OracleTypes.VARCHAR);		
		call.registerOutParameter(8,OracleTypes.NUMBER);		

		call.execute();

		customerid=call.getString(4);
		userId=call.getString(5);
		userName=call.getString(6);
		password=call.getString(7);
		recordFound=call.getInt(8);
	}
	catch(Exception ex){
		logCategory.error(ex);
		throw ex;
	}
	finally
	{
	   try{call.close();}catch(Exception x){}
	   pool.freeConnection("erp",connection);
	} 

	String temporary = customerid+"~CLEF";
	if(userName.equalsIgnoreCase(temporary))
	{
		userSystemGenerated = true;
	}

%>

<html>
<head>
<title>Get your Username/password</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="/styles/style.css" type="text/css">
<script LANGUAGE="JavaScript" src="/jscript/cl_functions.js">
</script>
<SCRIPT LANGUAGE="JavaScript">
function validatePwd()
{
	var invalid = " "; // Invalid character is a space

	if (document.form1.login.value=="")
	{
		alert("Please Enter User Name")
		document.form1.login.focus();
		return(false);
	}
	if (document.form1.login.value.indexOf(invalid) > -1)
	{
		alert("Sorry, spaces are not allowed.");
		document.form1.login.focus();
		return false;
	}

	var minLength = 4; // Minimum length
	var pw1 = document.form1.password.value;
	var pw2 = document.form1.confirmpassword.value;
	// check for a value in both fields.
	if (pw1 == '' || pw2 == '')
	{
		alert('Please enter your password twice.');
		document.form1.password.focus();

		return false;
	}
	
	// check for minimum length
	if (document.form1.password.value.length < minLength)
	{
		alert('Your password must be at least ' + minLength + ' characters long. Try again.');
		document.form1.password.focus();
		return false;
	}

	// check for spaces
	if (document.form1.password.value.indexOf(invalid) > -1)
	{
		alert("Sorry, spaces are not allowed.");
		document.form1.password.focus();
		return false;
	}

	else
	{
		if (pw1 != pw2)
		{
		alert ("Password does not match. Please re-enter your password.");
		document.form1.password.focus();
		return false;
		}
	}
}

function validatePwd1()
{
	var invalid = " "; // Invalid character is a space
	var minLength = 4; // Minimum length
	
	// check for minimum length
	if (document.form2.password.value.length < minLength)
	{
		alert('Your password must be at least ' + minLength + ' characters long. Try again.');
		document.form2.password.focus();
		return false;
	}

	// check for spaces
	if (document.form2.password.value.indexOf(invalid) > -1)
	{
		alert("Sorry, spaces are not allowed.");
		document.form2.password.focus();
		return false;
	}	
}

</script>

</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script language="javascript" src="/jscript/top.js"></script>
<table width="21%" border="0" cellspacing="0" cellpadding="0" align="left">
	<tr bgcolor="#FFFFFF"> 
		<td colspan="2"><img src="/img/blank.gif" height="3"></td>
	</tr>
	<tr> 
		<td bgcolor="DFE1BC" colspan="2"><img src="/img/blank.gif" height="10"></td>
	</tr>
	<tr valign="middle" align="left"> 
		<td bgcolor="DFE1BC" width="17">&nbsp;</td>
	    <td bgcolor="DFE1BC" height="520" valign="top">&nbsp;</td>
	</tr>
</table>

<table width="79%" border="0" cellspacing="3" cellpadding="0" align="left">
	<tr>
		<td bgcolor="B4BC6D">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr> 
		          <td bgcolor="B4BC6D" height="32" width="10"><img src="img/blank.gif" width="1" height="28"></td>
				  <td><font class="cntblu"><a href="/" class="lnkblu">home</a><font class="cntblu">&gt;</font><a href="/sis/index.jsp" class="lnkblu">Login for SIS</a><font class="cntblu">&gt;</font><a href="javascript:history.back()" class="lnkblu">Students can acquire a username/password</a>&gt;Get your username/password</font></td>	
				</tr>
			</table>
		</td>
	</tr>
	 <tr> 
		<td bgcolor="B4BC6D"> 
		    <table border="0" cellspacing="0" cellpadding="0">
        
		        <tr> 
				  <td width="8">&nbsp;</td>
		          <td class="headblubld" height="34" valign="center">Get your username/password&nbsp;&nbsp;&nbsp;</td>
				</tr>        
		    </table>
		</td>
	 </tr>
</table>

<br>
<br>
<br>
<br>

<table width="75%" border="0" cellspacing="0" cellpadding="0" align="left">
	<tr> 
		<td width="1" rowspan="3"></td>
	    <td rowspan="6" width="10"><img src="/sis/img/blank.gif" width="1"></td>
		<td align="left" height="5"></td>
	    <td rowspan="1" valign="top">&nbsp;</td>
	</tr>
	<tr> 
		<td align="left">&nbsp;</td>
	</tr>
	<tr> 
		<td align="left" height="30">
<%
		if(recordFound==1) 
		{
			if(userSystemGenerated)
			{
	
	
%>
				<form  method="post" action="/sis/register/SISupdateuserdetails.jsp" name="form1" onSubmit="return validatePwd()">
				<INPUT TYPE="hidden" NAME="userId" value="<%=userId%>"></input>
				<INPUT TYPE="hidden" NAME="customerid" value="<%=customerid%>"></input>

				<SCRIPT LANGUAGE="JavaScript">
				var newPassword = eval("hex_md5('document.form1.password.value')");
				document.write("<INPUT TYPE=\"hidden\" NAME=\"newPassword\" value=\""+newPassword+"\"></input>");
				</script>	

				<div align=justify>
					<p>	<FONT CLASS="new"><font class="new"><b>Thank You !</b></font></font><BR><BR>

					Your enrollment record has been successfully retrieved.<BR><BR>

					Please select a <font class="verbld">User name</font> and <font class="verbld">password</font> in the screen below . In future , 
					You will need to enter this to access your personalized page.

					This <font class="verbld">user name/password</font> will also enable you to access all <font class="verbld">careerlauncher.com</font> 
					services including <font class="verbld">SIS</font>.</p>
				</div>
 
				<div align="center">
					<center>
					<table border="0" width="100%" cellspacing="3">    
							   
					<tr align="center">
					  <td width="600" height="19" colspan="2"></td>
					</tr>
					<tr align="center">
					  <td width="254" valign="top" height="41">
						<div align="right"><p><small><font class=cnt>User Name : </font></small>
					  </td>

					  <td width="346" valign="top" height="41">
						<div align="left"><p>
						  <input type="text" name="login" size="20" maxlength="12" class="boxborder">							  
					   </td>
					</tr>						
					<tr align="center">
						 <td width="254" height="41" valign="top"><div align="right"><p><small><font class=cnt>
						 Password :</font></small></td>
						 <td width="346" height="41" valign="top"><div align="left"><p><input type="password"
						 name="password" size="20" maxlength="12" class="boxborder">
						 <br><font face="Arial" color="#FF0000">
						 <small><small>(Password must be at least four (4)characters long.)
						 </small></small></font>
						</td>
					</tr>
					<tr align="center">
						<td width="254" height="41" valign="top"><div Align="right"> <p><small><font class="cnt">Confirm Password :</font></small>
						</td>
						<td width="346" height="41" valign="top"><div align="left"><p>
						<input type="password" name="confirmpassword" size="20" maxlength="12" class="boxborder">
						</td>
					</tr>

				  </table>
					<div align="center"><center>
					<table border="0" width="100%" cellpadding="0"  cellspacing="3">
						<tr>
						  <td width="600" align="right" valign="top" colspan="2"><div align="center"><center><BR>
							<table border="0" cellpadding="2" cellspacing="1" width="100%" bgcolor="#E7E7E7">
							<tr>
							  <td width="50%"><div align="right"><p><input type="reset" value="Reset" name="B2" class="goldBorder"></td>
							  <td width="50%"><div align="left"><p><input type="Submit" value="Submit" name="B1" class="goldBorder"></td>
							</tr>
							</table>
						  </center></div></td>
						</tr>
					  </table>
					  </center>
					  </div>
					 </form>

<%
				}
				else
				{
%>
	
					<form  method="post" action="/sis/register/SISloginwhenonlypassword.jsp" name="form2" onSubmit="return validatePwd1()">
					<INPUT TYPE=hidden NAME="customerid" value="<%=customerid%>"></input>
						<div align=justify>
					<p><FONT class="new"><font class="verbld">Thank You !</font></font><BR><BR>

					Your enrollment record has been successfully retrieved.<BR>
					You might have forgotten but you are also registered with us. Your login is <font class="lnkbld"><%=userName%></font>.
					<br>
					If you have forgotten the password you may  <a href="#" onclick="javascript: OpenWindow('/sis/register/forgotpassword.html','forgotpassword','450','400')" class="lnkblu"> retrieve password</a></p>

					</div>
 
				  <div align="center">
					 <center>
						 <table border="0" width="100%" cellspacing="3">    
							   
							<tr align="center">
								<td width="600" height="19" colspan="2"></td>
							</tr>
  
							<tr align="center">
								  <td width="254" valign="top" height="41">
									<div align="right"><p><small><font class="cnt">
											User Name :</font>
											 </small>
								  </td>

								  <td width="346" valign="top" height="41">
									<div align="left"><p>
									  <input type="text" name="login" size="20" maxlength="12" value="<%=userName%>" readonly class="boxborder">
										  
								   </td>
							   </tr>
								
		
								<tr align="center">
								  <td width="254" height="41" valign="top"><div align="right"><p><small><font class="cnt">
								   Password :</font></small></td>
								  <td width="346" height="41" valign="top"><div align="left"><p><input type="password"
									name="password" size="20" maxlength="12" class="boxborder">
									<br><font face="Arial" color="#FF0000"><small><small>(Password must be at least four (4)characters long.)
									</small></small></font>

								   </td>
								 </tr>
							  </table>

							<div align="center"><center>
							<table border="0" width="100%" cellpadding="0"  cellspacing="3">
								<tr>
								  <td width="600" align="right" valign="top" colspan="2"><div align="center"><center><BR>
								<table border="0" cellpadding="2" cellspacing="1" width="100%" bgcolor="#E7E7E7">
									<tr>
									  <td width="50%"><div align="right"><p><input type="reset" value="Reset" name="B2" class="goldBorder"></td>
									  <td width="50%"><div align="left"><p><input type="Submit" value="Submit" name="B1" class="goldBorder"></td>
									</tr>
								  </table>
								  </center></div></td>
								</tr>
							  </table>
							  </center></div>		
							 </form>
		
<%
						}
					}
					else
					{
%>

						<p><font class="new"><BR><BR>
						<b>Sorry !  </b></font>There seems to be  a mismatch between our systems and  the information entered 
						by you.  In case your date of birth is recorded wrong in the  system , please call your 
						center agent and ask  them to update the  information in our system. 
						They will also  be able to help you obtain  your receipt id data.
						<BR><BR>
						If  your call is made during our regular working hours   we should be able to get your 
						access  your account information and  make changes  immediately. Most problems are 
						resolved within a day. 
						</p>
						<BR><BR>
						
						<center><form  name="form3">
							<input type="Button" value="Back" onClick="history.back()" class="goldBorder">
						</form></center>

<%
	
					}

%>
</td>
  </tr>
</table>
</body>
</html>
