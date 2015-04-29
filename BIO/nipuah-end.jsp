<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@include file="nipuah-const.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@page import="java.text.DateFormat"%>
<%@include file="../checkDateNEW.inc"%>

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

<TITLE>nipuah-end</TITLE>
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

function getInflationOpr(){
	var myDate = document.myForm.date.value;
	var myTime = document.myForm.hour.value;

	myDate = saderDate(myDate);
	document.myForm.date.value = myDate;
	myTime = saderTime(myTime);
	document.myForm.hour.value = myTime;
	
	var workSeq;
	
	document.myForm.go.disabled=true;
	
	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	//set parameters
	RejReas_Collection.AddValue("cono", MvxCompany);
	RejReas_Collection.AddValue("Reference_Order", document.myForm.orderNum.value);
	RejReas_Collection.CreateCollection("MO_Rep_GetInflation_Opr_ForEnding");//Run model

	if (RejReas_Collection.count == 0){//record not found !!
		alert("<%=error_notExist%>");
		document.myForm.go.disabled=false;
	}else if (RejReas_Collection.count > 1){
		alert("<%=error_tooMuch%>");
		document.myForm.go.disabled=false;
	}else{
		var oStd=RejReas_Collection.Item(0);//row
		
		workSeq = oStd.GetValue("VOWOSQ");
		document.myForm.workSeqHid.value = workSeq;
		
		order = oStd.GetValue("VHMFNO");
		document.myForm.orderHID.value = order;
		
		var parit = oStd.GetValue("VHPRNO");
		document.myForm.itemHID.value = parit;
		
		document.myForm.rollStatusHID.value = oStd.GetValue("STATUS");
		
		document.myForm.aprRollHID.value = oStd.GetValue("LMBANO");
		
		RejReas_Collection=null;
			
		document.myForm.go.disabled=true;
		var WinParam="<%=WinParam%>";
		var w = window.open("blank.jsp","RepManWin",WinParam);
		//var w = window.open("blank.jsp","RepManWin");
		
		if (!<%=debug%>)
				w.blur();
				
		document.myForm.submit();
		//alert("OK")
	}
	RejReas_Collection=null; 
	
}//end function getInflationOpr()

function getLastLot(){
	var workSeq;
	
	var qtyOfRools;
	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	//set parameters
	RejReas_Collection.AddValue("cono", MvxCompany);
	
	RejReas_Collection.AddValue("bano", "'" + document.myForm.orderNum.value + "%'");
	RejReas_Collection.CreateCollection("MO_Rep_GetLastLotNumber");//Run model
	
	if (RejReas_Collection.count == 0)
		document.myForm.qtyOfRolls.value = 0;
	else{
		var oStd=RejReas_Collection.Item(0);//row
		document.myForm.qtyOfRolls.value = oStd.GetValue("LMBANO").substring(4,7);
	}
	
}

function saderD(date){
	date.value = saderDate(date.value);
}

function saderT(time){
	time.value = saderTime(time.value);
}
</SCRIPT>
</HEAD>


<BODY dir=<%=page_dir%> onLoad='document.myForm.orderNum.focus();' oncontextmenu="return false">
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
<P align="center"><B><FONT size="+2"><%=title_end%></FONT></B></P>
<P><BR>
<BR>
</P>
<DIV align="center">
<FORM name = "myForm" action="mwsfPMS420_EndWorkOp.jsp" target="RepManWin" method="POST">
<TABLE border="0">
	<TBODY align="center">
		<TR>
			<TD align="<%=labels_align%>"><%=moNumber%></TD>
			<TD><INPUT type="text" name="orderNum" size="10" onChange='getLastLot()'></TD>
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
		<TR>
			<TD align="<%=labels_align%>"><%=reportDate%></TD>
			<TD align="right"><INPUT type="text" name="date" 
					value='<%=currentDateStr%>' size="10"></TD>
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
		<TR>
			<TD align="<%=labels_align%>"><%=reportHour%></TD>
			<TD align="right"><INPUT type="text" name="hour" 
					value='<%=currentTimeStr%>' size="10"></TD>
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
		
	</TBODY>
</TABLE>
<p>
<INPUT type="button" name="exit" value="<%=exitBtn%>" class="myButton"  onclick="returnToFirst()">
&nbsp;&nbsp;&nbsp;
<INPUT type="button" name="go" value="<%=doBtn%>" class="myButton" onclick="getInflationOpr()">
<INPUT type="hidden" name="workSeqHid">
<INPUT type="hidden" name="qtyOfRolls">
<INPUT type="hidden" name="orderHID">
<INPUT type="hidden" name="itemHID">
<INPUT type="hidden" name="rollStatusHID">
<INPUT type="hidden" name="aprRollHID">
<INPUT type="hidden" name="doPMS150" value="1">
</FORM>
</DIV>
</BODY>
</HTML>
