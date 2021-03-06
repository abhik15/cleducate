/*
 * JSP generated by Resin-3.0.8 (built Tue, 08 Jun 2004 02:25:40 PDT)
 */

package _jsp;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.*;
import java.io.*;

public class _OptimizedShowGroupImg__jsp extends com.caucho.jsp.JavaPage{
  private boolean _caucho_isDead;
  
  public void
  _jspService(javax.servlet.http.HttpServletRequest request,
              javax.servlet.http.HttpServletResponse response)
    throws java.io.IOException, javax.servlet.ServletException
  {
    javax.servlet.http.HttpSession session = request.getSession(true);
    com.caucho.server.webapp.Application _jsp_application = _caucho_getApplication();
    javax.servlet.ServletContext application = _jsp_application;
    com.caucho.jsp.PageContextImpl pageContext = com.caucho.jsp.QJspFactory.allocatePageContext(this, _jsp_application, request, response, null, session, 8192, true);
    javax.servlet.jsp.JspWriter out = pageContext.getOut();
    javax.servlet.ServletConfig config = getServletConfig();
    javax.servlet.Servlet page = this;
    response.setContentType("text/html");
    org.apache.taglibs.image.ImageTag _jsp_ImageTag_0 = null;
    org.apache.taglibs.image.ResizeTag _jsp_ResizeTag_1 = null;
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      
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

      out.write(_jsp_string1, 0, _jsp_string1.length);
      com.caucho.jsp.BodyContentImpl _jsp_endTagHack0 = null;
      if (_jsp_ImageTag_0 == null) {
        _jsp_ImageTag_0 = new org.apache.taglibs.image.ImageTag();
        _jsp_ImageTag_0.setPageContext(pageContext);
        _jsp_ImageTag_0.setParent((javax.servlet.jsp.tagext.Tag) null);
        _jsp_ImageTag_0.setSrc("/sis/student_img/group_photo/3/3.jpg");
        _jsp_ImageTag_0.setDir("generated/group_photo/3");
        _jsp_ImageTag_0.setName("3.jpg");
        _jsp_ImageTag_0.setAttributes("alt='A sample image'");
        _jsp_ImageTag_0.setRefresh(false);
        _jsp_ImageTag_0.setQuality((float) 0.8);
      }

      int _jspEval2 = _jsp_ImageTag_0.doStartTag();
      if (_jspEval2 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
        out = pageContext.pushBody();
        _jsp_endTagHack0 = (com.caucho.jsp.BodyContentImpl) out;
        _jsp_ImageTag_0.setBodyContent(_jsp_endTagHack0);
        out.write('\n');
        if (_jsp_ResizeTag_1 == null) {
          _jsp_ResizeTag_1 = new org.apache.taglibs.image.ResizeTag();
          _jsp_ResizeTag_1.setPageContext(pageContext);
          _jsp_ResizeTag_1.setParent((javax.servlet.jsp.tagext.Tag) _jsp_ImageTag_0);
          _jsp_ResizeTag_1.setWidth("85");
        }

        _jsp_ResizeTag_1.doEndTag();
        out.write(_jsp_string2, 0, _jsp_string2.length);
        _jsp_ImageTag_0.doAfterBody();
        out = pageContext.popBody();
      }
      _jsp_ImageTag_0.doEndTag();
      if (_jsp_endTagHack0 != null) {
        pageContext.releaseBody(_jsp_endTagHack0);
        _jsp_endTagHack0 = null;
      }
      out.write(_jsp_string3, 0, _jsp_string3.length);
      
                out.println("Total images : "+totalFile);

		for(int i=0; i<totalFile; i++) 
		{
			File F = new File(files[i]);

      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((F.getName()));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((locId));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((i));
      out.write(_jsp_string7, 0, _jsp_string7.length);
      out.print((locId));
      out.write('/');
      out.print((F.getName()));
      out.write(_jsp_string8, 0, _jsp_string8.length);
      

	    if ((i+1)%10 == 0) // start a new row
			out.println("</tr><tr>");
		}

      out.write(_jsp_string9, 0, _jsp_string9.length);
      
	if(fileName == null)
	{

      out.write(_jsp_string10, 0, _jsp_string10.length);
      out.print((locId));
      out.write('/');
      out.print((locId));
      out.write(_jsp_string11, 0, _jsp_string11.length);
      
	}
	else
	{

      out.write(_jsp_string10, 0, _jsp_string10.length);
      out.print((locId));
      out.write('/');
      out.print((fileName));
      out.write(_jsp_string12, 0, _jsp_string12.length);
      
	}	

      out.write(_jsp_string13, 0, _jsp_string13.length);
    } catch (java.lang.Throwable _jsp_e) {
      pageContext.handlePageException(_jsp_e);
    } finally {
      if (_jsp_ImageTag_0 != null)
        _jsp_ImageTag_0.release();
      if (_jsp_ResizeTag_1 != null)
        _jsp_ResizeTag_1.release();
      com.caucho.jsp.QJspFactory.freePageContext(pageContext);
    }
  }

  private com.caucho.java.LineMap _caucho_line_map;
  private java.util.ArrayList _caucho_depends = new java.util.ArrayList();

  public java.util.ArrayList _caucho_getDependList()
  {
    return _caucho_depends;
  }

  public void _caucho_addDepend(com.caucho.make.PersistentDependency depend)
  {
    super._caucho_addDepend(depend);
    _caucho_depends.add(depend);
  }

  public boolean _caucho_isModified()
  {
    if (_caucho_isDead)
      return true;
    if (com.caucho.util.CauchoSystem.getVersionId() != 1174304630)
      return true;
    for (int i = _caucho_depends.size() - 1; i >= 0; i--) {
      com.caucho.make.Dependency depend;
      depend = (com.caucho.make.Dependency) _caucho_depends.get(i);
      if (depend.isModified())
        return true;
    }
    return false;
  }

  public long _caucho_lastModified()
  {
    return 0;
  }

  public com.caucho.java.LineMap _caucho_getLineMap()
  {
    return _caucho_line_map;
  }

  public void destroy()
  {
      _caucho_isDead = true;
      super.destroy();
  }

  public void init(com.caucho.java.LineMap lineMap,
                   com.caucho.vfs.Path appDir)
    throws javax.servlet.ServletException
  {
    com.caucho.vfs.Path resinHome = com.caucho.util.CauchoSystem.getResinHome();
    com.caucho.vfs.MergePath mergePath = new com.caucho.vfs.MergePath();
    mergePath.addMergePath(appDir);
    mergePath.addMergePath(resinHome);
    com.caucho.loader.DynamicClassLoader loader;
    loader = (com.caucho.loader.DynamicClassLoader) getClass().getClassLoader();
    String resourcePath = loader.getResourcePathSpecificFirst();
    mergePath.addClassPath(resourcePath);
    _caucho_line_map = new com.caucho.java.LineMap("_OptimizedShowGroupImg__jsp.java", "foo");
    _caucho_line_map.add("/OptimizedShowGroupImg.jsp", 5, 32);
    _caucho_line_map.add(51, 58);
    _caucho_line_map.add(58, 77);
    _caucho_line_map.add(58, 84);
    _caucho_line_map.add(60, 86);
    _caucho_line_map.add(60, 89);
    _caucho_line_map.add(64, 95);
    _caucho_line_map.add(73, 103);
    _caucho_line_map.add(73, 105);
    _caucho_line_map.add(73, 107);
    _caucho_line_map.add(75, 109);
    _caucho_line_map.add(75, 111);
    _caucho_line_map.add(78, 113);
    _caucho_line_map.add(87, 120);
    _caucho_line_map.add(91, 125);
    _caucho_line_map.add(91, 127);
    _caucho_line_map.add(92, 129);
    _caucho_line_map.add(97, 135);
    _caucho_line_map.add(97, 137);
    _caucho_line_map.add(98, 139);
    com.caucho.vfs.Depend depend;
    depend = new com.caucho.vfs.Depend(appDir.lookup("OptimizedShowGroupImg.jsp"), "47NEIj6hgInn/pzOYLVyXA==", false);
    _caucho_depends.add(depend);
  }

  private final static char []_jsp_string2;
  private final static char []_jsp_string10;
  private final static char []_jsp_string7;
  private final static char []_jsp_string4;
  private final static char []_jsp_string5;
  private final static char []_jsp_string1;
  private final static char []_jsp_string3;
  private final static char []_jsp_string6;
  private final static char []_jsp_string0;
  private final static char []_jsp_string8;
  private final static char []_jsp_string9;
  private final static char []_jsp_string12;
  private final static char []_jsp_string13;
  private final static char []_jsp_string11;
  static {
    _jsp_string2 = "\n\n".toCharArray();
    _jsp_string10 = "\r\n		<IMG SRC=\"/sis/student_img/group_photo/".toCharArray();
    _jsp_string7 = "</A><BR>\r\n\n			<!--IMG SRC=\"/sis/student_img/group_photo/".toCharArray();
    _jsp_string4 = "\r\n			<TD align=\"center\">\r\n\r\n			<A HREF=\"showGroupImg.jsp?fileName=".toCharArray();
    _jsp_string5 = "&locId=".toCharArray();
    _jsp_string1 = "\r\n<html>\r\n<head>\r\n	<title>Student Album</title>\r\n<link rel=\"stylesheet\" href=\"/styles/style.css\" type=\"text/css\">\r\n</head>\r\n<body leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">\r\n<table width=\"778\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">\r\n  <tr>\r\n    <td width=\"1\" align=\"left\" valign=\"top\" bgcolor=\"#E0E0E0\"><img src=\"/ananda/img/1x1.gif\" width=\"1\" height=\"1\" /></td>\r\n    <td align=\"left\" valign=\"top\"><img src=\"/img/learner.gif\" width=\"175\" height=\"152\" border=\"0\" usemap=\"#Map2\" /></td>\r\n    <td width=\"602\" align=\"left\" valign=\"top\"><object classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" codebase=\"http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0\" width=\"602\" height=\"152\">\r\n      <param name=\"movie\" value=\"/swf/learner.swf\" />\r\n      <param name=\"quality\" value=\"high\" />\r\n      <embed src=\"/swf/learner.swf\" quality=\"high\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" type=\"application/x-shockwave-flash\" width=\"602\" height=\"152\"></embed>\r\n    </object></td>\r\n  </tr>\r\n</table>\r\n<CENTER><br>\r\n<FONT class=\"lnkbld\"><IMG SRC=\"/img/my_album.gif\" BORDER=\"0\" ALT=\"My Album\"></FONT>\r\n<br>\r\n\n".toCharArray();
    _jsp_string3 = "	\n<table WIDTH=\"100%\" cellspacing=\"0\" cellpadding=\"3\" border=\"1\" bordercolorlight=\"#999999\" bordercolordark=\"#ffffff\" class=\"pcnt\">\r\n<TR>\r\n\r\n".toCharArray();
    _jsp_string6 = "\" class=\"lnkblu\">Photo ".toCharArray();
    _jsp_string0 = "\r\n\n\n\n".toCharArray();
    _jsp_string8 = "\" WIDTH=\"86\" HEIGHT=\"65\" BORDER=\"0\" ALT=\"\"-->\n\n			</TD>\r\n".toCharArray();
    _jsp_string9 = "\r\n</TR>\r\n</TABLE><BR>\r\n\n".toCharArray();
    _jsp_string12 = "\" BORDER=\"0\" ALT=\"\"><BR><BR>\r\n".toCharArray();
    _jsp_string13 = "\r\n<A HREF=\"javascript:window.close()\" class=\"lnkblu\">close</A><BR><BR></CENTER>\n".toCharArray();
    _jsp_string11 = ".jpg\" BORDER=\"0\" ALT=\"\"><BR><BR>\r\n".toCharArray();
  }
}
