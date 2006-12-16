<%@ page language="java" %>
<%@ page import="com.school.image.UploadPhotoBean,java.util.*" %>
<%@ page import="oracle.ord.im.OrdHttpJspResponseHandler" %>
<%@ page import="oracle.ord.im.OrdHttpUploadFormData" %>
<%@ page import="oracle.ord.im.OrdHttpUploadFile" %>

<jsp:useBean id="image" scope="page" class="com.school.image.UploadPhotoBean"/>
<jsp:useBean id="handler" scope="page"
             class="oracle.ord.im.OrdHttpJspResponseHandler"/>
<jsp:useBean id="formData" scope="page"
             class="oracle.ord.im.OrdHttpUploadFormData"/>

<%!
	int schoolId=0;
    int schoolEnrollId=0;
	OrdHttpUploadFile photo = null;
	OrdHttpUploadFile uploadStudentPhoto = null; 
	OrdHttpUploadFile uploadFatherPhoto = null;
	OrdHttpUploadFile uploadMotherPhoto = null;
	OrdHttpUploadFile uploadGuardianPhoto = null;
	OrdHttpUploadFile uploadAuthorizedPhoto = null;
	String fail="";
	String success="";
	
%>

<%
	try
    {
        formData.setServletRequest( request );
        if ( !formData.isUploadRequest() )
        {
%>
            <jsp:forward page="StudentPhotoUploadForm.jsp"/>
<%
            return;
        }

        formData.parseFormData();
		schoolId = Integer.parseInt(formData.getParameter("schoolId"));
        schoolEnrollId = Integer.parseInt(formData.getParameter("schoolEnrollId"));
	
		uploadStudentPhoto = formData.getFileParameter("student");
		uploadFatherPhoto = formData.getFileParameter("father");
		uploadMotherPhoto = formData.getFileParameter("mother");
		uploadGuardianPhoto = formData.getFileParameter("guardian");
		uploadAuthorizedPhoto = formData.getFileParameter("authorized");

        if(!(uploadStudentPhoto == null || uploadStudentPhoto.getOriginalFileName() == null || uploadStudentPhoto.getOriginalFileName().length() == 0))
		{
			image.setErrorMsg("");
			image.insertNewPhoto( uploadStudentPhoto,"student",schoolEnrollId,schoolId);
			System.out.println("Student Photo Upload");
			if(image.getErrorMsg()!= null && !image.getErrorMsg().equals(""))
			{
				fail="<BR> Student " +image.getErrorMsg();
			}
			else
			{
				success +=" Student Image uploded Successfully.<BR>";
			}			
		}

        if(!(uploadFatherPhoto == null || uploadFatherPhoto.getOriginalFileName() == null || uploadFatherPhoto.getOriginalFileName().length() == 0))
		{
			image.setErrorMsg("");
			image.insertNewPhoto( uploadFatherPhoto,"father",schoolEnrollId,schoolId);
			System.out.println("Father Photo Upload");
			if(image.getErrorMsg()!= null && !image.getErrorMsg().equals(""))
			{
				fail="<BR> Father "+image.getErrorMsg();
			}
			else
			{
				success +=" Father Image uploded Successfully.<BR>";
			}
		}

        if(!(uploadMotherPhoto == null || uploadMotherPhoto.getOriginalFileName() == null || uploadMotherPhoto.getOriginalFileName().length() == 0))
		{
			image.setErrorMsg("");
			image.insertNewPhoto( uploadMotherPhoto,"mother",schoolEnrollId,schoolId);
			System.out.println("Mother Photo Upload");
			if(image.getErrorMsg()!= null && !image.getErrorMsg().equals(""))
			{
				fail="<BR> Mother "+image.getErrorMsg();
			}
			else
			{
				success +=" Mother Image uploded Successfully.<BR>";
			}
		}

	    if(!(uploadGuardianPhoto == null || uploadGuardianPhoto.getOriginalFileName() == null || uploadGuardianPhoto.getOriginalFileName().length() == 0))
		{
			image.setErrorMsg("");
			image.insertNewPhoto( uploadGuardianPhoto,"guardian",schoolEnrollId,schoolId);
			System.out.println("Guardian Photo Uplaod");
			if(image.getErrorMsg()!= null && !image.getErrorMsg().equals(""))
			{
				fail="<BR> Guardian "+image.getErrorMsg();
			}
			else
			{
				success +=" Guardian Image uploded Successfully.<BR>";
			}
		}

        if(!(uploadAuthorizedPhoto == null || uploadAuthorizedPhoto.getOriginalFileName() == null || uploadAuthorizedPhoto.getOriginalFileName().length() == 0))
		{
			image.setErrorMsg("");
			image.insertNewPhoto( uploadAuthorizedPhoto,"authorized",schoolEnrollId,schoolId);
			System.out.println("Authorized Photo Upload");
			if(image.getErrorMsg()!= null && !image.getErrorMsg().equals(""))
			{
				fail="<BR> Authorized Person "+image.getErrorMsg();
			}
			else
			{
				success +=" Authorized Person Image uploded Successfully.<BR>";
			}
		}
	}
    finally
    {
		uploadStudentPhoto.release();
		uploadFatherPhoto.release();
		uploadMotherPhoto.release();
		uploadGuardianPhoto.release();
		uploadAuthorizedPhoto.release();
        formData.release();
    }

%>

<!-- HTML header -->
<html lang="EN">
<title>ERP Photo Upload</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache"> 
<link rel="stylesheet" href="/ssheet/dstyles.css">
</head>

<!-- Direct browser to main page -->
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!-- <table WIDTH="100%" cellspacing="0" cellpadding="3" border="1" bordercolorlight="#999999" bordercolordark="#ffffff">
<TR align="center">
	<TD class="td1"><font class="subjecwithoutlinks">Student Detail</font></TD>
	<TD class="leftband"><a class="subhdbldhin" href="/getParentDetail.do?schoolEnrollId=<%=schoolEnrollId%>">Insert Parents Detail</a></TD>
	<TD class="leftband"><a class="subhdbldhin" href="/clzone/apps/erp/image/StudentPhotoUploadForm.jsp?schoolEnrollId=<%=schoolEnrollId%>">Upload Photo</a></TD>
</TR>
</TABLE> -->
<!-- Page heading -->
<table border="0" width="100%">
  <tr>
    <td colspan="2" bgcolor="#f7f7e7" align="center"><font size="+2">
      <i>Photo uploaded</font>
    </td>
  </tr>
</table>

<!-- Display header and instructions -->
<p><center>
<font size=3 color="#336699">
<b class="cnt"><%=success%></b>
<b class="cnt"><%=fail%></b>
</font></center>
<hr size=1>
</p>
<!-- Output link to return to the main page -->
<p>
<table width="100%">
  <tr bgcolor="#f7f7e7">
    <td colspan="3" align="center" class="lnkbld">
      <a href="PhotoUploaded.jsp?schoolEnrollId=<%=schoolEnrollId%>&schoolId=<%=schoolId%>">Click here</A> to view the uploaded Photo.
    </td>
  </tr>
</table>
</p>

<!-- Finish the page -->
</body>
</html>
