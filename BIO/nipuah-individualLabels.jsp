<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@include file="slitter-const.jsp"%>
<%@include file="slitter-labels-heb.jsp"%>
<%@include file="../checkDateNEW.inc"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.Time"%>
<%@page import="java.text.DateFormat"%>

<%	
	
	String type = session.getAttribute("type").toString();
	String charac = session.getAttribute("charac").toString();
	String micron = session.getAttribute("micron").toString();
	String gauge = session.getAttribute("gauge").toString();
	String widthMm = session.getAttribute("widthMm").toString();
	String widthInch = session.getAttribute("widthInch").toString();
	String cf = session.getAttribute("cf").toString();
	String lengthMtr = session.getAttribute("lengthMtr").toString();
	String lengthFt = session.getAttribute("lengthFt").toString();
	String weightKg = session.getAttribute("weightKg").toString();
	String kind = session.getAttribute("kind").toString();
	
%>
<HTML>
<HEAD>


<META http-equiv="Content-Type" content="text/html; charset=UTF-8"">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css";>


<LINK href="theme/Master.css" rel="stylesheet" type="text/css">

<style type="text/css">
input.myButton {width:150}
</style>

<TITLE>slitter-rollLoading.jsp</TITLE>
<SCRIPT language="javascript">

function onLoad(){
	var myType = document.myForm.type.value;
		
	if (myType != ""){
		document.myForm.rollNumber.focus();
	}
}

function getItem(item){
	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	
	//set parameters
	RejReas_Collection.AddValue("itemNumber", item.value);
		
	RejReas_Collection.CreateCollection("MO_GetParitDescription");//Run model
	
	if (RejReas_Collection.count > 0){
		var oStd=RejReas_Collection.Item(0);//row
		
		document.myForm.type.value = oStd.GetValue("TYPE");
		document.myForm.charac.value = oStd.GetValue("CHARAC");
		document.myForm.micron.value = oStd.GetValue("MICRON");
		document.myForm.gauge.value = oStd.GetValue("GAUGE");
		document.myForm.widthMm.value = oStd.GetValue("WIDTH_MM");
		document.myForm.widthInch.value = oStd.GetValue("WIDTH_INCH");
		document.myForm.cf.value = oStd.GetValue("CF_F");
		document.myForm.weightKg.value = oStd.GetValue("NETO");
		
		if (oStd.GetValue("KIND") == '05' || oStd.GetValue("KIND") == '08')
			document.myForm.lengthMtr.value = formatWeight(oStd.GetValue("FINIHED_LENGTH"),0);
		else
			document.myForm.lengthMtr.value = oStd.GetValue("LENGTH");
			
		document.myForm.kind.focus();
	}else{
		item.value = '';
		alert("<%=error_itemNotExists%>");
	}
}

function formatWeight(num, decimals){
	var position = num.indexOf(".");
	
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

function printLabel(){
	document.myForm.go.disabled=true;
	var WinParam="<%=WinParam%>";
	var w = window.open("blank.jsp","RepManWin",WinParam);
	//var w = window.open("blank.jsp","RepManWin");
		
	if (!<%=debug%>)
		w.blur();
			
	document.myForm.submit();	
	//alert("OK")
}

function returnToFirst(){	
	window.location='nipuah-management.jsp';
}

function enableGoBtn(){
	document.myForm.go.disabled=false;
}

function reload(){	
	window.location.reload();
}

function parseRoll(num){
	roll = num.value;
	
	if (roll.length > 9){
		father = roll.substr(7, 9);
		
		if (father.charAt(8) == ".")
			father = father.substr(0,7)
		
		document.myForm.fatherHID.value = father;
	}
}
</SCRIPT>
</HEAD>


<BODY dir=<%=page_dir%> onLoad='document.myForm.item.focus();onLoad()' oncontextmenu="return false">

<P align="center"><B><FONT size="+2">Extrusion - Individual Labels</FONT></B></P>

<DIV align="center">
<FORM name = "myForm" action="nipuah-doIndividualLabel.jsp" target="RepManWin" method="POST">
<table border=1>
<TD>
<TABLE border="0">
	<TBODY align="center">
		<TR>
			<TD align="<%=labels_align%>"><%=lblItem%></TD>
			<TD align="<%=input_align%>"><B><INPUT type="text" name="item" size="20" tabindex="1" colspan=3 onChange="getItem(this)"></B></TD>
		</TR>
		<TR>
			<TD align="<%=labels_align%>"><%=lblType%></TD>
			<TD align="<%=input_align%>"><B><INPUT type="text" name="type" size="10" tabindex="2" value="<%=type%>"></B></TD>
			<TD align="<%=labels_align%>"><%=lblCharac%></TD>
			<TD align="<%=input_align%>"><B><INPUT type="text" name="charac" size="10" tabindex="3" value="<%=charac%>"></B></TD>				
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
		
		<TR>
			<% if (mvxd.indexOf("1") >= 0){ %>
				<TD align="<%=labels_align%>"><%=lblThickMicron%></TD>
				<TD align="<%=input_align%>"><B><INPUT type="text" name="micron" size="10" tabindex="4" value="<%=micron%>"></B></TD>
			<% }else{ %>
				<INPUT type="hidden" name="micron">
			<% } %>
			<TD align="<%=labels_align%>"><%=lblThickGauge%></TD>
			<TD align="<%=input_align%>"><B><INPUT type="text" name="gauge" size="10" tabindex="5" value="<%=gauge%>"></B></TD>
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
		<TR>
			<% if (mvxd.indexOf("1") >= 0){ %>
				<TD align="<%=labels_align%>"><%=lblWidthMm%></TD>
				<TD align="<%=input_align%>"><B><INPUT type="text" name="widthMm" size="10" tabindex="6" value="<%=widthMm%>"></B></TD>
			<% }else{ %>
				<INPUT type="hidden" name="widthMm">
			<% } %>
			<TD align="<%=labels_align%>"><%=lblWidthInch%></TD>
			<TD align="<%=input_align%>"><B><INPUT type="text" name="widthInch" size="10" tabindex="7" value="<%=widthInch%>"></B></TD>
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
		<TR>
			<TD align="<%=labels_align%>"><%=lblC_F%></TD>
			<TD align="<%=input_align%>"><B><INPUT type="text" name="cf" size="10" tabindex="8" value="<%=cf%>"></B></TD>
			<TD>&nbsp;</TD>
			<TD>&nbsp;</TD>				
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
		<TR>
			<% if (mvxd.indexOf("1") >= 0){ %>
				<TD align="<%=labels_align%>"><%=lblLengthMtr%></TD>
				<TD align="<%=input_align%>"><B><INPUT type="text" name="lengthMtr" size="10" tabindex="9" value="<%=lengthMtr%>"></B></TD>
				
				<TD align="<%=labels_align%>"><%=lblLengthFt%></TD>
				<TD align="<%=input_align%>"><B><INPUT type="text" name="lengthFt" size="10" tabindex="10" value="<%=lengthFt%>"></B></TD>
			<% }else{ %>
				<TD align="<%=labels_align%>"><%=lblLengthFt%></TD>
				<TD align="<%=input_align%>"><B><INPUT type="text" name="lengthMtr" size="10" tabindex="9" value="<%=lengthMtr%>"></B></TD>
				<INPUT type="hidden" name="lengthFt">
			<% } %>
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
		<TR>
			<% if (mvxd.indexOf("1") >= 0){ %>
				<TD align="<%=labels_align%>"><%=lblWeightKg%></TD>
			<% }else{ %>
				<TD align="<%=labels_align%>"><%=lblWeightLbs%></TD>
			<% } %>
			<TD align="<%=input_align%>"><B><INPUT type="text" name="weightKg" size="10" tabindex="11" value="<%=weightKg%>"></B></TD>
			
			<TD align="<%=labels_align%>"><%=lblSugRoll%></TD>
			<TD align="<%=input_align%>"><select name="kind" tabindex="11">
									<option value="">
									<% if (kind.equals("02")){ %>
										<option value="02" selected>J</option>
									<% }else{ %>
										<option value="02">J</option>
									<% } %>
									<% if (kind.equals("03")){ %>
										<option value="03" selected>B</option>
									<% }else{ %>
										<option value="03">B</option>
									<% } %>
									<% if (kind.equals("05")){ 
										if (mvxd.indexOf("1") >= 0){ %>
											<option value="05" selected>F</option>
										<% }else{ %>
											<option value="05" selected>G</option>
										<% }
									 }else{ 
										if (mvxd.indexOf("1") >= 0){ %>
											<option value="05">F</option>
										<% }else{ %>
											<option value="05">G</option>
										<% }
									} %>
									
									<% if (mvxd.indexOf("1") < 0) {
										if (kind.equals("08")){ %>
											<option value="08" selected>S</option>
										<% }else{ %>
											<option value="08">S</option>
										<% }
									} %>
									
							  </select></TD>
		</TR>
		
	</TBODY>
</TABLE>
</TD></BR></Table>


<p>
<TABLE border=0>
	<TBODY align="center">
		<TR>
			<TD align="<%=labels_align%>"><%=lblRollNumber%></TD>
			<% if (mvxd.indexOf("1") >= 0){ %>
				<TD align="<%=input_align%>"><B><INPUT type="text" name="rollNumber" size="10" tabindex="12"></B></TD>
			<% }else{ %>
				<TD align="<%=input_align%>"><B><INPUT type="text" name="rollNumber" size="25" tabindex="12" onChange="parseRoll(this)"></B></TD>
			<% } %>
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
		
		<TR>
			<TD align="<%=labels_align%>"><%=lblQty%></TD>
			<TD align="<%=input_align%>"><B><INPUT type="text" name="qty" size="1" value="1" tabindex="13"></B></TD>
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
	</TBODY>
</TABLE>

<p>
<INPUT type="button" name="exit" value="<%=exitBtn%>" class="myButton"  onclick="window.location='nipuah-management.jsp'" tabindex="15">
&nbsp;&nbsp;&nbsp;
<INPUT type="button" name="go" value="<%=doBtn%>" class="myButton" onclick="printLabel()" tabindex="14">


<INPUT type="hidden" name="fatherHID">


</FORM>
</DIV>
</BODY>
</HTML>
