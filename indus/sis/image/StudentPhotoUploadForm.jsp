<!--
/**
*	Author	:	Amrendra Kumar
*	Version	:	1.0
*	Date	:	25-Aug-2006
*/
-->

<%@ page language="java" %>

<%-- HTML header --%>
<html>
<head>
<title>ERP Upload Photo</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="/ssheet/dstyles.css">
</head>
<body>
<%
	int schoolId = 1;
//	String schoolEnrollId = request.getParameter("schoolEnrollId");
	String schoolEnrollId = "465";
    String errorMessage = request.getParameter( "error" );
    if ( errorMessage != null )
    {
%>
        <p>
        <font size=3 color="#336699"><b>Error message</b></font>
        <hr size=1>
        </p>
        <p>
        <%= errorMessage %>
        </p>
<%
    }
%>

<%-- Display header --%>
<p>
<font size=3 color="#336699"><b>Upload photo for enrollment Id : <%=schoolEnrollId%></b></font><hr size=1>
</p>

<%-- Output the form --%>
<p>
<form action="/sis/image/UploadPhoto.jsp"
      method="post" enctype="multipart/form-data">
<table border="0" width="100%" cellspacing="0" summary="photo upload form">
  <tr bgcolor="#f7f7e7">
    <td scope="col" colspan="2">&nbsp;</td>
  </tr>
      <input type="hidden" name="schoolId" value="<%=schoolId%>">
      <input type="hidden" name="schoolEnrollId" value="<%=schoolEnrollId%>">
  <tr bgcolor="#f7f7e7">
    <td scope="col" valign="top"><b>Student Photo:</b></td>
    <td scope="col" >
      <input type="file" name="student">
      <br></td>
  </tr>
    <tr bgcolor="#f7f7e7">
    <td scope="col" valign="top"><b>Father Photo:</b></td>
    <td scope="col" >
      <input type="file" name="father">
      <br>
    </td>
  </tr>
    <tr bgcolor="#f7f7e7">
    <td scope="col" valign="top"><b>Mother Photo:</b></td>
    <td scope="col" >
      <input type="file" name="mother">
      <br>
    </td>
  </tr>
    <tr bgcolor="#f7f7e7">
    <td scope="col" valign="top"><b>Local Guardian Photo:</b></td>
    <td scope="col" >
      <input type="file" name="guardian">
      <br>
    </td>
  </tr>
    <tr bgcolor="#f7f7e7">
    <td scope="col" valign="top"><b>Authorized Person Photo:</b></td>
    <td scope="col" >
      <input type="file" name="authorized">
      <br>
    </td>
  </tr>

  <tr bgcolor="#f7f7e7">
    <td colspan="2">
      &nbsp;
    </td>
  </tr>
  <tr bgcolor="#f7f7e7">
    <td colspan="2">
      <center>
	  <input type="submit" value="Upload photo" styleClass="boxborder"></center>
    </td>
  </tr>
  <tr bgcolor="#f7f7e7">
    <td colspan="2">
      &nbsp;
    </td>
  </tr>
</table>
</form>
</p>

<%-- Output a link to return to the main page --%>
<p>
<table width="100%">
  <tr bgcolor="#f7f7e7">
    <td colspan="3" align="center">
      <a href="/sis/image/PhotoUploaded.jsp?schoolEnrollId=<%=schoolEnrollId%>&schoolId=<%=schoolId%>">Return to photo album</a>
    </td>
  </tr>
</table>
</p>
</body>
</html>

