<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@include file="nipuah-const.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@include file="../checkDate.inc"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.Time"%>
<%@page import="java.text.DateFormat"%>

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

<TITLE>nipuah-report.jsp</TITLE>
<SCRIPT language="javascript">

var MvxCompany = "<%=MvxCompany%>";


function returnToFirst(){
	
	window.location='nipuah-first.jsp';
}

function enableGoBtn(){
	document.myForm.go.disabled=false;
}

function onLoad(){
	document.myForm.txtMO.focus();
	
	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	
	RejReas_Collection.AddValue("cono", MvxCompany);
	RejReas_Collection.CreateCollection("MO_Rer_GetBioProdNotes");//Run model
	
	for (var i = 0; i < RejReas_Collection.count; i++){
		var oStd=RejReas_Collection.Item(i);//row
			
		var opt, opt2;
		opt = document.createElement("<option>");
		opt.value = oStd.GetValue("PFOPTN");
		opt.text  = oStd.GetValue("PFTX30");
		document.myForm.note1.add(opt);
		opt2 = document.createElement("<option>");
		opt2.value = oStd.GetValue("PFOPTN");
		opt2.text  = oStd.GetValue("PFTX30");
		document.myForm.note2.add(opt2);
	}//end for
	
	var empStr = ",";
	RejReas_Collection.AddValue("cono", MvxCompany);
	RejReas_Collection.CreateCollection("MO_GetEmployees");//Run model
	
	for (var i = 0; i < RejReas_Collection.count; i++){
		var oStd=RejReas_Collection.Item(i);//row
		
		empStr = empStr + oStd.GetValue("PFOPTN") + ",";
	}
	
	document.myForm.empsHID.value = empStr;
	
	RejReas_Collection=null;
}

function findMoData(){
	var order = document.myForm.txtMO.value;
	order = order.toUpperCase();
	document.myForm.txtMO.value = order;
	
	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	//set parameters
	RejReas_Collection.AddValue("cono", MvxCompany);
	RejReas_Collection.AddValue("Reference_Order", order);
	RejReas_Collection.CreateCollection("MO_Rep_GetMoAttributes");//Run model
	
	if (RejReas_Collection.count == 0){//record not found !!
		alert("<%=error_notExist%>");
		document.myForm.go.disabled=true;
	}else if (RejReas_Collection.count > 1){
		alert("<%=error_tooMuch%>");
		document.myForm.go.disabled=true;
	}else{
		var oStd=RejReas_Collection.Item(0);//row
		var myNum;
		var myType;
		var micron;
		
		var status = oStd.GetValue("VOWOST");
		
		if (status == "60"){
			document.myForm.go.disabled=false;
			document.myForm.workSeqHid.value = oStd.GetValue("VHWOSQ");
			myNum = oStd.GetValue("VHMAQA");
			myType = oStd.GetValue("MMITGR");
			micron = oStd.GetValue("MMCFI3");
			
			document.myForm.txtType.value = myType.substring(1,4)
			document.myForm.txtOvi.value = micron;
			document.myForm.densityHid.value = oStd.GetValue("MMDIM1");
			document.myForm.fromWidthHid.value = oStd.GetValue("AHANUF");
			document.myForm.toWidthHid.value = oStd.GetValue("AHANUT");
			document.myForm.itnoHid.value = oStd.GetValue("VHITNO");
			document.myForm.whloHid.value = oStd.GetValue("VHWHLO");
			
			document.myForm.printTypeHID.value = findTeur("ITGR", myType, "description");
			document.myForm.micronHID.value = findTeur("CFI3", micron, "description");
			
			aaa = new Number(oStd.GetValue("AHANUF"));
			bbb = new Number(oStd.GetValue("AHANUT"));
			document.myForm.txtRangeWidth.value = aaa.toFixed(0) + "-" + bbb.toFixed(0)
			
			RejReas_Collection=null;
			getLastLot();
		}else{
			document.myForm.go.disabled=true;
			
			if (status == "40")
				alert("<%=error_orderNotStarted%>");
			else if (status == "70")
				alert("<%=error_orderStoped%>");
			else if (status == "90")
				alert("<%=error_orderFinished%>");
			
		}
	}
	RejReas_Collection=null;	
}

function getLastLot(){
	var workSeq;
	
	var qtyOfRools;
	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	//set parameters
	RejReas_Collection.AddValue("cono", MvxCompany);
	
	RejReas_Collection.AddValue("bano", "'" + document.myForm.txtMO.value + "%'");
	RejReas_Collection.CreateCollection("MO_Rep_GetLastLotNumber");//Run model
	
	if (RejReas_Collection.count == 0){
		document.myForm.rollNumber1.value = document.myForm.txtMO.value + "001";
		document.myForm.rollNumber2.value = document.myForm.txtMO.value + "002";
	}
	else{
		var oStd=RejReas_Collection.Item(0);//row
		
		document.myForm.rollNumber1.value = createOddRoll(oStd.GetValue("MLBANO").substring(4,7), 1);
		document.myForm.rollNumber2.value = createOddRoll(oStd.GetValue("MLBANO").substring(4,7), 2);
	}
	
	document.myForm.roll1Hid.value = document.myForm.rollNumber1.value
	document.myForm.roll2Hid.value = document.myForm.rollNumber2.value
}

function createOddRoll(myNum, k){
	var next;
	var order = document.myForm.txtMO.value;
	
	next = (myNum * 1) + k;
	
	switch (next.toString().length){
		case (1):
			return order + "00" + next;
			break;
		case (2):
			return order + "0" + next;
		default:
			return order + next;
	}
}

function sendData(){
	document.myForm.go.disabled=true;
	if (allDataFull() && widthIsInRange() && lengthAndWeightOk() && 
		checkDatesAndTimes(1) && checkDatesAndTimes(2) && employeeExists()){

		//document.myForm.go.disabled=true;
		var WinParam="<%=WinParam%>";
		var w = window.open("blank.jsp","RepManWin",WinParam);
		//var w = window.open("blank.jsp","RepManWin");
		
		if (!<%=debug%>)
			w.blur();
				
		document.myForm.submit();
		//alert("OK")
	}else
		document.myForm.go.disabled=false;
}

function enableDo(){
	document.myForm.go.disabled=false;
}

function employeeExists(){
	var empStr = document.myForm.empsHID.value;
	var emp = ",E" + document.myForm.emp1.value + ",";

	if (empStr.search(emp) >= 0){
		var emp = ",E" + document.myForm.emp2.value + ",";
		
		if (empStr.search(emp) >= 0)
			return true;
		else{
			alert("<%=error_employeeNotExists%>");
			return false;
		}
	}else{
		alert("<%=error_employeeNotExists%>");
		return false;
	}
}//end function employeeExists()

function checkDatesAndTimes(i){
	var diffDays = <%=diffDays%>;
	var toDay = document.myForm.dateHid.value;
	var myDate = eval("document.myForm.date" + i + ".value");
	var myTime = eval("document.myForm.hour" + i +".value");

	myDate = saderDate(myDate);

	if (isValidDate(myDate)){
		myTime = saderTime(myTime);
		
		if (isValidTime(myTime)){
			toDay = new Date("20"+toDay.substring(6,8),toDay.substring(3,5),toDay.substring(0,2),0,0,0);
			myDate = new Date("20"+myDate.substring(6,8),myDate.substring(3,5),myDate.substring(0,2),0,0,0);
			
			difference = toDay.getTime() - myDate.getTime();
			difference = Math.floor(difference / (1000*60*60*24));
			
			if (difference < 0 || difference - diffDays > 0){
				if (1=1)
					alert("<%=error_oddDateNotInRange%>");
				else
					alert("<%=error_evenDateNotInRange%>");
				return false;
			}else
				return true;
		}else{
			if (i=1)
				alert("<%=error_wrongOddTime%>");
			else
				alert("<%=error_wrongEvenTime%>");
			return false;
		}
	}else{
		if (i=1)
			alert("<%=error_wrongOddDate%>");
		else
			alert("<%=error_wrongEvenDate%>");
		return false;
	}
}

function widthIsInRange(){
	var width1 = document.myForm.width1.value;
	var width2 = document.myForm.width2.value;
	var fromWidth = document.myForm.fromWidthHid.value;
	var toWidth = document.myForm.toWidthHid.value;
	var doNext = 0;
	var toDay = new Date();
	var days = toDay.getDate();
	if (days > 9){
		days = days + "";
		days = days.substring(0,1) * 1 + days.substring(1,2) * 1;
	}
	
	var month = toDay.getMonth() + 1;
	if (month > 9){
		month = month + "";
		month = month.substring(0,1) * 1 + month.substring(1,2) * 1;
	}
	
	var passNum = days * 1 + month * 1;
	var pass = "bio" + passNum;

	if ((width1 - fromWidth < 0) || (width1 - toWidth > 0)){
		passEntered1 = prompt("<%=error_OddWidthNotOk%>","");
		if (passEntered1.toLowerCase() != pass)
			return false;
		else
			doNext = 1;
	}
	else
		doNext = 1;
	
	if (doNext == 1){
		if ((width2 - fromWidth < 0) || (width2 > toWidth > 0)){
			passEntered2 = prompt("<%=error_EvenWidthNotOk%>","");
			if (passEntered2.toLowerCase() != pass)
				return false;
			else
				return true;
		}
		else
			return true;
	}
	//return true;
}

function allDataFull(){
	if (document.myForm.roll1Hid.value == ""){
		alert("<%=error_missingRoll%>");
		return false;
	}else if (document.myForm.width1.value == ""){
		alert("<%=error_missingWidth1%>");
		return false;
	}else if (document.myForm.width2.value == ""){
		alert("<%=error_missingWidth2%>");
		return false;
	}else if (document.myForm.length1.value == ""){
		alert("<%=error_missingLength1%>");
		return false;
	}else if (document.myForm.length2.value == ""){
		alert("<%=error_missingLength2%>");
		return false;
	}else if (document.myForm.weight1.value == ""){
		alert("<%=error_missingWeight1%>");
		return false;
	}else if (document.myForm.weight2.value == ""){
		alert("<%=error_missingWeight2%>");
		return false;
	}else if (document.myForm.emp1.value == ""){
		alert("<%=error_missingEmp1%>");
		return false;
	}else if (document.myForm.emp2.value == ""){
		alert("<%=error_missingEmp2%>");
		return false;
	}else if (document.myForm.loc1.value == ""){
		alert("<%=error_missingLoc1%>");
		return false;
	}else if (document.myForm.loc2.value == ""){
		alert("<%=error_missingLoc2%>");
		return false;
	}else if (document.myForm.date1.value == ""){
		alert("<%=error_missingDate1%>");
		return false;
	}else if (document.myForm.date2.value == ""){
		alert("<%=error_missingDate2%>");
		return false;
	}else if (document.myForm.hour1.value == ""){
		alert("<%=error_missingHour1%>");
		return false;
	}else if (document.myForm.hour2.value == ""){
		alert("<%=error_missingHour2%>");
		return false;
	}else
		return true;

}

function lengthAndWeightOk(){

	var deviationPermitted = <%=deviation%>;
	var length = document.myForm.length1.value;
	var weight = document.myForm.weight1.value;
	var width = document.myForm.width1.value;
	var density = document.myForm.densityHid.value;
	var ovi = document.myForm.txtOvi.value;
	
	var computedWeight = (length * width * ovi * density) / 1000000;
	var deviation = Math.abs(computedWeight - weight) / weight;
	
	aaa = new Number(computedWeight);
	
	if (deviation > deviationPermitted){
		alert("<%=error_oddWeightNotOk%>" + " - " + aaa.toFixed(0));
		return false;
	}
	else{
		var length = document.myForm.length2.value;
		var weight = document.myForm.weight2.value;
		var width = document.myForm.width2.value;
		
		var computedWeight = (length * width * ovi * density) / 1000000;
		var deviation = Math.abs(computedWeight - weight) / weight;
		
		if (deviation > deviationPermitted){
			alert("<%=error_evenWeightNotOk%>" + " - " + aaa.toFixed(0));
			return false;
		}
		else
			return true;
	}
}

function findTeur(field, key, sug){
	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	
	//set parameters
	RejReas_Collection.AddValue("cono", MvxCompany);
	RejReas_Collection.AddValue("fieldName", field);
	RejReas_Collection.AddValue("key", key);
		
	RejReas_Collection.CreateCollection("MO_GetDescription");//Run model
	
	if (RejReas_Collection.count > 0){
		var oStd=RejReas_Collection.Item(0);//row
		
		if(sug == "description")
			return oStd.GetValue("CTTX40");	//description
		else
			return oStd.GetValue("CTTX15"); //name
	}else
		return "";
}

function saderD(date){
	date.value = saderDate(date.value);
}

function saderT(time){
	time.value = saderTime(time.value);
}


</SCRIPT>
</HEAD>


<BODY dir=<%=page_dir%> onload="onLoad()">
<%
Date currentDate = new Date(System.currentTimeMillis());

String currentDateStr = DateFormat.getDateInstance(DateFormat.SHORT).format(currentDate);//currentDate.toString();
String currentTimeStr = new Time(System.currentTimeMillis()).toString();
%>

<P align="center"><B><FONT size="+2"><%=title_report%></FONT></B></P>
<P><BR>
<BR>

<form name="myForm" action="doNisayon.jsp" method=post"" target="RepManWin">

<div align="center"><table border="0"  width="60%">
  <tr>
     <td align=<%=labels_align%>><%=lblOrder%></td>
     <td align=<%=input_align%>><input type="text" name="txtMO" value="" border="0" size="5" tabindex="1" 
     onChange="findMoData()"> </td>
     <td>&nbsp;&nbsp;&nbsp;</td>
     <td align=<%=labels_align%>><%=lblType%></td>
	 <td align=<%=input_align%>><input type="text" name="txtType" value="" border="0"  readonly class='readonly' size="5"> </td>
     <td>&nbsp;&nbsp;&nbsp;</td>
     <td align=<%=labels_align%>><%=lblOvi%></td>
	 <td align=<%=input_align%>><input type="text" name="txtOvi" value="" border="0"  readonly class='readonly' size="5"> </td>
	 <td>&nbsp;&nbsp;&nbsp;</td>
     <td align=<%=labels_align%>><%=lblRangeWidth%></td>
	 <td align=<%=input_align%>><input type="text" name="txtRangeWidth" value="" border="0"  readonly class='readonly' size="5"> </td>
  </tr>
</table></div>
<br /><br />


<div align="center">
<table width="60%"  border="0" cellpadding="0" cellspacing="0" valign="top">
<tr>
<td><table border="0" cellpadding="0" valign="top">
<tr>
<th align="center" colspan="2"><%=lblOddRoll%></th>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblRollNumber%></td>
	<td align="<%=input_align%>"><input name="rollNumber1" type="text" readonly class='readonly'
				style="font-weight:bolder;color:blue"></td>
</tr> 
<tr>
	<td align="<%=labels_align%>"><%=lblLength%></td>
	<td align="<%=input_align%>"><input name="length1" type="text" tabindex="2"
			onChange="document.myForm.length2.value=document.myForm.length1.value;enableDo()"></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblWidth%></td>
	<td align="<%=input_align%>"><input name="width1" type="text" tabindex="3"
			onChange="document.myForm.width2.value=document.myForm.width1.value;enableDo()"></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblWeight%></td>
	<td align="<%=input_align%>"><input name="weight1" type="text" tabindex="4"
			onChange="document.myForm.weight2.value=document.myForm.weight1.value;enableDo()"></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblEmp%></td>
	<td align="<%=input_align%>"><input name="emp1" type="text" tabindex="5"
			onChange="document.myForm.emp2.value=document.myForm.emp1.value;enableDo()"></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblLocation%></td>
	<td align="<%=input_align%>"><input name="loc1" type="text" tabindex="6"
			onChange="document.myForm.loc2.value=document.myForm.loc1.value;enableDo()"></td>
</tr>
	<tr>
	<td align="<%=labels_align%>"><%=lblNote%></td>
	<td align="<%=input_align%>"><select name="note1" tabindex="7"
			onChange="document.myForm.note2.value=document.myForm.note1.value;enableDo()">
					 	<option></option>
					 </select></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblDate%></td>
	<td align="<%=input_align%>"><input name="date1" type="text" tabindex="8" value="<%=currentDateStr%>"
			onChange='saderD(this);document.myForm.date2.value=document.myForm.date1.value;document.myForm.hour1.value="";
			document.myForm.hour2.value="";enableDo()'></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblHour%></td>
	<td align="<%=input_align%>"><input name="hour1" type="text" tabindex="9" value="<%=currentTimeStr%>"
			onChange="saderT(this);document.myForm.hour2.value=document.myForm.hour1.value;enableDo()">
	</td>
</tr>
</table></td>


</td>
<td><table border="0" cellpadding="0" valign="top">
<tr>
<th align="center" colspan="2">גליל זוגי</th>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblRollNumber%></td>
	<td align="<%=input_align%>"><input name="rollNumber2" type="text" readonly class='readonly' 
				style="font-weight:bolder;color:blue"></td>
</tr> 
<tr>
	<td align="<%=labels_align%>"><%=lblLength%></td>
	<td align="<%=input_align%>"><input name="length2" type="text" tabindex="10" onChange="enableDo()"></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblWidth%></td>
	<td align="<%=input_align%>"><input name="width2" type="text" tabindex="11" onChange="enableDo()"></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblWeight%></td>
	<td align="<%=input_align%>"><input name="weight2" type="text" tabindex="12" onChange="enableDo()"></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblEmp%></td>
	<td align="<%=input_align%>"><input name="emp2" type="text" tabindex="13" onChange="enableDo()"></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblLocation%></td>
	<td align="<%=input_align%>"><input name="loc2" type="text" tabindex="14" onChange="enableDo()"></td>
</tr>
	<tr>
	<td align="<%=labels_align%>"><%=lblNote%></td>
	<td align="<%=input_align%>"><select name="note2" tabindex="15" onChange="enableDo()">
					 	<option></option>
					 </select></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblDate%></td>
	<td align="<%=input_align%>"><input name="date2" type="text" tabindex="16" value="<%=currentDateStr%>"
			onChange='saderD(this);document.myForm.hour2.value="";enableDo()'></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblHour%></td>
	<td align="<%=input_align%>"><input name="hour2" type="text" tabindex="17" value="<%=currentTimeStr%>"
			onChange='saderT(this);enableDo()'>
	</td>
</tr>
</table></td>


</td>
</tr>
</table>
</div>
<br />
<div align="center"><%=lblPrint%><input type="checkbox" name="withLabels" value="yes" tabindex="18">
<p>
<INPUT type="button" name="exit" value="<%=exitBtn%>" class="myButton"  onclick="window.location='nipuah-first.jsp'" tabindex="20">
&nbsp;&nbsp;&nbsp;
<INPUT type="button" name="go" value="<%=doBtn%>" class="myButton"  onclick="sendData()" tabindex="19">
<INPUT type="hidden" name="workSeqHid">
<INPUT type="hidden" name="densityHid">
<INPUT type="hidden" name="fromWidthHid">
<INPUT type="hidden" name="toWidthHid">
<INPUT type="hidden" name="roll1Hid">
<INPUT type="hidden" name="roll2Hid">
<INPUT type="hidden" name="itnoHid">
<INPUT type="hidden" name="whloHid">
<INPUT type="hidden" name="dateHid" value="<%=currentDateStr%>">
<INPUT type="hidden" name="timeHid" value="<%=currentTimeStr%>">
<INPUT type="hidden" name="empsHID">
<INPUT type="hidden" name="printTypeHID">
<INPUT type="hidden" name="micronHID">

</form>



</body>
</html>

