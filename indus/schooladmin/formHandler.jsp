<!-- 
	 Author: Kamal Singh Deori
     Filename: SchoolReports.jsp
     Date: 21 Dec 05
	 Desc: For Display of School Reports
-->
<%@ page language="java" import ="java.sql.*,oracle.jdbc.driver.*,org.apache.log4j.*,com.cl.sql.PoolManager"%>
<%
		//errorPage="/epage/AnandaError.jsp"
	
		PoolManager pool = PoolManager.getInstance();
		Category logCategory = Category.getInstance("ananda.admin.SchoolReports");
		Connection connection = null;
		CallableStatement call = null;
		ResultSet schoolReport=null;
		// Grab the variables from the form.
	    String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		int schoolId = Integer.parseInt(request.getParameter("locationId"));
		String schoolName="";
		if(schoolId==2)
			schoolName="Ananda - Hyderabad:Sainik Puri";
		else if(schoolId==4)
			schoolName="Ananda - Indore:Sai Kirpa Colony";
			else if(schoolId==1)
			schoolName="Indus - Hyderabad:Sainik Puri";
			else if(schoolId==3)
			schoolName="Indus - Indore:Sai Kirpa Colony";
%>
<html>
<title></title>
<head></head>
<link rel="stylesheet" href="/styles/ananda.css" type="text/css">
<body>
<img src=/img/ananda_logo.jpg><br><br>
<table WIDTH="100%" cellspacing="0" cellpadding="4" border="1" bordercolorlight="#5E5E5D" bordercolordark="#ffffff" class="runningtext">
<tr><td colspan=17 align=left><strong><font color=blue>Enrollment details between <%=startDate%> and <%=endDate%> for location:<%=schoolName%></font></strong>
</td></tr>
<tr>
<td align=center><strong>SERIAL NO.</td>
<td align=center><strong>CLASS NAME</td>
<td align=center><strong>FIRST NAME</td>
<td align=center><strong>LAST NAME</td>
<td align=center><strong>DATE OF BIRTH</td>
<td align=center><strong>SEX</td>
<td align=center><strong>PER ADD LINE1</td>
<td align=center><strong>PER ADD LINE2</td>
<td align=center><strong>PER ADD CITY</td>
<td align=center><strong>PER ADD STATE</td>
<td align=center><strong>PER ADD ZIP CODE</td>
<td align=center><strong>MOTHER NAME</td>
<td align=center><strong>FATHER NAME</td>
<td align=center><strong>MOTHER MOBILE</td>
<td align=center><strong>FATHER MOBILE</td>
<td align=center><strong>MOTHER EMAIL</td>
<td align=center><strong>FATHER EMAIL</td>
</tr>
<%
		int counter=1;
		try
		{
			connection = pool.getConnection("school");
			call = connection.prepareCall ("{call SCHOOL.SCHOOL_REPORTS.GET_ENROLL_DETAILS(?,?,?,?)}");
			call.setString(1,startDate);
			call.setString(2,endDate);
			call.setInt(3,schoolId);
			call.registerOutParameter(4,OracleTypes.CURSOR);

			call.execute();

			schoolReport=(ResultSet)call.getObject(4);

			while(schoolReport.next())
			{
%>
				<tr>
					<td><%=counter%></td>
					<td><%=schoolReport.getString("class")%></td>
					<td><%=schoolReport.getString("FNAME")%></td>
					<td><%=schoolReport.getString("lname")%></td>
					<td><%=schoolReport.getDate("DATE_OF_BIRTH")%></td>
					<td><%=schoolReport.getString("SEX")%></td>
					<td><%=schoolReport.getString("PER_ADD_LINE_1")%></td>
					<td><%=schoolReport.getString("PER_ADD_LINE_2")%></td>
					<td><%=schoolReport.getString("PER_ADD_CITY")%></td>
					<td><%=schoolReport.getString("PER_ADD_STATE")%></td>
					<td><%=schoolReport.getInt("PER_ADD_ZIP_CODE")%></td>
					<td><%=schoolReport.getString("MOTHER_NAME")%></td>
					<td><%=schoolReport.getString("FATHER_NAME")%></td>
					<td><%=schoolReport.getLong("MOTHER_MOBILE")%></td>
					<td><%=schoolReport.getLong("FATHER_MOBILE")%></td>
					<td><%=schoolReport.getString("MOTHER_EMAIL")%></td>
					<td><%=schoolReport.getString("FATHER_EMAIL")%></td>
				</tr>
<%
				counter++;
			}
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

		if(counter==1)
		{
%>
			<script language="JavaScript">
				alert("There are no Record....");
				history.back();
			</script>
<%
			return;
		}
%>
</body>
</html>