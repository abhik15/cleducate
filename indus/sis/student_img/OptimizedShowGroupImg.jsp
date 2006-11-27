<%@ page import = "java.util.*,java.io.*"%>
<%@ taglib uri="http://jakarta.apache.org/taglibs/image-1.0" prefix="img" %>


<%
	int locId = Integer.parseInt(request.getParameter("locId"));
	
	String fileName = "";
	try
	{
		fileName = request.getParameter("fileName");
	}
	catch(Exception ex)
	{
		fileName = "";
	}
	String phyDir = application.getRealPath("/group_photo/"+locId);
	java.io.File path = new File(phyDir);        
	String[] files = path.list();
	int totalFile = 0;
	try
	{
		totalFile = files.length;
	}
	catch(Exception ex)
	{
		totalFile = 0;
	}
%>
<html>
<head>
	<title>Student Album</title>
<link rel="stylesheet" href="/styles/style.css" type="text/css">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="778" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="1" align="left" valign="top" bgcolor="#E0E0E0"><img src="/ananda/img/1x1.gif" width="1" height="1" /></td>
    <td align="left" valign="top"><img src="/img/learner.gif" width="175" height="152" border="0" usemap="#Map2" /></td>
    <td width="602" align="left" valign="top"><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="602" height="152">
      <param name="movie" value="/swf/learner.swf" />
      <param name="quality" value="high" />
      <embed src="/swf/learner.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="602" height="152"></embed>
    </object></td>
  </tr>
</table>
<CENTER><br>
<FONT class="lnkbld"><IMG SRC="/img/my_album.gif" BORDER="0" ALT="My Album"></FONT>
<br>

<img:image 
	src="/sis/student_img/group_photo/3/3.jpg" 
	dir="generated/group_photo/3" 
	name="3.jpg" 
	attributes="alt='A sample image'"
	refresh="false"
	quality="0.8">
<img:resize width="85" />

</img:image>	
<table WIDTH="100%" cellspacing="0" cellpadding="3" border="1" bordercolorlight="#999999" bordercolordark="#ffffff" class="pcnt">
<TR>

<%
                out.println("Total images : "+totalFile);

		for(int i=0; i<totalFile; i++) 
		{
			File F = new File(files[i]);
%>
			<TD align="center">

			<A HREF="showGroupImg.jsp?fileName=<%=F.getName()%>&locId=<%=locId%>" class="lnkblu">Photo <%=i%></A><BR>

			<!--IMG SRC="/sis/student_img/group_photo/<%=locId%>/<%=F.getName()%>" WIDTH="86" HEIGHT="65" BORDER="0" ALT=""-->

			</TD>
<%

	    if ((i+1)%10 == 0) // start a new row
			out.println("</tr><tr>");
		}
%>
</TR>
</TABLE><BR>

<%
	if(fileName == null)
	{
%>
		<IMG SRC="/sis/student_img/group_photo/<%=locId%>/<%=locId%>.jpg" BORDER="0" ALT=""><BR><BR>
<%
	}
	else
	{
%>
		<IMG SRC="/sis/student_img/group_photo/<%=locId%>/<%=fileName%>" BORDER="0" ALT=""><BR><BR>
<%
	}	
%>
<A HREF="javascript:window.close()" class="lnkblu">close</A><BR><BR></CENTER>
