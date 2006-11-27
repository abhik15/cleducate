<%--
  -- Filename MSGSaveMemberBook.jsp
  -- Author Shilpa Arora
  -- Date 5th March 2003
  --%>

<%@ page import=",org.apache.log4j.Category,java.sql.Connection,com.cl.sql.CLMSPoolManager" %> 
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>

<%
	String logFile = application.getRealPath("/logs/error/")+"MSGErrorLog.log";
	int cat = 1;
	request.setAttribute("cat",Integer.toString(cat));
	request.setAttribute("jspname","/msg/list/MSGSaveMemberBook.jsp");

	String user = (cat == 0) ? "CUSTOMER" : "EMPLOYEE";
%>

<cl:CLValidateSessionTag userType="<%=user%>"/> 


<%
/*
 * The code saves the members to the member book, it can be called either for a
 * full updation or partial updation, full updation means storing all the members
 * again whereas partial updation means adding more members to it, by default, it
 * does the full updation.
 */
%>

<%@ page import="com.cl.msg.*,java.util.*,java.math.BigDecimal" %>
<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
<jsp:useBean id="book" class="com.cl.msg.list.MSGMemberBook" scope="page" />

<%
	String qid			= request.getParameter("qid");
	String receiver		= request.getParameter("receiver");
	String updation		= request.getParameter("updation");
	String display		= request.getParameter("display");
	String orderby		= request.getParameter("orderby");
	String type			= request.getParameter("type");
	String activeGroup	= ""; //used in case of group lists

	if (updation == null || updation.equals(""))
	{
		updation = "full";
	}
	if (display == null || display.equals(""))
	{
		display = "full";
	}

	String agentsString = request.getParameter("membersString");
	out.println(agentsString); 
	StringTokenizer tokensAgents = new StringTokenizer(agentsString, "|");
	OTMember[] members = new OTMember[tokensAgents.countTokens()];

	for (int i=0; i<members.length ; i++)
	{
		StringTokenizer tokensID= new StringTokenizer(tokensAgents.nextToken(),"-");
		if(tokensID.hasMoreElements())
		{
			members[i] = new OTMember();
			members[i].setAgentName(tokensID.nextToken());
			members[i].setNickName(tokensID.nextToken());
			activeGroup = members[i].getNickName();
		}
	}
	out.println(activeGroup);

	String result = "Your " + (type.equalsIgnoreCase("SYSTEM") ? "Address Book" : "Group list") 
							+ " is updated successfully";

	CLMSPoolManager clmsPool = CLMSPoolManager.getInstance();
	Connection conn = null;
	try
	{
		conn = clmsPool.getConnection("erp");
		if (updation.equals("full"))
		{
			result = book.saveMemberList(conn,agent.getAgentID(), agent.getDestID(), type, new OTMembers(members));
			activeGroup = ""; //making active group null incase of total book recreation as so many groups are active
		}
		else
		{
			result = book.saveMoreMembers(conn,agent.getAgentID(), agent.getDestID(), type, new OTMembers(members));
		}
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}


%>

<%
if (qid==null || qid.equals("") )
{
%>	
	
<jsp:forward page="/msg/list/MSGCreateMemberBook.jsp" >
<jsp:param name="message" value="<%= result%>" />
<jsp:param name="display" value="<%=display%>" />
<jsp:param name="type" value="<%=type%>" />
<jsp:param name="ac" value="<%=activeGroup%>" />
</jsp:forward>
		
<%
}
else
{
%>
<jsp:forward page="/msg/list/MSGMemberBook.jsp">
<jsp:param name="message" value="<%= result%>"/>
<jsp:param name="qid" value="<%=qid%>" />
<jsp:param name="type" value="<%=type%>" />
<jsp:param name="receiver" value="<%=receiver%>" />
</jsp:forward>
<%
}	
%>

