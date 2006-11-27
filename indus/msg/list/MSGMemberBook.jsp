<%--
  -- Author Shilpa Arora
  -- File MSGMemberBook.jsp
  -- Create Date 4 March 03
  --%>

<%@ page import="java.sql.Connection,com.cl.sql.CLMSPoolManager,com.cl.msg.*"  %>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>
<cl:CLValidateSessionTag />

<%
/*
 * The code displays the users address book(initially called as member book) 
 * to him with their status to the current channel, he can select the users
 * from here and that go to his "TO BOX", this is one of the ways of receiver
 * selection just like location tree and receivers list
 */
String logFile	=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
String receiver = request.getParameter("receiver");
String message	= request.getParameter("message");
String type		= request.getParameter("type");

if(message == null)
	message = "";

int qID = 0;

if (type==null || type.equals(""))
{
	type= "SYSTEM"; //default is system i.e. address book
}

boolean addressBook = type.equals("SYSTEM")?true:false; //bolean value for the ease of coditional interface shown by the code

try
{
	qID = Integer.parseInt(request.getParameter("qid"));
}
catch(NumberFormatException nfe)
{
	throw new Exception ("Invalid qid passed-->"+request.getParameter("qid"));
}
%>

<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
<jsp:useBean id="book" class="com.cl.msg.list.MSGMemberBook" scope="page" />
<%
	CLMSPoolManager clmsPool = CLMSPoolManager.getInstance();
	Connection conn = null;
	MSGAgent[] agents = null;
	try
	{
		conn = clmsPool.getConnection("erp");
		//retrieves the members from the list as well as their status for the channel
		agents = book.getMemberList(conn,agent.getAgentID(),agent.getDestID(), qID, type);
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
%>

<HTML>
<HEAD>
<TITLE>CLMS- <%= type.equals("SYSTEM")? "Address Book":"Group List"%> </TITLE>
<link rel="stylesheet" href="/styles/style.css" type="text/css">

<script language="javascript">


/* 
 * This is used when user has made the selection and closes the window, it
 * effects the opening windows "To Box Value"
 * Records the current screen status to the receivers' string 
 * (selected users get added/deselected, 
 * disabled get removed)
 */
function record()
{
	document.agentForm.receiver.value=trim(document.agentForm.receiver.value);
	for(i=1;i<document.agentForm.elements.length;i++)
	{
		//first remove all the agent names that exist in the string
		if((document.agentForm.elements[i].type=="checkbox" ||
			(document.agentForm.elements[i].type=="hidden"
			&& document.agentForm.elements[i].name!="receiver")) &&
			match(document.agentForm.receiver.value, document.agentForm.elements[i].value)!='')
			{
				
					// look for remove val i.e. the exact agent name
					var removeVal=match(document.agentForm.receiver.value, document.agentForm.elements[i].value);

					var putIn='';
					if(removeVal.indexOf(",")!=removeVal.lastIndexOf(","))
					{
						putIn=', ';
					}
					document.agentForm.receiver.value=document.agentForm.receiver.value.substr(0,document.agentForm.receiver.value.toUpperCase().indexOf(removeVal))+putIn+document.agentForm.receiver.value.substr(document.agentForm.receiver.value.toUpperCase().indexOf(removeVal)+removeVal.length,document.agentForm.receiver.value.length);

			}
				
		}		
		// then add all the nick names to it
		for(i=1;i<document.agentForm.elements.length;i++)
		{
			if(
				(document.agentForm.elements[i].type=="checkbox" &&
				document.agentForm.elements[i].checked==true && 		document.agentForm.elements[i].disabled==false ) 
				&& match(document.agentForm.receiver.value, "\""+document.agentForm.elements[i].name+"\"")=='')
				{
					if(document.agentForm.receiver.value!="" )
					{
						document.agentForm.receiver.value+=", ";
					}
					document.agentForm.receiver.value+='"'+document.agentForm.elements[i].name+'"';
				}
			
				//if the checkbox is not selected or disabled and the value exists with receivers then Remove-->
				else if(
				document.agentForm.elements[i].type=="checkbox" &&
				(document.agentForm.elements[i].checked==false || 		document.agentForm.elements[i].disabled==true)
				&& (
				match(document.agentForm.receiver.value, "\""+document.agentForm.elements[i].name+"\"")!=''))
				{
					// look for remove val i.e. the exact agent name
					var removeVal=match(document.agentForm.receiver.value, "\""+document.agentForm.elements[i].name+"\"");
					// if exact agent name not found then look for nick name
					if (removeVal=='')
					{
						removeVal=match(document.agentForm.receiver.value, "\""+document.agentForm.elements[i].name+"\"");
					}
					var putIn='';
					if(removeVal.indexOf(",")!=removeVal.lastIndexOf(","))
					{
						putIn=', ';
					}
					document.agentForm.receiver.value=document.agentForm.receiver.value.substr(0,document.agentForm.receiver.value.toUpperCase().indexOf(removeVal))+putIn+document.agentForm.receiver.value.substr(document.agentForm.receiver.value.toUpperCase().indexOf(removeVal)+removeVal.length,document.agentForm.receiver.value.length);
				}

			}

	document.agentForm.receiver.value=trim(document.agentForm.receiver.value);
	window.opener.document.payload.receiver.value=document.agentForm.receiver.value;
	window.close();
}


// the function is performs the mass check/uncheck of checkboxes
function checkIt()
{
	if (document.agentForm.elements[0].checked==true)
	{
		for(i=1;i<document.agentForm.elements.length;i++)
		{
			if(document.agentForm.elements[i].type=="checkbox" && !document.agentForm.elements[i].disabled )
			{
				document.agentForm.elements[i].checked=false;
				document.agentForm.elements[i].click();
			}
		}
	}
	else
	{
		for(i=1;i<document.agentForm.elements.length;i++)
		{
			if(document.agentForm.elements[i].type=="checkbox" && !document.agentForm.elements[i].disabled )
			{
				document.agentForm.elements[i].checked=true;
				document.agentForm.elements[i].click();
			}
		}
	}
}

//called by the checkboxes to remove the check from the "CHECK ALL CHECKBOX"
function uncheckIt(val)
{
	if(document.agentForm.elements[0].type=="checkbox" && document.agentForm.elements[0].checked ==true)
	{
		document.agentForm.elements[0].checked = val;
	}
}

/*
 * Called the first time when the windo opens, to select the checkboxes whose
 * value already exist in the openers "TO BOX"
 */
function loader()
{
	self.resizeTo(450,460);

	for(var y=0;y<document.agentForm.elements.length;y++)
	{
		if(document.agentForm.elements[y].type=="checkbox" && document.agentForm.elements[y].disabled==false && 
	(match(document.agentForm.receiver.value,document.agentForm.elements[y].value) || match(document.agentForm.receiver.value,"\""+document.agentForm.elements[y].name + "\"")) )
		{
			document.agentForm.elements[y].checked=false;
			document.agentForm.elements[y].click();
		}
	}
}

/*
 * CUSTOMISED TRIM 
 */
function trim(s) 
{
	return s.replace(/^\s*/, '').replace(/\s*$/, '');
}

/*
 * Customized match function written specifically for This Book. Luks for 
 * the given string in the given string.
 * param lookIn is the string in which it luks e.g. "Shilpa Arora, 
 * Uma Ramchandran, Dev Tuli"
 * param lookFor is the string it luks for e.g. "Shilpa Arora" or "Uma
 * Ramchandran"
 * return value is a string, if no match found its empty i.e. ""
 * return value for the matched value is that particular value with any existing prefixing/suffixing 
 * commas e.g. on looking for the string "Shilpa Arora", this will return "Shilpa Arora," 
 * on looking for the string "Uma Ramchandran", this will return ", Uma Ramchandran," 
 */

function match(lookIn,lookFor)
{
	lookIn=lookIn.toUpperCase();
	lookFor=lookFor.toUpperCase();
	lookIn=trim(lookIn);
	var result='';
	found=true;
	start=0;
	end=lookIn.length-1;
	idx= lookIn.indexOf(lookFor);
	if(idx==-1)
	{
	return '';
	}
	//alert('in mhtd~luk in->'+lookIn+'luk for->'+lookFor+',index of-->'+idx);
	//backward search
	for(pos=idx-1;pos>=0;pos--)
	{
		if(lookIn.charAt(pos)==',')
		{
			start=pos;
			break;
		}
		else if(lookIn.charAt(pos)==' ')
		{
			start=pos;
		}
		else
		{
		found=false;
		break;
		}
	}

	//forward search
	for(pos=idx+lookFor.length;pos<lookIn.length;pos++)
	{
		if(lookIn.charAt(pos)==',')
		{
			end=pos;
			break;
		}
		else if( lookIn.charAt(pos)==' ')
		{
			end=pos;
		}
		else
		{
			found=false;
			break;
		}
	}
	//alert('see start-'+start+', end-'+end);
	if(found)
	{
		result=lookIn.substr(start,end-start+1);
	}
	else
	{
		result='';
	}
	return result;
}

/*
 * click operation on a checkbox performs highlighting of the row and the 
 * rows of the same nick names, as well as unchecking the "CHECK ALL CHECKBOX"
 */
function clickOperation(chkBox, trID)
{
	uncheckIt(chkBox.checked);
	var tr= document.getElementById('tr-'+trID); 
	while (tr!=null)
	{
		if (chkBox.checked)
		{
			tr.style.backgroundColor='<%=addressBook?"#E2F2FE":"#F2F4E3"%>';
		}
		else
		{
			tr.style.backgroundColor='#FFFFFF';
		}
		tr = document.getElementById('tr-'+trID+'tr-'+(parseInt(trID)+1));
		trID++;
	}

}


</script>


</HEAD>

<BODY <%= (agents != null && agents.length >0)? "onload=\"loader()\"":"" %>>

<p class="new"><%=message%></p>

 <font class="verbld"><%=qID>0?"<img src=\""+queues.getQueue(qID).getIconURL()+"\" align=\"absmiddle\">":"" %>&nbsp;Channel :</font> <font class="cnt"><%=qID>0?queues.getQueue(qID).getQDescr():"" %></font>

<p class="cnt" style="line-height: 180%">This is the listing of your <%= addressBook?"Address book":"Group List"%>, please click on the checkbox to choose the <%= addressBook?"members":"groups"%> you want to send your message to. You can use the <%= addressBook?"nick":"group"%> names directly in the "To Box" within quotes( for e.g. <%= addressBook?"\"shivku\"":"\"southcampus\" or \"myteam\""%>). To edit your <%= addressBook?"address book":"group list"%> please <a href="/msg/list/MSGCreateMemberBook.jsp?display=partial&qid=<%=qID%>&type=<%=type%>&receiver=<%=receiver%>" class="lnkblu">click here</a>.</p>
<%
if (agents == null || agents.length ==0)
{
%>
<table class="lnkbld" border="0"   bordercolorlight="#C0D9F5" cellspacing="0" cellpadding="0" bordercolordark="#FFFFFF" width="100%">
<tr>
<td align="center">(Your <%= addressBook?"Address book":"Group List"%> is empty at the moment)
</td>
</tr>
</table>
<%
}
else 
{
%>
	<form name="agentForm">
	<%
	if (addressBook)
	{
	%>
		<table border="1" width="100%" bordercolorlight="<%=addressBook?"#C0D9F5":"#dfe1bc"%>" cellspacing="0" cellpadding="0" bordercolordark="#FFFFFF" class="cnt">
		<tr class="verbld" bgcolor="<%=addressBook?"#C0D9F5":"#dfe1bc"%>">
		<td width="5%" ><input type="checkbox" value="#" name="chkAll" onClick="checkIt()"></td>
		<td width="35%" >All Members(Nick Names)</td>
		<td width="35%" >All Members(CLMS Names)</td>
		<td width="25%" >Status for the channel</td>
		</tr>
		
		<%
		String previousNickName = "";
		int previousID =0;
		String bgcolor= "#FFFFFF";// param is bgcolor of the row which is to be disabled if agents cant read from the channel the normal color is FFFFFF(i.e. white)

		for (int i=0;i<agents.length;i++)	
		{
			if(agents[i].getQPrivilege()==-1 || agents[i].getQPrivilege()==2)
				bgcolor = "#E4E4E4";
			else 
				bgcolor = "#FFFFFF";
		%>
		<tr height="20" id="<%=(agents[i].getNickName().equals(previousNickName) && !bgcolor.equals("#E4E4E4"))?"tr-"+previousID:""%>tr-<%=i%>" bgcolor = "<%=bgcolor%>">
		<td width="5%" >
		<%if (!agents[i].getNickName().equals(previousNickName)) {%>
		<input type="checkbox" value="<%=agents[i].getAgentName()%>" onClick="clickOperation(this, '<%=i%>')" <%=(bgcolor.equals("#E4E4E4")?"disabled":"")%> name="<%=agents[i].getNickName()%>">
		<%} else {%>
		<input type="hidden" value="<%=agents[i].getAgentName()%>"   name="<%=agents[i].getNickName()%>">
		<%}%>
		</td>
		<td width="35%" >
		"<%=agents[i].getNickName()%>"
		</td>
		<td width="35%"  ><%=agents[i].getAgentName()%></td>
		<td width="25%" >
		<% 
			/*
			 * Privilege can have the following values
			 * -1 for no privilege for the channel (no entry in msg_q_acl)
			 * 2 write privilege only
			 * 4 read privilege only (valid in this context)
			 * 6 read/write privileges (valid in this context)
			 */
			switch(agents[i].getQPrivilege())
			{
				case -1:
					out.println("<font class=\"new\">No privileges</font>");
					break;
				case 2:
					out.println("<font class=\"new\">Cannot Read</font>");
					break;
				default:
					out.println("<font class=\"cntblu\">OK</font>");
					break;

			}
		%>
		</td>
		<%
			previousNickName = agents[i].getNickName();
			previousID = i;
		}	
		%>
		<tr>
		<td colspan="4" align="center"><input type="button" value="Cancel and Close" onClick="window.close()" class="cnt"><input type="button" value="Select Checked Names" onClick="record()" class="cnt"></td>
		</tr>
		<input type="hidden" name="receiver" value='<%=receiver%>'>

		</table>
	<%
	}
	else	
	{
	%>

		<table border="1" width="100%" bordercolorlight="#dfe1bc" cellspacing="0" cellpadding="0" bordercolordark="#FFFFFF" class="cnt">
		<tr class="verbld" bgcolor="#dfe1bc">
		<td width="5%" ><input type="checkbox" value="#" name="chkAll" onClick="checkIt()"></td>
		<td width="35%" >All Groups</td>
		<td width="60%" >All Members of Groups(CLMS Names)</td>
		</tr>
		
		<%
		String groupAgents ="";// the agents of the group
		String previousNickName = "";
		int countValidAgents = 0;// tracks how many agents in a channel are valid
		int previousID =0;
		String fontclass= "cnt";// this is the font class for the display of agents who have read privileges for the channel, those who cant read from the channel the class used is disabled
		String bgcolor= "#FFFFFF";// param is bgcolor of the row which is to be disabled if all the agents of the group cant read from the channel the normal color is FFFFFF(i.e. white)


		for (int i=0;i<agents.length;i++)	
		{
			if(agents[i].getQPrivilege()==-1 || agents[i].getQPrivilege()==2)
				fontclass = "disabled";
			else 
				fontclass = "cnt";
			
			
			if (agents[i].getNickName().equals(previousNickName))
			{
				if(fontclass.equals("cnt"))countValidAgents ++;
				groupAgents+=", <font class=\""+fontclass+"\">"+agents[i].getAgentName()+"</font>";
			}
			else
			{
				if (groupAgents.length()>0)
					{
						if (countValidAgents==0) // to disable a group
						{
							bgcolor ="#E4E4E4";
						}
					%>
					<tr height="20" id="<%=(agents[i].getNickName().equals(previousNickName) && !bgcolor.equals("#E4E4E4"))?"tr-"+previousID:""%>tr-<%=i%>" bgcolor = "<%=bgcolor%>">
					<td width="5%" >
					<%if (!agents[i].getNickName().equals(previousNickName)) {%>
					<input type="checkbox" value="<%=previousNickName%>" onClick="clickOperation(this, '<%=i%>')" <%=(bgcolor.equals("#E4E4E4")?"disabled":"")%> name="<%=previousNickName%>">
					<%} else {%>
					<input type="hidden" value="<%=previousNickName%>"   name="<%=agents[i].getNickName()%>">
					<%}%>
					</td>
					<td width="35%" >
					"<%=previousNickName%>"
					</td>
					<td width="60%"  ><%=groupAgents%></td>
					</tr>
					<%
					}
				groupAgents="<font class=\""+fontclass+"\">"+agents[i].getAgentName()+"</font>";
				if(fontclass.equals("cnt"))
					countValidAgents =1;
				else
					countValidAgents = 0;

				}
			previousNickName = agents[i].getNickName();
			previousID = i;
		}	
		
		if (countValidAgents==0) // to disable a group
		{
			bgcolor ="#E4E4E4";
		}
		else
		{
			bgcolor= "#FFFFFF";
		}
		%>
					<tr height="20" id="tr-<%=(previousID+1)%>" bgcolor = "<%=bgcolor%>">
					<td width="5%" >
					<input type="checkbox" value='<%=previousNickName%>' onClick="clickOperation(this, '<%=(previousID+1)%>')"   name="<%=previousNickName%>" <%=(bgcolor.equals("#E4E4E4")?"disabled":"")%>>
					</td>
					<td width="35%" >
					"<%=previousNickName%>"
					</td>
					<td width="60%"  ><%=groupAgents%></td>
					</tr>



		<td colspan="4" align="center"><input type="button" value="Cancel and Close" onClick="window.close()" class="cnt"><input type="button" value="Select Checked Names" onClick="record()" class="cnt"></td>
		</tr>
		<input type="hidden" name="receiver" value='<%=receiver%>'>
		</table>
		<p class="new">
		Please note: The <font class="disabled">grayed names</font> are the disabled names in a group for the current channel i.e. these members cannot read from the specific channel and while using the group name to send the message, the message will not be sent to the <font class="disabled">grayed names</font>. Incase no member of the group can read from the channel, the group is disabled.
		</p>


	<%
	}	
	%>
	</form>
<%
}	
%>
<br>
</BODY>
</HTML>
