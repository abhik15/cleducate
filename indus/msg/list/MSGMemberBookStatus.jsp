<%@ page import="java.util.*,com.cl.msg.*,com.cl.sql.CLMSPoolManager,java.sql.*"%>
<jsp:useBean id="bookMembers" class="com.cl.msg.list.MSGMemberBook" scope="page" />
<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />

<%
CLMSPoolManager pool = CLMSPoolManager.getInstance();
Connection connection = null;


	ArrayList processedNames = new ArrayList();
	int qID = 0;
	String receiver= request.getParameter("receiver");
	if (receiver.equals("##"))
		return; // the case denotes BORADCAST CHANNEL
	qID =  Integer.parseInt(request.getParameter("qid"));

	String exists ="";// the result from database
	String name= "";
	StringTokenizer nameTokens = new StringTokenizer(receiver, ",");
	int cntCheckBox=0; //counts how many hceck boxes finnaly appear
	String[] groups = null;
		//var below for the read message link
		int msgID	= 0;
		int msgcnt	= 0;
		int pID		= 0;
		int pn		= 0;
		int seq		= 0;
		int rpage	= 0;
		int cat		= 0;
		String fid	= "";
		String fldr = "";
try
{
	connection = pool.getConnection("erp");
	groups = bookMembers.getGroupNames(connection,agent.getAgentID(), agent.getDestID());

		try
		{
			msgID	= Integer.parseInt(request.getParameter("mid"));
			msgcnt	= Integer.parseInt(request.getParameter("msgcnt"));
			pID		= Integer.parseInt(request.getParameter("pID"));
			pn		= Integer.parseInt(request.getParameter("pn"));
			seq		= Integer.parseInt(request.getParameter("seq"));
			rpage	= Integer.parseInt(request.getParameter("rpage"));
			cat		= Integer.parseInt(request.getParameter("cat"));
			fid		= request.getParameter("fid");
			fldr	= request.getParameter("fldr");
		}
		catch(NumberFormatException nfe)
		{
			msgID = 0;
		}


%>

	  <tr> 
	<td align="left" height="30" class="cntblu">The address book/group status of the members is as follows,
	<form action="/msg/list/MSGSaveMemberBook.jsp" method="post" name="bookForm">
	<table border="1" width="100%" bordercolorlight="#C0D9F5" cellspacing="0" cellpadding="0" bordercolordark="#FFFFFF" class="cnt" >
	<tr bgcolor="#C0D9F5" class="verbld">
	<td width="40%">CLMS Name</td>
	<td width="40%">Nick Name/Group Name</td>
	<td width="20%">Add </td>
	</tr>

<%
	while(nameTokens.hasMoreElements())
	{
		name = nameTokens.nextToken();

		if (processedNames.contains(name))
			continue;

		exists = bookMembers.findInBook(connection, agent.getAgentID(), agent.getDestID(),qID, name);
%>
		<tr >
		<td width="40%" height="20"><%= (exists.startsWith("$"))?exists.substring(1, exists.lastIndexOf("$")):name%></td>
		<td width="40%">
		<%
		if (exists.startsWith("$"))	
			out.println(exists.substring(exists.lastIndexOf("$")+1));
		else if (exists.startsWith("#"))	
			out.println("<input type=\"text\" name=\""+name+"\" value=\""+name.trim()+"\" class=\"cnt\" maxlength=\"40\" size =\"15\">");
		else if (exists.startsWith("@"))	
			out.println("&nbsp;");
		%>
		</td>
		<td width="20%" class="new">
		<%
		if (exists.startsWith("$"))	
			out.println("Already Added");
		else if (exists.startsWith("#"))
		{
			out.println("<input type=\"checkbox\" value=\""+name.trim()+"\">");
			cntCheckBox++;
		}
		else if (exists.startsWith("@"))	
			out.println("Keyword");
		%>
		</td>
		</tr>
		<%
		processedNames.add(name);	
	}

}	
finally
{
	pool.freeConnection( "erp", connection);
}

if(cntCheckBox>0)//submit button only if any checkbox is present
{
%>

	<tr>
	<td colspan="3" align="center">
	<input type="button" value="Add to Address Book" onClick="submitBookForm('SYSTEM')" class="cnt">&nbsp;
	<%
	if (groups!=null && groups.length>0)	
	{
		%>
		<input type="button" value="Add to Group" onClick="submitBookForm('USER')" class="cnt">
		<select name="group" class="cnt">
		<%
		for (int i=0;i<groups.length;i++)
		{
			out.println("<option value=\""+groups[i]+"\">\""+ groups[i]+"\"</option>");
		}	
		%>
		</select>
	<%
	}	
	%>
</td>
	</tr>
</table>
<%
}


if (msgID>0)// The link of going back to message will be there
{
%>
	<table border="0" width="100%">
	<tr valign="bottom"><td align="left" >
	<a href="/msg/MSGStaffRead.jsp?cat=<%=cat%>&msgcnt=<%=msgcnt %>&msgID=<%=msgID%>&pID=<%=pID %>&pn=<%=pn%>&seq=<%=seq%>&rpage=<%=rpage%>&fid=<%=fid %>&fldr=<%=fldr%>" class="lnkblu">Go back to Message</a>
	</td>
	
	<td align="right">
	<a href="/msg/MSGInbox.jsp?cat=1&fldr=Inbox&fid=S1" class="lnkblu">Go to Inbox</a></td></tr>
	</table>
<%
}
else
{
%>
	<table border="0" width="100%">
	<tr><td  align="center">
	<a href="/msg/MSGInbox.jsp?cat=1&fldr=Inbox&fid=S1" class="lnkblu">Go to Inbox</a></td></tr>
	</table>
<%
}
%>

<input type="hidden" name="updation" value="partial">
<input type="hidden" name="membersString" value="">
<input type="hidden" name="display" value="full">
<input type="hidden" name="type" value="SYSTEM">
</form>
</td>
</tr>
