<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
<%
	if(agent.getPkID()==0 &&  (String)session.getValue("uid") == null)
	{

%>
		<html>
		<body>
		<script language="javascript">
		
		alert("You are not logged in.");
		window.top.location.href="/"
		
		</script>
		</body>
		</html>

<%

	}
	else
	{
		session.invalidate();

%>
		<html>
		<body>
		<script language="javascript">
		
		alert("You have successfully signed out.");

		window.top.location.href="/"		

		</script>
		</body>
		</html>
<%
	}

%>	