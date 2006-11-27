<%--
  -- Filename MSGManageGroups.jsp
  -- Author Shilpa Arora
  -- Date 12 March , 2003
  --%>


 <%--
   --  The file creates, renames and deletes a group for an agent
   --%>

<%@ page import="org.apache.log4j.Category,java.sql.Connection,com.cl.sql.CLMSPoolManager" %> 
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>

<%
	String logFile = application.getRealPath("/logs/error/")+"MSGErrorLog.log";
	int cat = 1;
	request.setAttribute("cat",Integer.toString(cat));
	request.setAttribute("jspname","/msg/list/MSGSaveMemberBook.jsp");

	String user = (cat == 0) ? "CUSTOMER" : "EMPLOYEE";
%>

<cl:CLValidateSessionTag userType="<%=user%>"/> 



<%@ page import="com.cl.msg.*,java.util.*,java.math.BigDecimal" %>
<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
<jsp:useBean id="groups" class="com.cl.msg.list.MSGMemberGroups" scope="page" />

<%
	String qid		= request.getParameter("qid");
	String receiver = request.getParameter("receiver");
	String updation = request.getParameter("updation");
	String display	= request.getParameter("display");
	String orderby	= request.getParameter("orderby");
	String type		= request.getParameter("type");

	String activeGroup=""; // this denotes the resultant group name

	if (updation == null || updation.equals(""))
	{
		updation = "full";
	}
	if (display == null || display.equals(""))
	{
		display = "full";
	}
	String result ="Your Groups are updated successfully";
	
	String act = request.getParameter("act");
	String group = request.getParameter("group");
	String newName = request.getParameter("newName"); 

	CLMSPoolManager clmsPool = CLMSPoolManager.getInstance();
	Connection conn = null;
	try
	{
		conn = clmsPool.getConnection("erp");
		if (act == null)
		{
			result = "No request made for any changes";
		}
		else if (act.equals("Add"))
		{
			if(
				group.indexOf("\"")>-1    || group.indexOf("'")>-1 
				|| group.indexOf("~")>-1  || group.indexOf("#")>-1 
				|| group.indexOf("@")>-1  || group.indexOf("$")>-1 
				|| group.indexOf("&")>-1  || group.indexOf("|")>-1 
				|| group.indexOf("\\")>-1 || group.indexOf(",")>-1 
				|| group.indexOf("?")>-1  || group.indexOf("^")>-1 
				|| group.indexOf("%")>-1  || group.indexOf("-")>-1
				)
					result = "The Group cannot be added, the Name contained invalid characters(<b>\",\'\\~@#$%26?|^%25</b>), please remove any such character and try again";
			else
			{
				result = groups.addGroup(conn,agent.getAgentID(), agent.getDestID(), group).substring(1);
				activeGroup = group;
			}
		}
		else if (act.equals("Rename"))
		{
			if(
				   newName.indexOf("\"")>-1 || newName.indexOf("'")>-1 
				|| newName.indexOf("~")>-1  || newName.indexOf("#")>-1 
				|| newName.indexOf("@")>-1  || newName.indexOf("$")>-1 
				|| newName.indexOf("&")>-1  || newName.indexOf("|")>-1 
				|| newName.indexOf("\\")>-1 || newName.indexOf(",")>-1 
				|| newName.indexOf("?")>-1  || newName.indexOf("^")>-1 
				|| newName.indexOf("%")>-1  || newName.indexOf("-")>-1
				)
					result = "The Group cannot be renamed, the Name contained invalid characters(<b>\",\'\\~@#$%26?|^%25</b>), please remove any such character and try again";
			else
			{
				result = groups.renameGroup(conn,agent.getAgentID(), agent.getDestID(), group, newName).substring(1);
				activeGroup = newName;
			}
		}
		else if (act.equals("Delete"))
		{
			result = groups.deleteGroup(conn,agent.getAgentID(), agent.getDestID(), group).substring(1);
		}
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}

%>

	
<jsp:forward page="/msg/list/MSGCreateMemberBook.jsp" >
<jsp:param name="message" value="<%= result%>" />
<jsp:param name="display" value="<%=display%>" />
<jsp:param name="type" value="<%=type%>" />
<jsp:param name="ac" value="<%=activeGroup%>" />
<jsp:param name="qid" value="<%=qid==null?"":qid%>" />
<jsp:param name="receiver" value="<%=receiver==null?"":receiver%>" />
</jsp:forward>
		
