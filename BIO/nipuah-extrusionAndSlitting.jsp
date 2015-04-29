<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@include file="nipuah-const.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@include file="../checkDateNEW.inc"%>

<%
	session.setAttribute("slitOrder1", "");
	session.setAttribute("slitOrder2", "");
	session.setAttribute("roll1", "");
	session.setAttribute("roll2", "");
	session.setAttribute("machine", "");
	session.setAttribute("worqSeq", "");
	session.setAttribute("loadedItem", "");
	
	session.setAttribute("workSeq1", "");
	session.setAttribute("workSeq2", "");
	session.setAttribute("length1", "");
	session.setAttribute("length2", "");
	session.setAttribute("width1", "");
	session.setAttribute("width2", "");
	session.setAttribute("slitter1", "");
	session.setAttribute("slitter2", "");
%>

<HTML>
<HEAD>

<META http-equiv="Content-Type"
	content="text/html; charset=WINDOWS-1255">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="theme/Master.css" rel="stylesheet" type="text/css">

<style type="text/css">
input.myButton {width:180}
input.myButtonSp {width:180;color:white; background-color:blue}
</style>
	
<TITLE>nipuah-first.jsp</TITLE>

<SCRIPT language="javascript">
function CloseIbrix(){
	var activeIndex = top.QuickSwitch.getActiveIndex();
	top.QuickSwitch.enableDisableScreen('close');
	top.QuickSwitch.closeActiveProgram(activeIndex, "closed");
}


</SCRIPT>

</HEAD>
<BODY oncontextmenu="return false">

<P align="center"><FONT size="+2"><B>שיחול - דיווח שיחול + חיתוך</B></FONT></P>

<P><BR>

</P>
<DIV align="center">
<TABLE border="0">
	<TBODY align="center">
		<TR>
			<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="start" class="myButton" 
				value="1. התחלת הוראת חיתוך" onclick="window.location='nipuah-slitter-startWork.jsp'"></TD>
		</TR>
		<TR>
			<TD></TD>
		</TR>
		
		<TR>
			<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="stop" class="myButton" value="2. דיווח שיחול וחיתוך"
			 onclick="window.location='nipuah-reportAndSlit.jsp'"></TD>
		</TR>
		<TR>
			<TD></TD>
		</TR>
		
		<TR>
			<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="3. סיום הוראת חיתוך"
			 onclick="window.location='nipuah-slitter-endOrder.jsp'"></TD>
		</TR>
		<TR>
			<TD></TD>
		</TR>
		
		
	
		<TR>
			<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="7. <%=exitBtn%>"
			 onclick="window.location='nipuah-first.jsp'"></TD>
		</TR>
		
		
	</TBODY>
</TABLE>
</DIV>
</BODY>
</HTML>
