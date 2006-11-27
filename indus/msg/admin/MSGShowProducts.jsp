<%@ page import="java.util.*,com.cl.common.CLFormEssentials"  errorPage="/msg/MSGErrorPage.jsp"%>

<%
String index= request.getParameter("idx");
String chosenProducts="|"+request.getParameter("cpids")+"|";
String allProducts = request.getParameter("pids"); 
String prod = request.getParameter("prod");

StringTokenizer stProdIDs = new StringTokenizer("|"+allProducts+"|","|",false);
%>
<html>
<head>
<title>Select the Products for <%=prod%> Category</title>
<link rel="stylesheet" href="/styles/style.css" type="text/css">
<script language="javascript">

	function updateSel(val)
	{
		if (val)
			selectAll();
		else
			unSelectAll();
	}

	function selectAll()
	{
		for(i=1;i<document.prodForm.elements.length;i++)
		{
			if(document.prodForm.elements[i].type=="checkbox" )
			{
				document.prodForm.elements[i].checked=true;
			}
		}
	}

	function unSelectAll()
	{
		for(i=1;i<document.prodForm.elements.length;i++)
		{
			if(document.prodForm.elements[i].type=="checkbox" )
			{
				document.prodForm.elements[i].checked=false;
			}
		}
	}

	function updateChecker(val)
	{
		if (!val)
			document.getElementById("checker").checked=false;
	}

	function record()
	{
		countSelection = 0;
		window.opener.document.pForm.ids<%=index%>.value="";
		window.opener.document.pForm.display<%=index%>.value="";
		if(document.getElementById("checker").checked)
		{
			window.opener.document.pForm.ids<%=index%>.value=document.getElementById("checker").value;
			window.opener.document.pForm.display<%=index%>.value=document.getElementById("checker").name;
			countSelection++;
		}
		else
		{
			for(i=0;i<document.prodForm.elements.length;i++)
			{
				if(document.prodForm.elements[i].type=="checkbox" && document.prodForm.elements[i].checked==true)
				{
					if(window.opener.document.pForm.ids<%=index%>.value!="")
					{
						window.opener.document.pForm.ids<%=index%>.value+="|";
						window.opener.document.pForm.display<%=index%>.value+=", ";
					}
					if(window.opener.document.pForm.display<%=index%>.value=="")
					{
						window.opener.document.pForm.display<%=index%>.value="All students enrolled for ";
					}
					window.opener.document.pForm.ids<%=index%>.value+=document.prodForm.elements[i].value;
					window.opener.document.pForm.display<%=index%>.value+=document.prodForm.elements[i].name;
					countSelection++;
				}
			}
		}

		if(countSelection == 0)
		{
			window.opener.document.pForm.ids<%=index%>.value=document.getElementById("checker").value;
			window.opener.document.pForm.display<%=index%>.value=document.getElementById("checker").name;
			window.opener.document.pForm.ids<%=index%>.checked = false;
		}
		else
		{
			window.opener.document.pForm.ids<%=index%>.checked = true;
		}
		window.close();
	}

</script>
</head>

<body>
<form name="prodForm">
<p class="verbld">Choose the Products for <%=prod%> category from here </p>
<table border="1" class="cnt" width="100%" cellspacing="0" cellpadding="0" bordercolorlight="white" bordercolordark="#C0D9F5">
<tr><td bgcolor="#C0D9F5"><input type="checkbox" name="All students enrolled for <%=prod%> program" value="<%=allProducts %>" <%=chosenProducts.indexOf("|"+allProducts+"|")>-1?"checked":"" %> onClick="updateSel(this.checked)" id="checker"></td><td bgcolor="#C0D9F5"><font class="lnkbld">All students enrolled for all Products of <%=prod%> Category</font></td></tr>
<%
String tmpToken="";
while(stProdIDs.hasMoreTokens())
{
	tmpToken = stProdIDs.nextToken();
	try
	{
		%>
		<tr><td><input type="checkbox" name="<%=CLFormEssentials.getProdTitle(Integer.parseInt(tmpToken))%>" value="<%=tmpToken %>" <%=chosenProducts.indexOf("|"+tmpToken+"|")>-1?"checked":"" %> onClick="updateChecker(this.checked)"></td><td>
		<%
		out.println("All Students enrolled for "+CLFormEssentials.getProdTitle(Integer.parseInt(tmpToken)));
		%>
		</td></tr>
		<%
	}
	catch(NumberFormatException nfe)
	{
		out.println("Wrong Parameter Passed");
	}
}
%>
<tr>
<td colspan="2"><p align="center">
<input type="reset" value="Restore Previous Selection"  class="cnt"><input type="button" value="Choose the selected Products" onClick="record()" class="cnt"><input type="button" value="Close Window" onClick="javascript:window.close()" class="cnt"></p></td>
</table>
</form>
</body>
</html>
