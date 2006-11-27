<%@ page import = "java.util.*,java.io.*, com.oreilly.servlet.*,com.oreilly.servlet.multipart.*"%>
<html>
<head>
	<title>Upload Student photo</title>
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
 
<%
	try
	{
		//out.println("From session "+session.getValue("userId"));
		String userId = (String)session.getValue("userId");
		String phyDir = application.getRealPath("/sis/student_img/"+userId);
		java.io.File f = new java.io.File(phyDir);
		if(!f.exists())
		{
			f.mkdir();
		}
		MultipartRequest req = new MultipartRequest(request, phyDir, 1048576, new DefaultFileRenamePolicy());

		//int userId = Integer.parseInt(req.getParameter("userId"));
		//out.println("From request"+userId);
		Enumeration en = req.getFileNames();
			String fieldName = "";
			String systemFileName = "";
			java.io.File uploadFile = null;

			String fileType = "";

			while(en.hasMoreElements())
			{
				fieldName = (String)en.nextElement();
				systemFileName = req.getFilesystemName(fieldName);
				uploadFile = req.getFile(fieldName);
				
				java.io.File path = new File(phyDir);        
				String[] files = path.list();
				int totalFile = files.length;
				if(totalFile>1)
				{
					userId = userId+"_"+totalFile;
				}

				if(uploadFile != null)
				{
				if(uploadFile.length() > 0)
				{
					String fileLocation = phyDir + java.io.File.separator +userId+ ".jpg";

					java.io.File fileNewName = new File(fileLocation);
					uploadFile.renameTo(fileNewName);

					try
					{
						fileType = systemFileName.substring(systemFileName.indexOf('.')+1,systemFileName.length());
					}
					catch(Exception e)
					{
						fileType = "";
					}
					
					FileInputStream file  = new FileInputStream(fileLocation);
					int bLength = file.available();
					byte data[] = new byte[bLength];
					file.read(data);
					file.close();
				}
				}
			}
	}
	catch(Exception ex)
	{
		out.println(ex.toString());
		return;
	}
%>

<font class="lnkbld">
<CENTER><BR><BR><IMG SRC="/img/smileyyellow.jpg" WIDTH="80" HEIGHT="80" BORDER="0" ALT=""><BR><BR>
					Successfully uploaded  photo !<BR><BR><BR>
					<A HREF="javascript:window.close()">Close</A>
					</CENTER></font>