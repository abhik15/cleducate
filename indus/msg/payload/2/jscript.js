function validate(formname){
if(formname.receiver.value==""){
	alert("Please enter receiver(s) for the message");
	formname.receiver.focus();
	return false;
	}
if(formname.subject.value==""){
	alert("Please give a subject");
	formname.subject.focus();
	return false;
	}
if(formname.body.value==""){
	alert("Please enter some message");
	formname.body.focus();
	return false;
	}

	return true;
}

function send(formname){
	if(validate(formname)){
	formname.action="/msg/payload/2/Send.jsp";
	formname.submit();
	}
}

function attach(formname){
	formname.action="/msg/payload/2/TakeAttachment.jsp";
	formname.submit();
}

