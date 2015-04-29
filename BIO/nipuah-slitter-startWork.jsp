<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@include file="nipuah-slitter-const.jsp"%>
<%@include file="nipuah-slitter-labels-heb.jsp"%>
<%@include file="../checkDateNEW.inc"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.Time"%>
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
input.readonly {background-color:#F0F0F0;border-color:steelblue;border-width:1px;border-style:solid}
</style>

<TITLE>slitter-start.jsp</TITLE>
<SCRIPT language="javascript">

var MvxCompany = "<%=MvxCompany%>";

function returnToFirst(){
	window.location='nipuah-extrusionAndSlitting.jsp';
}

function onLoad(){
	document.myForm.machine.focus();
	
	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	
	RejReas_Collection.AddValue("cono", MvxCompany);
	
	if (mvxd.indexOf("1") >= 0)
		RejReas_Collection.AddValue("wrh", "010");
	else
		RejReas_Collection.AddValue("wrh", "200");
	
	RejReas_Collection.CreateCollection("MO_GetAllSLittersOnBio");//Run model
	
	for (var i = 0; i < RejReas_Collection.count; i++){
		var oStd=RejReas_Collection.Item(i);//row
			
		var opt;
		opt = document.createElement("<option>");
		opt.value = oStd.GetValue("MSWHSL");
		
		if (mvxd.indexOf("1") >= 0)
			opt.text  = oStd.GetValue("MSWHSL");
		else
			opt.text  = oStd.GetValue("MSWHSL") + " | " + oStd.GetValue("NAME");
			
		document.myForm.machine.add(opt);
		
	}//end for
	
	RejReas_Collection=null;
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

function getOrderItem(){
	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	
	//set parameters
	RejReas_Collection.AddValue("cono", MvxCompany);
	RejReas_Collection.AddValue("Reference_Order", document.myForm.orderNum.value);
		
	RejReas_Collection.CreateCollection("MO_GetSlitterInputItem");//Run model
	
	if (RejReas_Collection.count > 0){
		var found = false;
		for (var i = 0; i < RejReas_Collection.count && ! found; i++){
			var oStd=RejReas_Collection.Item(i);//row
			
			var orderMachine = oStd.GetValue("VOPLGR");
			
			if (orderMachine != "99")
				found = true;
		}
		
		var currMachine = "S" + document.myForm.machine.value;
		
		if (currMachine == orderMachine){
			loadedItem = document.myForm.itemHID.value;
			
			if (loadedItem != ""){
				if (loadedItem != oStd.GetValue("VMMTNO")){
					document.myForm.go.disabled = true;
					roll = document.myForm.rollHID.value;
					alert("<%=error_anotherRollOnMachine1%>" + roll + "<%=error_anotherRollOnMachine2%>");
					document.myForm.orderNum.value = "";
				}else
					document.myForm.go.disabled = false;
			}else
				document.myForm.go.disabled = false;
		}else{
			document.myForm.go.disabled = true;
			alert("<%=error_wrongOrder%>");
		}
	}else{
		document.myForm.go.disabled = true;
		alert("<%=error_orderNotExists%>");
	}
	RejReas_Collection=null;	
}// end function getOrderItem()

function enableGoBtn(){
	document.myForm.go.disabled=false;
}

function startWork(){
	document.myForm.go.disabled=true;
	if (allDataFull() && checkDateAndTime()){
		//document.myForm.go.disabled=true;
		var WinParam="<%=WinParam%>";
		var w = window.open("blank.jsp","RepManWin",WinParam);
		
		if (!<%=debug%>)
			w.blur();
			
		document.myForm.submit();
		//alert("OK");
	}else
		document.myForm.go.disabled=false;
}//end function startWork()

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
	if (document.myForm.machine.value == ""){
		alert("<%=error_missingMachine%>");
		return false;
	}else if (document.myForm.orderNum.value == ""){
		alert("<%=error_missingOrder%>");
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

function saderD(date){
	date.value = saderDate(date.value);
}

function saderT(time){
	time.value = saderTime(time.value);
}
</SCRIPT>
</HEAD>


<BODY dir=<%=page_dir%> onload="onLoad()">
<!--  oncontextmenu="return false" -->
<%
Date currentDate = new Date(System.currentTimeMillis());
 
String currentDateStr = "";
String currentDateStr1 = "";
String currentTimeStr1 = "";

if (mvxd.indexOf("1") >= 0){
	currentDateStr1 = DateFormat.getDateInstance(DateFormat.SHORT).format(currentDate);
	currentDateStr = currentDateStr1.substring(0,2) + currentDateStr1.substring(3,5) + currentDateStr1.substring(6,8);

	currentTimeStr1 = new Time(System.currentTimeMillis()).toString();
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
	
	Calendar cal = Calendar.getInstance();
	cal.setTime(currentDate);
	cal.add(Calendar.HOUR_OF_DAY, difHours);
	
	currentDateStr1 = DateFormat.getDateInstance(DateFormat.SHORT).format(cal.getTime());
	currentDateStr = currentDateStr1.substring(3,5) + currentDateStr1.substring(0,2) + currentDateStr1.substring(6,8);

	currentTimeStr1 = DateFormat.getTimeInstance(DateFormat.SHORT).format(cal.getTime());
}

String currentTimeStr = currentTimeStr1.substring(0,2) + currentTimeStr1.substring(3,5);
%>
<P align="center"><B><FONT size="+2"><%=title_startWork%></FONT></B></P>
<P><BR>
<BR>
</P>
<DIV align="center">
<FORM name = "myForm" action="nipuah-slitter-doStartWork.jsp" target="RepManWin" method="POST">
<TABLE border="0">
	<TBODY align="center">
		<TR>
			<TD align="<%=labels_align%>"><%=lblMachine%></TD>
			<TD align="<%=input_align%>"><select name="machine" tabindex="1">
					 	<option></option>
					 </select></TD>
			<TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
			<TD align="<%=labels_align%>"><%=reportDate%></TD>
			<TD align="right"><INPUT type="text" name="date" 
					value='<%=currentDateStr%>' size="10" readonly class='readonly'></TD>
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
		<TR>	
			<TD align="<%=labels_align%>"><%=lblMoNumber%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="orderNum" size="20" tabindex="2" onChange='getOrderItem()'></TD>
			<TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
			<TD align="<%=labels_align%>"><%=reportHour%></TD>
			<TD align="right"><INPUT type="text" name="hour" 
					value='<%=currentTimeStr%>' size="10" readonly class='readonly'></TD>
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
		
	</TBODY>
</TABLE>
<p>
<INPUT type="button" name="out" value="<%=exitBtn%>" class="myButton"  onclick="window.location='nipuah-extrusionAndSlitting.jsp'" tabindex="6">
&nbsp;&nbsp;&nbsp;
<INPUT type="button" name="go" value="<%=doBtn%>" class="myButton" onclick="startWork()" tabindex="5">

<INPUT type="hidden" name="rollHID">
<INPUT type="hidden" name="itemHID">
<INPUT type="hidden" name="weightHID">
</FORM>
</DIV>
</BODY>
</HTML>
