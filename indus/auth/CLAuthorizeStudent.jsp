<%--
  -- @Filename CLAuthorizeStudent.jsp
  -- @Version 2.4
  -- @Author Shilpa Arora
  -- @Creation Date August 29, 2001
  -- @Version Date nov 23,2001
  --%>

<%--
  -- @Change History
  -- @Author Shilpa Arora
  -- @Date sep 17,2001
  -- @Version 2.0
  -- 1. The name of the file changed to CLAuthorizeStudent.jsp from SISAuthorizeStudent.jsp.
  -- 2. The file now accepts two parameters...
  --    @param source The URL of the page fired the request for this page
  --    @param sourceProductID The related productID of that URL
  -- 3. The resulting redirection is always to the URL provided in the source.
  --
  -- @Author Shilpa Arora
  -- @Date sep 21,01
  -- @version 2.1
  -- 1.StudentLogin.setUserID(rs.getInt("enroll_id_id"));--->StudentLogin.setUserID(rs.getInt("user_id"));
  --
  -- @author Shilpa Arora
  -- @date nov 16,2001
  -- @version 2.2
  -- 1. CustomerID setted for SISStudentLogin Bean.
  --
  -- @author Shilpa Arora
  -- @date nov 23,2001
  -- @version 2.3
  -- 1. JDBC Statements converted to PreparedStatements
  --
  -- @author Shilpa Arora
  -- @date nov 27,2001
  -- @version 2.4
  -- 1. Session timeout added(8 mtns)
  -- 
  -- @author Shilpa Arora
  -- @date nov 28,2001
  -- @version 2.5
  -- 1. Password setted for the bean
  --
  --%>
  
<%-- @Special Comments
  -- 1. when uploaded on sun the the connection file is loaded as
  -- SISConn.loadConnectionParameters("/usr/local/apache/wf_connection.properties","bdc_server");
--%>

<%@ page import="java.sql.*,oracle.jdbc.driver.*,com.cl.sql.SISPoolManager2" errorPage="/epage/CLError.jsp"%> 

<jsp:useBean id="StudentLogin" scope="session" class="com.cl.sis.student.SISStudentLogin"/>
<jsp:useBean id="StudentInfo" scope="session" class="com.cl.sis.student.SISStudentInfo"/>

<jsp:useBean id="Systems" scope="application" class="com.cl.CLSystems"/>

<jsp:useBean id="SISExp" scope="application" class="com.cl.sis.exception.SISException"/>
<jsp:setProperty name="SISExp" property="fileName" value="CLAuthorizeStudent.jsp"/>

<%
	String logFile=application.getRealPath("/logs/error/")+"SISErrorLog.log";
	SISExp.setErrorFileName(logFile);

	Connection connection=null;
	SISPoolManager2 pool = SISPoolManager2.getInstance();

	PreparedStatement pstmt=null;
	ResultSet rs = null;
	
	String userName=request.getParameter("userName");
	String password=request.getParameter("password");
	String source=request.getParameter("source");
	String target=request.getParameter("target");

	String productID="|0|";
	String productCategory ="|";
	String enrollStatus="na";
	String sourceProductID=request.getParameter("sourceProductID");
	Statement stmt=null;
	try
	{
		connection = pool.getConnection("erp");
	
		pstmt=connection.prepareStatement("select initcap(a.fname) fname,initcap(a.lname) lname, a.user_id, email from cl_web_user a where uname=? and password=?");
		pstmt.setString(1,userName);
		pstmt.setString(2,password);
		rs=pstmt.executeQuery();
		if(rs.next())
		{
			StudentLogin.setFirstName(rs.getString("fname"));
			String lname = rs.getString("lname");
			if(lname == null)
				lname = "";
			StudentLogin.setLastName(lname);
			StudentLogin.setPassword(password);
			/////////////////////////////////////////////////
			/////////change made by Shilpa Arora on 21 sep,01
			///////// StudentLogin.setUserID(rs.getInt("enroll_id_id"));--->StudentLogin.setUserID(rs.getInt("user_id"));
			//////////////////////////////////////////////////////
			StudentLogin.setUserID(rs.getInt("user_id"));
			StudentInfo.setEmail(rs.getString("email"));
		}
		else 
		{
%>
		<jsp:setProperty name="StudentLogin" property="loggedIn" value="false"/>
		<jsp:forward page="<%=source%>" >
		<jsp:param name="message" value="Invalid login or password, please note that login and password is case sensitive." />
		<jsp:param name="target" value="<%=target%>" />		
		<jsp:param name="source" value="<%=source%>" />
		</jsp:forward>

<%
		}
			
	if(StudentLogin.getUserID() > 0)
	{
		try
		{
			pstmt = connection.prepareStatement("select a.cust_id,b.prod_id,b.enroll_status,b.enroll_id,c.prod_title, PROD_CATEGORY from cl_cust_login a,cl_enroll b,cl_product c where a.user_id=? and a.cust_id=b.cust_id and b.prod_id=c.prod_id order by enroll_status,prod_id");

			pstmt.setInt(1,StudentLogin.getUserID());
			ResultSet rsProduct=pstmt.executeQuery();

			if(rsProduct.next())
			{
				productID="|"+rsProduct.getString("prod_id")+"|";
				productCategory+= rsProduct.getString("PROD_CATEGORY")+"|";
				enrollStatus=rsProduct.getString("enroll_status");
				StudentLogin.setEnrollID(rsProduct.getInt("enroll_id"));
				StudentLogin.setCustomerID(rsProduct.getInt("cust_id"));
				StudentLogin.setProduct(rsProduct.getString("prod_title"));
			}
		}
		finally
		{
			if(pstmt != null)
			{
				try
				{
					pstmt.close();
					pstmt = null;
				}
				catch(SQLException sql)
				{
				}
			}
		}

%>
		<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
		<jsp:setProperty name="StudentLogin" property="userName" param="userName"/>
		<jsp:setProperty name="StudentLogin" property="loggedIn" value="true"/>
		<jsp:setProperty name="StudentLogin" property="loggedInProduct" value="<%=productID %>"/>
		<jsp:setProperty name="StudentLogin" property="loggedInProductCategory" value="<%=productCategory %>"/>
		<jsp:setProperty name="StudentLogin" property="enrollStatus" value="<%=enrollStatus %>"/>
<%
			session.putValue("login",userName);
			session.putValue("password",password);
			session.putValue("uid",Integer.toString(StudentLogin.getUserID()));
			session.putValue("fname",StudentLogin.getFirstName());
			session.putValue("lname",StudentLogin.getLastName());
	}
		
		
		////////////////proceed>>>

		if(!StudentLogin.isLoggedIn())
		{

			response.sendRedirect(source+"?message=Invalid login or password, please note that login and password is case sensitive.&target="+target+"&source="+source);
		}//end of if(not logged in)
		else 
		{
			for(int i=0;i<Systems.systems.length;i++)
			{
				if(Systems.systems[i].indexOf(productID)>-1)
				{
					StudentLogin.setProblem(Systems.systemTitles[i]);
				}
			}//end of for loop

			OracleCallableStatement ocs= null;
			try
			{
				ocs=(OracleCallableStatement)connection.prepareCall("{call sis_student.log_time(?)}");
				ocs.setInt(1, StudentLogin.getUserID());
				ocs.execute();
				connection.commit();
			}
			finally
			{
				if(ocs!=null)
				try
				{
					ocs.close();
					ocs = null;
				}
				catch(SQLException sqle)
				{}
			}
		
			boolean redirected=false;
			if(sourceProductID.indexOf(productID)>-1 || sourceProductID.indexOf("|0|")>-1)
			{
				response.sendRedirect(target);
				redirected=true;
			}
			else 
			{
				for(int i=0;i<Systems.systems.length;i++)
				{
					if(Systems.systems[i].indexOf(productID)>-1)
					{
						response.sendRedirect(Systems.systemURLs[i]);
						redirected=true;
						break;
					}
				}
			}
	
		
			if(!redirected)
			{
				response.sendRedirect(Systems.webURL);
				SISExp.setErrorFileName(logFile);
				SISExp.setMessage("No entry in file CLSystems.java for the product-"+productID);
				SISExp.writeLog();
			}		
		}//end of else of if(not logged in)

	}
	finally
	{
		if(pstmt != null)
		{
			try
			{
				pstmt.close();
				pstmt = null;
			}
			catch(SQLException sql)
			{
			}
		}
		pool.freeConnection("erp",connection);
	}
%>

