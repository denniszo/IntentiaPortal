<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@include file="nipuah-const.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@include file="../checkDateNEW.inc"%>
<%@page import="java.text.DateFormat"%>

<%@page import="java.util.Calendar"%>
<%@page import = "java.sql.DriverManager"%>
<%@page import = "java.sql.SQLException"%>
<%@page import = "java.sql.Connection"%>
<%@page import = "java.sql.PreparedStatement"%>
<%@page import = "java.sql.ResultSet"%>

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

<TITLE>nipuah-fixBioReporting.jsp</TITLE>
<SCRIPT language="javascript">

var MvxCompany = "<%=MvxCompany%>";
var comFrom = "<%=comFrom%>";

function returnToFirst(){
	if (comFrom == "1")
		window.location='nipuah-management.jsp';
	else
		window.location='../Yizur/yizur-first.jsp';
}

function enableGoBtn(){
	document.myForm.go.disabled=false;
}

function onLoad(){
	document.myForm.txtRoll.focus();
	
	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	
	RejReas_Collection.AddValue("cono", MvxCompany);
	RejReas_Collection.CreateCollection("MO_Rer_GetBioProdNotes");//Run model
	
	for (var i = 0; i < RejReas_Collection.count; i++){
		var oStd=RejReas_Collection.Item(i);//row
			
		var note = oStd.GetValue("PFOPTN");
		
		if (mvxd.indexOf("1") >= 0){
			if (note.substr(0,1) == "T"){
				var opt, opt2;
				opt = document.createElement("<option>");
				opt.value = note;
				opt.text  = oStd.GetValue("PFTX30");
				document.myForm.note1.add(opt);
				opt2 = document.createElement("<option>");
				opt2.value = oStd.GetValue("PFOPTN");
				opt2.text  = oStd.GetValue("PFTX30");
				document.myForm.note2.add(opt2);
			}
		}else{
			if (note.substr(0,2) == "UT"){
				var opt, opt2;
				opt = document.createElement("<option>");
				opt.value = note;
				opt.text  = oStd.GetValue("PFTX30");
				document.myForm.note1.add(opt);
				opt2 = document.createElement("<option>");
				opt2.value = oStd.GetValue("PFOPTN");
				opt2.text  = oStd.GetValue("PFTX30");
				document.myForm.note2.add(opt2);
			}
		}
	}//end for
	
	var empStr = ",";
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
}

function findRollData(){
	var roll = document.myForm.txtRoll.value;
	roll = roll.toUpperCase();
	document.myForm.txtRoll.value = roll;
	
	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	//set parameters
	RejReas_Collection.AddValue("cono", MvxCompany);
	RejReas_Collection.AddValue("roll", roll);
	
	if (mvxd.indexOf("1") >= 0)
		RejReas_Collection.AddValue("wrh", "010");
	else
		RejReas_Collection.AddValue("wrh", "200");
		
	RejReas_Collection.CreateCollection("MO_GetJumboData");//Run model
	
	if (RejReas_Collection.count > 0){
		var oStd=RejReas_Collection.Item(0);//row
		
		order = oStd.GetValue("ORDER");
		
		if (order != ""){
			document.myForm.orderHID.value = order;
			document.myForm.atnHID.value = oStd.GetValue("ATN");
			document.myForm.wrhHID.value = oStd.GetValue("WRH");
			document.myForm.densityHid.value = oStd.GetValue("DENSITY");
			document.myForm.micronHID.value = oStd.GetValue("MICRON");
			document.myForm.printTypeHID.value = oStd.GetValue("MMITGR");
			document.myForm.txtItem.value = oStd.GetValue("ITEM");
			document.myForm.statusHID.value = oStd.GetValue("STATUS");
			
			loc = oStd.GetValue("LOCATION");
			document.myForm.loc1.value = loc;
			document.myForm.loc2.value = loc;
			
			if (loc.indexOf("-") > 0)
				document.myForm.locHID.value = loc.substr(3);
			else
				document.myForm.locHID.value = loc;
				
			document.myForm.weight1.value = formatWeight(oStd.GetValue("WEIGHT"),2);
			document.myForm.weight2.value = formatWeight(oStd.GetValue("WEIGHT"),2);
			document.myForm.oldWeightHID.value = formatWeight(oStd.GetValue("WEIGHT"),2);
			document.myForm.length1.value = oStd.GetValue("LENGTH");
			document.myForm.length2.value = oStd.GetValue("LENGTH");
			document.myForm.lengthHID.value = oStd.GetValue("LENGTH");
			document.myForm.width1.value = oStd.GetValue("WIDTH");
			document.myForm.width2.value = oStd.GetValue("WIDTH");
			document.myForm.widthHID.value = oStd.GetValue("WIDTH");
			
			for (var i = 0; i < RejReas_Collection.count; i++){
				var oStd=RejReas_Collection.Item(i);//row
				
				if(oStd.GetValue("SUG") == "EMPLOYY"){
					if (mvxd.indexOf("1") >= 0)
						employee = oStd.GetValue("VALUE").substring(1,4);
					else
						employee = oStd.GetValue("VALUE").substring(2,5);
						
					document.myForm.emp1.value = employee;
					document.myForm.emp2.value = employee;
					document.myForm.empHID.value = employee;
				}else{
					document.myForm.note1.value = oStd.GetValue("VALUE");
					document.myForm.note2.value = oStd.GetValue("VALUE");
					document.myForm.noteHID.value = oStd.GetValue("VALUE");
				}
			}
			document.myForm.del.checked=true;
			document.myForm.sugHID.value=3;
			document.myForm.loc2.disabled = true;
		}else{
			alert("<%=error_rollNotCreatedValidely%>");
			document.myForm.txtRoll.value = "";
		}
	}else{
		if (roll.length == 7){
			RejReas_Collection.AddValue("cono", MvxCompany);
			RejReas_Collection.AddValue("order", roll.substr(0,4));
			
			if (mvxd.indexOf("1") >= 0)
				RejReas_Collection.AddValue("faci", "001");
			else
				RejReas_Collection.AddValue("faci", "200");
		
			RejReas_Collection.CreateCollection("MO_GetJumboOrderData");//Run model
			
			if (RejReas_Collection.count > 0){
				var oStd=RejReas_Collection.Item(0);//row
			
				document.myForm.orderHID.value = oStd.GetValue("ORDER");
				document.myForm.wrhHID.value = oStd.GetValue("WRH");
				document.myForm.densityHid.value = oStd.GetValue("DENSITY");
				document.myForm.micronHID.value = oStd.GetValue("MICRON");
				document.myForm.txtItem.value = oStd.GetValue("ITEM");
				document.myForm.printTypeHID.value = oStd.GetValue("MMITGR");
				document.myForm.statusHID.value = "1";
				
				document.myForm.addOne.checked=true;
				document.myForm.sugHID.value=1;
				document.myForm.loc2.disabled = false;
			}else{
				alert("<%=error_notExist%>");
				document.myForm.txtRoll.value = "";
			}
		}else{
			alert("<%=error_rollNotValid%>");
			document.myForm.txtRoll.value = "";
		}
	}	
	RejReas_Collection=null;	
}

function convertToGauge(micron){
	switch(micron){
		case "11.2":
			return "45";
			break;
		case "12.5":
			return "50";
			break;
		case "15":
			return "60";
			break;
		case "19":
			return "75";
			break;
		case "25":
			return "100";
			break;
		case "32":
			return "125";
			break;
		case "38":
			return "150";
			break;	
		case "50":
			return "200";
			break;
		default:
			return "60";
			break;
	}
}

function formatWeight(num, decimals){
	num = "" + num;
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

function sendData(){
	document.myForm.go.disabled=true;
	
	if (document.myForm.sugHID.value == 2)
		newWeight = -1 * (document.myForm.oldWeightHID.value - document.myForm.weight2.value);
	else if (document.myForm.sugHID.value == 3)
		newWeight = -1 * document.myForm.oldWeightHID.value;
	else
		newWeight = document.myForm.weight2.value;
		
	if (newWeight == 0 && (document.myForm.length2.value != document.myForm.lengthHID.value 
						   || document.myForm.width2.value != document.myForm.widthHID.value))
		newWeight = 0.01;
	else
		newWeight = Math.round(newWeight * 100) / 100;
		
	document.myForm.newWeightHID.value = newWeight;
	
	if (document.myForm.sugHID.value == "3" 
		|| (allDataFull() && lengthAndWeightOk() && 
		checkDatesAndTimes() && employeeExists() && widthIsNumeric()
		&& lengthIsNumeric())){
		
		if (document.myForm.sugHID.value != "3" && document.myForm.withLabels.checked){
			myType = document.myForm.printTypeHID.value;
			document.myForm.printTypeHID.value = findTeur("ITGR", myType, "description");
			
			if (mvxd.indexOf("1") < 0){
				micron = document.myForm.micronHID.value;
				document.myForm.gaugeHID.value = convertToGauge(micron);
			}
		}
		
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
	
	if (document.myForm.sugHID.value != 1){
		document.myForm.change.checked=true;
		document.myForm.sugHID.value=2;
	}
}

function widthIsNumeric(){
	var width = document.myForm.width2.value;
	
	if (IsNumeric(width))
		return true;
	else{
		alert("<%=error_widthNotNumeric%>");
		return false;
	}
}

function lengthIsNumeric(){
	var length = document.myForm.width2.value;
	
	if (IsNumeric(length))
		return true;
	else{
		alert("<%=error_lengthNotNumeric%>");
		return false;
	}
}

function IsNumeric(sText){
   var ValidChars = "0123456789.";
   var IsNumber=true;
   var Char;

   for (i = 0; i < sText.length && IsNumber == true; i++){ 
      Char = sText.charAt(i); 
      if (ValidChars.indexOf(Char) == -1)
     	IsNumber = false;
   }
	
   return IsNumber;
}

function employeeExists(){
	var empStr = document.myForm.empsHID.value;
	var emp = "";
	
	if (mvxd.indexOf("1") >= 0)
		emp = ",E" + document.myForm.emp2.value + ",";
	else
		emp = ",UE" + document.myForm.emp2.value + ",";

	if (empStr.search(emp) >= 0)
		return true;
	else{
		alert("<%=error_employeeNotExists%>");
		return false;
	}
}//end function employeeExists()

function checkDatesAndTimes(){
	var diffDays = <%=diffDays%>;
	var toDay = document.myForm.dateHid.value;
	var myDate = document.myForm.date2.value;
	var myTime = document.myForm.hour2.value;

	myDate = saderDate(myDate);
	document.myForm.date2.value = myDate;

	if (isValidDate(myDate)){
		myTime = saderTime(myTime);
		document.myForm.hour2.value = myTime;
		
		if (isValidTime(myTime)){
			toDay = new Date("20"+toDay.substring(6,8),toDay.substring(3,5),toDay.substring(0,2),0,0,0);
			
			if (mvxd.indexOf("1") >= 0)
				myDate = new Date("20"+myDate.substring(6,8),myDate.substring(3,5),myDate.substring(0,2),0,0,0);
			else
				myDate = new Date("20"+myDate.substring(6,8),myDate.substring(0,2),myDate.substring(3,5),0,0,0);
			
			difference = toDay.getTime() - myDate.getTime();
			difference = Math.floor(difference / (1000*60*60*24));
			
			if (difference < 0 || difference - diffDays > 0){
				alert("<%=error_dateNotInRange%>");
				return false;
			}else
				return true;
		}else{
			alert("<%=error_wrongTime%>");
			return false;
		}
	}else{
		alert("<%=error_wrongDate%>");
		return false;
	}
}

function widthIsInRange(){
	var width = document.myForm.width2.value;
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

	if ((width - fromWidth < 0) || (width > toWidth > 0)){
		passEntered = prompt("<%=error_widthNotOk%>","");
		if (passEntered.toLowerCase() != pass)
			return false;
		else
			return true;
	}
	else
		return true;
	//return true;
}

function allDataFull(){
	if (document.myForm.txtRoll.value == ""){
		alert("<%=error_missingOneRoll%>");
		return false;
	}else if (document.myForm.length2.value == ""){
		alert("<%=error_missingLength%>");
		return false;
	}else if (document.myForm.width2.value == ""){
		alert("<%=error_missingWidth%>");
		return false;
	}else if (document.myForm.weight2.value == ""){
		alert("<%=error_missingWeight%>");
		return false;
	}else if (document.myForm.emp2.value == ""){
		alert("<%=error_missingEmp%>");
		return false;
	}else if (document.myForm.loc2.value == ""){
		alert("<%=error_missingLoc%>");
		return false;
	}else if (document.myForm.date2.value == ""){
		alert("<%=error_missingDate%>");
		return false;
	}else if (document.myForm.hour2.value == ""){
		alert("<%=error_missingHour%>");
		return false;
	}else
		return true;
}

function lengthAndWeightOk(){
	var deviationPermitted = <%=deviation%>;
	var length = document.myForm.length2.value;
	var weight = document.myForm.weight2.value;
	var width = document.myForm.width2.value;
	var density = document.myForm.densityHid.value;
	var ovi = document.myForm.micronHID.value;
	
	if (ovi == "12"){
		ovi = 12.5;
		document.myForm.micronHID.value = 12.5;
	}
		
	if (ovi == "11"){
		ovi = 11.2;
		document.myForm.micronHID.value = 11.2;
	}
		
	if (mvxd.indexOf("1") >= 0)
		computedWeight = (length * width * ovi * density) / 1000000;
	else
		computedWeight = (length * width * ovi * density * 17.067725) / 1000000;
		
	var deviation = Math.abs(computedWeight - weight) / weight;
	
	aaa = new Number(computedWeight);
	
	if (deviation > deviationPermitted){
		alert("<%=error_weightNotOk%>" + " - " + aaa.toFixed(0));
		return false;
	}
	else
		return true;
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
int myYear = Integer.parseInt(myDate.substring(0,4)) - 1900;
int myMonth = Integer.parseInt(myDate.substring(4,6)) - 1;
int myDay = Integer.parseInt(myDate.substring(6,8));
int myHour = Integer.parseInt(myTime.substring(0,2));
int myMin = Integer.parseInt(myTime.substring(2,4));
int mySec = Integer.parseInt(myTime.substring(4,6));

Calendar cal = Calendar.getInstance();
cal.set(myYear,myMonth,myDay,myHour,myMin,mySec);
 
String currentDateStr = "";
String currentDateStr1 = "";
String currentTimeStr1 = "";

if (mvxd.indexOf("1") >= 0){
	currentDateStr1 = DateFormat.getDateInstance(DateFormat.SHORT).format(cal.getTime());
	currentDateStr = currentDateStr1.substring(0,2) + currentDateStr1.substring(3,5) + currentDateStr1.substring(6,8);

	currentTimeStr1 = DateFormat.getTimeInstance(DateFormat.SHORT).format(cal.getTime());
}else{
	int difHours = 0;

	if (mvxd.indexOf("1") < 0){
		Connection dbConn = null;
		try {
		  Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
		
		  //db name
		  String dbName = "Movex";     
		  String url = "jdbc:odbc:" + dbName;
		  
		  dbConn = DriverManager.getConnection(url, mws_username, mws_password);
		  
		
		} catch (SQLException ex) { // Handle SQL errors
		  	out.println(ex.toString() + "<BR>");
		} catch (ClassNotFoundException ex1) {
		 	out.println(ex1.toString() + "<BR>");
		}
		String currYear = Integer.toString(Calendar.getInstance().get(Calendar.YEAR));
		
		String sql = "SELECT INT((TZTGMT-200)/100) AS HOURS FROM MVXJDTA.CITZON WHERE TZTIZO='MFG' AND TZYEA4=?";
		
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
		  stmt = dbConn.prepareStatement(sql);
		  
		  stmt.setString(1, currYear);
		  
		  rs = stmt.executeQuery();
		  
		  if (rs.next()){				// there is a record found
			  difHours = rs.getInt("HOURS");
		  }
		
		} catch (Exception e) {
			out.println(e.toString() + "<BR>");
		}
	}
	
	cal.add(Calendar.HOUR_OF_DAY, difHours);
	
	currentDateStr1 = DateFormat.getDateInstance(DateFormat.SHORT).format(cal.getTime());
	currentDateStr = currentDateStr1.substring(3,5) + currentDateStr1.substring(0,2) + currentDateStr1.substring(6,8);

	currentTimeStr1 = DateFormat.getTimeInstance(DateFormat.SHORT).format(cal.getTime());
}

String currentTimeStr = currentTimeStr1.substring(0,2) + currentTimeStr1.substring(3,5);
%>

<P align="center"><B><FONT size="+2"><%=title_fixJumbo%></FONT></B></P>
<P><BR>
<BR>

<form name="myForm" action="nipuah-doFixBioReporting.jsp" method=post"" target="RepManWin">

<div align="center"><table border="0"  width="60%">
  <tr>
     <td align=<%=labels_align%>><%=lblRoll%></td>
     <td align=<%=input_align%>><input type="text" name="txtRoll" value="" border="0" size="10" tabindex="1" 
     		onChange="findRollData()"> </td>
     
     <td align=<%=labels_align%>><%=lblItem%></td>
	 <td align=<%=input_align%>><input type="text" name="txtItem" value="" border="0" size="10" readonly class='readonly'> </td>
  </tr>
</table></div>
<br /><br />


<div align="center">
<table width="60%"  border="0" cellpadding="0" cellspacing="0" valign="top">
<tr>
<td><table border="0" cellpadding="0" valign="top">
<tr>
<th align="center" colspan="2"><%=lblRecordedData%></th>
</tr>

<tr>
	<td align="<%=labels_align%>"><%=lblLength%></td>
	<td align="<%=input_align%>"><input name="length1" type="text" tabindex="2" disabled>
				<input name="lengthHID" type="hidden"></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblWidth%></td>
	<td align="<%=input_align%>"><input name="width1" type="text" tabindex="3" disabled>
				<input name="widthHID" type="hidden"></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblWeight%></td>
	<td align="<%=input_align%>"><input name="weight1" type="text" tabindex="4" disabled></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblEmp%></td>
	<td align="<%=input_align%>"><input name="emp1" type="text" tabindex="5" disabled>
				<input name="empHID" type="hidden"></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblLocation%></td>
	<td align="<%=input_align%>"><input name="loc1" type="text" tabindex="6" disabled>
				<input name="locHID" type="hidden"></td>
</tr>
	<tr>
	<td align="<%=labels_align%>"><%=lblNote%></td>
	<td align="<%=input_align%>"><select name="note1" tabindex="7" disabled>
					 	<option></option>
					 </select>
				<input name="noteHID" type="hidden"></td>
</tr>
<tr>
	<td align="<%=labels_align%>">&nbsp;</td>
	<td align="<%=input_align%>">&nbsp;</td>
</tr>
<tr>
	<td align="<%=labels_align%>">&nbsp;</td>
	<td align="<%=input_align%>">&nbsp;</td>
</tr>
</table></td>


</td>
<td><table border="0" cellpadding="0" valign="top">
<tr>
<th align="center" colspan="2"><%=lblFixedData%></th>
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
			onChange='document.myForm.hour2.value="";enableDo()'></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblHour%></td>
	<td align="<%=input_align%>"><input name="hour2" type="text" tabindex="17" value="<%=currentTimeStr%>"
			onChange='enableDo()'>
	</td>
</tr>
</table></td>


</td>
</tr>
</table>

<p>
<table border=0>
<tr>
<TD align="<%=labels_align%>"><%=lblNew%></td><td><INPUT type="radio" name="fix" value="new" 
				id="addOne" tabindex="18" onclick='document.myForm.sugHID.value=1'></td>
</tr><tr>
<TD align="<%=labels_align%>"><%=lblFix%></td><td><INPUT type="radio" name="fix" value="change"
				id="change" tabindex="19" onclick='document.myForm.sugHID.value=2'></td>
</tr><tr>
<TD align="<%=labels_align%>"><%=lblDel%></td><td><INPUT type="radio" name="fix" value="del" 
				id="del" tabindex="20"  onclick='document.myForm.sugHID.value=3'></td>
</tr>
</table>

</div>

<br />
<% if (mvxd.indexOf("1") >= 0){ %>
	<div align="center"><%=lblPrint%><input type="checkbox" name="withLabels" value="yes" tabindex="22">
<% }else{ %>
	<div align="center"><%=lblPrint%><input type="checkbox" name="withLabels" value="yes" tabindex="22" checked>
<% } %>
<p>
<INPUT type="button" name="exit" value="<%=exitBtn%>" class="myButton"  onclick="returnToFirst()" tabindex="20">
&nbsp;&nbsp;&nbsp;
<INPUT type="button" name="go" value="<%=doBtn%>" class="myButton"  onclick="sendData()" tabindex="21">

<INPUT type="hidden" name="orderHID">
<INPUT type="hidden" name="densityHid">
<INPUT type="hidden" name="fromWidthHid">
<INPUT type="hidden" name="toWidthHid">
<INPUT type="hidden" name="roll1Hid">
<INPUT type="hidden" name="roll2Hid">
<INPUT type="hidden" name="atnHID">
<INPUT type="hidden" name="wrhHID">
<INPUT type="hidden" name="dateHid" value="<%=currentDateStr1%>">
<INPUT type="hidden" name="timeHid" value="<%=currentTimeStr1%>">
<INPUT type="hidden" name="empsHID">
<INPUT type="hidden" name="printTypeHID">
<INPUT type="hidden" name="micronHID">
<INPUT type="hidden" name="gaugeHID">
<INPUT type="hidden" name="sugHID">
<INPUT type="hidden" name="oldWeightHID">
<INPUT type="hidden" name="newWeightHID">
<INPUT type="hidden" name="statusHID">

</form>



</body>
</html>

