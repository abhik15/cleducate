<%@ page import="java.io.*, java.sql.*, java.util.Date, oracle.jdbc.driver.*, com.cl.sql.PoolManager, org.apache.log4j.*" errorPage="/epage/anandaError.jsp" buffer="none"%> 

<%

	Connection connection = null;
	PoolManager pool = PoolManager.getInstance();
	CallableStatement call = null;
	CallableStatement call1 = null;
	String errMsg ="";

	Category logCategory = Category.getInstance("SIS.register.SISupdateuserdetails");
	
	int customerId = Integer.parseInt(request.getParameter("customerid"));
	int userId = Integer.parseInt(request.getParameter("userId"));
	String login = request.getParameter("login");
	String password = request.getParameter("password");
	String newPassword = request.getParameter("newPassword"); 
	String loginLower = login.toLowerCase();

	int recordFound = 0;
	int countStatus = 0;

	Date d = new Date();
	long regDate=d.getTime()/1000;

	try
	{
		connection = pool.getConnection("erp"); 

		call=connection.prepareCall("{call ERP.ERP_USER_PKG.VALIDATE_LOGIN_NAME(?,?)}");
		call.setString(1,loginLower);
		call.registerOutParameter(2,OracleTypes.NUMBER);
		call.execute();
		recordFound = call.getInt(2);
	}

	catch(SQLException sql)
	{
		errMsg = "<b>ERR :</b> Some critical database problem. Please inform Tech Team.<br>"; 
		logCategory.error(sql);
	}
	catch(Exception ex){
		errMsg = "<b>ERR :</b>Some fatal execption occured. Please try after some time.<BR>";
		logCategory.error(ex);

	}finally
    {
	    try{call.close();}catch(Exception x){}
		pool.freeConnection("erp",connection);
    } 

	try
	{
		connection = pool.getConnection("erp");
		if(recordFound == 0 )
		{

			call1=connection.prepareCall("{call ERP.SIS_PKG.UPDATE_UNAME_PASSWORD(?,?,?)}");
			call1.setInt(1,userId);
			call1.setString(2,loginLower);
			call1.setString(3,password);
			call1.execute();
		}
	}
	catch(SQLException sql)
	{
		errMsg = "<b>ERR :</b> Some critical database problem. Please inform Tech Team.<br>"; 
		connection.rollback();
		logCategory.error(sql);
	}
	catch(Exception exec)
	{
		errMsg = "<b>ERR :</b>Some fatal execption occured. Please try after some time.<BR>";
		logCategory.error(exec);
	}

	finally
	{
		try
		{
			call1.close();
		}
		catch(Exception e){}
		pool.freeConnection("erp",connection); 

	}
	
%>

<html>
<head>
<title>Confirm Registration</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="/styles/style.css" type="text/css">

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
          <td><font class="cntblu"><a href="/" class="lnkblu">home</a><font class="cntblu">&gt;</font><a href="/sis/index.jsp" class="lnkblu">Login for SIS</a><font class="cntblu">&gt;</font><a href="/sis/register/SISlogincidanddob.html" class="lnkblu">Students can acquire a username/password</a>&gt;Confirm Registration</font></td>
</tr>
</table>
</td>
</tr>
 <tr> 
    <td bgcolor="B4BC6D"> 
      <table border="0" cellspacing="0" cellpadding="0">
        
        <tr> 
          <td width="8">&nbsp;</td>
          <td class="headblubld" height="34" valign="center">Confirm Registration&nbsp;&nbsp;&nbsp;</td>
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
	if(errMsg.length()==0) 
	{
		if(recordFound == 0)
		{
%>
			<BR><BR><p align="center"><font class="new"><b>
			Congratulations!</b></font> You are  now a registered user of SIS. </p>
			<BR> 
			</center></font>

			<form name=login action="/sis/auth.jsp" method="Post">
			<INPUT TYPE=hidden NAME="uname" value="<%=login%>"></input>
			<INPUT TYPE=hidden NAME="pwd" value="<%=password%>"></input>

			<center><INPUT TYPE=Submit  value="Go to SIS" class="goldBorder"></input></center>
			</form>

<%		
		}

		else
		{
%>

			<BR><BR><p align="center"><font class="new"><b>Sorry!</b>
			Somebody is already registered with the Username <b><%=login %></b>. Please go back and 	select some other User name.
			</font></p>
			<center><INPUT TYPE=Button  value="Back" onClick="history.back()" 	class="goldBorder"></input></center>
<%
		}
	}

	else
	{
%>
		<BR><BR><p align="center"><font class="new"><b>Sorry!</b>
		<%=errMsg%>
		</font></p>
		<center><INPUT TYPE=Button  value="Back" onClick="history.back()" 	class="goldBorder"></input></center>
<%
	}
%>
</td>
  </tr>
</table>
</body>
</html>
