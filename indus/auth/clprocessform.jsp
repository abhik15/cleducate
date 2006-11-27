<%@ page import="java.sql.*,oracle.jdbc.driver.OracleTypes"%>
<%@ page import="org.apache.log4j.*" errorPage="/epage/CLError.jsp" buffer="none" %>

<jsp:useBean id="CLConn" class="com.cl.sql.CLConnectionManager" scope="application"/>
<%
	Connection connection = CLConn.getConnection("erp");
	Category logCategory = Category.getInstance("clsite.enrollonline");

	String login = request.getParameter("login");	//UNAME
	String password = request.getParameter("password");	//PASSWORD
	String customerid = request.getParameter("customerid");
	String fname = "";
	String email = "";

	PreparedStatement stat = null;
	ResultSet resultSet = null;
	try
	{
		String loginCheckQuery = "SELECT UNAME,PASSWORD FROM CL_WEB_USER WHERE UNAME = ?";

		stat = connection.prepareStatement(loginCheckQuery);
		stat.setString(1,login);
		resultSet = stat.executeQuery();
		boolean recFound = false;
		if(resultSet.next())
		{
			recFound = true;
		}
		if(resultSet != null)
		{
			resultSet.close();
		}
		if(stat != null)
		{
			stat.close();
		}

		if(recFound)
		{
			response.sendRedirect("clregform.jsp?message=Sorry ! Another careerlauncher student is already using this username. Please try another one.");
		}
		else 
		{
			int userid = 0;

			stat = connection.prepareStatement("Select cl_user_id_seq.nextval from dual");
			resultSet = stat.executeQuery();
			if(resultSet.next())
			{
				int x = resultSet.getInt(1);
				userid = x;
			}
			if(resultSet.next())
			{
				recFound = true;
			}
			if(resultSet != null)
			{
				resultSet.close();
			}
			if(stat != null)
			{
				stat.close();
			}

			String salutation = request.getParameter("salutation");	//SALUTATION
			fname = request.getParameter("fname");	//FNAME
			String mname = request.getParameter("mname");	//MNAME
			String lname = request.getParameter("lname");	//LNAME


			String contaddress1 = request.getParameter("contaddress1");//LINE1_CONTACT
			String contaddress2 = request.getParameter("contaddress2");//LINE2_CONTACT

			String othercountry = request.getParameter("othercountry");
			String otherstate = request.getParameter("otherstate");
			String othercity = request.getParameter("othercity");
	
			int country = Integer.parseInt(request.getParameter("country"));

			int state = 0;
			int city = 0;

			int stdcoderes = 0;
			int telres = 0;
			int stdcodework = 0;
			int telwork = 0;

			try
			{
				state = Integer.parseInt(request.getParameter("state"));
			}
			catch(NumberFormatException nfe)
			{
				state = 0;
			}

			try
			{
				city = Integer.parseInt(request.getParameter("city"));	
			}
			catch(NumberFormatException nfe)
			{
				city = 0;
			}

 			String pincode = request.getParameter("pincode"); //PIN_CONTACT
					
			try
			{
				stdcoderes = Integer.parseInt(request.getParameter("stdcoderes"));//CITY_STD_CODE_RES
			}
			catch(NumberFormatException nfe)
			{
				stdcoderes = 0;
			}

			try
			{
				telres = Integer.parseInt(request.getParameter("telres"));//TEL_NO_RES
			}
			catch(NumberFormatException nfe)
			{
				telres = 0;
			}

			try
			{
				stdcodework = Integer.parseInt(request.getParameter("stdcodework"));				
			}
			catch(NumberFormatException nfe)
			{
				stdcodework = 0;
			}

			try
			{
				telwork = Integer.parseInt(request.getParameter("telwork"));	//TEL_NO_WORK
			}
			catch(NumberFormatException nfe)
			{
				telwork = 0;
			}

			if((othercountry.trim().length() == 0))
			{
				
				if((otherstate.trim().length() == 0))
				{					
					if((othercity.trim().length() == 0))
					{
						
						
					}
					else
					{
						city = 0;
					}
				}
				else
				{
					state = 0;
					city = 0;		
				}										
			}
			else
			{
				country = 0;
				state = 0;
				city = 0;			
			}

			if((country == 0) || (state == 0) || (city == 0))
			{
				if(othercity != null & othercity.trim().length() > 0)
				{
					contaddress2 += ","+othercity;
				}
				if(otherstate != null & otherstate.trim().length() > 0)
				{
					contaddress2 += ","+otherstate;
				}
				if(othercountry != null & othercountry.trim().length() > 0)
				{
					contaddress2 += ","+othercountry;
				}
			}

			email = request.getParameter("email");

			String monthofbirth = request.getParameter("monthofbirth");
			String dayofbirth = request.getParameter("dayofbirth");
			String yearofbirth = request.getParameter("yearofbirth");
			String dateofbirth = dayofbirth+"/"+monthofbirth+"/"+yearofbirth;

			String profession = request.getParameter("profession");
			String organisation = request.getParameter("organisation");
			int edulevel = Integer.parseInt(request.getParameter("edulevel"));
			String spamflag = request.getParameter("spamflag");

			if(spamflag == null)
			{
				spamflag="N";
			}			
		

			String insertWebUser = "INSERT INTO CL_WEB_USER (USER_ID, UNAME, PASSWORD, FNAME, MNAME, ";
			insertWebUser += "LNAME, SALUTATION, LINE1_CONTACT, LINE2_CONTACT, CITY_ID_CONTACT, ";
			insertWebUser += "PIN_CONTACT, STATE_ID_CONTACT, COUNTRY_ID_CONTACT, CITY_STD_CODE_RES, ";
			insertWebUser += "TEL_NO_RES, CITY_STD_CODE_WORK, TEL_NO_WORK, EMAIL, USER_DOB, ";
			insertWebUser += "USER_PROFESSION, USER_ORG, EDU_LEVEL_ID, SPAM_OF_FLAG, RECORD_DATE, ";
			insertWebUser += "LAST_LOGIN_DATE, SOURCE_ID) VALUES(?,?,?,?,?,";
			insertWebUser += "?,?,?,?,?,";
			insertWebUser += "?,?,?,?,";
			insertWebUser += "?,?,?,?,TO_DATE(?,'DD/MM/YYYY'),";
			insertWebUser += "?,?,?,?,SYSDATE,";
			insertWebUser += "SYSDATE,?)";

			stat = connection.prepareStatement(insertWebUser);
			stat.setInt(1,userid);
			stat.setString(2,login);
			stat.setString(3,password);
			stat.setString(4,fname);
			if(mname == null)
			{
				stat.setNull(5,OracleTypes.VARCHAR);
			}
			else
			{
				stat.setString(5,mname);
			}

			if(lname == null)
			{
				stat.setNull(6,OracleTypes.VARCHAR);
			}
			else
			{
				stat.setString(6,lname);
			}
			
			stat.setString(7,salutation);
			stat.setString(8,contaddress1);

			if(contaddress2 == null)
			{
				stat.setNull(9,OracleTypes.VARCHAR);
			}
			else
			{
				stat.setString(9,contaddress2);
			}

			if(city == 0)
			{
				stat.setNull(10,OracleTypes.NUMBER);
			}
			else
			{
				stat.setInt(10,city);
			}

			if(pincode == null)
			{
				stat.setNull(11,OracleTypes.VARCHAR);
			}
			else
			{
				stat.setString(11,pincode);
			}
			
			if(state == 0)
			{
				stat.setNull(12,OracleTypes.NUMBER);
			}
			else
			{
				stat.setInt(12,state);
			}

			if(country == 0)
			{
				stat.setNull(13,OracleTypes.NUMBER);
			}
			else
			{
				stat.setInt(13,country);
			}

			if(stdcoderes == 0)
			{
				stat.setNull(14,OracleTypes.NUMBER);
			}
			else
			{
				stat.setInt(14,stdcoderes);
			}

			if(telres == 0)
			{
				stat.setNull(15,OracleTypes.NUMBER);
			}
			else
			{
				stat.setInt(15,telres);
			}

			if(stdcodework == 0)
			{
				stat.setNull(16,OracleTypes.NUMBER);
			}
			else
			{
				stat.setInt(16,stdcodework);
			}
			
			if(telwork == 0)
			{
				stat.setNull(17,OracleTypes.NUMBER);
			}
			else
			{
				stat.setInt(17,telwork);
			}
						
			stat.setString(18,email);
			stat.setString(19,dateofbirth);
			stat.setString(20,profession);
			if(organisation == null)
			{
				stat.setNull(21,OracleTypes.VARCHAR);
			}
			else
			{
				stat.setString(21,organisation);
			}

			if(edulevel == 0)
			{
				stat.setNull(22,OracleTypes.NUMBER);
			}
			else
			{
				stat.setInt(22,edulevel);
			}
			stat.setString(23,spamflag);
			stat.setInt(24,3);

			connection.setAutoCommit(false);
			stat.executeUpdate();

			connection.commit();
		}
	}
	catch(Exception exec)
	{
		connection.rollback();
		logCategory.error(exec);
		throw exec;
	}
	finally
	{
		try
		{
			if(resultSet != null)
			{
				resultSet.close();
			}
			if(stat != null)
			{
				stat.close();
			}
			resultSet = null;
			stat = null;
		}
		catch(Exception ex){}
	}
		
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="/styles/style.css" type="text/css">
<title>Online Enrollment : Registration</title>
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
    <td bgcolor="DFE1BC" height="450" valign="top" align="left">&nbsp;</td>
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

	
	<BR><BR><font color=navy size=2 face=verdana><center><font color=red size=2 face=verdana>Thank you, <B><%=fname%> !</B></font> You are  now a registered user of our web-site. 
	</center></font>

<%

	/************************ Mailer Auto Responder******************************************/
			try
			{
				String mailBody = "Dear " +fname+ ",\n \n" ;
				mailBody += "Thank you for registering on www.careerlauncher.com.\n\n";
				mailBody += "It gives us immense pleasure to inform you that you are now associated with one of the leading companies in the field of preparatory education. Started in 1995 with a desire to give much needed guidance to students to help them clear prestigious entrance exams, Career Launcher assists over 10,000 students every year to shape up their careers through its various services. At present we run preparatory programs for MBA, MCA, IIT-JEE/Engineering exams, Hotel Management, Law, BBA, BCA and Fashion Design.\n\n";
				mailBody += "Career Launcher also provides students with career guidance services with its programme FutureMap and for those students who seek to guidance and training to prepare for their CBSE or SSC exams, we have created www.compassbox.com.\n\nCareerLauncher.com is also an integral part of Career Launcher's services as we seek to provide similar services via our site especially to students in cities where Career Launcher does not have an offline presence. Added to this we also aim to make our site our most efficient Customer Service Representative, which apart from providing content of a very high quality will also provide other value added services to all our customers like the convenience to enrol for our programmes online, providing customised feedback and guidance, online testing and many more.\n\n";
				mailBody += "We look forward to a mutually fruitful association with you in the coming years.\n\n";
				mailBody += "All the best for your career.\n\n";
				mailBody += "Regards,\n\n";
				mailBody += "The Career Launcher Team";
				String subjectOfMail = "Congratulations On Taking The First Step Towards Your Dream Career";

				com.cl.email.EMailSender sendmail = new com.cl.email.EMailSender();
				String mailIds[] = new String[1];
				mailIds[0] = email;				
				sendmail.sendMail(mailIds,mailBody,subjectOfMail,"smtp.net4india.com","customerservice@careerlauncher.com","clprocessform.jsp","text/plain");	
			}
			catch(Exception ex)
			{
				try
				{
					logCategory.error(ex);
				}
				catch(Exception exec){}
			}
%>
</body>
</HTML>
