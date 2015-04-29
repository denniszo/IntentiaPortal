<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">


<HTML>
<HEAD>
<title>Enter Password</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1255">

<script type="text/javascript">
document.onkeyup = KeyCheck;

// permits to run the page wit keyboard without mouse
function KeyCheck(e)
{
   var KeyID = (window.event) ? event.keyCode : e.keyCode;
   switch(KeyID)
   {
      case 119:	//F8
      	sendValue();
      	break;
   }
}

function disableEnterKey(e){
     var key;

     if(window.event)
          key = window.event.keyCode;     //IE
     else
          key = e.which;     //firefox

     if(key == 13)
          return false;
     else
          return true;
}
</script>

<script language="JavaScript">
//checks that data is entered before submiting
function sendValue(){
	var pass = document.myForm.pass.value;

	window.returnValue=pass;
	window.close();
}
</script>

<body  onload='document.myForm.pass.focus()'>
<center>
<h3>Password</h3>
<p>Enter password and click on button</p>
<p>
<form name=myForm>
<table>
<tr><td>
<input type=password size=30 name=pass onKeyPress="return disableEnterKey(event)"></td>
</tr>
</table>
<p>
<input type=button value="OK (F8)" onClick="sendValue()">

</form>
</body>
</html>
