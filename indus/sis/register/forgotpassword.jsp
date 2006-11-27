<%@ page import="java.io.*,java.sql.*,java.util.*,oracle.jdbc.driver.*,com.cl.sql.PoolManager" errorPage="/epage/anandaError.jsp"%>
<html><head></head><body>
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

		call.executeQuery();
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
			<td face="verdana" size="4"><b>Your password is: </b></td>
		</tr>

		<tr>
			<td>
			<center><font color=red size="2" face="verdana"><%=uname%> , <font color=navy>Your Password is:</font> <%=password%></font><BR><BR>
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