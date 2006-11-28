<!--
	*Created by Amrendra Kumar
	*Date of Creation: 27-11-06
	*This page is used for to retrieve his current password if he forgot his password.
	
-->

<%@ page import="java.io.*,java.sql.*,java.util.*,oracle.jdbc.driver.*,com.cl.sql.PoolManager" errorPage="/epage/anandaError.jsp"%>
<html><head>
	<link href="/styles/indus.css" rel="stylesheet" type="text/css" /> 
</head><body>
<%
	Connection connection = null;
	PoolManager poolManager = PoolManager.getInstance();
	CallableStatement call=null;
	String login=request.getParameter("login");	//UNAME

	String monthofbirth=request.getParameter("monthofbirth");
	String dayofbirth=request.getParameter("dayofbirth");
	String yearofbirth=request.getParameter("yearofbirth");
	String dateofbirth=dayofbirth+"-"+monthofbirth+"-"+yearofbirth;
	String uname="";
	String password="";
	try
	{
		connection = poolManager.getConnection("erp");
		call=connection.prepareCall("{CALL SIS_PKG.GET_PASSWORD(?,?,?,?)}");
		call.setString(1,login);
		call.setString(2,dateofbirth);
		call.registerOutParameter(3,OracleTypes.VARCHAR);
		call.registerOutParameter(4,OracleTypes.NUMBER);

		call.execute();
		uname=login;
		int record = call.getInt(4);
		if(record != 0)
		{
			password=call.getString(3);
%>

		<table border="0" width="100%"  cellspacing="0" cellpadding="0">
		<tr>
		 <td width="100%">
			<table border="0" width="100%" bgcolor="#474AC2" cellspacing="1" cellpadding="0">
        			<tr>
          				<td width="100%"><div align="center"><center><p>
						<font face="Arial" color="#FFFFFF">
			 			<big><big><I><U>INDUS WORLD SCHOOL</U></I>
						 </big></big></font>
		  			</td>
        			</tr>
      			</table>
		 </td>
		</tr>

		<tr>
			<td><BR></td>
		</tr>
		<tr>
			<td face="verdana" size="4" align="center"><b>Your password is successfully retrieved </b></td>
		</tr>

		<tr>
			<td>
			<center><font color=red size="2" face="verdana"><br>User Name :-&nbsp;<%=uname%>  <font color=navy><br><br>Your Password is:-&nbsp;</font> <%=password%></font><BR><BR>
			</center>
			
			
			</td>
		</tr>
		</table>

<%
	}
	else
	{
		out.println(" <h3><font color=red>Invalid Login Name or Incorrect Date Of Birth, Try Again</font></h3>");
%>

<%@ include file="forgotpassword.html" %>

<%
	}
	}
	catch(Exception ex)
	{
		System.out.println(ex.toString());
	}
	finally
	{
		poolManager.freeConnection("erp", connection);
		try{call.close();}catch(Exception ex){}
	}
%>

		<center><INPUT TYPE="Button"  value="close" onClick="window.close()" 	class="inpBrd"></input></center>