<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@include file="nipuah-label.jsp"%>
<HTML>
<HEAD>
<%@ page 
language="java"
%>
<META http-equiv="Content-Type"
	content="text/html; charset=WINDOWS-1255">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="theme/Master.css" rel="stylesheet" type="text/css">

<style type="text/css">
input.myButton {width:150}
</style>
	
<TITLE>nipuah-label-print.jsp</TITLE>
</HEAD>
<BODY onload="window.print();window.location='nipuah-first.jsp'">
<%for (int i = 0; i < label.length; i ++){
	out.println(label[i] + " <br>");
}
out.flush();
%>

</BODY>
</HTML>
