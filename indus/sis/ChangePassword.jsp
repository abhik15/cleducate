<%@ page import="java.io.*,java.sql.*,java.util.*,oracle.jdbc.driver.*,com.cl.sql.PoolManager,org.apache.log4j.*" %>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>
<cl:CLValidateSessionTag userType="CUSTOMER"/>

<html>
<head>
<title>Change password</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="/styles/style.css" type="text/css">
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
    <td colspan="2" bgcolor="DFE1BC" align="left" valign="top"><br><br><br><br><br></td></tr>
</table>
<table width="79%" border="0" cellspacing="3" cellpadding="0" align="left">
  <tr> 
    <td colspan="2" bgcolor="B4BC6D"> 
      <table border="0" cellspacing="0" cellpadding="0" align="left">
        <tr> 
          <td bgcolor="B4BC6D"  width="8" align="left" valign="top" height="32"><img src="/img/blank.gif" width="1" height="32"></td>
          <td align="left" valign="middle"><font class="cntblu"><a href="/" class="lnkblu">Home</a> 
		  <font class="cntblu"> &gt; </font> <a href="/sis/index.jsp" class="lnkblu">SIS page</a> <font class="cntblu">&gt;</font>Change password
          </a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td bgcolor="BACFE5"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        
        <tr> 
          <td width="8">&nbsp;</td>
          <td class="headblubld" height="34" valign="center">Change password&nbsp;&nbsp;&nbsp;</td>
        </tr>
        
      </table>
  </tr>
  <tr> 
    <td colspan="2" height="23">
<%
	PoolManager pool = PoolManager.getInstance();
	Connection connection = null;
	ResultSet identification=null;
	Category logCategory = Category.getInstance("indus.sis.changepwd");

	String login=session.getAttribute("uid").toString();
	String oldpassword=request.getParameter("oldpassword");
	String newpassword=request.getParameter("newpassword");
	String confirmNewPwd = request.getParameter("confirmnewpassword");
	if (!confirmNewPwd.equals(newpassword))
	{
				%>
				<script language="JavaScript">
				<!--
					alert("Mismatch in values for New Password and Confirm New Password. Please re-enter.");
					history.back();
				//-->
				</script>
<%
	}
	CallableStatement call = null;

	PreparedStatement pstmt=null;
	try
	{
		connection = pool.getConnection("erp");
		pstmt=connection.prepareStatement("SELECT UNAME,PASSWORD FROM CL_WEB_USER WHERE UNAME=? AND PASSWORD=?");

		pstmt.setString(1,login);
		pstmt.setString(2,oldpassword);

		identification=pstmt.executeQuery();

		if(identification.next())
		{

			call=connection.prepareCall("{CALL SIS_PKG.CHANGE_PASSWORD(?,?,?)}");
			call.setString(1,login);
			call.setString(2,oldpassword);
			call.setString(3,newpassword);
			call.execute();
			connection.commit();
			out.println();
	%>
				<BR><BR><center>
				<img src="/img/smiley.gif" width="95" height="95" border=0 alt=""><br><br>
				<font class="lnkbld">Your Password has been successfully changed.</font>
				<BR><BR>
				</center>
				<%
			}
			else
			{
				%>
				<script language="JavaScript">
				<!--
					alert("Invalid User Name or Password, Try Again.");
					history.back();
				//-->
				</script>
				<%
			}
		}
	
		catch(Exception ex)
		{
			connection.rollback();
			logCategory.error(ex);
			throw ex;
		}
		finally
		{
			pool.freeConnection("erp",connection);
			try
			{
				identification.close();
				call.close();
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