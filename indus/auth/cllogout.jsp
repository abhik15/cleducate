<jsp:useBean id="agent" class="com.cl.msg.MSGAgent" scope="session" />
<jsp:useBean id="StudentLogin" scope="session" class="com.cl.sis.student.SISStudentLogin"/>
<%
	if(agent.getPkID()==0 &&  StudentLogin.getUserID()==0)
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