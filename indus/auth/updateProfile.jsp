<%@ page import="java.sql.*,oracle.jdbc.driver.*" buffer="none"%>
<%@ page import="org.apache.log4j.*" errorPage="/epage/CLError.jsp" buffer="none" %>
<jsp:useBean id="CLConn" class="com.cl.sql.CLConnectionManager" scope="application"/>
<jsp:useBean id="form" class="com.cl.common.CLFormEssentials" scope="application"/>
<%
	Connection connection = CLConn.getConnection("erp");
	Category logCategory = Category.getInstance("clsite.auth.updateProfile");
	CallableStatement call = null;

	String uname = request.getParameter("uname");
	String password = request.getParameter("password");
	int res_isd = 0;
	int mobile = 0;
	int webuserid = 0;
	String loginname = request.getParameter("uname");
	int inquiryid = 0;
	int prospectid = 0;
	int customerid = 0;
	int sosid=0;
	String salutation = request.getParameter("salutation");
	String dateofbirth = request.getParameter("dateofbirth");
	String fname = request.getParameter("fname");
	String mname = request.getParameter("mname");
	String lname = request.getParameter("lname");
	String email = request.getParameter("email");
	String addline1 = request.getParameter("addline1");
	String addline2 = request.getParameter("addline2");
	int countryIdContact = Integer.parseInt(request.getParameter("countryIdContact"));
	int stateIdContact = Integer.parseInt(request.getParameter("stateIdContact"));
	int cityIdContact = Integer.parseInt(request.getParameter("cityIdContact"));
	String othercitycontact = request.getParameter("othercitycontact");
	String pin = request.getParameter("pin");
	int std = Integer.parseInt(request.getParameter("std"));
	int phno = Integer.parseInt(request.getParameter("phno"));
	String subcribe = request.getParameter("subcribe");
	res_isd = Integer.parseInt(request.getParameter("res_isd"));
	mobile = Integer.parseInt(request.getParameter("mobile"));
	webuserid = Integer.parseInt(request.getParameter("userid"));
	if(subcribe==null)
	{
		subcribe="N";
	}
%>
<html>
<head>
<title>Update Profile</title>
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
    <td bgcolor="DFE1BC" height="10" valign="top" align="left">&nbsp;</td>
  </tr>
</table>
<table width="79%" border="0" cellspacing="3" cellpadding="0" align="left">
  <tr> 
    <td colspan="2" bgcolor="B4BC6D"> 
      <table border="0" cellspacing="0" cellpadding="0" align="left">
        <tr> 
          <td bgcolor="B4BC6D"  width="8" align="left" valign="top" height="32"><img src="/img/blank.gif" width="1" height="32"></td>
          <td align="left" valign="middle"><font class="cntblu"><a href="/" class="lnkblu">Home</a>
		  <font class="cntblu">&gt;</font>Update Profile
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
          <td class="headblubld" height="34" valign="center">Update Profile&nbsp;&nbsp;&nbsp;<img src="/img/arrow.gif" align="absmiddle"></td>
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
	connection.setAutoCommit(false);
	call = connection.prepareCall ("{call ERP_USER_PKG.UPD_CL_USER_RECORD(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
	call.setInt(1,webuserid);
	call.setString(2,fname);
	call.setString(3,mname);
	call.setString(4,lname);
	call.setString(5,salutation);
	call.setString(6,addline1);
	call.setString(7,addline2);
	call.setInt(8,cityIdContact);
	call.setString(9,pin);
	call.setInt(10,stateIdContact);
	call.setInt(11,countryIdContact);
	call.setInt(12,std);
	call.setInt(13,phno);
	call.setString(14,email);
	call.registerOutParameter(15,OracleTypes.NUMBER);
	call.setString(16,uname);
	call.setString(17,password);
	call.setInt(18,res_isd);
	call.setInt(19,mobile);

	try
	{
		call.execute();
%>
		<center><br>
		<font class="lnkbld">Thanks <%=fname%></font><br><br>
			<img src="/img/smiley.gif" width="95" height="95" border=0 alt="">
			<br><br>
			<font class="cntblu">Your profile has been succefuly updated</font>
		</center>
<%
		connection.commit(); 
	}
	catch(Exception exec)
	{
		logCategory.error(exec);
		throw exec;
	}
	finally
	{
		try
		{
			call.close();
		}
		catch(Exception ex)
		{}
	}
%>
</td></tr></table>
</body>
</html>