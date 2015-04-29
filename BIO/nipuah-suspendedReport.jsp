<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@include file="nipuah-const.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@include file="../checkDateNEW.inc"%>
<%@page import="java.sql.Date"%>
<%@page import="java.text.DateFormat"%>
   
<%
int numOfLines = 0;
%>
<HTML>
<HEAD>


<META http-equiv="Content-Type"
	content="text/html; charset=windows-1255">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">


<LINK href="theme/Master.css" rel="stylesheet" type="text/css">

<style type="text/css">
input.myButton {width:150}
input.clReadonly {background-color:#F0F0F0;border-color:steelblue;border-width:1px;border-style:solid}
</style>

<TITLE>nipuah-suspendedReport.jsp</TITLE>
<SCRIPT language="javascript">

var MvxCompany = "<%=MvxCompany%>";

function onLoad(){
		
}

// this function reveales a new line for one more field
// the visibility of the new line is set to visible.
function addLines(x){
	for (i=1; i<=x;i++){
		eval("myLine" + i + ".style.display = ''");
	}
}

function initLines(){
	for (i=1; i<=6;i++){
		eval("myLine" + i + ".style.display = 'none'");
	
		eval("document.myForm.roll" + i + ".value = ''");
		eval("document.myForm.item" + i + ".value = ''");
		eval("document.myForm.order" + i + ".value = ''");
		eval("document.myForm.weight" + i + ".value = ''");
		eval("document.myForm.desc" + i + ".value = ''");
		eval("document.myForm.emp" + i + ".value = ''");
	}	
	document.myForm.numOfLinesHID.value = '';
}

function doTheJob(){
	initLines();

	myDate = document.myForm.date.value;
	
	myDate = saderDate(myDate);
	document.myForm.date.value = myDate;
	
	if (checkDateAndTime()){
		if (mvxd.indexOf("1") >= 0)
			myDate = "20"+myDate.substring(6,8)+myDate.substring(3,5)+myDate.substring(0,2);
		else
			myDate = "20"+myDate.substring(6,8)+myDate.substring(0,2)+myDate.substring(3,5);
		
		var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
		RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
		RejReas_Collection.MieServer = "<%=MIEServerURL%>";
		
		RejReas_Collection.AddValue("cono", MvxCompany);
		RejReas_Collection.AddValue("date", myDate);
		
		if (mvxd.indexOf("1") >= 0)
			RejReas_Collection.CreateCollection("MO_GetSuspendedRolls");//Run model
		else
			RejReas_Collection.CreateCollection("MO_GetSuspendedRollsUS");//Run model
		
		if (RejReas_Collection.count== 0){
			alert("<%=error_NoSuspended%>");
		}else{
			numOfLines = RejReas_Collection.count;
			document.myForm.numOfLinesHID.value = numOfLines;
			
			addLines(numOfLines);
			
			for (var i = 0; i < numOfLines; i++){
				var oStd=RejReas_Collection.Item(i);//row
					
				roll = oStd.GetValue("ROLL");
				myItem = oStd.GetValue("ITEM");
				order = oStd.GetValue("ORDER");
				weight = formatWeight(oStd.GetValue("WEIGHT"),0);
				desc = oStd.GetValue("DESC");
				emp = oStd.GetValue("REMARK");
				
				k = i + 1;
				
				eval("document.myForm.roll" + k + ".value = '" + roll + "'");
				eval("document.myForm.item" + k + ".value = '" + myItem + "'");
				eval("document.myForm.desc" + k + ".value = '" + desc + "'");
				eval("document.myForm.order" + k + ".value = '" + order + "'");
				eval("document.myForm.weight" + k + ".value = '" + weight + "'");
				eval("document.myForm.emp" + k + ".value = '" + emp + "'");
				
				document.myForm.go.disabled=true;
			}//end for
			
		}
		
		RejReas_Collection=null;
	}
}//end function doTheJob()

function checkDateAndTime(){
	var myDate = document.myForm.date.value;

	if (isValidDate(myDate)){
		return true;
	}else{
		alert("<%=error_wrongDate%>");
		return false;
	}
} //end function checkDateAndTime()

function formatWeight(num, decimals){
	num = "" + num;
	var position = num.indexOf(".");
	
	if (position == 0){
		num = "0" + num;
		position = 1;
	}
	
	if (decimals > 0)
		decimals++;
	
	if (position > 0){
		if (num.length > position + 1* decimals)
			return num.substring(0, position + 1 * decimals);
		else
			return num;
	}else
		return num;
}

</SCRIPT>
</HEAD>


<BODY dir=<%=page_dir%> onload="onLoad()">
<%
Date currentDate = new Date(System.currentTimeMillis());

String currentDateStr1 = DateFormat.getDateInstance(DateFormat.SHORT).format(currentDate);//currentDate.toString();

String currentDateStr = "";
if (mvxd.indexOf("1") >= 0)
	currentDateStr = currentDateStr1.substring(0,2) + "/" + currentDateStr1.substring(3,5) + "/" + currentDateStr1.substring(6,8);
else
	currentDateStr = currentDateStr1.substring(3,5) + "/" + currentDateStr1.substring(0,2) + "/" + currentDateStr1.substring(6,8);

%>
<P align="center"><B><FONT size="+2"><%=title_suspendedReport%></FONT></B></P>
<P><BR>
<BR>
</P>
<DIV align="center">
<FORM name = "myForm" action="yizur-doSuspendedReport.jsp" target="RepManWin" method="POST">
<TABLE border="0">
	<TBODY align="center">
		<TR>
			<TD align="<%=labels_align%>"><%=lblDate%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="date" size="6" tabindex="1" value='<%=currentDateStr%>' onChange='document.myForm.go.disabled=false'></TD>
		</TR>
	</TBODY>
</TABLE>

<p>&nbsp;<p>
<% // this loop creates 6 "div", none are visible in the begining.
   // before the first one there are headers.
int i = 1;

for (i=1; i<=300;i++){
	if (i < numOfLines+1){ %>
		<div id='myLine<%=i%>' align=right style='display:on'>
	<% }else{ %>
		<div id='myLine<%=i%>' align=right style='display:none'>
	<% } %>
	<center>
	<table border="0" id="tbl<%=i%>">
	<% if (i == 1){ %>
		<tr>
			<th><%=lblRoll%></th>
			<th><%=lblItem%></th>	
			<th><%=lblAsmahta%></th>		
			<th><%=lblWeight%></th>
			<th><%=lblDescription%></th>
			<th><%=lblChecker%></th>
		</tr>
	<% } %>
	<tr>
		<TD align="<%=input_align%>"><INPUT type="text" name="roll<%=i%>" value="" size=10  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="item<%=i%>" value="" size=10  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="order<%=i%>" value="" size=10  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="weight<%=i%>" value="" size=5  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="desc<%=i%>" value="" size=20  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="emp<%=i%>" value="" size=10  readonly class='clReadonly'></td>
	</tr>
	
	</TABLE>
	</div>
<% } %>
<p>
<INPUT type="button" name="exit" value="<%=exitBtn%>" class="myButton"  onclick="window.location='nipuah-first.jsp'" tabindex="3">
<INPUT type="button" name="go" value="<%=doBtn%>" class="myButton" onclick="doTheJob()" tabindex="2">

<INPUT type="hidden" name="numOfLinesHID">

</FORM>
</DIV>
</BODY>
</HTML>
