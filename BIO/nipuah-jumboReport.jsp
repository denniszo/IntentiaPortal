<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@include file="nipuah-const.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@include file="../checkDateNEW.inc"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.Time"%>
<%@page import="java.text.DateFormat"%>
<HTML>
<HEAD>


<META http-equiv="Content-Type"
	content="text/html; charset=windows-1255">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">


<LINK href="theme/Master.css" rel="stylesheet" type="text/css">

<style type="text/css">
input.myButton {width:150}
input.readonly {background-color:#F0F0F0;border-color:steelblue;border-width:1px;border-style:solid}
</style>

<TITLE>nipuah-start.jsp</TITLE>
<SCRIPT language="javascript">

var MvxCompany = "<%=MvxCompany%>";

function returnToFirst(){
	
	window.location='nipuah-first.jsp';
}



function doReport(){
	if (document.myForm.orderNum.value != ""){
		document.myForm.go.disabled=true;
		document.myForm.submit();
	}
}


</SCRIPT>
</HEAD>


<BODY dir=<%=page_dir%> onLoad='document.myForm.orderNum.focus();'>

<P align="center"><B><FONT size="+2"><%=title_jumboReport%></FONT></B></P>
<P>
</P>
<DIV align="center">
<form name="myForm" action="nipuah-doJumboReport.jsp" method="post">
<TABLE border="0">
	<TBODY align="center">
		<TR>
			<TD align="<%=labels_align%>"><%=moNumber%></TD>
			<TD><INPUT type="text" name="orderNum" size="10" onChange='document.myForm.go.disabled=false'></TD>
		</TR>
	</TBODY>
</TABLE>



<p>
<INPUT type="button" name="exit" value="<%=exitBtn%>" class="myButton"  onclick="window.location='nipuah-first.jsp'">
&nbsp;&nbsp;&nbsp;
<INPUT type="button" name="go" value="<%=doBtn%>" class="myButton" onclick="doReport()">

</FORM>
</DIV>
</BODY>
</HTML>
