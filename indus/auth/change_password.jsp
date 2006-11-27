<%@ page import = "com.cl.sql.PoolManager,java.sql.*,oracle.jdbc.driver.OracleTypes" %>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl"%>
<jsp:useBean id="StudentLogin" scope="session" class="com.cl.sis.student.SISStudentLogin"/>

<%
 int userID=StudentLogin.getUserID();
 				System.out.println(userID);
                String oldPassword=request.getParameter("oldpassword");;
                System.out.println(oldPassword);
				String newPassword=request.getParameter("newpassword");
System.out.println(newPassword);

		Connection connection = null;
		PoolManager poolManager = PoolManager.getInstance();
		CallableStatement ocs = null;
		String tmpResult = "";
		try
		{//opening brace for main try block
			connection = poolManager.getConnection("erp");
			ocs =connection.prepareCall("{call sat.change_password(?,?,?,?)}");
		
			ocs.setInt(1, userID);
			ocs.setString(2,oldPassword);
			ocs.setString(3, newPassword);
			ocs.registerOutParameter(4, OracleTypes.VARCHAR);
			ocs.execute();
	
			tmpResult = ocs.getString(4);
			if (tmpResult.startsWith("$"))
			{
				connection.commit();
			}
            ocs.close();
		}//closing brace of mmain try block
		catch(Exception sqle)
		{
System.out.println(sqle.toString());
}
		finally
		{//opening brace for finally block
			if (ocs!=null)
			{
					ocs.close();
				}
			poolManager.freeConnection("erp", connection);
}//closing brace for finally block
%>
<html>
<head>
<title>Change Password Results</title>
</head>
<body>
<%=tmpResult%>
</body>
</html>