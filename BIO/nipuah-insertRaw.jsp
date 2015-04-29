<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@include file="nipuah-const.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@include file="../checkDateNEW.inc"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>

<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="javax.naming.InitialContext"%>
<%@ page import="javax.naming.NamingException"%>
<%@ page import="com.intentia.bifrost.ibrix.proxy.IRuntimeEnvironmentConfiguration"%>
<%@ page import="com.intentia.yggdrasil.ibrix.configuration_5_1.RuntimeEnvironmentConfiguration_5_1"%>
<%@ page import="com.intentia.iec.connection.IMovexConnectionFactory"%>
<%@ page import="com.intentia.iec.connection.IMovexConnection"%>
<%@ page import="com.intentia.iec.connection.IMovexApiResultset"%>
<%@ page import="com.intentia.iec.connection.IMovexCommand"%>
<%@ page import="com.intentia.iec.connection.ConnectorException"%>
<%! public static IMovexConnectionFactory factory;%>

<%

	IRuntimeEnvironmentConfiguration runtimeEnvironment=new RuntimeEnvironmentConfiguration_5_1();
	runtimeEnvironment.init(request);
	String backend = runtimeEnvironment.getMIConfiguration().getServer();
	String port = runtimeEnvironment.getMIConfiguration().getPort();
	String apiuser = runtimeEnvironment.getMIConfiguration().getUser();
	String apiuserpwd = runtimeEnvironment.getMIConfiguration().getPassword();
	String myMsg = null;
	String errMsg = null;
	
	//lookup connection factory
	if(factory == null) {
		try {
			final InitialContext ctx = new InitialContext();
			factory = (IMovexConnectionFactory) ctx.lookup("java:comp/env/eis/mvxcon");
			myMsg = "Initiate Factory";
		} catch (NamingException e) {
			e.printStackTrace();
		}
	}	
	
	IMovexConnection connection = null;
	IMovexApiResultset resultset = null;
	Map mvxInput = null;
	int currState=0;	
	
	mvxInput = new HashMap();
	mvxInput.put(IMovexConnection.TRANSACTION,"GetServerTime");
	
	String myTime="";
    String myDate="";

	try {
		connection = factory.getConnection("GENERAL","", apiuser, apiuserpwd, backend, Integer.parseInt(port));
		final IMovexCommand command = connection.getCommand(mvxInput);
		
		//execute API
		if (command != null) {
			connection.setMaxRecordsReturned(0); //all you got
			//connection.setDateFormat("YMD8", "-");
			resultset = connection.execute(command);
			
			//any errors
			if (!connection.isOk()) {
           		errMsg = connection.getLastMessage();  
        		out.println("=================================<BR>Error found MMS175:" + errMsg + "<BR>");
        		out.flush();
        		
        		%>
				<script language="javascript">
			
						alert('<%=errMsg.replaceAll("                    ", "")%>');
						window.close();	
						window.opener.enableGoBtn();
				</script>
				<%
       		}else{
       			currState=1;
       		}
			
            if(resultset!=null){
                Iterator it = resultset.iterator();
                int size = resultset.size();
                if(it.hasNext()){
                    Map row = (Map) it.next();
                    myTime=(String)row.get("TIME");
                    myDate=(String)row.get("DATE");
                }
            }
          }
	} catch (ConnectorException e) {
		e.printStackTrace();
	} finally {
		try {
			connection.close();
		} catch (Exception ex) {
			//do nothing
		}
	}
	connection=null;
	mvxInput=null;

	String comFrom = session.getAttribute("comFrom").toString(); 
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
</style>

<TITLE>nipuah-start.jsp</TITLE>
<SCRIPT language="javascript">

var MvxCompany = "<%=MvxCompany%>";
var comFrom = "<%=comFrom%>";

function returnToFirst(){
	if (comFrom == "1")
		window.location='nipuah-management.jsp';
	else
		window.location='nipuah-first.jsp';
}

function enableGoBtn(){
	document.myForm.go.disabled=false;
}

function onLoad(){
	var empStr = ",";
	
	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	
	RejReas_Collection.AddValue("cono", MvxCompany);
	RejReas_Collection.CreateCollection("MO_GetEmployees");//Run model
	
	for (var i = 0; i < RejReas_Collection.count; i++){
		var oStd=RejReas_Collection.Item(i);//row
		
		var emp = oStd.GetValue("PFOPTN");
		
		if (mvxd.indexOf("1") >= 0){
			if (emp.substr(0,1) == "E")
				empStr = empStr + emp + ",";
		}else{
			if (emp.substr(0,2) == "UE")
				empStr = empStr + emp + ",";
		}
	}
	
	document.myForm.empsHID.value = empStr;
	
	RejReas_Collection=null;
	
	document.myForm.orderNum.focus();
}

function IsNumeric(sText){
   var ValidChars = "0123456789";
   var IsNumber=true;
   var Char;

   for (i = 0; i < sText.length && IsNumber == true; i++){ 
      Char = sText.charAt(i); 
      if (ValidChars.indexOf(Char) == -1)
     	IsNumber = false;
   }
	
   return IsNumber;
}

function initLines(){
	for (i=1; i<=15;i++){
		eval("myLine" + i + ".style.display = 'none'");
	
		eval("document.myForm.raw" + i + ".value = ''");
		eval("document.myForm.rawName" + i + ".value = ''");
		eval("document.myForm.current" + i + ".value = ''");
		eval("document.myForm.other" + i + ".value = ''");
		eval("document.myForm.new" + i + ".value = ''");
		eval("document.myForm.spe4_" + i + ".value = ''");
		eval("document.myForm.spe5_" + i + ".value = ''");
		eval("document.myForm.silo" + i + ".value = ''");
	}	
}

//this function reveales a new line for one more field
//the visibility of the new line is set to visible.
function addLines(x){
	for (i=1; i<=x;i++){
		eval("myLine" + i + ".style.display = ''");
	}
}

function findRaw(num){
	document.myForm.go.disabled=false;
	
	var order = num.value;
		
	initLines();
	
	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	
	RejReas_Collection.AddValue("cono", MvxCompany);
	RejReas_Collection.AddValue("order", order);
	
	RejReas_Collection.CreateCollection("MO_GetRawOfOrderShort");//Run model
	
	if (RejReas_Collection.count==0){
		alert("<%=error_notExist%>");
		num.value = "";
		document.myForm.orderNum.focus();
	}else{
		numOfLines = RejReas_Collection.count;
		document.myForm.numOfLinesHID.value = numOfLines;
		
		addLines(numOfLines);
		var x="";
		var y="";
		var myArr = new Array();
		
		for (var i = 0; i < RejReas_Collection.count; i++){
			
			var oStd=RejReas_Collection.Item(i);//row
			
			k = i+1;
			
			eval("document.myForm.raw" + k + ".value = '" + oStd.GetValue("RAW") + "'");
			eval("document.myForm.rawName" + k + ".value = '" + oStd.GetValue("NAME") + "'");
			
			bio = order.charAt(0);
			
			if (bio < 3)
				tmp = oStd.GetValue("MMSPE4");
			else 
				tmp = oStd.GetValue("MMSPE5");
				
			if (tmp != ""){
				/*
				if (tmp.charAt(0) == "|"){
					myArr[0] = "";
					myArr[1] = tmp.substr(1);
				}else if (tmp.charAt(tmp.length) == "|"){
					myArr[0] = tmp.substr(0,tmp.length-1);
					myArr[1] = "";
				}else*/
					myArr = tmp.split("|");
				
				if (bio == 1 || bio == 3){
					x = myArr[0];
					y = myArr[1];
				}else{
					x = myArr[1];
					y = myArr[0];
				}	
			
				eval("document.myForm.current" + k + ".value = '" + x + "'");
				eval("document.myForm.other" + k + ".value = '" + y + "'");
			}
		}
	}
	
	RejReas_Collection=null;
	
	document.myForm.new1.focus();
}

function keepRaw(raw){
	document.myForm.go.disabled=false;
	
	myArr = raw.value.split("|");
	
	document.myForm.rawHID.value = myArr[0];
	document.myForm.rawNameHID.value = myArr[1];
}

function keepNew(x,i){
	newVal = x.value;
	otherVal = eval("document.myForm.other" + i + ".value");
	order = document.myForm.orderNum.value;
	bio = order.charAt(0);
	
	if (IsNumeric(newVal)){
		if (newVal<=12){
			eval("document.myForm.silo" + i + ".value = '1'");
			newVal = "Silo " + newVal;
		}else
			eval("document.myForm.silo" + i + ".value = '0'");
	}else
		eval("document.myForm.silo" + i + ".value = '0'");
	
	if (bio==1 || bio==3)
		newVal = newVal + "|" + otherVal;
	else
		newVal = otherVal + "|" + newVal;
	
	if (bio<3)
		eval("document.myForm.spe4_" + i + ".value = '" + newVal + "'");
	else
		eval("document.myForm.spe5_" + i + ".value = '" + newVal + "'");
}

function doTheJob(){
	document.myForm.go.disabled=true;
	
	if (allDataFull() && employeeExists() && checkDateAndTime()){	
		document.myForm.go.disabled=true;
		var WinParam="<%=WinParam%>";
		var w = window.open("blank.jsp","RepManWin",WinParam);
		//var w = window.open("blank.jsp","RepManWin");
		
		if (!<%=debug%>)
			w.blur();
			
		document.myForm.submit();
		//alert("OK");
	}
}//end function getInflationOpr()

function checkDateAndTime(){
	var myDate = document.myForm.date.value;
	var myTime = document.myForm.hour.value;

	myDate = saderDate(myDate);
	document.myForm.date.value = myDate;

	if (isValidDate(myDate)){
		myTime = saderTime(myTime);
		document.myForm.hour.value = myTime;
		
		if (isValidTime(myTime))
			return true;
		else{
			alert("<%=error_wrongTime%>");
			return false;
		}
	}else{
		alert("<%=error_wrongDate%>");
		return false;
	}
} //end function checkDateAndTime()

function allDataFull(){
	if (document.myForm.orderNum.value == ""){
		alert("<%=error_missingOrder%>");
		return false;
	}else if (! rawEntered()){
		return false;
	}else if (document.myForm.emp.value == ""){
		alert("<%=error_missingEmployee%>");
		return false;
	}else if (document.myForm.date.value == ""){
		alert("<%=error_missingDate%>");
		return false;
	}else if (document.myForm.hour.value == ""){
		alert("<%=error_missingHour%>");
		return false;
	}else
		return true;
}

function rawEntered(){
	numOfLines = document.myForm.numOfLinesHID.value;
	found = false;
	
	for (i=1; i<=numOfLines & ! found; i++){
		if (eval("document.myForm.new" + i + ".value != ''"))
			found = true;
	}
	
	if (! found){
		alert("<%=error_missingRaw%>");
		return false;
	}else
		return true;
}

function employeeExists(){
	var empStr = document.myForm.empsHID.value;
	var emp = "";
	
	if (mvxd.indexOf("1") >= 0)
		emp = ",E" + document.myForm.emp.value + ",";
	else
		emp = ",UE" + document.myForm.emp.value + ",";

	if (empStr.search(emp) >= 0)
		return true;
	else{
		alert("<%=error_employeeNotExists%>");
		return false;
	}
}//end function employeeExists()

function saderD(date){
	date.value = saderDate(date.value);
}

function saderT(time){
	time.value = saderTime(time.value);
}

</SCRIPT>
</HEAD>


<BODY dir=<%=page_dir%> onLoad='onLoad()'>
<%
int myYear = Integer.parseInt(myDate.substring(0,4)) - 1900;
int myMonth = Integer.parseInt(myDate.substring(4,6)) - 1;
int myDay = Integer.parseInt(myDate.substring(6,8));
int myHour = Integer.parseInt(myTime.substring(0,2));
int myMin = Integer.parseInt(myTime.substring(2,4));
int mySec = Integer.parseInt(myTime.substring(4,6));

Calendar cal = Calendar.getInstance();
cal.set(myYear,myMonth,myDay,myHour,myMin,mySec);

String currentDateStr1 = DateFormat.getDateInstance(DateFormat.SHORT).format(cal.getTime());

String currentDateStr = "";
if (mvxd.indexOf("1") >= 0)
	currentDateStr = currentDateStr1.substring(0,2) + currentDateStr1.substring(3,5) + currentDateStr1.substring(6,8);
else
	currentDateStr = currentDateStr1.substring(3,5) + currentDateStr1.substring(0,2) + currentDateStr1.substring(6,8);
	
String currentTimeStr1 = DateFormat.getTimeInstance(DateFormat.SHORT).format(cal.getTime());
String currentTimeStr = currentTimeStr1.substring(0,2) + currentTimeStr1.substring(3,5);
%>
<P align="center"><B><FONT size="+2"><%=title_insertRaw%></FONT></B></P>
<P><BR>
<BR>
</P>
<DIV align="center">
<FORM name = "myForm" action="nipuah-doInsertRaw.jsp" target="RepManWin" method="POST">
<TABLE border="0">
	<TBODY align="center">
		<TR>
			<TD align="<%=labels_align%>"><%=moNumber%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="orderNum" size="10" tabindex="1"
				onChange="findRaw(this)"></TD>
		</TR>
	</TBODY>
</TABLE>

<% // this loop creates 15 "div", only 3 are visible in the begining.
// before the first one there are headers.
int i = 1;

for (i=1; i<=15;i++){
	if (i < numOfLines+1){ %>
		<div id='myLine<%=i%>' align=right style='display:on'>
	<% }else{ %>
		<div id='myLine<%=i%>' align=right style='display:none'>
	<% } %>
	<center>
	<table border="0" id="tbl<%=i%>">
	<% if (i == 1){ %>
		<tr bgColor="#E5E5E5">
			<th><%=lblRaw%></th>
			<th><%=lblRawName%></th>	
			<th><%=lblSiloFrom%></th>		
			<th><%=lblSiloTo%></th>
		</tr>
	<% } %>
	  
	<tr>
		<TD align="<%=input_align%>"><INPUT type="text" name="raw<%=i%>" value="" size=10  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="rawName<%=i%>" value="" size=30  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="current<%=i%>" value="" size=20  readonly class='clReadonly'>
				<INPUT type="hidden" name="other<%=i%>"></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="new<%=i%>" value="" size=20  maxlength="12" 
			onChange="keepNew(this,<%=i%>)" tabindex="1*<%=i%>+1">
				<INPUT type="hidden" name="spe4_<%=i%>">
				<INPUT type="hidden" name="spe5_<%=i%>">
				<INPUT type="hidden" name="silo<%=i%>"></td>
	</tr>	
	</TABLE>
	</div>
<% } %>	
		
<TABLE border="0">
	<TBODY align="center">
		
		<tr>
			<td align="<%=labels_align%>"><%=lblEmp%></td>
			<td align="<%=input_align%>"><input name="emp" type="text"  size="10" tabindex="16"
				onChange="document.myForm.go.disabled=false;"></td>
		</tr>
		<TR>
			<TD align="<%=labels_align%>"><%=reportDate%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="date" 
					value='<%=currentDateStr%>' size="10"></TD>
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
		<TR>
			<TD align="<%=labels_align%>"><%=reportHour%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="hour" 
					value='<%=currentTimeStr%>' size="10"></TD>
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
		  
	</TBODY>
</TABLE>
<p>
<INPUT type="button" name="exit" value="<%=exitBtn%>" class="myButton"  onclick="returnToFirst()" tabindex="18">
&nbsp;&nbsp;&nbsp;
<INPUT type="button" name="go" value="<%=doBtn%>" class="myButton" onclick="doTheJob()" tabindex="17">

<INPUT type="hidden" name="workSeqHid">
<INPUT type="hidden" name="orderHID">
<INPUT type="hidden" name="empsHID">
<INPUT type="hidden" name="numOfLinesHID">
</FORM>
</DIV>
</BODY>
</HTML>
