<!-- 
	 Author: Kamal Singh Deori
     Filename: UpdBrochure.jsp
     Date: 23 Nov 05
	 Desc: For Use of Update Brochure
-->
<%@ page language="java" import ="java.sql.*,oracle.jdbc.driver.*,org.apache.log4j.*,com.cl.sql.PoolManager,com.opus.epg.sfa.java.*"%>
<%@ page import="java.util.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="expires" content="0">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">
<title>Ananda Admission Submit</title>
<link rel="stylesheet" href="../styles/ananda.css" type="text/css">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<center>
  <table width="780" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td valign="top" align="center"><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="780" height="124">
          <param name=movie value="../swf/admission_topband.swf">
          <param name=quality value=high>
          <embed src="../swf/admission_topband.swf" quality=high pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="780" height="124">
          </embed> 
        </object></td>
    </tr>
  </table>
  <center>
    <table width="780" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td align="left" valign="top" bgcolor="#33CCCC"><img src="../img/1x1.gif" width="1" height="1" /></td>
        <td align="left" valign="top"><table width="778" border="0" cellspacing="0" cellpadding="0">
            <tr valign="top" align="left">
              <td width="14%">&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            <tr>
              <td align="left" valign="top">&nbsp;</td>
              <td valign="top" align="left" background="../img/parents_bg.gif"><img src="../img/admission.gif" hspace="8" align="absmiddle" /></td>
            </tr>
        </table></td>
        <td align="left" valign="top" bgcolor="#33CCCC"><img src="../img/1x1.gif" width="1" height="1" /></td>
      </tr>
      <tr>
        <td align="left" valign="top" bgcolor="#33CCCC"></td>
        <td><table width="778" border="0" cellspacing="0" cellpadding="0" background="../img/admission_bg.gif">
            <tr>
              <td valign="top" align="left" width="14%"><table border="0" cellspacing="3" cellpadding="0" width="100%">
                <tr valign="top" align="left">
                  <td></td>
                </tr>
                <tr valign="top" align="left">
                  <td align="right"><img src="../img/1x1.gif" width="1" height="20" /></td>
                </tr>
                <tr valign="top" align="left">
                  <td align="right">&nbsp;</td>
                </tr>
                <tr valign="top" align="left">
                  <td align="center"></td>
                </tr>
              </table></td>
              <td valign="top" align="left"><table width="95%" border="0" cellspacing="0" cellpadding="15">
                <tr>
                  <td valign="top" align="left"><font class="runningtext"><strong>Dear Parents,</strong>                      <br />
<table width="100%" border="0" cellspacing="3" cellpadding="0" align="left" class="runningtext">
  
  <tr> 
    <td>
	<center>
<%
				Category logCategory = Category.getInstance("ananda.registration.UpdBrochure");
				PoolManager pool = PoolManager.getInstance();
				Connection connection = null;
				CallableStatement call = null;

				String merchantID = "00001117";
				String sessionID = "";
				String amount = (String)session.getAttribute("inrProdPrice");
				String locale = "";
				String transactionNumber = "";
				String acquirerResponseCode = "";
				String qsiRespCode = "";
				String qsiRespCodeDesc = "";
				StringBuffer qst = new StringBuffer("");

				// Extract  the encrypted Digital Receipt from the request
				long registrationId = Long.parseLong(request.getParameter("registrationId"));
				int prodPrice = Integer.parseInt(request.getParameter("amount")); 

				// Create a Payment Client Object
				Merchant oMerchant 	= new Merchant();
				PostLib oPostLib = new PostLib();

				try
				{
					oMerchant.setMerchantOnlineInquiry(merchantID,	request.getParameter("TxnID"));
					PGSearchResponse    oPgSearchResp=oPostLib.postStatusInquiry(oMerchant);
					ArrayList oPgRespArr = oPgSearchResp.getPGResponseObjects();
		
					if (oPgRespArr !=  null)
					{
						PGResponse oPgResp = (PGResponse)oPgRespArr.get(0);
						sessionID = request.getParameter("TxnID");
						locale = "en";
						transactionNumber = oPgResp.getEpgTxnId();
						acquirerResponseCode = "";//oPgResp.getAuthIdCode();

						// obtain the QSI reponse code, determine the description and
						// create the final two rows of the table containing the results
						qsiRespCode = oPgResp.getRespCode();
						qsiRespCodeDesc = oPgResp.getRespMessage();

						qst.append("&amount="+prodPrice);
						qst.append("&qsiRespCode="+qsiRespCode);
						qst.append("&qsiRespCodeDesc="+java.net.URLEncoder.encode(qsiRespCodeDesc));
						qst.append("&eid="+registrationId);

						if(qsiRespCode.equals("0"))
						{
							session.removeAttribute("user");
							try
							{
								connection = pool.getConnection("school");
								call = connection.prepareCall ("{call SCHOOL.ANANDA_REGISTRATION.UPD_BROCHURE(?,?,?,?,?,?,?)}");
								call.setLong(1,registrationId);
								call.setString(2,"ACTIVE");
								call.setString(3,locale);
								call.setLong(4,Long.parseLong(transactionNumber));
								call.setString(5,acquirerResponseCode);
								call.setInt(6,Integer.parseInt(qsiRespCode));
								call.setString(7,qsiRespCodeDesc);
								call.execute();
							}
							catch(SQLException x)
							{
								int errorCode = x.getErrorCode();
					//			if(errorCode == 20000)
								{
									String errorMsg = x.toString();
									//errorMsg = errorMsg.substring(33);
									//errorMsg = errorMsg.substring(0,45);
									out.println("<center><br><br><font class=\"new\"><b>"+errorMsg+"</b></font><br><br><a href=\"JavaScript:history.back()\" class=\"lnkblu\">Back</a></center>");
								}
				
								return;
							}
							catch(Exception exec)
							{
								logCategory.error(exec);
								throw exec;
							}
							finally
							{
								session.removeAttribute("inrProdPrice");
								session.removeAttribute("convRate");
								session.removeAttribute("prodPrice");
								session.removeAttribute("prodCurr");
								session.removeAttribute("registrationId");
								try{call.close();}catch(Exception exec){}
								pool.freeConnection("school",connection);
							}
%>
							Thank you for submitting your brochure. Your Registration Id is <%=registrationId%><br><br>
							<IMG SRC="/img/smiley.gif" WIDTH="95" HEIGHT="95" BORDER="0" ALT=""><br><br>
							<A HREF="/">Back</A>
<%
						}
						else
						{
							try
							{
								connection = pool.getConnection("school");
								call = connection.prepareCall ("{call SCHOOL.ANANDA_REGISTRATION.UPD_BROCHURE(?,?,?,?,?,?,?)}");
								call.setLong(1,registrationId);
								call.setString(2,"ONLINE");
								call.setString(3,locale);
								call.setLong(4,Long.parseLong(transactionNumber));
								call.setString(5,acquirerResponseCode);
								call.setInt(6,Integer.parseInt(qsiRespCode));
								call.setString(7,qsiRespCodeDesc);
								call.execute();
							}
							catch(Exception ex)
							{
								logCategory.error(ex.toString());
								throw(ex);
							}
							finally
							{						
								try{call.close();}catch(Exception exec){}
								pool.freeConnection("school",connection);						
							}
							response.sendRedirect("AnandaError.jsp?"+qst.toString());
							return;
						}
					}
					else 
					{
						logCategory.error(oPgSearchResp.toString());
						throw(new NullPointerException("oPgSearchResp.getPGResponseObjects returned null"));
					}
				}
				catch (Exception ex) 
				{
					logCategory.error(ex.toString());
					throw(ex);
				}
%>
		</center>
 </td>
 </tr>
</table>
</body>
</html>