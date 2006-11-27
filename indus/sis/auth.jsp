<%@ page import="java.sql.*,oracle.jdbc.driver.*" %>
<%@ page import="com.cl.sql.PoolManager,org.apache.log4j.*" errorPage="/epage/anandaError.jsp"%>

<%
	Category logCategory = Category.getInstance("school.auth");
	PoolManager poolManager = PoolManager.getInstance();
		
	CallableStatement enrCstmt=null;
	Connection connection = null;
	String uName = request.getParameter("uname");
	String uPassword = request.getParameter("pwd");
	
	String fname = "";
	String lname = "";
	String email = "";
	int locId = 0;

	int userID = 0;
	try
	{
		connection = poolManager.getConnection("erp");
		enrCstmt=connection.prepareCall("{CALL ERP.ERP_USER_PKG.VALIDATE_WEB_USER_LOGIN(?,?,?,?,?,?,?)}");
        enrCstmt.setString(1,uName);
		enrCstmt.setString(2,uPassword);
		enrCstmt.registerOutParameter(3,OracleTypes.NUMBER);
		enrCstmt.registerOutParameter(4,OracleTypes.VARCHAR);
		enrCstmt.registerOutParameter(5,OracleTypes.VARCHAR);
		enrCstmt.registerOutParameter(6,OracleTypes.VARCHAR);
		enrCstmt.registerOutParameter(7,OracleTypes.NUMBER);
		enrCstmt.execute();
		userID = enrCstmt.getInt(3);
		fname = enrCstmt.getString(4);
		lname = enrCstmt.getString(5);
		email = enrCstmt.getString(6);
		locId = enrCstmt.getInt(7);
		session.putValue("uid",""+userID);
		session.putValue("fname",fname);
		session.putValue("lname",lname);
		session.putValue("uName",uName);
		session.putValue("locId",""+locId);

		enrCstmt = null;
	}
	catch(Exception ex)
	{
		System.out.println("Exception "+ex);
		logCategory.error(ex);
		throw ex;    
	}
	finally
	{
		poolManager.freeConnection("erp", connection);

		if(enrCstmt != null)
		{
			enrCstmt.close();
		}
		
	}
		
		if(userID == 0)
		{
			response.sendRedirect("index.jsp?message=Invalide username/password. Please login again");
		}
		else
		{
%>
			<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
<%
			response.sendRedirect("sis.jsp");	
			
		}
	
%>