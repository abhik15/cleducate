<%@ page import="java.sql.Connection,com.cl.sql.CLMSPoolManager,java.util.*"  errorPage="/msg/MSGErrorPage.jsp"%>
<%@ taglib uri="http://www.careerlauncher.com/cl_taglib" prefix="cl" %>
<%--
  -- Filename:	 MSGDisplayPrivilege.jsp
  -- Author:     Shilpa Arora
  -- Create Date:5th June 2002 
  --%>

<%
	CLMSPoolManager clmsPool = CLMSPoolManager.getInstance();
	Connection conn = null;
	int cat = 1;
	String logFile = application.getRealPath("/logs/error/")+"MSGErrorLog.log";
	request.setAttribute("cat",Integer.toString(cat));
	request.setAttribute("jspname","/msg/MSGSDisplayPrivilege.jsp");
%>

	<cl:CLValidateSessionTag />
	<jsp:useBean id="form" class="com.cl.common.CLFormEssentials" scope="application"/>
	<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
	<jsp:setProperty name="agent" property="errorFileName" value="<%=logFile %>"/>
	<jsp:useBean id="studentPicker" class="com.cl.msg.admin.MSGStudentPicker" scope="page" />
	<jsp:setProperty name="studentPicker" property="errorFileName" value="<%=logFile %>"/>

	<jsp:useBean id="loginControl" type="com.cl.common.CLLoginControl" scope="session"/>

	<jsp:useBean id="appPrivilege" scope="session" type="com.cl.clzone.login.AppPrivilege"/>
<%
	int empId = loginControl.getEmpId();
	
	String qid = request.getParameter("qid");
	String pid = request.getParameter("pid");
	
	String scope1 = "";//request.getParameter("scope1");
	//System.out.println(scope1);
	String privilege = request.getParameter("privilege");
		if(privilege.equals("LOC_BATCHES"))
		{
			scope1 = appPrivilege.checkPrivilege("ERP#CLMS#SEND_SCHED_ANNOU_BATCHES");
		}
		if(privilege.equals("ALL_CENTERS"))
		{
			scope1 = appPrivilege.checkPrivilege("ERP#CLMS#SEND_SCHED_ANNOU_CENTER");
		}
		if(privilege.equals("ALL_PRODS"))
		{
			scope1 = appPrivilege.checkPrivilege("ERP#CLMS#CLMS_ACAD_HEAD");
		}
	String productCategory = request.getParameter("product");
	String product = request.getParameter("product_display");
	boolean call = true;
	if(productCategory == null || productCategory.equals("null")|| productCategory.equals(""))
	{
		productCategory = "MBA";
		call = false;
	}
	if(product == null || product.equals("null")|| product.equals(""))
		product = "All";
	String display[][] = null;

	/*
	 * Various privileges need to have only one output for this jsp to function  
	 * i.e. two dimential array- display, the first dimention holds the id and the other dimention hold
	 * the value for the display.
	 */

	try
	{
		conn = clmsPool.getConnection("erp");

		if(privilege != null && privilege.equals("ALL_PRODS"))
			display = studentPicker.getProducts(conn,empId);
		else if(privilege != null && privilege.equals("ALL_CENTERS"))
			display = studentPicker.getCenters(conn,scope1,empId);
		else if(privilege != null && privilege.equals("ALL_BATCHES"))
			display = studentPicker.getBatches(conn);
		else if(privilege != null && privilege.equals("LOC_BATCHES") && call)
			display = studentPicker.getBatches(conn,agent.getPkID(),productCategory , product,scope1);
%>
	<html>
	<head>
	<title>Whom do you want to send message?</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache">

	<link rel="stylesheet" href="/styles/style.css" type="text/css">
	<script language="javascript">
	//for the privilege-ALL_PRODS

	<%
	if((privilege != null && privilege.equals("ALL_PRODS")))
	{
	%>
	
	function popup(pids, idx, prod)
	{
	tagpopup= window.open("/msg/admin/MSGShowProducts.jsp?pids="+pids+"&cpids="+document.getElementById("ids"+idx).value+"&idx="+idx+"&prod="+prod,"registration","left=0,top=0,status=no,resize=yes,toolbar=no,scrollbars=yes,width=670,height=380");
	}

	//for the privilege-ALL_PRODS
	function reset()
	{
		<%
		for(int i=0;i< display.length;i++)
			{
			%>
				document.pForm.ids<%=i%>.value = document.pForm.ids<%=i%>.defaultValue;
				document.pForm.display<%=i%>.value = document.pForm.display<%=i%>.defaultValue;
			<%
			}
		%>
	}

	<%
	}	
	%>

	// for all privileges
	function selectAll()
	{
		for(i=1;i<document.pForm.elements.length;i++)
		{
			if(document.pForm.elements[i].type=="checkbox" )
			{
				document.pForm.elements[i].checked=true;
			}
		}
	}

	// for all privileges
	function unSelectAll()
	{
		for(i=1;i<document.pForm.elements.length;i++)
		{
			if(document.pForm.elements[i].type=="checkbox" )
			{
				document.pForm.elements[i].checked=false;
			}
		}
	}

	// for all privileges
	function verify()
	{
		count=0;
		for(i=1;i<document.pForm.elements.length;i++)
		{
			if(document.pForm.elements[i].type=="checkbox" && document.pForm.elements[i].checked==true)
			{
				count++;
			}
		}
		if(count<1)
		{
			alert("Please choose at least one of the choices given to you.");
			return false;
		}
		return true;
	}

<%
	if(privilege != null && privilege.endsWith("BATCHES"))
	{
		String fproduct = "";
		String fproductCategory = "";
		String tmp = "";
		//System.out.println("TOKENS: " + form.getProdCategory());
		StringTokenizer tokens = new StringTokenizer(form.getProdCategory(), ",");
/*		while(tokens.hasMoreElements())
		{
			fproduct += "'All',";
			tmp = tokens.nextToken();
			fproductCategory += "'" + tmp.substring(1,tmp.indexOf("'",1)) + "',";
		}
*/
		fproduct += form.getProdTitle();
		fproductCategory += form.getProdTitleCategory();
%>
	   <cl:productCategory category="<%=form.getProdCategory()%>" product="<%=fproduct%>" productCategory="<%=fproductCategory %>" htmlType="javascript" selectedCategory="<%=productCategory %>" selectedProduct="<%=product %>"/>
<%
	}// end of privilege ends with - BATCHES	
%>
	</script>
	</head>
	<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  <%=(privilege != null && privilege.equals("ALL_PRODS"))?"onLoad='reset()'":"" %>>
	<!-- Add top.js for top band -->
	<script language="javascript" src="/jscript/top.js"></script>
	<table border="0" width="100%" cellspacing="0" cellpadding="3">
	<tr valign="top"><td bgcolor="DFE1BC" width="21%" valign="top">
		<cl:CLMsgSisLeftBandTag connObj="<%=conn%>" category="<%=Integer.toString(cat)%>" level="1"/>
	</td>

	<td width="79%">
	<!-- TOP BAND START -->
	<table align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr valign="top"><td bgcolor="B4BC6D">
		<table border="0" cellspacing="0" cellpadding="0">
		<tr><td bgcolor="B4BC6D" height="32" width="10">
				<img src="img/blank.gif" width="1" height="28">
			</td>
			<td><font class="cntblu"><a href="/" class="lnkblu">Home</a><font class="cntblu"> &gt; </font><a href="/clzone/login/CLZone.jsp" class="lnkblu">CL Zone Home</a> &gt; <a href="/msg/MSGStaffCompose.jsp" class="lnkblu">Compose Message</a> &gt; <a href="/msg/admin/MSGPickStudents.jsp?pid=<%=pid%>&qid=<%=qid%>">Criteria Selection</a>
			&gt; <font class="cntblu">Whom do you want to send the message</font>
			</td>
		</tr>
		</table>
	</td></tr></table>
	<!-- TOP BAND END -->

	<table cellspacing="3" cellpadding="0" border="0" bordercolor=blue align="left" width="100%">
	<tr><td><img src="/img/blank.gif" width="5" height="10"></td></tr>
	<tr><td>
		  <cl:writeChannels agentID="<%=agent.getAgentID() %>" destID="<%=agent.getDestID() %>" clSource="/msg/MSGStaffCompose.jsp" connObj="<%=conn%>" sisSource="/msg/admin/MSGPickStudents.jsp"/>
	</td></tr>
	<tr><td><img src="/img/blank.gif" width="5" height="10"></td></tr>
<%
	}
	finally
	{
		clmsPool.freeConnection("erp",conn);
	}

	if(call && (display==null || display.length==0))
		out.println("<tr><td>" + (privilege.equals("LOC_BATCHES")?"<p class=\"cnt\"><font class=\"new\"><b>Sorry!</b></font> No batches found for your center for the product  "+productCategory+"-"+product+". Please check.</p></td></tr>":"<p class=\"cnt\"><font class=\"new\"><b>Sorry!</b></font> We could not find any selections for you to choose and so you cannot proceed further to send your message to the students at this moment. Please contact IT-Career Launcher to get this problem rectified.</p></td></tr>"));

	if(privilege != null && privilege.endsWith("BATCHES"))
	{
%>
	<tr valign="top"><td>
	<!-- PRODUCT CATEGORY - PRODUCT LIST - INSTRUCTIONS TABLE START -->
	<table width="100%" cellpadding="0" cellspacing="3" border=0 bordercolor=red>
	<form style="margin-bottom: 0px;" method="get" action="/msg/admin/MSGDisplayPrivilege.jsp" name="form1">
	<tr valign="top"><td width="50%">
	<table width="100%" border="0" cellspacing="0" cellpadding="3">
		<tr bgcolor="#b0cfff"> 
			<td><img src="/img/blank.gif" width="5" height="20"></td>
			<td><b><font class="cnt">Select Product Category Here</font></b></td>
        </tr>
        <tr bgcolor="#D9DDB6"> 
			<td rowspan="2"><img src="/img/blank.gif" width="5" height="20"></td>
			<td bgcolor="#D9DDB6" height="35"> 
				<cl:productCategory category="<%=form.getProdCategory()%>" product="<%=product%>" productCategory="<%=productCategory %>" htmlType="cathtml"  actionTitle="Show Batches" />
			</td>
        </tr>
        <tr bgcolor="#D9DDB6"> 
			<td valign="middle" align="left" bgcolor="#D9DDB6">
				<img src="/img/blank.gif" width="1" height="15">
			</td>
        </tr>
	</table>
    </td>
    <td rowspan="2" width="50%" bgcolor="#D9DDB6"> 
	<table width="100%" border="0" bordercolor=red cellspacing="0" cellpadding="3">
		<tr bgcolor="#b0cfff"> 
			<td><img src="/img/blank.gif" width="5" height="20"></td>
			<td><b><font class="cnt">Instructions</font></b></td>
        </tr>
        <tr bgcolor="#D9DDB6"> 
			<td><img src="/img/blank.gif" width="5" height="20"></td>
			<td bgcolor="#D9DDB6" valign="top" height="35"><font class="cnt"><br>To see the listing of batches of a Product for your center, select the relevant Product Category and the Product from the given drop downs and click on the Show batches Button.</font></td>
        </tr>
	</table>
    </td></tr>
	<tr><td width="50%"> 
	<table width="100%" border="0" cellspacing="0" cellpadding="3">
		<tr bgcolor="#b0cfff">
			<td><img src="/img/blank.gif" width="5" height="20"></td>
			<td><b><font class="cnt">Select Product Here</font></b></td>
        </tr>
        <tr bgcolor="#D9DDB6"> 
			<td rowspan="2"><img src="/img/blank.gif" width="5" height="20"></td>
			<td bgcolor="#D9DDB6" valign="bottom" height="35"> 
				<cl:productCategory category="<%=form.getProdCategory()%>" product="<%=product%>" productCategory="<%=productCategory %>" htmlType="prodhtml"  actionTitle="Show Batches" />
			</td>
        </tr>
        <tr bgcolor="#D9DDB6"> 
			<td height="45" valign="middle" align="left">
				<a href="javascript:document.form1.submit()" ><img src="/msg/img/show_batches.gif"  height="30" border="0"></a>

			  <input type="hidden" name="scope1" value="<%=scope1 %>" >
			  <input type="hidden" name="qid" value="<%=qid %>" >
			  <input type="hidden" name="pid" value="<%=pid %>" >
			  <input type="hidden" name="privilege" value="<%=privilege %>" >
			</td>
        </tr>
      </table>
	  </td></tr>
  	  </form>
	  </table>
<%
	}	
%>

<% 
	if(display!=null && display.length>0)
	{
%>
	<tr><td class="cnt">I want to send my message to <%=privilege.equals("LOC_BATCHES")?"the batch(es) that I select from the list given below.":"" %></font>
	</td></tr>
	<form method="POST" action="/msg/admin/MSGCompose4Students.jsp" name="pForm" onSubmit="return verify()">
	<tr><td>
		<input type="hidden" name="qid" value="<%=qid %>">
		<input type="hidden" name="pid" value="<%=pid %>">
		<input type="hidden" name="privilege" value="<%=privilege %>">
		<input type="hidden" name="plength" value="<%=display.length %>">
		<table border="0" width="100%">
		<tr>
			<td width="11%"><a class="lnkblu" href="javascript:selectAll()">Select_All</a></td>
			<td width="89%"><a class="lnkblu" href="javascript:unSelectAll()">Unselect_All</a></td>
		</tr>

<%
		if(privilege.equals("LOC_BATCHES"))
		{
%>
	<tr>
	<td colspan="2">
		<table width="100%" border="0" cellspacing="1" cellpadding="3" bordercolorlight="#000000" bordercolordark="#ffffff">
		<tr align="left" valign="top"> 
			<td bgcolor="#b0cfff" width="10%"><b><font class="cnt">Select</font></b></td>
			<td bgcolor="#b0cfff"><b><font class="cnt">Batch ID</font></b></td>
			<td bgcolor="#b0cfff"><b><font class="cnt">Classrom centre</font></b></td>
			<td bgcolor="#b0cfff"><b><font class="cnt">Batch start date</font></b></td>
			<td bgcolor="#b0cfff"><b><font class="cnt">Batch time</font></b></td>
			<td bgcolor="#b0cfff"><b><font class="cnt">Batch description</font></b></td>
			<td bgcolor="#b0cfff"><b><font class="cnt">Batch product</font></b></td>
			<td bgcolor="#b0cfff"><b><font class="cnt">Total Students</font></b></td>
		</tr>
<%
			for(int i=0;i< display.length;i++)
			{
%>
		<tr bgcolor="#D9DDB6"> 
			<td class="cnt"><input type="checkbox" name="ids<%=i %>" value="<%=display[i][0] %>">&nbsp;<%=i+1%>.</td>
			<td class="cnt"><%=display[i][1].substring(0,display[i][1].indexOf("~")) %></td>
			<%display[i][1]=display[i][1].substring(display[i][1].indexOf("~")+1, display[i][1].length());%>
            <td class="cnt"><%=display[i][1].substring(0,display[i][1].indexOf("~")) %></td>
			<%display[i][1]=display[i][1].substring(display[i][1].indexOf("~")+1, display[i][1].length());%>
            <td class="cnt"><%=display[i][1].substring(0,display[i][1].indexOf("~")) %></td>
			<%display[i][1]=display[i][1].substring(display[i][1].indexOf("~")+1, display[i][1].length());%>
            <td align="right" class="cnt"><%=display[i][1].substring(0,display[i][1].indexOf("~")) %></td>
			<%display[i][1]=display[i][1].substring(display[i][1].indexOf("~")+1, display[i][1].length());%>
            <td class="cnt"><%=display[i][1].substring(0,display[i][1].indexOf("~")) %></td>
			<%display[i][1]=display[i][1].substring(display[i][1].indexOf("~")+1, display[i][1].length());%>
            <td class="cnt"><%=display[i][1].substring(0,display[i][1].indexOf("~")) %></td>
			<%display[i][1]=display[i][1].substring(display[i][1].indexOf("~")+1, display[i][1].length());%>
			<td class="cnt"><%=display[i][1] %></font><input type="hidden" name="display<%=i %>" value="<%=display[i][0] %>"></td>
		</tr>
<%
			}
%>
		</table>
		</td></tr>
<%
		}
		else if(privilege.equals("ALL_PRODS"))
		{
			for(int i=0;i< display.length;i++)
			{
%>
		<tr>
			<td width="11%"><input type="checkbox" name="ids<%=i %>" value="<%=display[i][0] %>" id="ids<%=i %>"></td>
			<td width="89%"><textarea rows="3" name="display<%=i %>" cols="50" style="background-color: #C0D9F5; color: #000000; border-style: solid; border-color: #C0D9F5" class="cnt" onFocus="blur()" >All Students enrolled for <%=display[i][1] %> program</textarea>&nbsp;&nbsp;<a class="lnkblu" href="javascript:popup('<%=display[i][0] %>','<%=i%>','<%=display[i][1] %>')">Choose Products</font>
		</td></tr>
<%
			}
		}
		else
		{
			for(int i=0;i< display.length;i++)
			{
%>
		<tr>
			<td width="11%"><input type="checkbox" name="ids<%=i %>" value="<%=display[i][0] %>"></td>
			<td width="89%"><font class="cnt"><%=display[i][1] %></font><input type="hidden" name="display<%=i %>" value="<%=display[i][1] %>">
		</td></tr>
<%
			}
		}
%>
		
		<tr>
			<td width="11%"><p><a class="lnkblu" href="javascript:selectAll()">Select_All</a></p></td>
			<td width="89%"><p><a class="lnkblu" href="javascript:unSelectAll()">Unselect_All</a></p></td>
		</tr>
		<tr>
			<td><a href="javascript:if(verify()){pForm.submit()}"><img src="/msg/img/proceed.gif" border="0"></a></td>
			<td>&nbsp;</td>
		</tr>
	</form>
	</table>
<%
	}
%>
</td></tr>
</table>
</td></tr>
</table>
</body>
</html>
