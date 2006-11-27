<%@ page import="java.sql.*,oracle.jdbc.driver.*,org.apache.log4j.*" buffer="none"%>

<jsp:useBean id="CLConn" class="com.cl.sql.CLConnectionManager" scope="application"/>
<jsp:useBean id="form" class="com.cl.common.CLFormEssentials" scope="application"/>
<script LANGUAGE="JavaScript" src="/jscript/cl_functions.js">
</script>
<script language="JavaScript">
<!--
function chkSelect()
{
	if (ChkBlank("form1.fname","Please write your first name.") == false) return false
	if (ChkBlank("form1.email","Please write your Email .") == false) return false
	if (ChkBlank("form1.email","Please write your Email .") == false) return false
	if (ChkBlank("form1.email","Please write your Email .") == false) return false
	else if (ChkBlank("form1.loginname","Please write your Login Name .") == false) return false
	else if (ChkBlank("form1.password","Please write your Password .") == false) return false
	else if (ChkEmail("form1.email","Please write your Proper Email (Like : abc@abc.xyz).") == false) return false
	else if (ChkBlank("form1.addline1","Please write your Address Line1 .") == false) return false
	else if (ChkNumber("form1.pin","Please write your PIN Number (Number Only) .") == false) return false
	else if (ChkNumber("form1.std","Please write your STD Code (Number Only) .") == false) return false
	else if (ChkNumber("form1.phno","Please write your Phone No (Number Only) .") == false) return false
}
	var countryids = new Array(<%=form.getCountryId()%>
	var countrynames = new Array(<%=form.getCountryName()%>

	var stateids = new Array(<%=form.getStateId()%>
	var statenames = new Array(<%=form.getStateName()%>
	var statecountryids = new Array(<%=form.getStateCountryId()%>

	var cityids = new Array(<%=form.getCityId()%>
	var citynames = new Array(<%=form.getCityName()%>
	var citycountryids = new Array(<%=form.getCityCountryId()%>
	var citystateids = new Array(<%=form.getCityStateId()%>

var countryvalue = 1
var statevalue = 1
///////////////////////////////////
function checkOtherContact()
{
	var index = document.form1.cityIdContact.selectedIndex;
	var text = document.form1.cityIdContact.options[index].text
	if(text =="OTHER")
	{
		document.form1.othercitycontact.maxLength=50
	}
	else
	{
		document.form1.othercitycontact.value="";
		document.form1.othercitycontact.maxLength=0
	}
}
function selectCountryContact()
{
	countryvalue=document.form1.countryIdContact.value
	changeStatesContact(countryvalue)	
}
function selectStateContact()
{
	statevalue = document.form1.stateIdContact.value
	changeCitiesContact(countryvalue,statevalue)
}

function changeStatesContact(countryvalue)
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

	document.form1.stateIdContact.length=x

	for(i=0;i<x;i++)
	{
		document.form1.stateIdContact.options[i].value=stateids[temp[i]]
	}
	for(i=0;i<x;i++)
	{
		document.form1.stateIdContact.options[i].text=statenames[temp[i]]
	}
	statevalue = document.form1.stateIdContact.value
	changeCitiesContact(countryvalue,statevalue)
}

function changeCitiesContact(countryvalue,statevalue)
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

	document.form1.cityIdContact.length=x

	for(i=0;i<x;i++)
	{
		document.form1.cityIdContact.options[i].value=cityids[temp[i]]
	}
	for(i=0;i<x;i++)
	{
		document.form1.cityIdContact.options[i].text=citynames[temp[i]]
	}
}
//-->
</SCRIPT>
<%
	Connection connection = CLConn.getConnection("erp");
	Category logCategory = Category.getInstance("clsite.auth.editProfile");
	
	String login_name = (String)session.getValue("login");
	String password = (String)session.getValue("password");
	String uid = (String)session.getValue("uid");
	
	if(login_name == null)
	{
		login_name = request.getParameter("login");
		password = request.getParameter("password");
	}
	
	if(login_name == null)
	{
%>
		<jsp:forward page="editprofile.html"/>
		<!-- response.sendRedirect("editprofile.html");  -->
<%	}
	
	ResultSet resultset = null; 
	CallableStatement call = null;
	int customer_id = 0;
	int user_id = 0;
	String fname = "";
	String mname = "";	
	String lname = "";	
	String email = "";
	String salutation = "";
	String dayofbirth = "";	
	String addline1 = "";	
	String addline2 = "";
	int countryidcont= 0;	
	int stateidcont= 0;	
	int cityidcont= 0;
	String pin= "";
	int city_std_code_res= 0;
	int tel_no_res= 0;
	
	int isd_res =0;
	int	mobile =0;
%>
<html>
<head>
<title>Edit Profile</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="/styles/style.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<script language="javascript" src="/jscript/top.js"></script>
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
		<script language="javascript" src="left_link.js"></script>
		<script language="javascript" src="/jscript/left_link.js"></script>
	</td>
	</tr>
  <tr> 
    <td bgcolor="DFE1BC" width="17" align="left" valign="top">&nbsp;</td>
    <td bgcolor="DFE1BC" height="240" valign="top" align="left">&nbsp;</td>
  </tr>
</table>
<table width="79%" border="0" cellspacing="3" cellpadding="0" align="left">
  <tr> 
    <td colspan="2" bgcolor="B4BC6D"> 
      <table border="0" cellspacing="0" cellpadding="0" align="left">
        <tr> 
          <td bgcolor="B4BC6D"  width="8" align="left" valign="top" height="32"><img src="/img/blank.gif" width="1" height="32"></td>
          <td align="left" valign="middle"><font class="cntblu"><a href="/" class="lnkblu">Home</a>
		  <font class="cntblu">&gt;</font>Edit Profile
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
          <td class="headblubld" height="34" valign="center">Edit Profile&nbsp;&nbsp;&nbsp;<img src="/img/arrow.gif" align="absmiddle"></td>
        </tr>
     </table>
    </td>
    <td rowspan="2" width="21%" align="left" valign="top">
		<script language="javascript" src="/jscript/bannar.js"></script>
    </td>
  </tr>
  <tr> 
    <td height="23">
<%
		call = connection.prepareCall ("{call CL_CUST_WEB_USER_PKG.VALIDATE_WEB_USER_LOGIN(?,?,?)}");
		call.setString(1,login_name);
		call.setString(2,password);
		call.registerOutParameter(3,OracleTypes.NUMBER);
	try
	{
		call.execute();
		user_id = call.getInt(3);
		
		if(call!=null)
		{
			call.close();
			call = null;
		}
		call = connection.prepareCall ("{call ERP_USER_PKG.GET_WEB_USER(?,?,?)}");
		call.registerOutParameter(3, OracleTypes.NUMBER);
		call.registerOutParameter(2, OracleTypes.CURSOR);
		call.setInt(1,user_id);
		
		call.execute();
		
		try
		{
			resultset = (ResultSet)call.getObject(2);
			if (resultset.next())
			{					
				salutation = resultset.getString("SALUTATION");
				fname = resultset.getString ("FNAME");	
				mname = resultset.getString ("MNAME");
				lname = resultset.getString ("LNAME");	
				email = resultset.getString ("EMAIL");	
				dayofbirth = resultset.getString ("DOB");
				addline1 = resultset.getString ("LINE1_CONTACT");	
				addline2 = resultset.getString ("LINE2_CONTACT");	
				countryidcont= resultset.getInt ("COUNTRY_ID_CONTACT");	
				stateidcont= resultset.getInt ("STATE_ID_CONTACT");	
				cityidcont= resultset.getInt ("CITY_ID_CONTACT");
				pin = resultset.getString("PIN_CONTACT");
				city_std_code_res = resultset.getInt ("CITY_STD_CODE_RES");
				tel_no_res = resultset.getInt ("TEL_NO_RES");
				isd_res =resultset.getInt ("ISD");
				mobile =resultset.getInt ("MOBILE");
			
				resultset.close();
				if(call!=null)
				{
					call.close();
					call = null;
				}
			}
			session.putValue("uid",Integer.toString(user_id));
			session.putValue("fname",fname);
			session.putValue("lname",lname);
			session.putValue("login",login_name);
			session.putValue("password",password) ;
%>
			<form method=post action="updateProfile.jsp" name="form1"   onSubmit="return(chkSelect())">
			<center>
			<table cellspacing="0" cellpadding="3" border="0" class="cnt" width="100%">
			<tr>
				<td width="20%">First Name</td>
				<td> : </td>
				<td><input type="text" name="fname" value="<%=fname%>" maxlength="40">
				</td>
			</tr>
<%
			if(mname!=" ")
			{
%>
			<tr>
				<td width="20%">Middle Name</td>
				<td> : </td>
				<td><input type="text" name="mname" value="<%=mname%>" maxlength="40">
				</td>
			</tr>
<%
			}
%>
			<tr>
				<td>Last Name</td>
				<td> : </td>
				<td><input type="text" name="lname" value="<%=lname%>" maxlength="40">
				</td>
			</tr>
			<tr>
			<td>Email</td>
				<td> : </td>
				<td><input type="text" name="email" value="<%=email%>" maxlength="50"></td>
			</tr>
			<tr>
				<td valign="top">Date Of Birth</td>
				<td valign="top"> : </td>
				<td><input type="text" name="dateofbirth" VALUE="<%=dayofbirth%>" disabled><br><font class="new">If this date of birth does not match with your date of birth, Please mail to</font> <a href="helpme@careerlauncher.com" class="lnkblu">helpme@careerlauncher.com</a> <font class="new">with your first and last name</font>
				
				</td>
			</tr>
			<tr>
				<td valign="top">Add Line 1</td>
				<td valign="top"> : </td>
				<td><input type="text" name="addline1" value="<%=addline1%>"  maxlength="80">
				</td>
			</tr>
			<tr>
				<td>Add Line2</td>
				<td> : </td>
				<td><input type="text" name="addline2" value="<%=addline2%>" maxlength="80"></td>
			</tr>
			<tr>
				<td>Country</td>
				<td> : </td>
				<td>
					<select name="countryIdContact" onChange=selectCountryContact()>
							<script language=javascript>
							<!--
								for(i=0;i<countrynames.length;i++)
								{
									if(<%=countryidcont%> == countryids[i])
									{
										document.write("<option value = " +countryids[i]+ " selected>" + countrynames[i])
									}
									else
									{
										document.write("<option value = " +countryids[i]+ ">" + countrynames[i])
									}
								}
							//-->
							</script>
						</select>
						</td>
					</tr>
					<tr>
						<td>State</td>
						<td> : </td>
						<td>
						<select name="stateIdContact" onChange="selectStateContact(),checkOtherContact()">
							<script language=javascript>
							<!--
								for(i=0;i<statenames.length;i++)
								{
									if(<%=stateidcont%> == stateids[i])
									{
										if(countryvalue==statecountryids[i])
										{
											document.write("<option value = " +stateids[i]+" selected>" + statenames[i])
										}
									}
									else
									{
										if(countryvalue==statecountryids[i])
										{
											document.write("<option value = " +stateids[i]+">" + statenames[i])
										}
									}
								}
							//-->
							</script>
						</select>
						</td>
					</tr>
					<tr>
						<td>City</td>
						<td> : </td>
						<td>
						<select name="cityIdContact" onChange="checkOtherContact()">
							<script language=javascript><!--
								for(i=0;i<citynames.length;i++)
								{
									if(<%=cityidcont%> == cityids[i])
									{
										if(countryvalue==citycountryids[i])
										{
											//if(statevalue==citystateids[i])
											//{	
												document.write("<option value = " +cityids[i]+ " selected>" + citynames[i])
											//}
										}
									}
									else
									{
										if(countryvalue==citycountryids[i])
										{
											//if(statevalue==citystateids[i])
											//{	
												document.write("<option value = " +cityids[i]+ ">" + citynames[i])
											//}
										}
									}
								}
							//--></script>
							</select>
							<font class="cnt"><small>Other</small></font> 
							<input type=text name="othercitycontact" size=10 value=" " maxlength="0"></input>
							<font class="new">
							  [If not in city list]
							</font>
						</td>
					</tr>
					<tr>
						<td>PIN</td>
						<td> : </td>
						<td><input type="text" name="pin" value="<%=pin%>"  maxlength="10"></td>
					</tr>
					<tr>
						<td>Telephone</td>
						<td> : </td>
						<td>STD : <input type="text" name="std" size="4" value="<%=city_std_code_res%>" maxlength="7"> No : <input type="text" name="phno" size="6" value="<%=tel_no_res%>" maxlength="8"></td>
					</tr>
					<tr>
						<td></td>
						<td><input type="checkbox" name="subcribe" value="Y" checked></td>
						<td>I want to subscribe to other updates from Career Launcher</td>
					</tr>
					<tr>
						<td></td>
						<td>
						<input type="hidden" name="uname" value="<%=login_name%>">
						<input type="hidden" name="password" value="<%=password%>">
						<input type="hidden" name="res_isd" value="<%=isd_res%>">
						<input type="hidden" name="mobile" value="<%=mobile%>">
						<input type="hidden" name="salutation" value="<%=salutation%>">
						<input type="hidden" name="userid" value="<%=user_id%>">
						<input type="hidden" name="customerid" value="<%=customer_id%>">
						</td>
						<td><input type="reset" value = "Reset"> &nbsp;&nbsp;
						<input type="submit" value="Submit">
						</td>
					</tr>
					</table>
					</center>
					</form>
<%
			}
			catch(Exception ex)
			{
				connection.rollback();
				logCategory.error(ex);
				throw ex;
			}
			}
			catch(SQLException sql)
			{
				int errorCode = sql.getErrorCode();
				if (errorCode == 20006)
				{
%>
					<center><b><font class="new">Invalid username or password. Check if the caps lock on. </font></b><br><br><br><br><br>
					<a href="javascript:history.back();" class="lnkblu">Try again</a></center>
<%
				}
				else
				{
					logCategory.error(sql);
					throw sql;
				}	
			}
			finally
			{
				try
				{
					resultset.close();
					resultset = null;
					call.close();
					call = null;
				}
				catch(Exception ex)
				{}
			}
%>
</td>
</tr>
</table>
</body>
</html>