<!-- 
	 Author: Kamal Singh Deori
     Filename: OrderBrochure.jsp
     Date: 1 Dec 05
	 Desc: For Use of Order Brochure 
-->
<%@ page import="org.apache.log4j.*,com.opus.epg.sfa.java.*"%>
<%
	Category logCategory = Category.getInstance("ananda.registration.OrderBrochure");

	Merchant oMerchant 	= new Merchant();
	PostLib oPostLib	= new PostLib();
	MPIData oMPI = new MPIData();
	try 
	{
		long registrationId = Long.parseLong(request.getParameter("registrationId"));
		int amount = Integer.parseInt(request.getParameter("price"));

		StringBuffer sessionId = new StringBuffer(session.getId()+"_"+registrationId);

		String merchantId = "00001117"; // customer code for creditcard gateway

		String localeId = "en"; // set Locale "en" = English 
		String returnURL = "http://www.anandaschool.com/registration/UpdBrochure.jsp?registrationId="+registrationId+"&amount="+amount+"&";
			
		if(sessionId.length() > 45)
		sessionId = new StringBuffer(sessionId.substring(sessionId.length()-45,sessionId.length()));
				
		session.setAttribute("amount",Integer.toString(Math.round(amount)));

		oMPI.setMPIRequestDetails(Integer.toString(Math.round(amount))
		,"INR "+Integer.toString(Math.round(amount))
		,"356"
		,"2"
		,""
		,""
		,""
		,""
		,"0"
		,""
		,"image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-powerpoint, application/vnd.ms-excel, application/msword, application/x-shockwave-flash, */*"
		,"Mozilla/4.0 (compatible; MSIE 5.5; Windows NT 5.0)"
		);

		oMerchant.setMerchantDetails(
		merchantId
		,merchantId
		,merchantId
		,""
		, sessionId.toString()
		,"EID-"+registrationId
		, returnURL
		, "GET"
		,"INR"
		,"EID-"+registrationId
		, "req.Preauthorization"
		, Integer.toString(Math.round(amount))
		,""
		, ""
		, ""
		, ""
		, ""
		, ""
		);

		PGResponse oPGResponse = oPostLib.postSSL(null,null,oMerchant,oMPI,response);

		if(oPGResponse.getRedirectionUrl() != null)
		{
			response.sendRedirect(oPGResponse.getRedirectionUrl());
		}
		else 
		{
			logCategory.fatal("Error encountered. Error Code : " +oPGResponse.getRespCode() + " . Message " +  oPGResponse.getRespMessage());
			throw(new NullPointerException("oPGResponse.getRedirectionUrl returned null"));
		}
	}
	catch(Exception nex)
	{
		logCategory.fatal(nex);
		throw(nex);
	}
%>
