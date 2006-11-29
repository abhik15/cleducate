<%-- 
  -- FileName MSGLocationTree.jsp
  -- Author Shilpa Arora
  -- Date 4th september 2002
  --%>

<%-- 
  -- The location box for CLMS displays the receivers by their locations. The location tree is built on
  -- the bases of the reserved words, the words reserved in CLMS are.
  -- 1. All
  -- 2.	Head Office
  -- 3. Delhi
  -- 4. Mumbai
  -- 5. Noida
  -- 6. Thane
  -- 7.	Chandigarh
  -- 8.	Pune
  -- 9.	Network
  -- All these reserved words make the expandable nodes of the tree, that displays the Receivers of that
  -- particular location. The user if chooses the location cannot choose the receiver of that location
  -- inidividually as the reserved word of that location itself means all the receivers of that location.
  -- 
  --%>

<%
String logFile=application.getRealPath("/logs/error/")+"MSGErrorLog.log";
%>

<%@ page import="com.cl.msg.*,java.sql.Connection,com.cl.sql.PoolManager"  %>
<jsp:useBean id="queues" class="com.cl.msg.MSGQueues" scope="application" />
<jsp:setProperty name="queues" property="errorFileName" value="<%=logFile %>"/>


<%!
/*
 * Generates a '|' delimited string of the ids passed as array(no '|' signs at corners) 
 */
String makeLocationString(int[] locID){
	String loc="";
	for(int i=0;i<locID.length;i++){
		loc+=locID[i];
		if(i<locID.length-1)
			loc+="|";
		}
	return loc;
}

int idCounter=0;//gets used for generating ids of <tr>'s of the receivers

// CLMS reserved words...
String reservedWords[]= {
	"Head Office", 
	"Delhi", 
	"Mumbai", 
	"Noida", 
	"Thane", 
	"Chandigarh", 
	"Pune", 
	"Network"};
%>



<%
request.setAttribute("jspname","/msg/LocationTree.jsp");
int qID=0;
int count=0;
int[] locIDArray;
int receiversCount = 0;
String receiver="";
String expanded="";
MSGAgent[] agents=null;
receiver =request.getParameter("receiver");
expanded =request.getParameter("xpd");
if(receiver==null)
	receiver="";
if(expanded==null)
	expanded="";

try{
	qID=Integer.parseInt(request.getParameter("qid"));
}catch(NumberFormatException nfe){
	qID=0;
	}

%>


<html>

<head>
<title>CLMS- Location Tree</title>
<link rel="stylesheet" href="/styles/style.css" type="text/css">

<script language="javascript">

/* Gets called on the click event of the parent nodes' checkboxes to update the clicked/enabled status 
 * all the checkboxes shown on the screen at that time
 */
function update(cVal, cName){

for(var i=0;i<document.agentForm.elements.length;i++)
	{
	if(document.agentForm.elements[i].type=="checkbox" && document.agentForm.elements[i].name==cName )
		{
		if(document.agentForm.elements[i-1].name=="B-"+document.agentForm.elements[i].value )
			{
			update(cVal, (document.agentForm.elements[i].name.substr(0,document.agentForm.elements[i].name.indexOf('-'))-1)+'-'+document.agentForm.elements[i].value);
			document.agentForm.elements[i].checked= cVal;
			document.agentForm.elements[i].disabled= cVal;
			}
			else
			{
			document.agentForm.elements[i].disabled= false;
			document.agentForm.elements[i].checked= !cVal;
			document.agentForm.elements[i].click();
			document.agentForm.elements[i].disabled= cVal;
			}
		}
	else if(document.agentForm.elements[i].type=="text" && document.agentForm.elements[i].name=="T"+cName.substr(cName.indexOf("-"),cName.length-cName.indexOf("-")))
		{
			if(cVal)
				{
				document.agentForm.elements[i].value="All members selected";
				}
			else 
				{
				document.agentForm.elements[i].value=document.agentForm.elements[i].defaultValue;
				}
		}
	}


}


/* 
 * Records the current screen status to the receivers' string (selected users get added/deselected, 
 * disabled get removed)
 */
function record(){
document.agentForm.receiver.value=trim(document.agentForm.receiver.value);
for(i=1;i<document.agentForm.elements.length;i++)
	{
	if(document.agentForm.elements[i].type=="checkbox")
		{
		//if the checkbox is selected, not disabled and the value doesnt exist in receivers then Add-->
		if(document.agentForm.elements[i].checked==true && 		document.agentForm.elements[i].disabled==false && match(document.agentForm.receiver.value, document.agentForm.elements[i].value)=='')
			{
			if(document.agentForm.receiver.value!="" )
				{
				document.agentForm.receiver.value+=", ";
				}
			document.agentForm.receiver.value+=document.agentForm.elements[i].value;
			}
		//if the checkbox is not selected or disabled and the value exists with receivers then Remove-->
		else if((document.agentForm.elements[i].checked==false || 		document.agentForm.elements[i].disabled==true) && match(document.agentForm.receiver.value, document.agentForm.elements[i].value)!='')
			{
			var removeVal=match(document.agentForm.receiver.value, document.agentForm.elements[i].value);
			var putIn='';
			if(removeVal.indexOf(",")!=removeVal.lastIndexOf(","))
				{
				putIn=', ';
				}
			document.agentForm.receiver.value=document.agentForm.receiver.value.substr(0,document.agentForm.receiver.value.toUpperCase().indexOf(removeVal))+putIn+document.agentForm.receiver.value.substr(document.agentForm.receiver.value.toUpperCase().indexOf(removeVal)+removeVal.length,document.agentForm.receiver.value.length);
				
			}

		}
	}
document.agentForm.receiver.value=trim(document.agentForm.receiver.value);
}


/*
 * Self call for the tree functionality with the modified var expanded.
 * For a node to be expanded its value should exist in var expanded as |RESERVED WORD|
 */

function tree(bVal, bName){
record();
document.treeForm.receiver.value=document.agentForm.receiver.value;
if(bVal=='+'){
	document.treeForm.xpd.value+='|'+bName.substr(2,bName.length)+'|';
}
else if(bVal=='-'){
document.treeForm.xpd.value=document.treeForm.xpd.value.substr(0,document.treeForm.xpd.value.indexOf('|'+bName.substr(2,bName.length)+'|'))+document.treeForm.xpd.value.substr(document.treeForm.xpd.value.indexOf('|'+bName.substr(2,bName.length)+'|')+bName.substr(2,bName.length).length+2,document.treeForm.xpd.value.length);
}
document.treeForm.submit();
}


function trim(s) {
return s.replace(/^\s*/, '').replace(/\s*$/, '');
}

/*
 * Customized match function written specifically for This Location Tree. Luks for the given string in
 * the given string.
 * param lookIn is the string in which it luks e.g. "Shilpa Arora, Uma Ramchandran, Dev Tuli"
 * param lookFor is the string it luks for e.g. "Shilpa Arora" or "Uma Ramchandran"
 * return value is a string, if no match found its empty i.e. ""
 * return value for the matched value is that particular value with any existing prefixing/suffixing 
 * commas e.g. on looking for the string "Shilpa Arora", this will return "Shilpa Arora," 
 * on looking for the string "Uma Ramchandran", this will return ", Uma Ramchandran," 
 */

function match(lookIn,lookFor){
lookIn=lookIn.toUpperCase();
lookFor=lookFor.toUpperCase();
lookIn=trim(lookIn);
var result='';
found=true;
start=0;
end=lookIn.length-1;
idx= lookIn.indexOf(lookFor);
if(idx==-1){
	return '';
}
//alert('in mhtd~luk in->'+lookIn+'luk for->'+lookFor+',index of-->'+idx);
//backward search
for(pos=idx-1;pos>=0;pos--){
if(lookIn.charAt(pos)==','){
	start=pos;
	break;
	}
else if(lookIn.charAt(pos)==' '){
	start=pos;
	}
else{
	found=false;
	break;
	}
}

//forward search
for(pos=idx+lookFor.length;pos<lookIn.length;pos++){
if(lookIn.charAt(pos)==','){
	end=pos;
	break;
	}
else if( lookIn.charAt(pos)==' '){
	end=pos;
	}
else{
	found=false;
	break;
	}
}
//alert('see start-'+start+', end-'+end);
if(found){
	result=lookIn.substr(start,end-start+1);
	}
else{
	result='';
	}

return result;
}




function loader(){
for(var y=0;y<document.agentForm.elements.length;y++){
	if(document.agentForm.elements[y].type=="checkbox" && document.agentForm.elements[y].disabled==false && match(document.agentForm.receiver.value,document.agentForm.elements[y].value) ){
		document.agentForm.elements[y].checked=false;
		document.agentForm.elements[y].click();
		}
	}

}

function done(){
record();
if(match(document.agentForm.receiver.value,'All')!=''){
	document.agentForm.receiver.value="All";
	}
window.opener.document.payload.receiver.value=document.agentForm.receiver.value;
window.close();
}


/*
 * Selecting/deselecting a name from the list of receivers changes the background color and updates 
 * the user feedback count.
 */
function chColor(cName, tdName, txtName){
var table= document.getElementById("TR-"+tdName); 
var text= document.getElementById(txtName); 
var cnt=0;
if(cName.checked==false)
	{
	if(trim(text.value)!="No member selected" && trim(text.value)!="All members selected")
		{
		cnt= parseInt(trim(text.value.substr(0,text.value.indexOf("mem"))))-1;
		if(cnt==0)
			{
			text.value="No member selected";
			}
		else if(cnt==1)
			{
			text.value="1 member selected";
			}
		else{
			text.value=cnt+" members selected";
			}
		}
	table.style.backgroundColor='#FFFFFF';
	}
else{
	if(trim(text.value)=="No member selected")
		{
		text.value="1 member selected";
		}
	else if(trim(text.value)!="All members selected")
		{
		text.value=(parseInt(trim(text.value.substr(0,text.value.indexOf("mem"))))+1)+" members selected";
		}
	table.style.backgroundColor='#DFE1BC';
	}
}

</script>

</head>

<body onload="javascript=loader()">
<!-- <p align="center"><font class="verbld">CLMS Members </font>&nbsp;<a href="/msg/MSGReceivers.jsp?qid=<%=qID%>&receiver=<%=receiver %>" class="lnkblu"> Go to the older version (Receivers List)</a></p>
 -->
 <div align="right"><a href="javascript: window.close()" class="lnkblu">Close Window</a></div>
 <font class="verbld"><%=qID>0?"<img src=\""+queues.getQueue(qID).getIconURL()+"\" align=\"absmiddle\">":"" %>&nbsp;Channel :</font> <font class="cnt"><%=qID>0?queues.getQueue(qID).getQDescr():"" %></font>

<p class="cnt" style="line-height: 180%">To send a message to all the members of any location, please choose the location by clicking the checkbox. To choose/see the members of a particular location click on the <input type="button" value="+" class="cnt"> button given with the location and to hide the members click on the button again.</p>
<%
	PoolManager clmsPool = PoolManager.getInstance();
	Connection conn = null;
	try
	{
		conn = clmsPool.getConnection("erp");
		receiversCount= queues.getReceiversCount(conn,"All", qID, 1);
		/* if the total receivers are less than or equal to 25, the tree will come with all branches expanded if 
		 * no expansion has been chosen by user 
		 */
		if(receiversCount<=25 && expanded.equals(""))
			for (int i=0;i<reservedWords.length;i++)
				expanded+="|"+reservedWords[i]+"|";

%>

<!--
  -- Form used to manage the tree function(expand/collapse)
  -->
<form method="post" action="/msg/MSGLocationTree.jsp" name="treeForm">
<input type="hidden" name="xpd" value="<%=expanded%>">
<input type="hidden" name="receiver" value="<%=receiver%>">
<input type="hidden" name="qid" value="<%=qID%>">
</form>

<form method="POST"  name="agentForm">
  <input type="hidden" name="receiver" value="<%=receiver%>">
  <table border="1" width="100%" bordercolorlight="#DFE1BC" cellspacing="0" cellpadding="0" bordercolordark="#FFFFFF" class="cnt">
    <tr>
		<td width="3%"><input type="checkbox" name="3-None" value="All" onClick="javascript:update(this.checked,'2-All')" title="Select/Deselect All Members"></td>
	    <td width="93%">All (<%=receiversCount %> members)</td>
    </tr>
    <tr>
	    <td width="3%">&nbsp;</td>
		<td width="93%">
        <table border="1" width="100%" bordercolorlight="#DFE1BC" cellspacing="0" cellpadding="0" bordercolordark="#FFFFFF" class="cnt">
			<%
			boolean xpd=false; //used to store the expanded status of a location
			//makes nodes of the reserved words
			for(int i=0;i<reservedWords.length;i++)
			{
			receiversCount=queues.getReceiversCount(conn,reservedWords[i], qID, 1);
			if(receiversCount>0)
				{
				xpd= expanded.indexOf("|"+reservedWords[i]+"|")>-1?true:false;
				%>
				<tr>
					<td width="4%"><input type="button" value="<%=xpd?"-":"+"%>" name="B-<%=reservedWords[i] %>" onClick="javascript:tree(this.value,this.name)" class="cnt" title="<%=xpd?"Hide":"Show"%> members of <%=reservedWords[i] %>"></td>
					<td width="4%">
					<input type="checkbox" name="2-All" value="<%=reservedWords[i] %>"  onClick="javascript:update(this.checked,'1-<%=reservedWords[i] %>')" title="Select/Deselect all members of <%=reservedWords[i] %>"></td>
					<td width="92%"><%=reservedWords[i] %> (<%=receiversCount %> member<%=receiversCount>1?"s":"" %>) 
					<%
					int selected=0;
					if(expanded.indexOf("|"+reservedWords[i]+"|")==-1 && !receiver.equals(""))
					{
					MSGQueues.SelectedReceivers sr= queues.getSelectedReceiversCount(conn,reservedWords[i], qID,receiver);
					selected= sr.count;
					receiver= sr.notFound;
					}
					out.println("<input type=\"text\" name=\"T-"+reservedWords[i]+"\" size=\"25\" style=\"border-style: dotted; border-color: #FFFFFF\" value=\""+(selected==0?"No":Integer.toString(selected))+" member"+(selected==0?"":"s")+" selected\" onfocus=\"blur()\" class=\"new\">" );
					%>
					</td>
				</tr>
				<%
					//if this part of node is to be expanded
					if(expanded.indexOf("|"+reservedWords[i]+"|")>-1)
						{
						agents= queues.getRecepients(conn,qID, 1,"|"+makeLocationString(queues.getLocationIDs(conn,reservedWords[i]))+"|");
						if(agents!=null && agents.length>0)
							{
							%>
							<tr>
								<td width="4%">&nbsp;</td>
								<td width="4%">&nbsp;</td>
								<td width="92%">
								<table border="1" width="100%" cellspacing="0" cellpadding="0" bordercolordark="#FFFFFF" bordercolorlight="#DFE1BC" class="cnt">
									<%
									for(int y=0;y<agents.length;y++)
										{
										%>
										<tr id="TR-<%=idCounter %>">
										  <td width="5%"><input type="checkbox" name="1-<%=reservedWords[i] %>" value="<%=agents[y].getAgentName() %>" onClick="javascript:chColor(this,<%=idCounter %>,'T-<%=reservedWords[i] %>')" title="Select/Deselect <%=agents[y].getAgentName() %>"></td>
										  <td width="55%"><%=agents[y].getAgentName() %></td>
										  <td width="40%"><%=agents[y].getLocation() %></td>
										</tr>
										<%
										idCounter++;
										 }//end of for loop of agents	  
										%>
								 </table>
								 </td>
							</tr>
							<%
							}// end of if(receivers exist in location)
						}// end of if(expanded)
				}// end of if(receivers more than 0)
			}// end of for loop--reservedWords length
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}
			%>
            </table>
		</td>
	</tr>
  </table>
  <table border="0">
  <tr>
  <td><input type="button" value="O K " onClick="javascript:done()" class="cnt"></td>
  <td><input type="button" value="Cancel" onClick="javascript:window.close()" class="cnt"></td>
  </tr>
  </table>
</form>
 <div align="right"><a href="javascript: window.close()" class="lnkblu">Close Window</a></div>
</body>

</html>
