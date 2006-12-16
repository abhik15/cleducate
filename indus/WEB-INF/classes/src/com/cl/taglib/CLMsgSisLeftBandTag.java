// Decompiled by DJ v2.9.9.61 Copyright 2000 Atanas Neshkov  Date: 12/14/2006 2:18:41 PM
// Home Page : http://members.fortunecity.com/neshkov/dj.html  - Check often for new version!
// Decompiler options: packimports(3) 
// Source File Name:   CLMsgSisLeftBandTag.java

package com.cl.taglib;

import com.cl.clzone.apps.fis.Fis_View_Request_Util;
import com.cl.common.CLLoginControl;
import com.cl.msg.MSGAgent;
import com.cl.sis.student.SISStudentLogin;
import com.cl.sql.PoolManager;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.*;
import java.util.HashMap;
import java.util.StringTokenizer;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.TagSupport;
import org.apache.log4j.Category;

public class CLMsgSisLeftBandTag extends TagSupport
{

    public CLMsgSisLeftBandTag()
    {
        connectionFromJsp = false;
    }

    public void setCategory(String s)
    {
        try
        {
            category = Integer.parseInt(s);
        }
        catch(NumberFormatException numberformatexception)
        {
            category = 0;
        }
    }

    public void setLevel(String s)
    {
        try
        {
            level = Integer.parseInt(s);
        }
        catch(NumberFormatException numberformatexception)
        {
            level = 0;
        }
    }

    public void setConnObj(Connection connection1)
    {
        connection = connection1;
        connectionFromJsp = true;
    }

    public int doStartTag()
        throws JspTagException
    {
        JspWriter jspwriter = pageContext.getOut();
        clmsPool = PoolManager.getInstance();
        newline = System.getProperty("line.separator");
        try
        {
            if(!connectionFromJsp)
                connection = clmsPool.getConnection("erp");
            if(category == 1)
                jspwriter.println(getClmsLeftBand());
            else
                jspwriter.println(getSisLeftBand());
        }
        catch(SQLException sqlexception)
        {
            logCategory = Category.getInstance("clsite.com.cl.taglib");
            logCategory.error(sqlexception.toString());
        }
        catch(IOException ioexception)
        {
            logCategory = Category.getInstance("clsite.com.cl.taglib");
            logCategory.error(ioexception.toString());
        }
        catch(Exception exception)
        {
            logCategory = Category.getInstance("clsite.com.cl.taglib");
            logCategory.error(exception.toString());
        }
        finally
        {
            if(!connectionFromJsp)
                clmsPool.freeConnection("erp", connection);
        }
        return 0;
    }

    public String getSisLeftBand()
        throws SQLException
    {
        String s = "";
        StringBuffer stringbuffer = new StringBuffer(1000);
        Object obj = null;
        Object obj1 = null;
        Object obj2 = null;
        Object obj3 = null;
        Object obj4 = null;
        try
        {
            s = pageContext.getSession().getAttribute("inboxURL").toString();
        }
        catch(NullPointerException nullpointerexception)
        {
            s = "/msg/MSGInbox.jsp?fid=1&fldr=Inbox";
        }
        stringbuffer.append(newline + "<table width=\"100%\" cellspacing=\"0\"" + " cellpadding=\"0\" align=\"left\">");
        stringbuffer.append(newline + "<tr><td colspan=\"3\" valign=\"top\">");
        stringbuffer.append(newline + "<img src=\"/img/blank.gif\" height=\"8\"></td></tr>");
        stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td>");
        stringbuffer.append(newline + "<td colspan=\"2\" class=\"highlighttext\"><B>SIS Messaging System</B></td></tr>");
        if(!s.startsWith("javascript"))
        {
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td><td colspan=\"2\"><img src=\"/img/blank.gif\" width=\"3\" height=\"10\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" class=\"highlighttext\"><B>Folders</B></td></tr>");
            stringbuffer.append(getFolders());
        }
        stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td><td colspan=\"2\"><img src=\"/img/blank.gif\" width=\"3\" height=\"10\"></td></tr>");
        stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td><td colspan=\"2\"><font class=\"highlighttext\"><a href=\"/msg/MSGStudentCompose.jsp\" class=\"highlighttext\"><B>Compose Message</B></a></font></td></tr>");
        stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td><td colspan=\"2\"><img src=\"/img/blank.gif\" width=\"3\" height=\"5\"></td></tr>");
        stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td>");
        stringbuffer.append(newline + "<td colspan=\"2\" valign=\"top\"><font class=\"lnkblubld\"><a href=\"/sis/ChangePwd.jsp\" class=\"highlighttext\"><B>Change Password</B></a></font><br><br></td></tr>");
        stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td>");
        stringbuffer.append(newline + "<td colspan=\"2\" valign=\"top\"><font class=\"lnkblubld\"><a href=\"/sis/logout.jsp\" class=\"highlighttext\"><B>Logout</B></a></font><br><br></td></tr>");
        String s1 = stringbuffer.toString() + "</table>";
        stringbuffer = null;
        return s1;
    }

    private String getProductLink()
    {
        SISStudentLogin sisstudentlogin;
        String s = "";
        Object obj = null;
        Object obj1 = null;
        sisstudentlogin = (SISStudentLogin)pageContext.getSession().getAttribute("StudentLogin");
        String s1;
        cstmt = connection.prepareCall("{call sis_student.get_prod_page(?,?,?,?)}");
        cstmt.setString(1, sisstudentlogin.getProduct());
        cstmt.registerOutParameter(2, 12);
        cstmt.registerOutParameter(3, 12);
        cstmt.registerOutParameter(4, 12);
        cstmt.execute();
        String s2 = cstmt.getString(2);
        String s3 = cstmt.getString(3);
        try
        {
            cstmt.close();
        }
        catch(Exception exception) { }
        if(s3 == null || s3.length() == 0 || s2 == null || s2.length() == 0)
            s1 = "";
        else
            s1 = "<a href=\"" + s3 + "\" class=\"lnkblu\">" + s2 + "</a>";
        try
        {
            cstmt.close();
        }
        catch(SQLException sqlexception) { }
        break MISSING_BLOCK_LABEL_258;
        Exception exception1;
        exception1;
        s1 = "";
        try
        {
            cstmt.close();
        }
        catch(SQLException sqlexception1) { }
        break MISSING_BLOCK_LABEL_258;
        Exception exception2;
        exception2;
        try
        {
            cstmt.close();
        }
        catch(SQLException sqlexception2) { }
        throw exception2;
        return s1;
    }

    private boolean chkTimekeeper(int i, int j)
    {
        boolean flag = false;
        PreparedStatement preparedstatement = null;
        String s = "select count(*) cnt from hris.cl_timekeeper where emp_id_timekeeper = ?";
        try
        {
            preparedstatement = connection.prepareStatement(s);
            preparedstatement.setInt(1, i);
            rset = preparedstatement.executeQuery();
            rset.next();
            if(rset.getInt("cnt") > 0)
                flag = true;
            else
                flag = false;
        }
        catch(SQLException sqlexception)
        {
            if(logCategory == null)
                logCategory = Category.getInstance("clsite.com.cl.taglib");
            logCategory.error(sqlexception.toString());
        }
        finally
        {
            try
            {
                rset.close();
            }
            catch(Exception exception1) { }
            try
            {
                preparedstatement.close();
            }
            catch(Exception exception2) { }
        }
        return flag;
    }

    private String getClmsLeftBand()
        throws SQLException
    {
        CLLoginControl cllogincontrol = (CLLoginControl)pageContext.getSession().getAttribute("loginControl");
        StringBuffer stringbuffer = new StringBuffer(1000);
        String as[] = getPrivileges();
        HashMap hashmap = new HashMap();
        for(int i = 0; i < as.length; i++)
            hashmap.put(i + "", "" + as[i]);

        stringbuffer.append(newline + "<table width=\"100%\" cellspacing=\"0\"" + " cellpadding=\"0\" align=\"left\">");
        stringbuffer.append(newline + "<tr><td colspan=\"3\" valign=\"top\">");
        stringbuffer.append(newline + "<img src=\"/img/blank.gif\" height=\"8\"></td></tr>");
        stringbuffer.append(newline + "<tr bgcolor=\"#51B4E3\" height=\"20\"><td><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td>");
        stringbuffer.append(newline + "<td colspan=\"2\" class=\"highlighttext\" align=\"center\">Messaging</td></tr>");
        if(level > -1)
        {
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" class=\"highlighttext\">CL Messaging<br>System 3.2</td></tr>");
            stringbuffer.append(newline + "<tr><td colspan=\"3\" valign=\"top\">");
            stringbuffer.append(newline + "<img src=\"/img/blank.gif\" height=\"8\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" class=\"highlighttext\"><B>Folders</B></td></tr>");
            stringbuffer.append(getFolders());
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"10\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td><td colspan=\"2\" valign=\"top\"><a href=\"/msg/MSGFolder.jsp?cat=" + category + "\"" + " title=\"CLMS Create Folder\" class=\"highlighttext\">Create Folder</a></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td><td colspan=\"2\"><img src=\"/img/blank.gif\" width=\"3\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td><td colspan=\"2\" valign=\"top\"><a href=\"/msg/MSGManageFolder.jsp?cat=" + category + "\"" + " title=\"CLMS Manage Folders\" class=\"highlighttext\">Manage Folders</a></td></tr>");
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td><td colspan=\"2\" valign=\"top\"><a href=\"/msg/MSGStaffCompose.jsp\"" + " title=\"CLMS Compose Message\" class=\"highlighttext\">Compose Message</a></td></tr>");
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td><td colspan=\"2\" valign=\"top\"><a href=\"/msg/MSGChannels.jsp?cat=1\"" + " title=\"CLMS Choose your channels\" class=\"highlighttext\">Choose Channels</a></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td><td colspan=\"2\"><img src=\"/img/blank.gif\" width=\"3\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td><td colspan=\"2\" valign=\"top\"><a href=\"/msg/list/MSGCreateMemberBook.jsp?type=SYSTEM&display=full&cat=" + category + "\"" + " title=\"CLMS- Edit Address Book\" class=\"highlighttext\">Edit Address Book</a><font class=\"new\"> New!</font></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td><td colspan=\"2\"><img src=\"/img/blank.gif\" width=\"3\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td><td colspan=\"2\" valign=\"top\"><a href=\"/msg/list/MSGCreateMemberBook.jsp?type=USER&display=full&cat=" + category + "\"" + " title=\"CLMS- Edit Group List\" class=\"highlighttext\">Edit Group List</a><font class=\"new\"> New!</font></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td><td colspan=\"2\"><img src=\"/img/blank.gif\" width=\"3\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td><td colspan=\"2\" valign=\"top\"><a href=\"/msg/util/MSGRetrievalUtility.jsp?cat=" + category + "\"" + " title=\"CLMS Message Retrieval Utility\" class=\"highlighttext\">Message Retrieval Utility</a></td></tr>");
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td><td colspan=\"2\" valign=\"top\"><a href=\"/msg/MSGManual.jsp?cat=1\"" + " title=\"About CLMS\" class=\"highlighttext\">About CLMS</a><br><br></td></tr>");
            stringbuffer.append(newline + "<tr bgcolor=\"#ffffff\"><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"3\" height=\"3\"></td></tr>");
        }
        stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
        if(level == -1)
        {
            int j = 0;
            j = Integer.parseInt((String)pageContext.getSession().getAttribute("unread"));
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td><td colspan=\"2\" align=\"right\"><a href=\"/msg/MSGInbox.jsp?cat=1&fid=S1&fldr=Inbox\"" + " title=\"CLMS\" class=\"highlighttext\">Go to CLMS</a>" + (j <= 0 ? "" : "<font class=\"lnkhed\"><b>(" + j + " New)</b></font>") + "&nbsp;&nbsp;</td></tr>");
        } else
        {
            stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td><td colspan=\"2\"><a href=\"/clzone/login/CLZone.jsp\"" + " title=\"CL Zone Home\" class=\"highlighttext\">CL Zone Home</a></td></tr>");
        }
        if(hashmap.containsValue("SMS_MOD"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\"><a href=\"/clzone/admin/sms/SendEmployeeSMSPage.jsp\" class=\"highlighttext\">Send SMS</a>  <font class=\"new\">New !</font></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\"><a href=\"/clzone/login/CLEmail.jsp\" target=\"_blank\" class=\"highlighttext\">Check Email</a></td></tr>");
        }
        stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"10\"></td></tr>");
        stringbuffer.append(newline + "<tr bgcolor=\"#51B4E3\" height=\"20\"><td><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td>");
        stringbuffer.append(newline + "<td colspan=\"2\" class=\"highlighttext\" align=\"center\">My Application</td></tr>");
        if(hashmap.containsValue("APP_ADMIN"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/admin/appmanager/index.jsp\" class=\"highlighttext\" title=\"Go To Application Manager\">App Manager</a></td></tr>");
        }
        if(hashmap.containsValue("SCHEDULER"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/apps/freedom\" class=\"highlighttext\" title=\"Go To PDP Scheduler Module\">PDP Scheduler</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("ERP_ONLINE"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append("<td colspan=\"2\" align=\"right\"><a href=\"/clzone/login/ERPOnline.jsp\" class=\"highlighttext\" title=\"Go To CL Online ERP Module\">ERP Zone</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("FINANCE"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append("<td colspan=\"2\" align=\"right\"><a href=\"/clzone/login/FinanceOnline.jsp\" class=\"highlighttext\" title=\"Go To Finance Related Module\">Finance Zone</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("OPERATION"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append("<td colspan=\"2\" align=\"right\"><a href=\"/clzone/login/OperationOnline.jsp\" class=\"highlighttext\" title=\"Go To Operation Related Module\">Operation Zone</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("ACADS"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append("<td colspan=\"2\" align=\"right\"><a href=\"/clzone/admin/acads/index.jsp\" class=\"highlighttext\" title=\"Go To Acads Module\">Acads Module</a>&nbsp;&nbsp;</td></tr>");
        }
        stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td></td>");
        stringbuffer.append(newline + "<tr bgcolor=\"#51B4E3\" height=\"20\"><td><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td>");
        stringbuffer.append(newline + "<td colspan=\"2\" class=\"highlighttext\" align=\"center\">HR Zone</td></tr>");
        if(hashmap.containsValue("HR_ADMIN"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/cl.jsp?tp=/clzone/apps/clhr/admin/index.jsp\"" + " class=\"highlighttext\"  title=\"Go To HRIS Admin Module\">HR Admin</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("HR_DEFAULT"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/cl.jsp?tp=/clzone/apps/clhr/employee/index.jsp\" class=\"highlighttext\"" + " title=\"Go To HR Information System\">HRIS</a>&nbsp;&nbsp;</td></tr>");
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/apps/clhr/elis/default.jsp\" " + "class=\"highlighttext\" title=\"ELIS Zone\">ELIS Zone</a>");
            int k = getPendingLeaveCount(cllogincontrol.getEmpId());
            int i1 = getPendingAttdCount(cllogincontrol.getEmpId());
            if(k > 0)
                stringbuffer.append("<br><font class=\"lnkhed\">(" + k + " leave app. pending)</font>");
            if(i1 > 0)
                stringbuffer.append("<br><font class=\"lnkhed\">(" + i1 + " attd. req. pending)</font>");
            stringbuffer.append("&nbsp;&nbsp;</td></tr>");
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
        }
        stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td></td>");
        stringbuffer.append(newline + "<tr bgcolor=\"#51B4E3\" height=\"20\"><td><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td>");
        stringbuffer.append(newline + "<td colspan=\"2\" class=\"highlighttext\" align=\"center\">My Utilities</td></tr>");
        if(hashmap.containsValue("INQ_APP"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append("<td colspan=\"2\" align=\"right\"><a href=\"/clzone/enquiry\" class=\"highlighttext\" title=\"Go To CL Inquiry Module\">Inquiry Module</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("AUDIT_REPORT"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/admin/erp/audit/CLAuditHome.jsp\" " + "class=\"highlighttext\" title=\"Go To View/Generate Audit Report\">Audit Reports</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("FRAN_APP"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/cl.jsp?tp=/clzone/login/CheckPrivilege.jsp?value=FRAN_APP\"" + " title=\"Business Partner\" class=\"highlighttext\">Business Partner</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("BUSS_ASS"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/cl.jsp?tp=/clzone/login/CheckPrivilege.jsp?value=BUSS_ASS\"" + " title=\"Business Partner\" class=\"highlighttext\">Business Associates</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("FMAP"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/apps/fmap/default.jsp\" " + "class=\"highlighttext\" title=\"Go to Futuremap Zone\">Futuremap Zone</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("ACAD_ADMIN"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/cl.jsp?tp=/clzone/login/CheckPrivilege.jsp?value=ACAD_ADMIN\" " + "class=\"highlighttext\" title=\"Go to Institute Entry Module\">Institutes</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("VIP_USER"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/cl.jsp?tp=/clzone/apps/vip\" class=\"highlighttext\" " + "title=\"Add New VIP Details\">VIP DB</a>&nbsp;&nbsp;</td></tr>");
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/cl.jsp?tp=/clzone/apps/strategic_reports\" class=\"highlighttext\" " + "title=\"Strategic Reports\">Strategic Reports</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("ESTORE_ADM"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=/clzone/cl.jsp?tp=\"CheckPrivilege.jsp?value=ESTORE_ADM\" class=\"highlighttext\" " + "title=\"eStore Admin\">eStore Admin</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("CC_ADMIN"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/cl.jsp?tp=/clzone/admin/CreditCards/index.jsp\" class=\"highlighttext\" " + "title=\"Go To Credit Card Admin Module\">Credit Card Admin</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("TS_ADMIN"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/cl.jsp?tp=/clzone/admin/ts/index.jsp\" class=\"highlighttext\" " + "title=\"Go To Test Series Module\">Test Series Admin</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("DOWNLOAD_SEC"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/cl.jsp?tp=/clzone/apps/download_section/index.jsp\" class=\"highlighttext\" " + "title=\"Go To Download Section\">Download Section</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("COMPL_SYS_ADMIN"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/cl.jsp?tp=/clzone/admin/complaint_system/index.jsp?status=PENDING\"" + " class=\"highlighttext\">Request System Admin</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("WEB_ADMIN"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/cl.jsp?tp=/clzone/login/CheckPrivilege.jsp?value=WEB_ADMIN\"" + " class=\"highlighttext\">Web Admin</a>&nbsp;&nbsp;</td></tr>");
        }
        if(hashmap.containsValue("FIS_APP"))
        {
            int l = 0;
            try
            {
                l = Fis_View_Request_Util.getReviewRequestCount(cllogincontrol.getEmpId(), connection);
            }
            catch(Exception exception)
            {
                logCategory = Category.getInstance("clsite.com.cl.taglib");
                logCategory.error(exception.toString());
                l = 0;
            }
            if(l > 0)
            {
                stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
                stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
                stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/cl.jsp?tp=/clzone/apps/fis/fis_checkuser.jsp\"" + " class=\"highlighttext\">Claims</a><b><font class=\"lnkhed\">" + "(" + l + " Pending)</font></b>&nbsp;&nbsp;</td></tr>");
            } else
            {
                stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
                stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
                stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/cl.jsp?tp=/clzone/apps/fis/fis_checkuser.jsp\"" + " class=\"highlighttext\">Claims</a>&nbsp;&nbsp;</td></tr>");
            }
        }
        if(hashmap.containsValue("ERP_REPORT"))
        {
            stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
            stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
            stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/reports/index.jsp\" class=\"highlighttext\" title=\"View ERP Reports\">Reports</a>&nbsp;&nbsp;</td></tr>");
        }
        stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
        stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
        stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/cl.jsp?tp=/clzone/apps/complaint_system\" class=\"highlighttext\">Request System</a>&nbsp;&nbsp;</td></tr>");
        stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
        stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
        stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
        stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"/clzone/cl.jsp?tp=/clzone/login/ChangePassword.html\" class=\"highlighttext\">Change Password</a>&nbsp;&nbsp;</td></tr>");
        stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
        stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
        stringbuffer.append(newline + "<td colspan=\"2\" align=\"right\"><a href=\"mailto:sujit@careerlauncher.com\" class=\"highlighttext\">Feedback</a>&nbsp;&nbsp;</td></tr>");
        stringbuffer.append(newline + "<tr><td colspan=\"3\"><img src=\"/img/blank.gif\" width=\"5\" height=\"5\"></td></tr>");
        stringbuffer.append(newline + "<tr><td><img src=\"/msg/img/blank.gif\" width=\"5\" height=\"5\"></td>");
        stringbuffer.append(newline + "<td colspan=\"2\" align=\"center\"><BR><a href=\"/clzone/login/logout.jsp\" class=\"highlighttext\"><IMG SRC=\"/img/logout.jpg\" WIDTH=\"51\" HEIGHT=\"21\" BORDER=\"0\" ALT=\"logout\"><!-- Logout --></a>&nbsp;&nbsp;</td></tr>");
        stringbuffer.append(newline + "</table>");
        String s = "";
        s = stringbuffer.toString();
        stringbuffer = null;
        return s;
    }

    private int getPendingLeaveCount(int i)
    {
        int j = 0;
        PreparedStatement preparedstatement = null;
        String s = "select count(*) cnt from hris.cl_leave_detail a, hris.hris_emp_detail b where status = 'APPLIED' and a.emp_id = b.emp_id and b.emp_id_superior = ?";
        try
        {
            preparedstatement = connection.prepareStatement(s);
            preparedstatement.setInt(1, i);
            rset = preparedstatement.executeQuery();
            rset.next();
            j = rset.getInt("cnt");
        }
        catch(SQLException sqlexception)
        {
            j = 0;
        }
        finally
        {
            try
            {
                rset.close();
            }
            catch(Exception exception1) { }
            try
            {
                preparedstatement.close();
            }
            catch(Exception exception2) { }
        }
        return j;
    }

    private int getPendingAttdCount(int i)
    {
        int j = 0;
        PreparedStatement preparedstatement = null;
        String s = "select count(*) cnt from hris.cl_attd_data_change a, hris.hris_emp_detail b where change_status = 'REQ' and a.emp_id = b.emp_id and b.emp_id_superior = ?";
        try
        {
            preparedstatement = connection.prepareStatement(s);
            preparedstatement.setInt(1, i);
            rset = preparedstatement.executeQuery();
            rset.next();
            j = rset.getInt("cnt");
        }
        catch(SQLException sqlexception)
        {
            j = 0;
        }
        finally
        {
            try
            {
                rset.close();
            }
            catch(Exception exception1) { }
            try
            {
                preparedstatement.close();
            }
            catch(Exception exception2) { }
        }
        return j;
    }

    private String getFolders()
    {
        StringBuffer stringbuffer;
        int i;
        stringbuffer = new StringBuffer(1000);
        i = ((MSGAgent)pageContext.getSession().getAttribute("agent")).getAgentID();
        try
        {
            cstmt = connection.prepareCall("{call erp.sis_msg.get_system_folders(?)}");
            cstmt.registerOutParameter(1, -10);
            cstmt.execute();
            rset = (ResultSet)cstmt.getObject(1);
            boolean flag = false;
            String s1 = "";
            boolean flag1 = false;
            for(; rset.next(); stringbuffer.append("</td></tr>"))
            {
                int j = rset.getInt("folder_id");
                String s2 = rset.getString("folder_name");
                int l;
                try
                {
                    _cstmt = connection.prepareCall("{call erp.sis_msg.get_system_folder_msg_count(?,?,?,?)}");
                    _cstmt.setInt(1, j);
                    _cstmt.setInt(2, i);
                    _cstmt.registerOutParameter(3, 2);
                    _cstmt.registerOutParameter(4, 2);
                    _cstmt.execute();
                    l = _cstmt.getInt(3);
                    _cstmt.close();
                }
                catch(SQLException sqlexception1)
                {
                    if(logCategory == null)
                        logCategory = Category.getInstance("clsite.com.cl.taglib");
                    logCategory.error(sqlexception1.toString());
                    l = 0;
                }
                finally
                {
                    try
                    {
                        if(_cstmt != null)
                            _cstmt.close();
                    }
                    catch(SQLException sqlexception2)
                    {
                        if(logCategory == null)
                            logCategory = Category.getInstance("clsite.com.cl.taglib");
                        logCategory.error(sqlexception2.toString());
                    }
                }
                stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td>");
                stringbuffer.append(newline + "<td><img src=\"/img/blank.gif\" width=\"5\"></td>");
                stringbuffer.append(newline + "<td valign=\"top\">");
                stringbuffer.append(newline + "<a href=\"/msg/MSGInbox.jsp?cat=" + category + "&fldr=" + URLEncoder.encode(s2) + "&fid=S" + j + "\" title=\"Folder " + s2 + "\" class=\"highlighttext\">" + s2 + "</a> <font class=\"highlighttext\">(" + l + ")</font>");
                if(j == 3 && l > 0)
                    stringbuffer.append(newline + "<font class=\"highlighttext\">[<a href=\"/msg/MSGEmptyTrash.jsp?cat=" + category + "&fwd=totrash" + "\" title=\"Click here to empty your Trash Can\" class=\"highlighttext\">Empty</a>]</font>");
            }

            try
            {
                rset.close();
            }
            catch(Exception exception) { }
            try
            {
                cstmt.close();
            }
            catch(Exception exception1) { }
            cstmt = connection.prepareCall("{call erp.sis_msg.get_user_folders(?,?)}");
            cstmt.registerOutParameter(1, -10);
            cstmt.setInt(2, i);
            cstmt.execute();
            int k;
            String s3;
            for(rset = (ResultSet)cstmt.getObject(1); rset.next(); stringbuffer.append(newline + "<a href=\"/msg/MSGInbox.jsp?cat=" + category + "&fldr=" + URLEncoder.encode(s3) + "&fid=U" + k + "\" title=\"Folder " + s3 + "\" class=\"highlighttext\">" + s3 + "</a> <font class=\"cnt\">(" + rset.getInt("message_count") + ")</font></td></tr>"))
            {
                k = rset.getInt("folder_id");
                s3 = rset.getString("folder_name");
                stringbuffer.append(newline + "<tr><td><img src=\"/img/blank.gif\" width=\"5\"></td>");
                stringbuffer.append(newline + "<td><img src=\"/img/blank.gif\" width=\"5\"></td>");
                stringbuffer.append(newline + "<td valign=\"top\">");
            }

            try
            {
                rset.close();
            }
            catch(Exception exception2) { }
            try
            {
                cstmt.close();
            }
            catch(Exception exception3) { }
        }
        catch(SQLException sqlexception)
        {
            if(logCategory == null)
                logCategory = Category.getInstance("clsite.com.cl.taglib");
            logCategory.error(sqlexception.toString());
            stringbuffer = null;
            stringbuffer = new StringBuffer(500);
            stringbuffer.append(newline + "<tr><td valign=\"top\">");
            stringbuffer.append(newline + "<a href=\"/msg/MSGInbox.jsp?cat=1&fid=1\" title=\"Folder Inbox\"" + " class=\"highlighttext\">Inbox</a></td></tr>");
            break MISSING_BLOCK_LABEL_1058;
        }
        break MISSING_BLOCK_LABEL_1058;
        local1;
        try
        {
            rset.close();
        }
        catch(SQLException sqlexception3) { }
        try
        {
            cstmt.close();
        }
        catch(SQLException sqlexception4) { }
        JVM INSTR ret 11;
        String s = stringbuffer.toString();
        stringbuffer = null;
        return s;
    }

    private String[] getPrivileges()
    {
        String s = "";
        String as[] = null;
        try
        {
            s = pageContext.getSession().getAttribute("privileges_type").toString();
        }
        catch(NullPointerException nullpointerexception)
        {
            as = new String[1];
            as[0] = "";
            return as;
        }
        StringTokenizer stringtokenizer = new StringTokenizer(s, ",");
        as = new String[stringtokenizer.countTokens()];
        for(int i = 0; stringtokenizer.hasMoreTokens(); i++)
            as[i] = stringtokenizer.nextToken();

        return as;
    }

    public int doEndTag()
        throws JspTagException
    {
        return 6;
    }

    private int category;
    private int level;
    private String newline;
    private static final String PKG_NAME = "clsite.com.cl.taglib";
    private Category logCategory;
    private PoolManager clmsPool;
    private Connection connection;
    private CallableStatement cstmt;
    private CallableStatement _cstmt;
    private ResultSet rset;
    private boolean connectionFromJsp;
}