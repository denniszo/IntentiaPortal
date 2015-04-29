<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@include file="nipuah-const.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@include file="../checkDateNEW.inc"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Time"%>
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
%>

<%
String comFrom = session.getAttribute("comFrom2").toString(); 
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

<TITLE>slitter-recycleReporting.jsp</TITLE>
<SCRIPT language="javascript">

var MvxCompany = "<%=MvxCompany%>";
var comFrom = "<%=comFrom%>";

function onLoad(){
	var numOfLines = 0;
	
	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	
	//set parameters
	RejReas_Collection.AddValue("cono", MvxCompany);
	
	if (mvxd.indexOf("1") >= 0)
		RejReas_Collection.CreateCollection("MO_GetRecycleItemsIS");//Run model
	else
		RejReas_Collection.CreateCollection("MO_GetRecycleItemsUS");//Run model
		
	numOfLines = RejReas_Collection.count;
	document.myForm.numOfLinesHID.value = numOfLines;
	
	addLines(numOfLines);
		
	for (var i = 0; i < RejReas_Collection.count; i++){
		var oStd=RejReas_Collection.Item(i);//row
			
		parit = oStd.GetValue("ITEM");
		desc = oStd.GetValue("HEB_DESC");
		descHid = oStd.GetValue("US_DESC");
		
		k = i + 1;
		eval("document.myForm.item" + k + ".value = '" + parit + "'");
		eval("document.myForm.description" + k + ".value = '" + desc + "'");
		eval("document.myForm.descHID" + k + ".value = '" + descHid + "'");
		
	}//end for
	
	var empStr = document.myForm.empsHID.value;
		
	if (empStr == ""){
		empStr = ",";
		RejReas_Collection.AddValue("cono", MvxCompany);
		
		if (mvxd.indexOf("1") >= 0)
			RejReas_Collection.CreateCollection("MO_GetShihulEmployees");//Run model
		else
			RejReas_Collection.CreateCollection("MO_GetShihulEmployeesUS");//Run model
		
		for (var i = 0; i < RejReas_Collection.count; i++){
			var oStd=RejReas_Collection.Item(i);//row
			
			empStr = empStr + oStd.GetValue("EAEMNO") + ",";
		}
		
		document.myForm.empsHID.value = empStr;	
	}
	
	RejReas_Collection=null;
	
	document.myForm.qty.focus();
}

// this function reveales a new line for one more field
// the visibility of the new line is set to visible.
function addLines(x){
	for (i=1; i<=x;i++){
		eval("myLine" + i + ".style.display = ''");
	}
}

function initLines(){
	for (i=1; i<=100;i++){
		eval("myLine" + i + ".style.display = 'none'");
	
		eval("document.myForm.item" + i + ".value = ''");
		eval("document.myForm.description" + i + ".value = ''");
		eval("document.myForm.descHID" + i + ".value = ''");		
	}	
	
	document.myForm.numOfLinesHID.value = '';
}

function returnToFirst(){	
	if (comFrom == "2")
		window.location='../Slitter/slitter-first.jsp';
	else
		window.location='nipuah-first.jsp';
}

function enableGoBtn(){
	document.myForm.go.disabled=false;
}


function recordRecycle(){
	document.myForm.go.disabled=true;
	if (allDataFull() && employeeExists() && checkDateAndTime()){
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
}//end function loadRoll()


function checkDateAndTime(){
	var myDate = document.myForm.date.value;
	
	myDate = saderDate(myDate);
	document.myForm.date.value = myDate;

	if (isValidDate(myDate))
		return true;
	else{
		alert("<%=error_wrongDate%>");
		return false;
	}
} //end function checkDateAndTime()

function allDataFull(){
	if (document.myForm.checked.value == "0"){
		alert("<%=error_missingHomer%>");
		return false;
	}else if (document.myForm.qty.value == ""){
		alert("<%=error_missingQuantity%>");
		return false;
	}else if (document.myForm.date.value == ""){
		alert("<%=error_missingDate%>");
		return false;
	}else if (document.myForm.employee.value == ""){
		alert("<%=error_missingEmployee%>");
		return false;
	}else
		return true;
}

function employeeExists(){
	var empStr = document.myForm.empsHID.value;
	var emp = "," + document.myForm.employee.value + ",";
	
	if (empStr.search(emp) >= 0)
		return true;
	else{
		alert("<%=error_employeeNotExists%>");
		return false;
	}
}//end function employeeExists()

function checkQty(qty){
	if (mvxd.indexOf("1") >= 0)
		max = 1000;
	else
		max = 3000;
		
	if (qty.value > max){
		alert("<%=error_tooMuchMoreThan1000%>");
		qty.value = "";
	}else
		document.myForm.employee.focus();
}

function saderD(date){
	date.value = saderDate(date.value);
}

function saderT(time){
	time.value = saderTime(time.value);
}
</SCRIPT>
</HEAD>


<BODY dir=<%=page_dir%> onload="onLoad()" oncontextmenu="return false">
<%
int myYear = Integer.parseInt(myDate.substring(0,4)) - 1900;
int myMonth = Integer.parseInt(myDate.substring(4,6)) - 1;
int myDay = Integer.parseInt(myDate.substring(6,8));
int myHour = Integer.parseInt(myTime.substring(0,2));
int myMin = Integer.parseInt(myTime.substring(2,4));
int mySec = Integer.parseInt(myTime.substring(4,6));

Date currentDate = new Date(myYear,myMonth,myDay,myHour,myMin,mySec);

String currentDateStr1 = DateFormat.getDateInstance(DateFormat.SHORT).format(currentDate);//currentDate.toString();

String currentDateStr = "";
if (mvxd.indexOf("1") >= 0)
	currentDateStr = currentDateStr1.substring(0,2) + currentDateStr1.substring(3,5) + currentDateStr1.substring(6,8);
else
	currentDateStr = currentDateStr1.substring(3,5) + currentDateStr1.substring(0,2) + currentDateStr1.substring(6,8);
	
String currentTimeStr1 = new Time(myHour,myMin,mySec).toString();
String currentTimeStr = currentTimeStr1.substring(0,2) + currentTimeStr1.substring(3,5);
%>
<P align="center"><B><FONT size="+2"><%=title_recycleReport%></FONT></B></P>
<P><BR>
<BR>
</P>
<DIV align="center">
<FORM name = "myForm" action="nipuah-doRecycleReport.jsp" target="RepManWin" method="POST">
<TABLE border="0">
	<TBODY align="center">
		<TR>
			<TD align="<%=labels_align%>"><%=reportDate%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="date" 
					value='<%=currentDateStr%>' size="5" onChange='document.myForm.dateHID.value=document.myForm.date.value'></TD>
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
		<TR>
			<TD align="<%=labels_align%>"><%=lblQty%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="qty" size="5" tabindex="1" onblur='checkQty(this)'></TD>
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
		<TR>
			<TD align="<%=labels_align%>"><%=lblEmp%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="employee" size="5" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
	</TBODY>
</TABLE>

<% // this loop creates 10 "div", none are visible in the begining.
   // before the first one there are headers.
int i = 1;

for (i=1; i<=10;i++){
	if (i < numOfLines+1){ %>
		<div id='myLine<%=i%>' align=right style='display:on'>
	<% }else{ %>
		<div id='myLine<%=i%>' align=right style='display:none'>
	<% } %>
	<center>
	<table border="0" id="tbl<%=i%>">
	<% if (i == 1){ %>
		<tr bgColor="white">
			<th><%=lblItem%></th>
			<th><%=lblDescription%></th>	
			<th>&nbsp;</th>		
		</tr>
	<% } 
	switch(i){
		case 1: %>
			<tr bgColor="#FF1F0F">
		<%	break;
		case 2 : %>
			<tr bgColor="#5F3FFF">
		<%	break;
		case 3 : %>
			<tr bgColor="#FFFF0F">
		<%	break;
		case 4 : %>
			<tr bgColor="#2FEF0F">
		<%	break;
		case 5 : %>
			<tr bgColor="#E5E5E5">
		<%	break;
		case 6 : %>
			<tr bgColor="#FF7F0F">
		<%	break;
		case 7 : %>
			<tr bgColor="#CF0F0F">
		<%	break;
		case 8 : %>
			<tr bgColor="#CF0FFF">
		<%	break;
		case 9 : %>
			<tr bgColor="#0F0F0F">
		<%	break;
		case 10 : %>
			<tr bgColor="#FF9FFF">
		<%	break;
	} %>
		
		<TD align="<%=input_align%>"><INPUT type="text" name="item<%=i%>" value="" size=10  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="description<%=i%>" value="" size=30  readonly class='clReadonly'>
					<INPUT type="hidden" name="descHID<%=i%>" value=""></td>
		
		<TD align="center" width=50><INPUT type="radio" name="chosen" value="<%=i%>" tabindex="1*<%=i%>+2"
				onClick="document.myForm.checked.value='<%=i%>'"></td>
	</tr>
	
	</TABLE>
	</div>
<% } %>



<p><div align="center"><%=lblLabels%><input type="checkbox" tabindex="50" name="withLabels" value="yes" checked>

<p>
<INPUT type="button" name="exit" value="<%=exitBtn%>" class="myButton"  onclick="returnToFirst()" tabindex=52">
&nbsp;&nbsp;&nbsp;
<INPUT type="button" name="go" value="<%=doBtn%>" class="myButton" onclick="recordRecycle()" tabindex="51">

<INPUT type="hidden" name="hourHID" value='<%=currentTimeStr%>'>
<INPUT type="hidden" name="dateHID" value='<%=currentDateStr%>'>
<INPUT type="hidden" name="itemHID">
<INPUT type="hidden" name="descHID">
<INPUT type="hidden" name="empsHID">
<INPUT type="hidden" name="numOfLinesHID">
<INPUT type="hidden" name="checked" value="0">
</FORM>
</DIV>
</BODY>
</HTML>
