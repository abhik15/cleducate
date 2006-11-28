

<%@ page import="java.sql.*,java.util.*,oracle.jdbc.driver.*,com.cl.sql.PoolManager,org.apache.log4j.*" errorPage="/epage/anandaError.jsp" %>

<html>
<head>
<title>Proceed for SIS</title>
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
          <td><font class="cntblu"><a href="/" class="lnkblu">home</a><font class="cntblu">&gt;</font><a href="/sis/SISLogin.jsp" class="lnkblu">Login for SIS</a><font class="cntblu">&gt;</font><a href="/sis/register/SISlogincidanddob.html" class="lnkblu">Students can acquire a login/password</a>&gt;Proceed for SIS</font></td>
</tr>
</table>
</td>
</tr>
 <tr> 
    <td bgcolor="BACFE5"> 
      <table border="0" cellspacing="0" cellpadding="0">
        
        <tr> 
          <td width="8">&nbsp;</td>
          <td class="headblubld" height="34" valign="center">Proceed for SIS</td>
        </tr>
        
      </table>
	  </td>
  </tr>
</table>

<br>
<br>
<br>
<br>
<table width="60%" border="0" cellspacing="0" cellpadding="0" align="left">
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


String login=request.getParameter("login");	//UNAME
String password=request.getParameter("password");
String customerid = request.getParameter("customerid");
	

Connection connection = null;
CallableStatement call = null;
CallableStatement call1 = null;

Statement stat = null;

ResultSet identification = null;

PoolManager pool = PoolManager.getInstance();
Category logCategory = Category.getInstance("SIS.register.SISloginwhenonlypassword");

try
{
	connection = pool.getConnection("erp"); 

	call=connection.prepareCall("{call ERP.ERP_USER_PKG.VALIDATE_WEB_USER_LOGIN(?,?,?)}");
	call.setString(1,login);
	call.setString(2,password);
	call.registerOutParameter(3,OracleTypes.NUMBER);
	call.execute();
	int tempuid = call.getInt(3);
	if(tempuid > 0)
	{
		
			
%>


<FORM METHOD=POST ACTION="/sis/auth.jsp" name="form1">
<input type="hidden" name="userName" value="<%=login %>">
<input type="hidden" name="password" value="<%=password %>">
</FORM>	
<script language="JavaScript">
document.form1.submit();
</script>
		
<%
			
	}
	else
	{
		
%>
		<BR><BR><p align="center"><font class="new">
		<strong>Invalid password for this User Name.</strong>
		</font><p><BR>
		<form name=login1  method="Post">
		<center><INPUT TYPE=Button  value="Back" onClick="history.back()" class="goldBorder"></input></center>
		</form>



<%
	}

}catch(Exception ex){
	logCategory.error(ex);
	throw ex;
}finally
{
   try{call.close();}catch(Exception x){}
   try{call1.close();}catch(Exception x){}
   pool.freeConnection("erp",connection);
} 
%>

</td>
  </tr>
</table>
</body>
</html>
