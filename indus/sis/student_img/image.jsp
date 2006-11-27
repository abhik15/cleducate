<%@ taglib uri="http://jakarta.apache.org/taglibs/image-1.0" prefix="img" %>


<table>
<tr>
<td>
<img:image src="/miku1.jpg"
        dir="generated"
        name="new-miku-20.jpg"
		refresh="true"
		quality="0.1"
	  attributes="border='0' alt='a sample dynamic image'">
  <img:resize width="160"  bestfit="yes" />
	<img:text text="Shree Bhattacharyya - image width height%"
		x="10%" 
		y="75%" 
		font="Arial" 
		bold="true" 
		size="14" 
		color="0x0000ff"
	/>
</img:image> 
<% int pid =3;
out.println("<img:image src=\"/group_photo/3/"+pid+"jpg\"");
        out.println("dir=\"generated/group_photo/3/"+pid+".jpg\"");
        out.println("name=\"3.jpg\"");
		out.println("refresh=\"true\"");
		out.println("quality=\"0.8\"");
	  out.println("attributes=\"border='0' alt='a sample dynamic image'\">");
  out.println("<img:resize width=\"160\"  bestfit=\"yes\" />");
	out.println("<img:text text=\"IWS\"");
out.println("x=\"10%\" y=\"75%\" font=\"Arial\" bold=\"true\" size=\"14\" color=\"0x0000ff\"/>");
out.println("</img:image>");
%>
</td>
<td>

<img:image src="/miku1.jpg"
        dir="generated"
        name="new-miku-10.jpg"
		refresh="true"
		quality="1"
	  attributes="border='0' alt='a sample dynamic image'">
  <img:resize scale="10%" />

<img:overlay x="5%" y="90%" color="0xffffff" tolerance="35">
<img:image src="/cl_logo.gif">
<img:resize scale = "60%" />
</img:image>  
</img:overlay>

</img:image> 

</td>

<td>

<img:image src="/miku1.jpg"
        dir="generated"
        name="new-miku-01.jpg"
		refresh="true"
	  attributes="border='0' alt='a sample dynamic image'">
  <img:resize scale="5%" />
	<img:text text="Shree "
		x="10%" 
		y="75%" 
		font="Arial" 
		bold="true" 
		size="10" 
		color="0x0000ff"
	/>
</img:image> 

</td>
</tr>
</table>

<p align="center">
	<b>Source Images used in the above example:-</b><br/>
	<img src="miku1.jpg" /><br/><br/>

</p>

			    	
