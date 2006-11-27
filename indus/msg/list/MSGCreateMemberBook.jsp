<%--
  -- Author Shilpa Arora
  -- Filename MSGCreateMemberBook.jsp
  -- Date 27, Feb 2003
  --%>

<%--
  -- The code provides a User Interface to Edit the Address Book/Group List 
  -- of CLMS agent(at present used for employees only), Use of Javascript is
  -- heavily done and the file is /msg/list/MSGBookJscript.js
  -- The file opens in a pop up and in full page(with top,
  -- left bands).
  --
  --%>

<%@ page import="com.cl.msg.*,org.apache.log4j.Category,java.sql.Connection,com.cl.sql.CLMSPoolManager" %> 
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>

<%
	int cat = 1;
	request.setAttribute("cat",Integer.toString(cat));
	request.setAttribute("jspname","/msg/list/MSGCreateMemberBook.jsp");

	String user = (cat == 0) ? "CUSTOMER" : "EMPLOYEE";
%>

<cl:CLValidateSessionTag userType="<%=user%>"/> 


<%
	/* 
	 * The parameter is required to see whether the page is getting displayed
	 * independently or getting included somewhere- the value "alone" states the 
	 * page is independently displayed and should include the headers
	 */

String qid		= request.getParameter("qid");
String receiver = request.getParameter("receiver");
String message	= request.getParameter("message");
String display	= request.getParameter("display");
String type		= request.getParameter("type");
String activeGroup = request.getParameter("ac"); //contains the group recently manipulated, if any

if (activeGroup==null)
	activeGroup =  "";

String groups[] =null; //for holding group names into it
if (type==null || type.equals(""))
{
	type= "SYSTEM"; //default is system i.e. address book
}

if (display==null || display.equals(""))
{
	display= "full"; //default is system i.e. address book
}

boolean full = display.equals("full") ? true: false;
boolean addressBook = type.equals("SYSTEM") ? true :false; // if type is "SYSTEM" the book behaves as an address book

if(message == null)
	message = "";
%>

<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
<jsp:useBean id="book" class="com.cl.msg.list.MSGMemberBook" scope="page" />

<%
	CLMSPoolManager clmsPool = CLMSPoolManager.getInstance();
	Connection conn = null;
	MSGAgent[] allAgents = null;
	MSGAgent[] bookAgents = null;

	try
	{
		conn = clmsPool.getConnection("erp");
		allAgents = book.getNonMembersList(conn,agent.getAgentID(), agent.getDestID() );// gets all the accessible agents for this particular agent
		bookAgents = book.getMemberList(conn,agent.getAgentID(), agent.getDestID(), type);// gets the agents in member book

	// declaring group names incase the book behaves as group list
	if (!addressBook)
		groups = book.getGroupNames(conn,agent.getAgentID(), agent.getDestID());
%>

<html>
<head>
<title>CLMS- Edit your <%=addressBook? "Address Book" :"Group List" %></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="expires" content="0">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">

<link rel="stylesheet" href="/styles/style.css" type="text/css">

<script LANGUAGE="JavaScript" src="/msg/list/MSGBookJscript.js"></script>

<script language="javascript">
/*
 * The following array holds the name of all the clms agents
 */
var all = new Array();
<%
	for (int i=0; i<allAgents.length; i++)
		out.println("all["+i+"] = '"+ allAgents[i].getAgentName().toLowerCase()+"';");
%>

/*
 * The following array holds the name of all the book agents
 */
var book = new Array(new Array(), new Array());
<%
	for (int i=0; i<bookAgents.length; i++)
	{
		out.println("book[0]["+i+"] = '"+ bookAgents[i].getAgentName().toLowerCase()+"';");
		out.println("book[1]["+i+"] = '"+ bookAgents[i].getNickName().toLowerCase()+"';");
	}
%>

//called on the onload of the body to populate the selects
function loadSelects()
{
	<%=!full?"self.moveTo(0,0);self.resizeTo(560,570);":""%>

	//loads the group list or the members list
	load(document.agentForm.bookAgents, book, <%=addressBook? "'#'":"document.agentForm.groups.value"%>);
	
	<%
	if(!addressBook)
	{
	%>
		var groupNames =  new Array();
		var index =0;
		for (var y=0; y< book[0].length; y++)
		{
			if (book[1][y]==document.agentForm.groups.value)
			{
				groupNames[index] = book[0][y];
				index++;
			}
		}
	
	<%
	}	
	%>

	// loads the clms names minus the names existing in the group list or address list
	loadDifference(document.agentForm.allAgents, all,<%=addressBook? "book[0]":"groupNames"%> ,<%=addressBook? "'#'":"document.agentForm.groups.value"%>);
}

//decides the method to load the clms select, is called when a key is press down on the search box
function decideLoad()
{

	<%
	if(!addressBook)
	{
	%>
		var groupNames =  new Array();
		var index =0;
		for (var y=0; y< book[0].length; y++)
		{
			if (book[1][y]==document.agentForm.groups.value)
			{
				groupNames[index] = book[0][y];
				index++;
			}
		}
	
	<%
	}	
	%>

	if (document.agentForm.startsWith.value=='')
	{
		
		// loads the clms names minus the names existing in the group list or address list
		loadDifference(document.agentForm.allAgents, all,<%=addressBook? "book[0]":"groupNames"%> ,<%=addressBook? "'#'":"document.agentForm.groups.value"%>);
	}
	else
	{
		reloadSelect(document.agentForm.startsWith, document.agentForm.allAgents, all, <%=addressBook? "book[0]":"groupNames"%>,<%=addressBook? "'#'":"document.agentForm.groups.value"%>);
	}
}

</script>

</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" <%=(!addressBook && (groups==null || groups.length==0))?"":"onLoad=\"loadSelects()\""%>>

<%
if (full)
{
%>	
<script language="javascript" src="/jscript/top.js"></script>
<table border="0" width="100%" cellspacing="0" cellpadding="3">
<tr valign="top"><td bgcolor="DFE1BC" width="21%" valign="top">
	<cl:CLMsgSisLeftBandTag connObj="<%=conn%>" category="<%=Integer.toString(cat)%>" level="1"/>
</td>
<td width="79%">
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
							   : "<a href=\"/sis/SIS.jsp\" class=\"lnkblu\">SIS page</a>" %> &gt; Edit your <%=addressBook? "Address Book" :"Group List" %></font>
			</td>
		</tr>
		</table>
	</td></tr></table>
	<!-- TOP BAND END -->

	<table width="100%" cellpadding="3" cellspacing="0" border="0">	
		<tr><td>
	<%
	String clSrc = (cat == 1) ? "/msg/MSGStaffCompose.jsp" : "/msg/MSGStudentCompose.jsp";
	%>
		<cl:writeChannels agentID="<%=agent.getAgentID() %>" destID="<%=agent.getDestID() %>" clSource="<%=clSrc%>" connObj="<%=conn%>" sisSource="/msg/admin/MSGPickStudents.jsp"/>
	</td></tr>

	<tr><td class="cnt">
<%
		}
		else
		{
		out.println("<table border=\"0\" width=\"100%\"><tr><td>");
		}
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
%>


<p class="new"><%=message%></p>

<table width="100%">
<tr>
	<td align="left">
	<font class="<%=addressBook? "lnkbld" :"verbld" %>">CLMS- <%=addressBook? "Address Book" :"Group List" %></font>
	</td>
	<td align="right">
	<a href="javascript:doNothing()" onClick="javascript:window.open('/msg/list/MSG<%=addressBook? "AddressBook" :"GroupList"%>Guide.html','AddressBook','status=no,toolbar=no,scrollbars=yes,width=500,height=460,top=10,left=10,resizable=yes')" class="lnkblu">How do I Manage My <%=addressBook? "Address Book" :"Group List" %>?</a>
	</td>
</tr>
</table>
<div align="justify">
<p><font class="cnt">You can edit your <%=addressBook? "Address Book" :"Group List" %> from here, <%=addressBook? "you can provide a nick name to a member(for e.g. \"gp\" for Gautam Puri)" :"assign the members a group  name (for e.g. \"southcampus\" for Nidhi Marwah, Harsh Wadwa, Shivani Gambir)" %> and add these to your book. And you are ready to use these <%=addressBook? "nick" :"group" %> names for sending messages by writing them in between double quotes in the To Box</font></p></div>


<%
//manage groups
if (!addressBook)
{
%>
<table border="1" width="100%" cellspacing="1" cellpadding="1" class="cnt" bordercolorlight="white" bordercolordark="#dfe1bc">
<tr><td bgcolor="#dfe1bc" colspan="3" class="verbld">Manage Groups</td></tr>
<tr bgcolor="#F2F4E3">
<td width="30%"><i>Add new Group</i></td>
<td width="40%"><i>Rename Group</i></td>
<td width="30%"><i>Delete Group</i></td>
</tr>
<tr>
<td width="30%" valign="top">
	<form name="groupForm" action="/msg/list/MSGManageGroups.jsp" method="post">
	<input type="text" size="10" maxlength="40" name="group">
	<input type="hidden" name="act" value="Add">
	<input type="hidden" name="type" value="<%=type%>">
	<input type="hidden" name="qid" value="<%=qid!=null? qid:""%>">
	<input type="hidden" name="receiver" value="<%=receiver!=null? receiver:""%>">
	<input type="hidden" name="display" value="<%=full?"full":"partial"%>">
	<input type="SUBMIT" value="Add" class="cnt">
	</form>
</td>
<td width="40%" valign="top">
	<%
	if (groups!=null && groups.length>0)
	{
	%>
	<form name="groupForm" action="/msg/list/MSGManageGroups.jsp" method="post">
		<select name="group" class="cnt">
		<%
		for (int i=0;i<groups.length;i++)
		{
			out.println("<option value=\""+groups[i]+"\""+ (groups[i].equals(activeGroup)?"selected":"") + ">"+groups[i]+"</option>");
		}	
		%>
		</select>
		to <input type="text" size="10" name="newName" maxlength="40">
		<input type="hidden" name="act" value="Rename">
		<input type="hidden" name="display" value="<%=full?"full":"partial"%>">
		<input type="hidden" name="type" value="<%=type%>">
		<input type="hidden" name="qid" value="<%=qid!=null? qid:""%>">
		<input type="hidden" name="receiver" value="<%=receiver!=null? receiver:""%>">
		<input type="submit" value="Rename" class="cnt" >
	</form>
	<%
	}	
	else 
		out.println("<font class=\"new\">No Group Found</font>");
	%>
</td>
<td width="30%" valign="top">
	<%
	if (groups!=null && groups.length>0)
	{
	%>
	<form name="groupForm" action="/msg/list/MSGManageGroups.jsp" method="post">
		<select name="group" class="cnt">
		<%
		for (int i=0;i<groups.length;i++)
		{
			out.println("<option value=\""+groups[i]+"\""+ (groups[i].equals(activeGroup)?"selected":"") +">"+groups[i]+"</option>");
		}	
		%>
		</select>
		<input type="hidden" name="act" value="Delete">
		<input type="hidden" name="display" value="<%=full?"full":"partial"%>">
		<input type="hidden" name="type" value="<%=type%>">
		<input type="hidden" name="qid" value="<%=qid!=null? qid:""%>">
		<input type="hidden" name="receiver" value="<%=receiver!=null? receiver:""%>">
		<input type="submit" value="Delete" class="cnt" >
	</form>
	<%
	}	
	else 
		out.println("<font class=\"new\">No Group Found</font>");
	%>
</td>
</tr>
</table>
<%
}	
%>


<form name="agentForm" action="/msg/list/MSGSaveMemberBook.jsp" method="post">
<table border="0" width="100%" cellspacing="2" cellpadding="3" class="cnt">
<tr>
	<td bgcolor="<%=addressBook? "#C0D9F5" :"#dfe1bc" %>" class="verbld" colspan="3">Build your <%=addressBook? "Address Book" :"Group List" %> by adding names from CLMS Members List</td>
</tr>
<%
if (!addressBook && (groups==null || groups.length==0))
{
%>
	<tr>
		<td class="new" colspan="3" align="center">You have no group to add members to, please create a group to proceed</td>
	</tr>
<%
}
else
{
%>
		<tr>
			<td align="left" valign="top" width="35%">
			<font  class="verbld">CLMS Members List</font><br>
			<font class="cnt">(All CLMS Members to whom you can send messages)</font>
			</td>
			<td width="30%">&nbsp;
			</td>
			<td align="left" valign="top" width="35%">	<font  class="verbld">Your <%=addressBook? "Address Book" :"Group List" %></font><%=addressBook? "<br><font class=\"cnt\">CLMS Name(\"Nick Name\")</font>" :"" %>
				<%
				if (addressBook)
				{
				%>
					<br>Sort on<select name="orderby" class="cntblu" onChange="sort(this.value, document.agentForm.bookAgents)">
					<option value="CLMS">CLMS Names</option>
					<option value="NICK">Nick Names</option>
					</select>
				<%
				}
				else 
				{
					out.println("<input type=\"hidden\" name=\"orderby\" value=\"NONE\">");
				// for sorting conditions not available in group list
				%>
					<br>Existing Groups<select name="groups" class="cntblu" onChange="loadSelects()">
					<%
					for (int y=0; y<groups.length; y++)
					{
					%>
						<option value="<%=groups[y]%>" <%= groups[y].equals(activeGroup)?"selected":""%>><%=groups[y]%></option>
					<%
					}	
					%>			
					</select>
				<%
				}	
				%>
		</td></tr>
		<tr>
		<td align="left" valign="top" width="35%">
				Find Name:<br>
				<input type="text" name="startsWith" value="" size="20" class="cnt" onKeyUp="decideLoad()"><br>
				<select size="11" name="allAgents" class="cnt" onChange="showNickName(this,document.agentForm.clmsNickName)" 
				ondblClick="javascript:shiftOption(document.agentForm.allAgents, document.agentForm.bookAgents, document.agentForm.clmsNickName, document.agentForm.bookNickName, document.agentForm.orderby.value, document.agentForm.membersString, book)">
				</select><br>
				<font class="cnt">(you can use double click to add)</font>
				<br><br>
		</td>
		<td align="left" width="30%" valign="<%=addressBook? "top" :"center" %>">
		<br><br>
				<table border="<%=addressBook? "1" :"0" %>" cellspacing="0" cellpadding="0" bordercolorlight="#C0D9F5" bordercolordark=white align="left">
				<%
				if (addressBook)
				{
				%>
				<tr><td align="center">
				<font  class="cntblu">Give Nick Name</font>
				<input type="text" name="clmsNickName" value="" onKeyPress="if(event.keyCode==13){shiftOption(document.agentForm.allAgents, document.agentForm.bookAgents, document.agentForm.clmsNickName, document.agentForm.bookNickName, document.agentForm.orderby.value, document.agentForm.membersString, book)}" onFocus="this.select()" MAXLENGTH="40" size="15">
				<font class="cnt"><br>(press enter key to add)</font>		
				<br>
				</td></tr>
				<tr><td align="center">
				<input type="Button" value="Add  >>" onClick="javascript:shiftOption(document.agentForm.allAgents, document.agentForm.bookAgents, document.agentForm.clmsNickName, document.agentForm.bookNickName, document.agentForm.orderby.value, document.agentForm.membersString, book)"  class="cnt">
				</td>
				</tr>
				<%
				}
				else
				{
				%>
				<tr><td align="center">
				<input type="hidden" name="clmsNickName" value="" >
				<input type="Button" value="Add  >>" onClick="javascript:shiftOption(document.agentForm.allAgents, document.agentForm.bookAgents, document.agentForm.clmsNickName, document.agentForm.bookNickName, document.agentForm.orderby.value, document.agentForm.membersString, book)"  class="cnt"><br>&nbsp;
				</td></tr>
				<%
				}	
				%>
			
				
			
				<%
				if (addressBook)
				{
				%>
				<tr><td align="center">
				<input type="Button" value="<<Remove" onClick="javascript:shiftOption( document.agentForm.bookAgents, document.agentForm.allAgents,  document.agentForm.bookNickName, document.agentForm.clmsNickName, document.agentForm.orderby.value, document.agentForm.membersString, book);"  class="cnt">
				</td></tr>
				<%
				}
				else
				{
				%>
				<tr><td align="center">
				<input type="hidden" name="bookNickName" value=""><input type="Button" value="<< Remove" onClick="javascript:shiftOption( document.agentForm.bookAgents, document.agentForm.allAgents,  document.agentForm.bookNickName, document.agentForm.clmsNickName, document.agentForm.orderby.value, document.agentForm.membersString, book);"  class="cnt">
				</td></tr>
				<%
				}	
				%>
				</table>


			</td>
			<td align="left" valign="top" class="cnt" width="35%">
			<br><br>
				<select size="11" name="bookAgents" class="cnt" onChange="showNickName(this,document.agentForm.bookNickName)" 
				onClick="showNickName(this,document.agentForm.bookNickName)"
				ondblClick="javascript:shiftOption( document.agentForm.bookAgents, document.agentForm.allAgents, document.agentForm.bookNickName, document.agentForm.clmsNickName, document.agentForm.orderby.value, document.agentForm.membersString, book);"  >
		<%
			String membersString ="|";
			for (int i=0; i< bookAgents.length; i++)
			{
				membersString+= bookAgents[i].getAgentName().toLowerCase() + "-" + bookAgents[i].getNickName() +"|";
			}	
		%>
				</select><br>
				<font class="cnt">(you can use double click to remove)</font><br>
				<%
				if (addressBook)
				{
				%>
				<font class="verbld">Nick Name of Selected Member </font><br><input type="text" name="bookNickName" value="" onFocus="this.select()" onKeyPress="if(event.keyCode==13){editNickName(document.agentForm.bookAgents,this, document.agentForm.membersString)}" MAXLENGTH="40" ><input type="Button" value="Edit" onClick="javascript:editNickName(document.agentForm.bookAgents,document.agentForm.bookNickName, document.agentForm.membersString)"  class="cnt"><font class="cnt"><br>(you can press enter key to edit)</font>
				<%
				}
				%>


				<br>
			</td>
		</tr>


		<tr>
		<input type="hidden" name="membersString" value="<%=membersString%>">

			<td align="center" colspan="3"><input type="button" value="Cancel Changes"
			<%if (display==null || !display.equals("full")){%>
			onClick="window.location.href='/msg/list/MSGMemberBook.jsp?qid=<%=qid%>&type=<%=type%>&receiver=<%=receiver%>'"  
			<%}
			else
				out.println("onClick=\"window.location.href='/msg/list/MSGCreateMemberBook.jsp?type="+ (addressBook? "SYSTEM" :"USER") +"&display=full&cat=1'\"");
			%> class="cnt">&nbsp;&nbsp;<input type="button" value="Save Changes" onClick="document.agentForm.submit()" class="cnt"></td>
		</tr>
<%
}
%>

</table>
	<input type="hidden" name="display" value="<%=full?"full":"partial"%>">
	<input type="hidden" name="type" value="<%=type%>">
	<input type="hidden" name="qid" value="<%=qid!=null? qid:""%>">
	<input type="hidden" name="receiver" value="<%=receiver!=null? receiver:""%>">
</form>

<%
if (full)
{
%>
	</td></tr>
	</table>
</td></tr>
</table>
<%
}
else
{
out.println("</td></tr></table>");
}
%>
</body>
</html>
