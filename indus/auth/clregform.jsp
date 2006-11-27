<%@ page import="java.sql.*,oracle.jdbc.driver.OracleTypes,com.cl.common.CLFormEssentials"%>
<%@ page import="org.apache.log4j.*" errorPage="/epage/CLError.jsp" buffer="none" %>
<%
	Category logCategory = Category.getInstance("clsite.enrollonline");
	String message = request.getParameter("message");		
%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" href="/styles/style.css" type="text/css">
	<script LANGUAGE="JavaScript" src="/jscript/cl_functions.js">
	</script>
	<SCRIPT LANGUAGE="JavaScript">
		agree = 0;
		function validatePwd()
		{
			var invalid = " ";
			var minLength = 4;
			var pw1 = document.form1.password.value;
			var pw2 = document.form1.repassword.value;
			if (pw1 == '' || pw2 == '')
			{
				alert('Please enter your password twice.');
				document.form1.password.focus();

				return false;
			}
			if (document.form1.password.value.length < minLength)
			{
				alert('Your password must be at least ' + minLength + ' characters long. Try again.');
				document.form1.password.focus();
				return false;
			}
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

		function validate(form)
		{
			var fname = form.fname.value
			
			if (form.login.value=="")
			{
				alert("Please Enter User Name")
				form.login.focus();
				return(false);
			}			
			else if (form.fname.value=="")
			{
				alert("Please Enter First Name")
				form.fname.focus();
				return(false);
			}
			else if (form.email.value=="")
			{
				alert("Please Enter E-mail")
				form.email.focus();
				return(false);
			}
			else if (form.email.value.indexOf("@") == -1 || form.email.value == "" || form.email.value.indexOf(".") == -1) 
			{
				alert("Please include a proper email address.");
				form.email.focus();
				return false;
			}
			else if (form.contaddress1.value=="")
			{
				alert("Please Enter Contact Address1")
				form.contaddress1.focus();
				return(false);
			}
			else if (isNaN(form.pincode.value))
			{
				alert("Please Enter Valid PIN code(Only Numbers)")
				form.pincode.focus();
				return(false);	
			}
			else if(form.pincode.value.indexOf(" ") != "-1")
			{
				alert("PIN Code field can't have blank spaces like (\" \") ");
				form.pincode.focus();
				return (false);
			}
			else if (form.stdcoderes.value=="")
			{
				alert("Please Enter Std code (res)")
				form.stdcoderes.focus();
				return(false);
			}
			else if(form.stdcoderes.value.indexOf(" ") != "-1")
			{
				alert("STD code Res. field can't have blank spaces like (\" \") ");
				form.stdcoderes.focus();
				return (false);
			}
			else if (isNaN(form.stdcoderes.value))
			{
				alert("Please Enter Valid Residence STD code(Only Numbers)")
				form.stdcoderes.focus();
				return(false);	
			}
			else if (form.telres.value=="")
			{
				alert("Please Enter Telephone (res)")
				form.telres.focus();
				return(false);
			}
			else if(form.telres.value.indexOf(" ") != "-1")
			{
				alert("Phone No Res. field can't have blank spaces like (\" \") ");
				form.telres.focus();
				return (false);
			}
			else if (isNaN(form.telres.value))
			{
				alert("Please Enter Valid Residence Phone(Only Numbers)")
				form.telres.focus();
				return(false);	
			}
			else if (isNaN(form.stdcodework.value))
			{
				alert("Please Enter Valid Work STD code(Only Numbers)")
				form.stdcodework.focus();
				return(false);	
			}
			if(form.stdcodework.value.indexOf(" ") != "-1")
			{
				alert("STD Code Work field can't have blank spaces like (\" \") ");
				form.stdcodework.focus();
				return (false);
			}
			else if (isNaN(form.telwork.value))
			{
				alert("Please Enter Valid Work Phone(Only Numbers)")
				form.telwork.focus();
				return(false);	
			}
			else if(form.telwork.value.indexOf(" ") != "-1")
			{
				alert("Phone No Work field can't have blank spaces like (\" \") ");
				form.telwork.focus();
				return (false);
			}
			
			return true;
		}

	var saldisplayvalue = new Array(<%=CLFormEssentials.getSalutationName()%>
	var salcodervalue = new Array(<%=CLFormEssentials.getSalutationId()%>
	
	var edudisplay = new Array(<%=CLFormEssentials.getEduLevelName()%>
	var eduvalue = new Array(<%=CLFormEssentials.getEduLevelId()%>
	
	var countryids = new Array(<%=CLFormEssentials.getCountryId()%>
	var countrynames = new Array(<%=CLFormEssentials.getCountryName()%>
	
	var stateids = new Array(<%=CLFormEssentials.getStateId()%>
	var statenames = new Array(<%=CLFormEssentials.getStateName()%>
	var statecountryids = new Array(<%=CLFormEssentials.getStateCountryId()%>

	var cityids = new Array(<%=CLFormEssentials.getCityId()%>
	var citynames = new Array(<%=CLFormEssentials.getCityName()%>
	var citycountryids = new Array(<%=CLFormEssentials.getCityCountryId()%>
	var citystateids = new Array(<%=CLFormEssentials.getCityStateId()%>

	var profdisplayvalue = new Array(<%=CLFormEssentials.getProfessionName()%>
	var profcodervalue = new Array(<%=CLFormEssentials.getProfessionId()%>

	var countryvalue = 1
	var statevalue = 1

	function selectCountry()
	{
		countryvalue=document.form1.country.value
		changeStates(countryvalue)		
	}

	function selectState()
	{
		statevalue = document.form1.state.value
		changeCities(countryvalue,statevalue)		
	}

	function changeStates(countryvalue)
	{
		var x=0
		var temp = new Array()
		for(i=0;i<statecountryids.length;i++)
		{
			if(countryvalue==statecountryids[i])
			{
				temp[x] = i
				x++			
			}	
		}

		document.form1.state.length=x

		for(i=0;i<x;i++)
		{
			document.form1.state.options[i].value=stateids[temp[i]]
		}
		for(i=0;i<x;i++)
		{
			document.form1.state.options[i].text=statenames[temp[i]]
		}
		statevalue = document.form1.state.value
		changeCities(countryvalue,statevalue)
	}

	function changeCities(countryvalue,statevalue)
	{		
		var x=0
		var temp = new Array()
		for(i=0;i<citycountryids.length;i++)
		{
			if(countryvalue==citycountryids[i])
			{
				if(statevalue==citystateids[i])
				{
					
					temp[x] = i
					x++			
				}
			}	
		}

		document.form1.city.length=x

		for(i=0;i<x;i++)
		{
			document.form1.city.options[i].value=cityids[temp[i]]
		}
		for(i=0;i<x;i++)
		{
			document.form1.city.options[i].text=citynames[temp[i]]
		}
	}

</script>
<Title>Registeration Page</Title>
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
    <td bgcolor="DFE1BC" valign="top" align="left">&nbsp;</td>
  </tr>
  <tr> 
    <td bgcolor="DFE1BC" width="17" align="left" valign="top">&nbsp;</td>
    <td bgcolor="DFE1BC" height="1150" valign="top" align="left">&nbsp;</td>
  </tr>
</table>

<table width="79%" border="0" cellspacing="3" cellpadding="0" align="left">
  <tr> 
    <td colspan="2" bgcolor="B4BC6D"> 
      <table border="0" cellspacing="0" cellpadding="0" align="left">
        <tr> 
          <td bgcolor="B4BC6D"  width="8" align="left" valign="top" height="32"><img src="/img/blank.gif" width="1" height="32"></td>
          <td align="left" valign="middle"><a href="/" class="lnkblu">Home</a>
		  <font class="cntblu">&gt;</font> <font class="cntblu">Registration</font>
		  </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td bgcolor="BACFE5"> 
      <table border="0" cellspacing="0" cellpadding="0">
        
        <tr> 
          <td width="8">&nbsp;</td>
          <td class="headblubld" height="34" valign="center">Online Registration&nbsp;&nbsp;&nbsp;
		  <img src="/img/arrow.gif" align="absmiddle">
		  </td>
        </tr>
        
      </table>
    </td>
    <td rowspan="2" align="left" valign="top">
	<script language="javascript" src="/jscript/bannar.js"></script>
    </td>
  </tr>
  <tr> 
    <td height="23">

<form action="clprocessform.jsp" method="POST" name="form1" onSubmit="return validatePwd()">
<p>
Please provide us the following information to become a registered user of <b>careerlauncher.com</B>. In future, you will need to enter this <b>username/password</B> to access your personalized page.

This <b>user name/password</B> will also enable you to access all <b>careerlauncher.com</B> services.
</p>
	 <center>
		 <table border="0" width="100%" cellspacing="3" class="cnt">    
			<tr>
			 <td width="600" bgcolor="#E7E7E7" height="18" colspan="2">
				<font class="lnkbld">Create your User ID &amp; Password</font>
			</td>
		 </tr>
    
	<tr align="center">
      <td width="600" height="19" colspan="2">
		Fields marked with (<font class="new">*</font>) are mandatory.
	  </td>
    </tr>
<%
	if(message != null)
	{
%>
		<tr align="center">
			<td width="600" height="19" colspan="2"><font class="new"><%=message%></font></td>
		</tr>
	<tr align="center">
      <td width="600" height="19" colspan="2"></td>
    </tr>
<%
	}
%>
	<tr align="center">
      <td width="254" valign="top" height="41" align="right">
		<font class="new">*</font>
		Username :
	  </td>

      <td width="346" valign="top" height="41">
		<div align="left"><p>
		  <input type="text" name="login" size="20" maxlength="12"><br>
			  <font face="Arial" color="#FF0000">
				<small><small>(Use only letters (a-z), numbers (0-9), the	</small>
			      <small>underscore (_), and no&nbsp; spaces.)
				  </small>
				</small>
			  </font>
	   </td>
   </tr>
    
	
	<tr>
      <td width="254" valign="top" height="41" align="right">
		<font color=red size="2" face="verdana">*</font>
			Password : 
		</td>
       <td width="346" valign="top" height="41">
		<input type="password" name="password" size="20" maxlength="12"><br>
				<font face="Arial" color="#FF0000">
					<small><small>(Password must be at least four (4) characters long.)
					</small></small>
				</font>
	  </td>
    </tr>
    <tr>
      <td width="254" height="41" align="right" valign="top">
		<font color=red size="2" face="verdana">*</font> 
	  Retype password :
	  </td>
      <td width="346" height="41" valign="top">
	  <input type="password" name="repassword" size="20" maxlength="12">
	  </td>
    </tr>
  </table>
   <table border="0" width="100%" cellpadding="0" class="cnt" cellspacing="3">
    <tr>
      <td width="600" bgcolor="#E7E7E7" colspan="2" height="20">
	  <font class="lnkbld">Personal Information</font>
	  </td>
    </tr>
    	<tr>
      <td width="600" colspan="2"></td>
    </tr>
    <tr>
      <td align="right" width="253">
		<font color=red size="2" face="verdana">*</font>
		Salutation :
		</td>
      <td width="347">
	  <select name="salutation" size="1">
	<script language=javascript>
	for(i=0;i<saldisplayvalue.length;i++)
	{
		document.write("<option value=" +salcodervalue[i]+ ">"+ saldisplayvalue[i])
		
		
	}
	</script>
    </select></td>
    </tr>
	<tr>
      <td  align="right" width="253">
	  <font color=red size="2" face="verdana">*</font>
	  First Name : 
	  </td>
      <td width="347">
	  <input type="text" name="fname" value autocomplete="off" size="25" maxlength="40">
	  </td>
    </tr>
    <tr>
      <td align="right" width="253">
		Middle Name :
		</td>
      <td width="347">
	  <input type="text" name="mname" value autocomplete="off" size="25" maxlength="40">
	  </td>
    </tr>
	<tr>
		<td align="right" width="253">
		Last Name :
		</td>
		<td width="347">
		<input name="lname" value autocomplete="off" size="25" maxlength="40">
		</td>
    </tr>
	<tr>
		<td align="right" width="253" valign="top">
		<font color=red size="2" face="verdana">*</font>
		Date Of Birth : 
		</td>
		<td width="347">
		<SELECT NAME='monthofbirth'>
		<option selected value='01'>Jan
		<option value='02'>Feb
		<option value='03'>Mar
		<option value='04'>Apr
		<option value='05'>May
		<option value='06'>Jun
		<option value='07'>Jul
		<option value='08'>Aug
		<option value='09'>Sep
		<option value='10'>Oct
		<option value='11'>Nov
		<option value='12'>Dec
		</SELECT>
		<SELECT NAME='dayofbirth'>
		<option selected value='01'>01
		<option value='02'>02
		<option value='03'>03
		<option value='04'>04
		<option value='05'>05
		<option value='06'>06
		<option value='07'>07
		<option value='08'>08
		<option value='09'>09
		<option value='10'>10
		<option value='11'>11
		<option value='12'>12
		<option value='13'>13
		<option value='14'>14
		<option value='15'>15
		<option value='16'>16
		<option value='17'>17
		<option value='18'>18
		<option value='19'>19
		<option value='20'>20
		<option value='21'>21
		<option value='22'>22
		<option value='23'>23
		<option value='24'>24
		<option value='25'>25
		<option value='26'>26
		<option value='27'>27
		<option value='28'>28
		<option value='29'>29
		<option value='30'>30
		<option value='31'>31
		</SELECT>
		<SELECT NAME='yearofbirth'>
		<option value='1960'>1960
		<option value='1961'>1961
		<option value='1962'>1962
		<option value='1963'>1963
		<option value='1964'>1964
		<option value='1965'>1965
		<option value='1966'>1966
		<option value='1967'>1967
		<option value='1968'>1968
		<option value='1969'>1969
		<option value='1970'>1970
		<option value='1971'>1971
		<option value='1972'>1972
		<option value='1973'>1973
		<option value='1974'>1974
		<option value='1975'>1975
		<option value='1976'>1976
		<option value='1977'>1977
		<option value='1978'>1978
		<option value='1979'>1979
		<option value='1980' selected>1980
		<option value='1981'>1981
		<option value='1982'>1982
		<option value='1983'>1983
		<option value='1984'>1984
		<option value='1985'>1985
		<option value='1986'>1986
		<option value='1987'>1987
		<option value='1988'>1988
		<option value='1989'>1989
		<option value='1990'>1990
		<option value='1991'>1991
		<option value='1992'>1992
		<option value='1993'>1993
		<option value='1994'>1994
		<option value='1995'>1995
		<option value='1996'>1996
		<option value='1997'>1997
		<option value='1998'>1998
		<option value='1999'>1999
		</SELECT> &nbsp;<br>
		<font color=red size="1" face="verdana"><small>(Used in retrieving the password)</small></font></td>
    </tr>    
	<tr>
		<td width="253" align="right">
		<font color=red size="2" face="verdana">*</font>
		E-mail Id : 
		</td>
		<td width="348">
		<input name="email" size="25" maxlength="50">
		</td>
    </tr>
    <tr>
		<td align="right" width="253">
		<font color=red size="2" face="verdana">* </font>
		Contact Address Line 1 : 
		</td>
		<td width="348">
		<input name="contaddress1" size="25" maxlength="80">
		</td>
    </tr>
	<tr>
		<td width="253" align="right">
		Contact Address Line 2 : 
		</td>
		<td width="348">
		<input name="contaddress2" size="25" maxlength="80">
		</td>
    </tr>
	<tr>
		<td align="right" width="253">
		Country : 
		</td>
		<td width="348">
		<select name="country" onChange=selectCountry()>
		<script language=javascript><!--
		for(i=0;i<countrynames.length;i++)
		{
			document.write("<option value = " +countryids[i]+ ">" + countrynames[i])
		}
		//--></script>
		</select>
		&nbsp;&nbsp;&nbsp;
		Other <input type=text name="othercountry" size=10 value=" " maxlength = "40"></input>
		</td>
    </tr>
	<tr>
		<td valign="top" align="right" width="253">
		State : 
		</td>
		<td width="348">
		<select name="state" onChange=selectState()>
		<script language=javascript><!--
		for(i=0;i<statenames.length;i++)
		{
			if(countryvalue==statecountryids[i])
			{
				document.write("<option value = " +stateids[i]+ ">" + statenames[i])
			}
		}
		//--></script>
		</select><br>
		Other<input type=text name="otherstate" size=10 value=" " maxlength = "40"></input>
		</td>
    </tr>
	<tr>
		<td  align="right" width="253">
		City : 
		</td>
		<td width="348">
		<select name="city">
		<script language=javascript><!--
		for(i=0;i<citynames.length;i++)
		{
			if(countryvalue==citycountryids[i])
			{
				if(statevalue==citystateids[i])
				{	
					document.write("<option value = " +cityids[i]+ ">" + citynames[i])
				}
			}
		}

		//--></script>
		</select>
	&nbsp;&nbsp;&nbsp;
	Other<input type=text name="othercity" size=10 value=" " maxlength = "40"></input>
		</td>
    </tr>
	<tr>
		<td align="right" width="253">
		Pin Code : 
		</td>
		<td width="348">
		<input name="pincode" size="25" maxlength="10">
		</td>
    </tr>
	<tr>
		<td align="right" width="253">
		<font color=red size="2" face="verdana">*</font>
		STD Code(<small><font color=red face="Times New Roman">Res</font></small>) : 
		</td>
		<td width="348"><input name="stdcoderes" size="25" maxlength="10"></td>
    </tr>
	<tr>
      <td align="right" width="253">
		<font color=red size="2" face="verdana">*</font>
		Telephone(<small><font color=red>Res</font></small>) : 
		</td>
      <td width="348"><input name="telres" size="25" maxlength="10"></td>
    </tr>
	<tr>
      <td width="253"  align="right">
		STD Code(<small><font color=red face="Times New Roman">Work</font></small>) : 
		</td>
      <td width="348"><input name="stdcodework" size="25" maxlength="10"></td>
    </tr>
	<tr>
      <td align="right" width="253">
		Telephone(<small><font color=red face="Times New Roman">Work</font></small>) : 
		</td>
      <td width="348"><input name="telwork" size="25" maxlength="10"></td>
    </tr>
	<tr>
      <td align="right" width="253">
		Profession : 
		</td>
      <td width="348"><select name="profession" size="1">
		<script language=javascript>
			for(i=0;i<profdisplayvalue.length;i++)
			{
				document.write("<option value=" +profcodervalue[i]+ ">"+ profdisplayvalue[i])
				
				
			}
		</script>
      </select></td>
    </tr>
	<tr>
		<td align="right" width="253">
		Education Level :
		</td>
		<td width="348">
		<select name="edulevel" size="1">
		<script language=javascript>
			for(i=0;i<eduvalue.length;i++)
			{
				document.write("<option value=" +eduvalue[i]+ ">"+ edudisplay[i])
				
				
			}
		</script>        
      </select></td>
    </tr>
	<tr>
      <td align="right" width="253">
		Organistation : 
		</td>
      <td width="348"><input name="organisation" size="25" maxlength="80"></td>
    </tr>
	<tr>
      <td width="253"><BR></td>
      <td width="348"><br></td>
    </tr>
	<tr>
		<td width="253" align="right">
		<input type=checkbox name="spamflag" value="Y" checked>
		</td>
      <td width="348" >I want to receive regular information about your services.</td>
</tr>
</table>
<table class="cnt" border="0" width="100%" cellpadding="0"  cellspacing="3">
    <tr>
		<td width="600" align="right" valign="top" colspan="2">
		<BR>
		<table class="cnt" border="0" cellpadding="2" cellspacing="1" width="100%" bgcolor="#E7E7E7">
        <tr>
		<INPUT TYPE=hidden NAME="customerid" value="null"></input>
        <td width="50%"><div align="right"><p><input type="reset" value="Reset" name="B2"></td>
         <td width="50%"><div align="left"><p><input type="Submit" value="Submit" name="B1"
         onClick="return validate(this.form)"></td>
        </tr>
		</table>
		</td>
    </tr>
  </table>
 </form>
</body>
</html>
