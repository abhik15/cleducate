<%@ page import = "java.util.*,java.io.*"%>

<%
	int locId = Integer.parseInt(request.getParameter("locId"));
	
	String fileName = "";
	int fileIndex=0;
	try
	{
		fileName = request.getParameter("fileName");
		fileIndex = Integer.parseInt(request.getParameter("fileIndex"));
	}
	catch(Exception ex)
	{
		fileName = "";
		fileIndex=0;
	}
	String phyDir = application.getRealPath("/sis/student_img/group_photo/"+locId);
	java.io.File path = new File(phyDir);        
	String[] files = path.list();
	int totalFile = 0;
	try
	{
		totalFile = files.length;
	}
	catch(Exception ex)
	{
//        out.println(ex.toString());
		
		totalFile = 0;
	}
%>
<html>
<head>
	<title>Student Album</title>
<link rel="stylesheet" href="/styles/style.css" type="text/css">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table  border="1" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="1" align="left" valign="top" bgcolor="#E0E0E0"><img src="/ananda/img/1x1.gif" width="1" height="1" /></td>
  </tr>
</table>
<CENTER><br>
<FONT class="lnkbld"><IMG SRC="/img/my_album.gif" BORDER="0" ALT="My Album"></FONT>
<br>

<table WIDTH="100%" cellspacing="0" cellpadding="3" border="1" bordercolorlight="#999999" bordercolordark="#ffffff" class="pcnt">
<tr>
<td width=30%> 
<table WIDTH="30%" cellspacing="0" cellpadding="3" border="1" bordercolorlight="#999999" bordercolordark="#ffffff" class="pcnt">
<TR>

<%
                out.println("Total images : "+totalFile);
		File nextFile=null,prevFile=null;
		for(int i=0; i<totalFile; i++) 
		{
			File F = new File(files[i]);
%>
			<TD align="center">

			<A HREF="ThumbShowGroupImg.jsp?fileName=<%=F.getName()%>&locId=<%=locId%>&fileIndex=<%=i%>" class="lnkblu"> 

<img src="/thumb/phpThumb.php?src=/sis/student_img/group_photo/<%=locId%>/<%=F.getName()%>&w=86">
<%=i+1%></A><BR>
			</TD>
<%

	    if ((i+1)%3 == 0) // start a new row
			out.println("</tr><tr>");
		} // end for
%>
</TR>
</TABLE><BR>
<td valign="top">
<%
	if(fileName.length() > 0 )
	{
%>
<% if (fileIndex >0 ) {
%>
<A HREF="ThumbShowGroupImg.jsp?fileName=<%=files[fileIndex-1]%>&locId=<%=locId%>&fileIndex=<%=fileIndex-1%>"
 class="lnkblu">Prev Photo </a><br><br>
<%}
%>
	<IMG SRC="/thumb/phpThumb.php?src=/sis/student_img/group_photo/<%=locId%>/<%=fileName%>&w=400"><BR>
<% if (fileIndex<files.length-1) {
%>
 Showing <%=fileIndex+1%> of <%=files.length%> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<A HREF="ThumbShowGroupImg.jsp?fileName=<%=files[fileIndex+1]%>&locId=<%=locId%>&fileIndex=<%=fileIndex+1%>"
 class="lnkblu">Next Photo </a> 
<%}
%>
<%
	}	
        else
	{
	out.println("Click on any photo to display it here");
	}
%>
</td></tr></table>
<A HREF="javascript:window.close()" class="lnkblu">close</A><BR><BR></CENTER>
