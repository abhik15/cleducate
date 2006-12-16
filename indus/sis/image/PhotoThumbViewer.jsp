<%@ page language="java" %>
<%@ page import="com.school.image.UploadPhotoBean" %>
<%@ page import="oracle.ord.im.OrdHttpJspResponseHandler" %>

<jsp:useBean id="handler" scope="page"
             class="oracle.ord.im.OrdHttpJspResponseHandler"/>

<%
	UploadPhotoBean album = (UploadPhotoBean)session.getAttribute("studentPhoto");
	session.setAttribute("studentPhoto",album);
	String media = request.getParameter("media");
	String identity = request.getParameter("p");
	try
    {
		if(identity.equals("s"))
		{
			handler.setPageContext( pageContext );
			if ( media.equals( "image" ) )
			{
				handler.sendImage( album.getStudentImage() );
				return;
			}
			if ( media.equals( "thumb" ) )
			{
				handler.sendImage( album.getStudentThumb() );
				return;
			}
		}
		else if(identity.equals("f"))
		{
			handler.setPageContext( pageContext );
			if ( media.equals( "image" ) )
			{
				handler.sendImage( album.getFatherImage() );
				return;
			}
			if ( media.equals( "thumb" ) )
			{
				handler.sendImage( album.getFatherThumb() );
				return;
			}
		}else if(identity.equals("m"))
		{
			handler.setPageContext( pageContext );
			if ( media.equals( "image" ) )
			{
				handler.sendImage( album.getMotherImage() );
				return;
			}
			if ( media.equals( "thumb" ) )
			{
				handler.sendImage( album.getMotherThumb() );
				return;
			}
		}else if(identity.equals("g"))
		{
			handler.setPageContext( pageContext );
			if ( media.equals( "image" ) )
			{
				handler.sendImage( album.getGuardianImage() );
				return;
			}
			if ( media.equals( "thumb" ) )
			{
				handler.sendImage( album.getGuardianThumb() );
				return;
			}
		}else if(identity.equals("a"))
		{
			handler.setPageContext( pageContext );
			if ( media.equals( "image" ) )
			{
				handler.sendImage( album.getAuthorizedImage() );
				return;
			}
			if ( media.equals( "thumb" ) )
			{
				handler.sendImage( album.getAuthorizedThumb() );
				return;
			}
		}
	}
	finally
    {

	}
%>
<%-- Don't understand the request --%>
<html lang="EN"><head> <title> PhotoAlbumMediaViewer.jsp - malformed URL </title></head>
<body><a href="JavaScript:window.close();">Close</a>
</body></html>

