<%@ page import = "java.util.*,java.io.*"%>
<%@ page import="java.sql.*,oracle.jdbc.driver.*" %>
<%@ page import="com.cl.sql.PoolManager,org.apache.log4j.*"%>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>
<cl:CLValidateSessionTag userType="CUSTOMER"/>
<%
	PoolManager poolManager = PoolManager.getInstance();
	int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
	
	String message = "";

	Connection connection = null;
	Category logCategory = Category.getInstance("feedback");

	CallableStatement call = null;
	ResultSet resultset = null;
	boolean error = false;
%>
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="/styles/style.css" type="text/css">

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Indus - Indore</title>
</style>
<link href="/styles/indus.css" rel="stylesheet" type="text/css" /> 
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="1" align="left" valign="top" bgcolor="#E0E0E0"><img src="/ananda/img/1x1.gif" width="1" height="1" /></td>
    <td align="left" valign="top"><img src="/img/learner.gif" width="175" height="152" border="0" usemap="#Map2" /></td>
    <td width="602" align="left" valign="top"><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="602" height="152">
      <param name="movie" value="/swf/learner.swf" />
      <param name="quality" value="high" />
      <embed src="/swf/learner.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="602" height="152"></embed>
    </object></td>
  </tr>
</table>
	<center><table WIDTH="100%" cellspacing="0" cellpadding="3" border="1" bordercolorlight="#999999" bordercolordark="#ffffff" class="pcnt">
	<TR class="lnkbld">
		<TD>ACTIVITY</TD>
		<TD>ACTIVITY_DATE</TD>
		<TD>FEEDBACK_DATE</TD>
		<TD>FEEDBACK</TD>
	</TR>
<%
	try
	{
		connection = poolManager.getConnection("erp");

		call = connection.prepareCall("{CALL cl_feedback.get_feedback_detail(?,?)}");
		call.registerOutParameter(1, OracleTypes.CURSOR);
		call.setInt(2,feedbackId);

		call.execute();
		resultset = (ResultSet)call.getObject(1);
		while(resultset.next())
		{
%>
			<TR class="pcnt">
				<TD><%=resultset.getString("ACTIVITY")%></TD>
				<TD><%=resultset.getString("ACTIVITY_DATE")%></TD>
				<TD><%=resultset.getString("FEEDBACK_DATE")%></TD>
				<TD><%=resultset.getString("FEEDBACK")%></TD>
			</TR>
			
<%
		}
	}
	catch(SQLException sqle)
	{
		logCategory.error(sqle);
		error = true;
		out.println(sqle.toString());
	}
	finally
	{
		poolManager.freeConnection("erp", connection);
		try
		{ call.close(); }
		catch(Exception ex)
		{
			logCategory.error(ex);
		}
	}

	if(error)
	{
		message = "failed";
	}
%>
</TABLE></center>
</body>
</html>