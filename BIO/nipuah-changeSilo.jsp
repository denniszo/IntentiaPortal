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

function findRaw(num){
	document.myForm.go.disabled=false;
	
	var order = num.value;
	
	for (var j=document.myForm.raw.length-1;j>=0;j--)
		document.myForm.raw.remove(j);
	
	var opt;
	opt = document.createElement("<option>");
	opt.text = "<%=lblChoose%>";	
	document.myForm.raw.add(opt);
	
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
		for (var i = 0; i < RejReas_Collection.count; i++){
			var oStd=RejReas_Collection.Item(i);//row
			
			var raw = oStd.GetValue("RAW");
			var rawName = oStd.GetValue("NAME");
			
			var opt;
			opt = document.createElement("<option>");
			opt.value = raw + "|" + rawName;
			opt.text = rawName;
			
			document.myForm.raw.add(opt);
		}
	}
	
	RejReas_Collection=null;
}

function keepRaw(raw){
	document.myForm.go.disabled=false;
	
	myArr = raw.value.split("|");
	
	document.myForm.rawHID.value = myArr[0];
	document.myForm.rawNameHID.value = myArr[1];
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
	}else if (document.myForm.raw.value == ""){
			alert("<%=error_missingRaw%>");
			return false;
	}else if (document.myForm.siloFrom.value == ""){
		alert("<%=error_missingSiloFrom%>");
		return false;
	}else if (document.myForm.siloTo.value == ""){
		alert("<%=error_missingSiloTo%>");
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
<P align="center"><B><FONT size="+2"><%=title_changeSilo%></FONT></B></P>
<P><BR>
<BR>
</P>
<DIV align="center">
<FORM name = "myForm" action="nipuah-doChangeSilo.jsp" target="RepManWin" method="POST">
<TABLE border="0">
	<TBODY align="center">
		<TR>
			<TD align="<%=labels_align%>"><%=moNumber%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="orderNum" size="10" tabindex="1"
				onChange="findRaw(this)"></TD>
		</TR>
		<tr>
			<TD align="<%=labels_align%>"><%=lblRaw%></TD>
			<TD align="<%=input_align%>"><select name="raw" tabindex="2" onchange='keepRaw(this)'>
					<option></option>
			</select></TD>
		</tr>
		<tr>
			<td align="<%=labels_align%>"><%=lblSiloFrom%></td>
			<td align="<%=input_align%>"><input name="siloFrom" type="text"  size="20" tabindex="3"></td>
		</tr>
		<tr>
			<td align="<%=labels_align%>"><%=lblSiloTo%></td>
			<td align="<%=input_align%>"><input name="siloTo" type="text"  size="20" tabindex="4"></td>
		</tr>
		<tr>
			<td align="<%=labels_align%>"><%=lblEmp%></td>
			<td align="<%=input_align%>"><input name="emp" type="text"  size="10" tabindex="5"
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
<INPUT type="button" name="exit" value="<%=exitBtn%>" class="myButton"  onclick="returnToFirst()" tabindex="6">
&nbsp;&nbsp;&nbsp;
<INPUT type="button" name="go" value="<%=doBtn%>" class="myButton" onclick="doTheJob()" tabindex="5">

<INPUT type="hidden" name="workSeqHid">
<INPUT type="hidden" name="orderHID">
<INPUT type="hidden" name="empsHID">
<INPUT type="hidden" name="rawHID">
<INPUT type="hidden" name="rawNameHID">
</FORM>
</DIV>
</BODY>
</HTML>
