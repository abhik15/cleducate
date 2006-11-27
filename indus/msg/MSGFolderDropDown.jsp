<%@ page language="java" import="oracle.jdbc.driver.OracleTypes,com.cl.sql.PoolManager,java.sql.*,org.apache.log4j.Category" %>

<%-- This file will generate a dropdown list of the users folders along with the system.
	 The javascript method moveMessage() must be present on the JSP Page where this jsp file
	 is included.
  --%>
	<jsp:useBean id="agent" type="com.cl.msg.MSGAgent" scope="session" />

<% 
	Connection conn = null;
	CallableStatement cstmt = null;
	ResultSet rset = null;
	PoolManager pool = PoolManager.getInstance();

	Category logCategory = null;

	// Folder Id is being retrieved as the current folder will not figure in the drop down list
	int folderId = Integer.parseInt(request.getParameter("fid"));
	int agentId = agent.getAgentID();

	try
	{
		conn = pool.getConnection("erp");
		// get system folder list
		cstmt = conn.prepareCall("{call erp.sis_msg.get_system_folders(?)}");
		cstmt.registerOutParameter(1,OracleTypes.CURSOR);

		cstmt.execute();

		rset = (ResultSet) cstmt.getObject(1);
%>
	<select class="cntblu" name="tofid" onChange="javascript: moveMessage()">
	<option value="0">Move to Folder
	<option value="0">- - - - - - - - - - - 
<%
		while(rset.next())
		{
			if(folderId == rset.getInt("folder_id"))
				continue;
			// Have prefixed S in the value attribute to denote that this folder is a SYSTEM folder
			out.println("<option value=\"S" + rset.getInt("folder_id") + "\">" + rset.getString("folder_name"));
		}

		rset.close();
		cstmt.close();
	
		cstmt = conn.prepareCall("{call erp.sis_msg.get_user_folders(?,?)}");
		cstmt.registerOutParameter(1,OracleTypes.CURSOR);
		cstmt.setInt(2,agentId);

		cstmt.execute();

		rset = (ResultSet) cstmt.getObject(1);
		while(rset.next())
		{
			if(folderId == rset.getInt("folder_id"))
				continue;
			// Have prefixed U in the value attribute to denote that this folder is a USER folder
			out.println("<option value=\"U" + rset.getInt("folder_id") + "\">" + rset.getString("folder_name"));
		}
		rset.close();
		cstmt.close();
%>
	</select>
<%	}
	finally
	{
		try
		{
			if(rset != null)
				rset.close();
		}
		catch(SQLException sql)
		{
			if(logCategory == null)
				logCategory = Category.getInstance("clsite.msg.MSGFolderDropDown");
			logCategory.error(sql.toString());
		}

		try
		{
			if(cstmt != null)
				cstmt.close();
		}
		catch(SQLException sql)
		{
			if(logCategory == null)
				logCategory = Category.getInstance("clsite.msg.MSGFolderDropDown");
			logCategory.error(sql.toString());
		}
		pool.freeConnection("erp",conn);
	}
%>