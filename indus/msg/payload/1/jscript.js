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

if(formname.body.value.length>2000){
	alert("Please make your message shorter, the system cannot send a message more than 2000 characters. If your message is long, try attaching it as a file.");
	formname.body.focus();
	return false;
	}

	return true;
}

function send(formname){
	if(validate(formname)){
	formname.action="/msg/payload/1/Send.jsp";
	formname.submit();
	}
}

function reply(formname){
}

function attach(formname){
	formname.action="/msg/payload/1/TakeAttachment.jsp";
	formname.submit();
}

