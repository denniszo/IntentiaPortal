<?xml version="1.0" encoding="UTF-8"?>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>

<%


String dir = request.getParameter("dir");
//File f = new File(dir);
//boolean ok = f.mkdirs();
//out.println("Directory " + dir + " created: " + ok);
String url=URLEncoder.encode(dir,"UTF-8");

%>

<html>
<head>
<script language="javascript">
var gInterval="";

function on_blur(){
gInterval=window.setInterval("winfocus()",100);	
	
}

function winfocus()
{
window.clearInterval(gInterval);
window.focus();
}
</script>



</head>
<body dir="rtl" onblur="on_blur()" class="Popupwnd">

<div class="Lbl">
<%=dir%>
</div>
<iframe src ="file:///<%=dir%>" frameborder="1" width="100%" height="80%"> </iframe>

<br /><br /><br />
<center>
<input id="btn" class="Btn" type="button" value="סגור חלון" onclick="javascript:window.close()" />
</center>
</body>
</html>