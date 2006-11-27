<%
	int locId = Integer.parseInt(request.getParameter("locId"));
	session.putValue("schoolId",""+locId);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE> Upload Student Group Photo photo </TITLE>
<script language="JavaScript">
<!--

	function validate(form)
	{
		if (form.file.value!="")
		{
			var zip = form.file.value;
			alert("alert "+zip); 
			if ((zip.indexOf('gif')==-1) && (zip.indexOf('jpg')==-1))
			{
				alert("Please add gif or jpg file only.")
				form.file.focus();
				return(false);
			}
		}
	}
	
//-->
</script>
</HEAD>
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
<CENTER>
	<b>Upload Group Photo</b><BR>
<FORM METHOD=POST ENCTYPE="multipart/form-data" ACTION="saveGroupPhoto.jsp" name="frm1">
<INPUT TYPE="file" NAME="file"><BR> <BR>
<INPUT TYPE="hidden" name="schoolId" value="<%=Integer.parseInt(request.getParameter("locId"))%>">
<INPUT TYPE="submit" value=" Upload Photo " onclick="return validate(this.form)">
</FORM></CENTER>
</BODY>
</HTML>
