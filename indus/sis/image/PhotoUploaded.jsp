<%@ page import="com.school.image.UploadPhotoBean,oracle.ord.im.OrdHttpJspResponseHandler" %>

<jsp:useBean id="album" scope="page" class="com.school.image.UploadPhotoBean"/>

<jsp:useBean id="handler" scope="page" class="oracle.ord.im.OrdHttpJspResponseHandler"/>

<%-- HTML header --%>
<html lang="EN">
<title>Uploaded Photo</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="/ssheet/dstyles.css">
<link rel="stylesheet" href="/ssheet/sstyles.css">
</head>

<body>

<table WIDTH="100%" cellspacing="0" cellpadding="3" border="1" bordercolorlight="#999999" bordercolordark="#ffffff">
	<TR align="center">
		<TD class="td1"><font class="subjecwithoutlinks">UPloaded Photo</font></TD>	
	</TR>
</table>

<table border="1" cellpadding="3" cellspacing="0" width="100%" summary="Table of thumb nail images" class="subjectcontent">
  <tr bgcolor="#336699">
    <th id="description"><font color="#ffffff">Description</font></th>
    <th id="image"><font color="#ffffff">Image</font></th>
  </tr>

<%-- Display all the entries --%>
<%! int schoolId;
	int schoolEnrollId;
%>
<%
	session.removeAttribute("studentPhoto");
	int schoolId = Integer.parseInt(request.getParameter("schoolId"));
	int schoolEnrollId = Integer.parseInt((String)request.getParameter("schoolEnrollId"));

	if(!album.selectStudentPhoto(schoolId,schoolEnrollId))
	{
		out.println("<i class=\"cnt\"> Photo has not been uploaded as yet. Please <a href=\"StudentPhotoUploadForm.jsp?schoolEnrollId="+schoolEnrollId+"\" class=\"lnkbld\">Click Here</a> to upload the photo</i></table>");

	}
	else
	{
	session.setAttribute("studentPhoto",album);
  //
  // Use a try block to ensure the JDBC connection is released.
  //
  try
  {
%>	<tr>
        <td headers="description">Student</td>
<%
	  if(album.getStudentImage()!=null)
	  {
%>      
        <td headers="image">
           <a href="PhotoThumbViewer.jsp?media=image&p=s" target="image">
	       <img src="PhotoThumbViewer.jsp?media=thumb&p=s" ></a>
		</td>		
<%
	  }
	  else
	  {
		 out.println("<td>Student Image has not been uploaded as yet And <br> Image height and width should not exceed then 450 and 450</td>");
	  }
%>
	</tr>
	<tr>
        <td headers="description">Father</td>
<%
		if(album.getFatherImage()!=null)
	  {
%>      
        <td headers="image">
           <a href="PhotoThumbViewer.jsp?media=image&p=f" target="image">
          <img src="PhotoThumbViewer.jsp?media=thumb&p=f"></a>
		</td>		
<%
	  }
	  else
	  {
		 out.println("<td>Father image has not been uploaded as yet And <br> Image height and width should not exceed then 450 and 450</td>");
	  }
%>
    </tr>
	<tr>
        <td headers="description">Mother</td>
<%
		if(album.getMotherImage()!=null)
	  {
%>
        <td headers="image">
           <a href="PhotoThumbViewer.jsp?media=image&p=m" target="image">
          <img src="PhotoThumbViewer.jsp?media=thumb&p=m"></a>
		</td>		
<%
	  }
	  else
	  {
		 out.println("<td>Mother image has not been uploaded as yet And <br> Image height and width should not exceed then 450 and 450</td>");
	  }
%>
	</tr>
	<tr>
        <td headers="description">Guardian </td>
 <%
		if(album.getGuardianImage()!=null)
	  {
%>
	    <td headers="image">
        <a href="PhotoThumbViewer.jsp?media=image&p=g" target="image">
        <img src="PhotoThumbViewer.jsp?media=thumb&p=g"></a>
		</td>		
<%
	  }
	  else
	  {
		 out.println("<td>Guardian image has not been uploaded as yet And <br> Image height and width should not exceed then 450 and 450</td>");
	  }
%>
	</tr>
	<tr>
        <td headers="description">Authorized Person	</td>
<%
		if(album.getAuthorizedImage()!=null)
	  {
%>
        <td headers="image">
          <a href="PhotoThumbViewer.jsp?media=image&p=a" target="image">
          <img src="PhotoThumbViewer.jsp?media=thumb&p=a"></a>
		</td>	
<%
	  }
	  else
	  {
		 out.println("<td>Authorized Person image has not been uploaded as yet And <br> Image height and width should not exceed then 450 and 450</td>");
	  }
%>
	</tr>
<%
  }
	// end try
  finally
  {

  }
}
%>

<%-- Finish the table --%>
</table>
</p>

<%-- Output a link to the upload form --%>
<p>
<table align="center" width="100%">
  <tr bgcolor="#f7f7e7">
    <td colspan="3" align="center" class="lnkbld">
      <a href="/sis/image/StudentPhotoUploadForm.jsp?schoolEnrollId=<%=schoolEnrollId%>&schoolId=<%=schoolId%>">Re-upload the Photo</a>
    </td>
  </tr>
  <tr>
		<td colspan="3"><a href="#" onClick="javascript:window.close();" class="lnkblu">Close</a></td>
	</tr>
</table>
</p>

</body>
</html>

