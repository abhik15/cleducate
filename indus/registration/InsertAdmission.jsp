<!-- 
	 Author: Kamal Singh Deori
     Filename: InsertAdmissionIndus.jsp
     Date: 25 Nov 05
	 Desc: For Use of Indus Admission Registration
-->
<%@ page language="java" import ="java.sql.*,oracle.jdbc.driver.*,org.apache.log4j.*,com.cl.sql.PoolManager,javax.servlet.http.HttpSession"%>
<%
		//errorPage="/epage/IndusError.jsp"
	
		PoolManager pool = PoolManager.getInstance();
		Category logCategory = Category.getInstance("ananda.registration.InsertAdmissionIndus");
		Connection connection = null;
		CallableStatement call = null;

		String registrationId = "";
		double motherAnnualIncome=0.0;
		long motherMobile=0;
		double fatherAnnualIncome=0.0;
		long fatherMobile=0;
		int std=0;
		long telephone=0;
		String classApplied = request.getParameter("classapplied");
		String fName = request.getParameter("fname");
		String lName = request.getParameter("lname");
		String dateOfBirth = request.getParameter("cdate")+"/"+request.getParameter("cmonth")+"/"+request.getParameter("cyear");
		String sex = request.getParameter("sex");
		String perAddLine1 = request.getParameter("address1");
		String perAddLine2 = request.getParameter("address2");
		String perAddCity = request.getParameter("city");
		String perAddState = request.getParameter("state");
		long perAddZipCode = Long.parseLong(request.getParameter("zipcode"));
		if(request.getParameter("std").equals(""))
		{}
		else
		{
			std = Integer.parseInt(request.getParameter("std"));
		}
		if(request.getParameter("telephone").equals(""))
		{}
		else
		{
			telephone = Long.parseLong(request.getParameter("telephone"));
		}

		String motherName = request.getParameter("mname");
		String motherDob = request.getParameter("mdate")+"/"+request.getParameter("mmonth")+"/"+request.getParameter("myear");
		String motherQuali = request.getParameter("mqualification");
		String motherOccupation = request.getParameter("mpresentoccupation");
		if(request.getParameter("mannualincome").equals(""))
		{}
		else
		{
			motherAnnualIncome = Double.parseDouble(request.getParameter("mannualincome"));
		}
		String motherOrgName = request.getParameter("mofficename");
		if(request.getParameter("mmobile").equals(""))
		{}
		else
		{
			motherMobile = Long.parseLong(request.getParameter("mmobile"));
		}

		String motherEmail = request.getParameter("memail");
		String fatherName = request.getParameter("ffname");
		String fatherDob = request.getParameter("fdate")+"/"+request.getParameter("fmonth")+"/"+request.getParameter("fyear");
		String fatherQuali = request.getParameter("fqualification");
		String fatherOccupation = request.getParameter("fpresentoccupation");
		if(request.getParameter("fannualincome").equals(""))
		{}
		else
		{
			fatherAnnualIncome = Double.parseDouble(request.getParameter("fannualincome"));
		}
		String fatherOrgName = request.getParameter("fofficename");
		if(request.getParameter("fmobile").equals(""))
		{}
		else
		{
			fatherMobile = Long.parseLong(request.getParameter("fmobile"));
		}
		String fatherEmail = request.getParameter("femail");
		String liveIn = request.getParameter("live");
		int siblingsChild = Integer.parseInt(request.getParameter("noofsiblings"));

		int schoolId = Integer.parseInt(request.getParameter("schoolId"));

		try
		{
			connection = pool.getConnection("school");
			call = connection.prepareCall ("{call SCHOOL.ANANDA_REGISTRATION.ANANDA_ADMISSION(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			call.setInt(1,schoolId);
			call.setString(2,classApplied);
			call.setString(3,fName);
			call.setString(4,lName);
			call.setString(5,dateOfBirth);
			call.setString(6,sex);
			call.setString(7,perAddLine1);
			call.setString(8,perAddLine2);
			call.setString(9,perAddCity);
			call.setString(10,perAddState);
			call.setLong(11,perAddZipCode);
			call.setInt(12,std);
			call.setLong(13,telephone);
			call.setString(14,motherName);
			call.setString(15,motherDob);
			call.setString(16,motherQuali);
			call.setString(17,motherOccupation);
			call.setDouble(18,motherAnnualIncome);
			call.setString(19,motherOrgName);
			call.setLong(20,motherMobile);
			call.setString(21,motherEmail);
			call.setString(22,fatherName);
			call.setString(23,fatherDob);
			call.setString(24,fatherQuali);
			call.setString(25,fatherOccupation);
			call.setDouble(26,fatherAnnualIncome);
			call.setString(27,fatherOrgName);
			call.setLong(28,fatherMobile);
			call.setString(29,fatherEmail);
			call.setString(30,liveIn);
			call.setInt(31,siblingsChild);
			call.registerOutParameter(32,OracleTypes.NUMBER);

			call.execute();

			registrationId=""+call.getInt(32);

		}
		catch(SQLException x)
		{
			int errorCode = x.getErrorCode();
//			if(errorCode == 20000)
			{
				String errorMsg = x.toString();
				//errorMsg = errorMsg.substring(33);
//				errorMsg = errorMsg.substring(0,45);
				out.println("<center><br><br><font class=\"new\"><b>"+errorMsg+"</b></font><br><br><a href=\"JavaScript:history.back()\" class=\"lnkblu\">Back</a></center>");
			}
			
			return;
		}
		catch(Exception exec)
		{
			logCategory.error(exec);
			throw exec;
		}
		finally
		{
			try{call.close();}catch(Exception exec){}
			pool.freeConnection("school",connection);
		}

  	   session = request.getSession();
	   session.setAttribute("regId",registrationId);

  	   response.sendRedirect("ConfRegistration.jsp");   
%>
