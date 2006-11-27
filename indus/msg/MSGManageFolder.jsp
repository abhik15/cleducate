<%@ page language="java" import="oracle.jdbc.driver.OracleTypes,org.apache.log4j.Category,java.sql.*,com.cl.sql.CLMSPoolManager" errorPage="/msg/MSGErrorPage.jsp"%> 
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>

<%
	String logFile = application.getRealPath("/logs/error/")+"MSGErrorLog.log";
	int cat = 0;
	try
	{
		cat = Integer.parseInt(request.getParameter("cat"));
	}
	catch(NumberFormatException nfe)
	{
		cat = 0;
	}
	request.setAttribute("cat",Integer.toString(cat));
	request.setAttribute("jspname","/msg/MSGManageFolder.jsp");

	String user = (cat == 0) ? "CUSTOMER" : "EMPLOYEE";
	String errorCode = request.getParameter("ec");
	String errorMessage = "";
	if(errorCode == null)
		errorCode = "";
	if(errorCode.equals("DUPLICATE"))
		errorMessage = "Folder by this name already exists. Could not rename folder.";
	else if(errorCode.equals("SYSTEM_FOLDER"))
		errorMessage = "<b>Inbox</b>, <b>Sent Items</b> and <b>Trash Can</b> are System Folders. Please choose some other name for your folders.";
%>

<cl:CLValidateSessionTag userType="<%=user%>"/> 

<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>

<html>
<head>
<title>CL Messaging System - Manage Folders</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="expires" content="0">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">

<link rel="stylesheet" href="/styles/style.css" type="text/css">

</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!-- Add top.js for top band -->
<script language="javascript" src="/jscript/top.js"></script>
<table border="0" width="100%" cellspacing="0" cellpadding="3">
<%
	String clSrc = (cat == 1)? "/msg/MSGStaffCompose.jsp" : "/msg/MSGStudentCompose.jsp";
	Connection conn = null;
	CallableStatement cstmt = null;
	CallableStatement _cstmt = null;
	ResultSet rset = null;
	int agentId = agent.getAgentID();
	Category logCategory = null;
	String PKG_NAME = "clsite.msg.MSGManageFolder";
 
	CLMSPoolManager pool = CLMSPoolManager.getInstance();
	int folderId = 0;
	String folderName = "";
	int totMsgCount = 0;
	int totUnreadMsgCount = 0;
	int totFldrMsgCount = 0;
	int unreadFldrMsgCount = 0;
	try
	{
		conn = pool.getConnection("erp");
%>
<tr valign="top"><td bgcolor="DFE1BC" width="21%" valign="top">
	<cl:CLMsgSisLeftBandTag connObj="<%=conn%>" category="<%=Integer.toString(cat)%>" level="1"/>
</td>
<td width="79%" valign="top">
	<!-- TOP BAND START -->
	<table align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td bgcolor="B4BC6D">
		<table border="0" cellspacing="0" cellpadding="0">
		<tr><td bgcolor="B4BC6D" height="32" width="10">
				<img src="/img/blank.gif" width="1" height="28">
			</td>
			<td><font class="cntblu">
				<a href="/" class="lnkblu">Home</a><font class="cntblu"> &gt; </font>
				<%= (cat == 1) ? "<a href=\"/clzone/login/CLZone.jsp\" class=\"lnkblu\">CL Zone Home</a>" 
							   : "<a href=\"/sis/SIS.jsp\" class=\"lnkblu\">SIS page</a>" %> &gt; Manage Folders</font>
			</td>
		</tr>
		</table>
	</td></tr></table>
	<!-- TOP BAND END -->
	<table width="100%" align="center" border="0" cellpadding="5" cellspacing="0">
	<tr><td>
		<cl:writeChannels agentID="<%=agent.getAgentID() %>" destID="<%=agent.getDestID() %>" clSource="<%=clSrc%>" connObj="<%=conn%>" sisSource="/msg/admin/MSGPickStudents.jsp"/>
	</td></tr>
<%
	if(errorCode != null && errorCode.length() > 0 && (!errorCode.equals("RENAMED")))
	{
%>
	<tr><td class="cnt"><font color="red">
	<b>Error:</b> <%=errorMessage%>
	</font></td></tr>
<%	}
%>
	<tr><td class="cnt"><font color="red">
	<b>Note:</b> Whenever you remove a folder the messages, if any, present in that folder will be
	transfered to the <b>Trash Can</b> folder. Also any message in your <b>Trash Can</b> that is older than 7 days will be automatically deleted by the system.
	</font></td></tr>
	</table>

	<table width="98%" align="center" border="1" cellpadding="5" cellspacing="0" bordercolorlight="silver" bordercolordark="#ffffff">
	<tr><td class="lnkbld">Folder</td>
		<td class="lnkbld">Total Messages</td>
		<td class="lnkbld">Unread Messages</td>
		<td class="lnkbld">Remove Folder</td>
		<td class="lnkbld">Rename Folder</td>
	</tr>
<%
		//first retrieve the system folders
		cstmt = conn.prepareCall("{call erp.sis_msg.get_system_folders(?)}");
		cstmt.registerOutParameter(1,OracleTypes.CURSOR);

		cstmt.execute();
		rset = (ResultSet) cstmt.getObject(1);
		while(rset.next())
		{
			folderId = rset.getInt("folder_id");
			folderName = rset.getString("folder_name");
			try
			{
				_cstmt = conn.prepareCall("{call erp.sis_msg.get_system_folder_msg_count(?,?,?,?)}");
				_cstmt.setInt(1,folderId);
				_cstmt.setInt(2,agentId);
				_cstmt.registerOutParameter(3,OracleTypes.NUMBER);	// total msg count
				_cstmt.registerOutParameter(4,OracleTypes.NUMBER);	// unread msg count

				_cstmt.execute();

				totFldrMsgCount = _cstmt.getInt(3);
				unreadFldrMsgCount = _cstmt.getInt(4);

				totMsgCount += totFldrMsgCount;
				totUnreadMsgCount += unreadFldrMsgCount;
				_cstmt.close();
			}
			finally
			{
				try
				{
					if(_cstmt != null)
						_cstmt.close();
				}
				catch(SQLException sql)
				{
					if(logCategory == null)
						logCategory = Category.getInstance(PKG_NAME);
					logCategory.error(sql.toString());
				}
			}
%>
	<tr><td class="cntblu">
			<a href="/msg/MSGInbox.jsp?cat=<%=cat%>&fldr=<%=java.net.URLEncoder.encode(folderName)%>&fid=S<%=folderId%>" title="Folder <%=folderName%>" class="lnkblu">
			<%=folderName%></a>
		</td>
		<td class="cntblu" align="right"><%=totFldrMsgCount%></td>
		<td class="cntblu" align="right"><%=unreadFldrMsgCount%></td>
<%
	if(folderId == 3 && totFldrMsgCount > 0)	// id for trash can
	{
%>
		<td colspan="2"><a class="lnkblu" href="/msg/MSGEmptyTrash.jsp?cat=<%=cat%>">Empty Trash</a></td>
<%
	}
	else
	{
%>
		<td colspan="2" class="cntblu"><img src="/img/blank.gif" width="3" height="3"></td>
<%	}
%>
	</tr>

<%
		} // end of while(rset.next())

		rset.close();
		cstmt.close();

		//now retrieve the user folders
		cstmt = conn.prepareCall("{call erp.sis_msg.get_user_folders(?,?)}");
		cstmt.registerOutParameter(1,OracleTypes.CURSOR);
		cstmt.setInt(2,agentId);

		cstmt.execute();
		rset = (ResultSet) cstmt.getObject(1);
		while(rset.next())
		{
			folderId = rset.getInt("folder_id");
			folderName = rset.getString("folder_name");
			totFldrMsgCount = rset.getInt("message_count");

			totMsgCount += totFldrMsgCount;

			try
			{
				_cstmt = conn.prepareCall("{call erp.sis_msg.count_msg(?,?,?,?,?,?)}");
				_cstmt.setInt(1,agentId);	
				_cstmt.setInt(2,1);	//destination id
				_cstmt.setInt(3,1);	// message status 1 - unread messages
				_cstmt.registerOutParameter(4,OracleTypes.NUMBER);	// Message count
				_cstmt.setInt(5,folderId);	// Folder id
				_cstmt.setString(6,"USER");	// folder type

				_cstmt.execute();

				unreadFldrMsgCount = _cstmt.getInt(4);
				totUnreadMsgCount += unreadFldrMsgCount;
				_cstmt.close();
			}
			finally
			{
				try
				{
					if(_cstmt != null)
						_cstmt.close();
				}
				catch(SQLException sql)
				{
					if(logCategory == null)
						logCategory = Category.getInstance(PKG_NAME);
					logCategory.error(sql.toString());
				}
			}

%>
	<tr><td class="cntblu">
			<a href="/msg/MSGInbox.jsp?cat=<%=cat%>&fldr=<%=java.net.URLEncoder.encode(folderName)%>&fid=U<%=folderId%>" title="Folder <%=folderName%>" class="lnkblu">
			<%=folderName%></a>
		</td>
		<td class="cntblu" align="right"><%=totFldrMsgCount%></td>
		<td class="cntblu" align="right"><%=unreadFldrMsgCount%></td>
		<td><a class="lnkblu" href="/msg/MSGModifyFolder.jsp?cat=<%=cat%>&fid=<%=folderId%>&tk=del">Remove Folder</a></td>
		<td class="cntblu">
			<form style="margin-bottom: 2;" action="/msg/MSGModifyFolder.jsp" name="deleteFolder<%=folderId%>">
			<input type="hidden" name="cat" value="<%=cat%>">
			<input type="hidden" name="fid" value="<%=folderId%>">
			<input type="hidden" name="tk" value="ren">
			<input type="text" name="fldr" size="15" maxlength="25" title="Enter new folder name." value=""><br>
			<input type="submit" value="Rename">
			</form>
		</td>
	</tr>

<%
		}//end of while(rset.next())
		rset.close();
		cstmt.close();
	}
	finally
	{
		try
		{
			if(rset != null)
				rset.close();
		}
		catch(SQLException sqle)
		{
			if(logCategory == null)
				logCategory = Category.getInstance(PKG_NAME);
			logCategory.error(sqle.toString());
		}

		try
		{
			if(cstmt != null)
				cstmt.close();
		}
		catch(SQLException sqle)
		{
			if(logCategory == null)
				logCategory = Category.getInstance(PKG_NAME);
			logCategory.error(sqle.toString());
		}
		/* # # # # # # # Pool Impl # # # # # # # */
		pool.freeConnection("erp",conn);
	}


%>
<tr><td class="lnkbld">Total</td>
	<td class="lnkbld" align="right"><%=totMsgCount%></td>
	<td class="lnkbld" align="right"><%=totUnreadMsgCount%></td>
	<td colspan="2"><img src="/img/blank.gif" width="3" height="3"></td>
</tr>
</table>
</td></tr></table>
</body>
</html>