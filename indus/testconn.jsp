<%@ page import = "java.sql.*,oracle.jdbc.driver.OracleTypes,org.apache.log4j.*,java.io.*,com.cl.sql.PoolManager" %>
<%
	PoolManager poolManager = PoolManager.getInstance();		
	Connection conn = poolManager.getConnection("school");

	if (conn == null)
		out.println("Null connection");
	else
		out.println("good connection");

%>