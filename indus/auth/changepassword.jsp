<%@ page import="com.cl.sql.SISPoolManager2,java.sql.*,oracle.jdbc.driver.*,org.apache.log4j.*"  buffer="none" errorPage="/epage/SISErrorFile.jsp"%> 
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>

<html>
<head>
<title>Change password</title>
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

	</td>
	</tr>
		
		 
  <!-- checkkkkkkkkkkkkkkkkkkkkkkk -->
  <tr> 
    <td colspan="2" bgcolor="DFE1BC" align="left" valign="top">
		<cl:CLMsgSisLeftBandTag category="2" level="0"/>
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
		  <font class="cntblu"> &gt; </font> <a href="/sis/SIS.jsp" class="lnkblu">SIS page</a> <font class="cntblu">&gt;</font>Change password
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
          <td class="headblubld" height="34" valign="center">Change password&nbsp;&nbsp;&nbsp;<img src="/img/arrow.gif" align="absmiddle"></td>
        </tr>
        
      </table>
  </tr>
  <tr> 
    <td colspan="2" height="23">
<%
	SISPoolManager2 pool = SISPoolManager2.getInstance();
	Connection connection = null;

	Category logCategory = Category.getInstance("clsite.auth.editProfile");

	String login=session.getAttribute("login").toString();
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
	Statement stat1 = null;
	ResultSet identification = null;
	PreparedStatement pstmt=null;
	try
	{
		connection = pool.getConnection("erp");
		if(!login.equals("mbacracker"))
		{
			stat1 = connection.createStatement();
			//String query ="SELECT UNAME,PASSWORD FROM CL_WEB_USER WHERE UNAME='" + login + "' AND PASSWORD='" + oldpassword + "'";
			pstmt=connection.prepareStatement("SELECT UNAME,PASSWORD FROM CL_WEB_USER WHERE UNAME=? AND PASSWORD=?");

			pstmt.setString(1,login);
			pstmt.setString(2,oldpassword);

			identification=pstmt.executeQuery();

			//identification = stat1.executeQuery(query);
			if(identification.next())
			{

				String insertquery = "UPDATE CL_WEB_USER SET PASSWORD='" + newpassword 
										+ "' WHERE UNAME='" + login + "'" 
										+ "AND PASSWORD='"  + oldpassword + "'";
				int numrows = stat1.executeUpdate(insertquery);
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
		else
		{
		%>
				<BR><BR><center>
				<img src="/img/sorry.gif" border=0 alt=""><br><br>
				<font class="lnkbld">Sorry! you cannot change the password for mbacracker, its a demo username</font>
				<BR><BR>
				</center>
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
				stat1.close();
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