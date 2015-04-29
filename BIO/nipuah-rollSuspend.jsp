<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@include file="nipuah-const.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@include file="../checkDateNEW.inc"%>
<HTML>
<HEAD>


<META http-equiv="Content-Type" content="text/html; charset=UTF-8"">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css";>


<LINK href="theme/Master.css" rel="stylesheet" type="text/css">

<style type="text/css">
input.myButton {width:150}
</style>

<TITLE>nipuah-rollSuspend.jsp</TITLE>
<SCRIPT language="javascript">

var MvxCompany = "<%=MvxCompany%>";

function onLoad(){
	document.myForm.rollNumber.focus();
	
}

function getData(){

	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	
	var roll = document.myForm.rollNumber.value;
	
	//cheks how many already packed - if all - alert
	RejReas_Collection.AddValue("cono", MvxCompany);
	RejReas_Collection.AddValue("roll", roll);
	RejReas_Collection.CreateCollection("MO_GetRollStatus");//Run model

	if (RejReas_Collection.count>0){
		var oStd=RejReas_Collection.Item(0);//row
		
		var item = oStd.GetValue("ITEM");
		var sstatus = oStd.GetValue("STATUS");
		
		document.myForm.item.value = item;
		document.myForm.status.value = sstatus;
		document.myForm.statusHID.value = sstatus;
		
		if (sstatus == "2"){
			sus.style.display = '';
			sus2.style.display = '';
		}else{
			sus.style.display = 'none';
			sus2.style.display = 'none';
		}
		
		RejReas_Collection.AddValue("cono", MvxCompany);
		RejReas_Collection.CreateCollection("MO_GetSuspendedCauses");//Run model
		
		for (var i = 0; i < RejReas_Collection.count; i++){
			var oStd=RejReas_Collection.Item(i);//row
			
			vvalue = oStd.GetValue("VALUE");
			text = oStd.GetValue("TEXT");
			doIt = false;
			
			if (mvxd.indexOf("1") >= 0){
				if (vvalue.charAt(0) != 'U')
					doIt = true;
			}else{
				if (vvalue.charAt(0) == 'U')
					doIt = true;
			}
			
			if (doIt){
				var opt;
				opt = document.createElement("<option>");
				opt.value = vvalue + "|" + text;
				opt.text  = text;
				document.myForm.cause.add(opt);
			}
			
		}
			
	}else{		// roll doesn't exists
		alert("<%=error_rollNotExists%>");
		document.myForm.go.disabled=true;
		
		return false;
	}
}

function keepCause(cause){
	myArr = cause.value.split("|");
	
	document.myForm.causeKeyHID.value = myArr[0];
	document.myForm.causeTextHID.value = myArr[1];
}

function doSuspend(){
	document.myForm.go.disabled=true;
	if (statusChanged() && allDataFull()){
		//document.myForm.go.disabled=true;
		var WinParam="<%=WinParam%>";
		var w = window.open("blank.jsp","RepManWin");
		//var w = window.open("blank.jsp","RepManWin",WinParam);
		
		if (!<%=debug%>)
			w.blur();
				
		document.myForm.submit();
		//alert("OK");
	}else
		document.myForm.go.disabled=false;
}

function allDataFull(){
	if (document.myForm.rollNumber.value == ""){
		alert("<%=error_missingOneRoll%>");
		return false;
	}else if (document.myForm.status.value == ""){
		alert("<%=error_statusMissing%>");
		return false;
	}else
		return true;
}

function statusChanged(){
	if (document.myForm.status.value == document.myForm.statusHID.value){
		alert("<%=error_statusNotChanged%>");
		return false;
	}else
		return true;
}

function enableGoBtn(){
	document.myForm.go.disabled=false;
}

function returnToFirst(){	
	window.location='nipuah-first.jsp';
}


</SCRIPT>
</HEAD>


<BODY dir=<%=page_dir%> onload="onLoad();">
<!--  oncontextmenu="return false" -->

<P align="center"><B><FONT size="+2"><%=title_rollSuspend%></FONT></B></P>
<P>
</P>
<DIV align="center">
<FORM name = "myForm" action="nipuah-doRollSuspend.jsp" target="RepManWin" method="POST">

<p>&nbsp;</P>
<TABLE border="0">
	<TBODY align="center">
		
		<TR>
			<TD align="<%=labels_align%>"><%=lblRollNumber%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="rollNumber" size="15" tabindex="1"
				onchange='getData()'></TD>		
		</TR>
		
		<TR>
			<TD align="<%=labels_align%>"><%=lblItem%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="item" size="15" readonly></TD>		
		</TR>
		
		<TR>
			<TD align="<%=labels_align%>"><%=lblStatus%></TD>
			<TD align="<%=input_align%>"><select name="status" tabindex="2">
					<option></option>
					<option value="2">2</option>
					<option value="3">3</option>
			</select></TD>
		</TR>
		<tr id='sus' style='display:none'>
			<TD align="<%=labels_align%>"><%=lblCause%></TD>
			<TD align="<%=input_align%>"><select name="cause" tabindex="3" onchange="keepCause(this)">
					<option></option>
			</select></TD>
		</tr>
		<TR id='sus2' style='display:none'>
			<TD align="<%=labels_align%>"><%=lblNote%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="note" size="20" tabindex="4" maxlength="20"></TD>		
		</TR>
	</TBODY>
</TABLE>


	

<p>
<INPUT type="button" name="exit" value="<%=exitBtn%>" class="myButton"  onclick="window.location='nipuah-first.jsp'" tabindex="4">
&nbsp;&nbsp;&nbsp;
<INPUT type="button" name="go" value="<%=doBtn%>" class="myButton" onclick="doSuspend()" tabindex="3">


<INPUT type="hidden" name="statusHID">
<INPUT type="hidden" name="causeKeyHID">
<INPUT type="hidden" name="causeTextHID">

</FORM>
</DIV>
</BODY>
</HTML>

