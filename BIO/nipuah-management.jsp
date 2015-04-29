<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@include file="nipuah-const.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@include file="../checkDateNEW.inc"%>

<%
	session.setAttribute("comFrom", "1");
	session.setAttribute("type", "");
	session.setAttribute("charac", "");
	session.setAttribute("micron", "");
	session.setAttribute("gauge", "");
	session.setAttribute("widthMm", "");
	session.setAttribute("widthInch", "");
	session.setAttribute("cf", "");
	session.setAttribute("lengthMtr", "");
	session.setAttribute("lengthFt", "");
	session.setAttribute("weightKg", "");
	session.setAttribute("kind", "");
	
	session.setAttribute("order", "");
	session.setAttribute("employee", "");
	session.setAttribute("emps", "");
	session.setAttribute("machine", "");	
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

<P align="center"><FONT size="+2"><B>Extrusion - Management</B></FONT></P>

<P><BR>

</P>
<DIV align="center">
<TABLE border="0">
	<TBODY align="center">
		<TR>
			<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="start" class="myButton" 
				value="1. <%=startWork%>" onclick="window.location='nipuah-start.jsp'"></TD>
		</TR>
		<TR>
			<TD></TD>
		</TR>
		<!--
		<TR>
			<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="stop" class="myButton" value="3. <%=stopWork%>"
			 onclick="window.location='nipuah-stop.jsp'"></TD>
		</TR>
		<TR>
			<TD></TD>
		</TR>
		-->
		<TR>
			<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="2. <%=endWork%>"
			 onclick="window.location='nipuah-end.jsp'"></TD>
		</TR>
		<TR>
			<TD></TD>
		</TR>
		
		<TR>
			<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="3. Extrusion Orders Creation"
			 onclick="window.location='../Yizur/yizur-ExtrusionOrdersCreation.jsp'"></TD>
		</TR>
		<TR>
			<TD></TD>
		</TR>
		<TR>
			<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="4. Raw Material Use Report"
			 onclick="window.location='../Yizur/yizur-rowMaterialUseReport.jsp'"></TD>
		</TR>
		<TR>
			<TD></TD>
		</TR>
		<TR>
			<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="5. Individual Labels"
			 onclick="window.location='nipuah-individualLabels.jsp'"></TD>
		</TR>
		<TR>
			<TD></TD>
		</TR>
		<TR>
			<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="6. Fix Extrusion Reporting"
			 onclick="window.location='nipuah-fixBioReporting.jsp'"></TD>
		</TR>
		<TR>
			<TD>&nbsp;</TD>
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
