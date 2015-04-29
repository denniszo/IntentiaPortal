<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@include file="nipuah-const.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@include file="../checkDateNEW.inc"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.Time"%>
<%@page import="java.text.DateFormat"%>

<%@page import="java.util.Calendar"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.SQLException"%>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.PreparedStatement"%>
<%@ page import = "java.sql.ResultSet"%>

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
	
	String slitOrder1 = session.getAttribute("slitOrder1").toString();
	String slitOrder2 = session.getAttribute("slitOrder2").toString();
	
	String sOrder1 = "";
	String sOrder2 = "";
	
	String mie=String.valueOf(MIEAppID);
	String allOrders = "";
	
	String faci = "";
	String test = "";
	
	if (mvxd.indexOf("1") >= 0)
		faci = "001";
	else
		faci = "200";
		
	if(mie.endsWith("TEST"))
		test = "1";
	else
		test = "0";
	
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
	    
	    String sql = "select * from seijdta.syfslitfold as AA where AA.TEST = ? and AA.FACI = ?";
	
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
	      stmt = dbConn.prepareStatement(sql);
	      stmt.setString(1, test);
      	  stmt.setString(2, faci);
	         
	      rs = stmt.executeQuery();
	      
	      String temp = "";
	      
	      while (rs.next()){				// there is a record found
	      	temp = rs.getString("orderNum");
	      	allOrders = allOrders + "," + temp.trim();
	      }
	    } catch (Exception e) {
	    	out.println(e.toString() + "<BR>");
	    }
	}else{
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
	    
	    String sql = "select * from seijdta.syfslitfold as AA where AA.MACHINE = 'BA' and AA.TEST = ? and AA.FACI = '001'";
	    
	    PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
	      stmt = dbConn.prepareStatement(sql);
	      stmt.setString(1, test);
      	     
	      rs = stmt.executeQuery();
	      
	      if (rs.next()){				// there is a record found
	    	  sOrder1 = rs.getString("orderNum");
	      }
	    } catch (Exception e) {
	    	out.println(e.toString() + "<BR>");
	    }
		
		sql = "select * from seijdta.syfslitfold as AA where AA.MACHINE = 'BB' and AA.TEST = ? and AA.FACI = '001'";
	    
	    try {
	      stmt = dbConn.prepareStatement(sql);
	      stmt.setString(1, test);
      	     
	      rs = stmt.executeQuery();
	      
	      if (rs.next()){				// there is a record found
	    	  sOrder2 = rs.getString("orderNum");
	      }
	    } catch (Exception e) {
	    	out.println(e.toString() + "<BR>");
	    }
	    
	    allOrders = sOrder1.trim() + "," + sOrder2.trim();
	}
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

<TITLE>nipuah-report.jsp</TITLE>
<SCRIPT language="javascript">

var MvxCompany = "<%=MvxCompany%>";


function returnToFirst(){
	
	window.location='nipuah-extrusionAndSlitting.jsp';
}

function enableGoBtn(){
	document.myForm.go.disabled=false;
}

function onLoad(){
	slitOrder1 = document.myForm.slitOrder1.value;
	slitOrder2 = document.myForm.slitOrder2.value;
	
	if (slitOrder1 != "" || slitOrder2 != "")
		window.location='nipuah-slitReporting.jsp';
	else{
	
		document.myForm.txtMO.focus();
		
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
}

function findMoData(){
	var order = document.myForm.txtMO.value;
	order = order.toUpperCase();
	document.myForm.txtMO.value = order;
	
	if (mvxd.indexOf("1") >= 0 && order.charAt(0) != '4'){
		alert("!!!שיחול וחיתוך רק על קו 4");
		document.myForm.txtMO.value = "";
	}else{
		
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
			
			divi = oStd.GetValue("VHDIVI");
			
			if (((mvxd.indexOf("1") >= 0) && (divi != "001")) || ((mvxd.indexOf("1") < 0) && (divi != "200"))){
				alert("<%=error_notExist%>");
				document.myForm.go.disabled=true;
			}else{
				
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
					wanted = formatWeight(oStd.GetValue("WANTED"),2);
					done = formatWeight(myNum,2);
					
					switch (micron){
						case "07":
							if (mvxd.indexOf("1") >= 0)
								ovi = 7;
							else
								ovi = 30;
							
							break;
						case "11":
							if (mvxd.indexOf("1") >= 0)
								ovi =11.2;
							else
								ovi = 45;
							
							break;
						case "12":
							if (mvxd.indexOf("1") >= 0)
								ovi =12.57;
							else
								ovi = 50;
							
							break;
						case "15":
							if (mvxd.indexOf("1") >= 0)
								ovi = 15;
							else
								ovi = 60;
							
							break;
						case "19":
							if (mvxd.indexOf("1") >= 0)
								ovi = 19;
							else
								ovi = 75;
							
							break;
						case "25":
							if (mvxd.indexOf("1") >= 0)
								ovi = 25;
							else
								ovi = 100;
							
							break;
						case "30":
							if (mvxd.indexOf("1") >= 0)
								ovi = 30;
							else
								ovi = 0;
							
							break;
						case "32":
							if (mvxd.indexOf("1") >= 0)
								ovi = 32;
							else
								ovi = 125;
							
							break;
						case "38":
							if (mvxd.indexOf("1") >= 0)
								ovi = 38;
							else
								ovi = 150;
							
							break;
						case "50":
							if (mvxd.indexOf("1") >= 0)
								ovi = 50;
							else
								ovi = 200;
							
							break;
						default:
							if (mvxd.indexOf("1") >= 0)
								ovi = micron;
							else
								ovi = micron * 4;
							
							break;
					}
						
					doNext = true;
					
					if (wanted - done < 0){
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
					
						passEntered = prompt("<%=error_tooMuch1%>" + done + "<%=error_tooMuch2%>" + wanted + "<%=error_tooMuch3%>","");
						if (passEntered.toLowerCase() != pass)
							doNext = false;	
					}
					
					if (doNext){
						document.myForm.txtType.value = myType.substring(1,4)
						document.myForm.txtOvi.value = micron;
						document.myForm.txtThick.value = ovi;
						document.myForm.densityHid.value = oStd.GetValue("MMDIM1");
						document.myForm.fromWidthHid.value = oStd.GetValue("AHANUF");
						document.myForm.toWidthHid.value = oStd.GetValue("AHANUT");
						document.myForm.itnoHid.value = oStd.GetValue("VHITNO");
						document.myForm.whloHid.value = oStd.GetValue("VHWHLO");
						
						document.myForm.printTypeHID.value = findTeur("ITGR", myType, "description");
						document.myForm.micronHID.value = findTeur("CFI3", micron, "description");
						
						aaa = new Number(oStd.GetValue("AHANUF"));
						bbb = new Number(oStd.GetValue("AHANUT"));
						document.myForm.txtRangeWidth.value = aaa.toFixed(0) + "-" + bbb.toFixed(0);
						
						RejReas_Collection=null;
						getLastLot();
					}else{
						alert("Wrong Password!!!");
						window.location='nipuah-first.jsp';
					}
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
		}
		RejReas_Collection=null;
		
		if (mvxd.indexOf("1") >= 0){
			sOrder1 = document.myForm.sOrder1.value;
			sOrder2 = document.myForm.sOrder2.value;
			
			if (sOrder1 != ""){
				document.myForm.slitOrder1.value = sOrder1;
				checkOrder(document.myForm.slitOrder1);
			}
			
			if (sOrder2 != ""){
				document.myForm.slitOrder2.value = sOrder2;
				checkOrder(document.myForm.slitOrder2);
			}
		}
	}
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
		
		lastRoll = oStd.GetValue("LMBANO").substring(4,7);
		
		if (lastRoll % 2 != 0){
			alert("<%=error_lastRollNotEven%>");
			window.location='nipuah-first.jsp';
		}else{
			document.myForm.rollNumber1.value = createOddRoll(lastRoll, 1);
			document.myForm.rollNumber2.value = createOddRoll(lastRoll, 2);
		}
	}
	
	document.myForm.roll1Hid.value = document.myForm.rollNumber1.value
	document.myForm.roll2Hid.value = document.myForm.rollNumber2.value
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
	document.myForm.exit.disabled=true;
	
	if (allDataFull() && widthIsInRange() && lengthAndWeightOk() && 
		checkDatesAndTimes(1) && checkDatesAndTimes(2) && employeeExists() && widthIsNumeric()
		&& lengthIsNumeric()){
		
		slitOrder1 = document.myForm.slitOrder1.value;
		slitOrder2 = document.myForm.slitOrder2.value;
		
		if (slitOrder1 != "" || slitOrder2 != ""){
			if (mvxd.indexOf("1") >= 0){
				document.myForm.slitter1.value = "BA";
				document.myForm.slitter2.value = "BB";
			}else{
				machine = document.myForm.txtMO.value;
				machine = "B" + machine.substring(0,1);
				document.myForm.slitterHID.value = machine;
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
	}else{
		document.myForm.go.disabled=false;
		document.myForm.exit.disabled=false;
	}
}

function enableDo(){
	document.myForm.go.disabled=false;
}

function widthIsNumeric(){
	var width1 = document.myForm.width1.value;
	var width2 = document.myForm.width2.value;
	
	if (IsNumeric(width1)){
		if (IsNumeric(width2))
			return true;
		else{
			alert("<%=error_oddWidthNotNumeric%>");
			return false;
		}
	}else{
		alert("<%=error_evenWidthNotNumeric%>");
		return false;
	}
}

function lengthIsNumeric(){
	var length1 = document.myForm.length1.value;
	var length2 = document.myForm.width2.value;
	
	if (IsNumeric(length1)){
		if (IsNumeric(length2))
			return true;
		else{
			alert("<%=error_oddLengthNotNumeric%>");
			return false;
		}
	}else{
		alert("<%=error_evenLengthNotNumeric%>");
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
	slitOrder1 = document.myForm.slitOrder1.value;
	slitOrder2 = document.myForm.slitOrder2.value;
	
	if (slitOrder1 != '' && slitOrder2 != '')
		return true;
	else{
		var empStr = document.myForm.empsHID.value;
		var emp = "";
		
		if (mvxd.indexOf("1") >= 0)
			emp = ",E" + document.myForm.emp1.value + ",";
		else
			emp = ",UE" + document.myForm.emp1.value + ",";
	
		if (empStr.search(emp) >= 0){
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
		}else{
			alert("<%=error_employeeNotExists%>");
			return false;
		}
	}
}//end function employeeExists()

function checkDatesAndTimes(i){
	var diffDays = <%=diffDays%>;
	var toDay = document.myForm.dateHid.value;
	var myDate = eval("document.myForm.date" + i + ".value");
	var myTime = eval("document.myForm.hour" + i +".value");

	myDate = saderDate(myDate);
	eval("document.myForm.date" + i + ".value = '" + myDate + "'");

	if (isValidDate(myDate)){
		myTime = saderTime(myTime);
		eval("document.myForm.hour" + i +".value = '" + myTime + "'");
		
		if (isValidTime(myTime)){
			toDay = new Date("20"+toDay.substring(6,8),toDay.substring(3,5),toDay.substring(0,2),0,0,0);
			
			if (mvxd.indexOf("1") >= 0)
				myDate = new Date("20"+myDate.substring(6,8),myDate.substring(3,5),myDate.substring(0,2),0,0,0);
			else
				myDate = new Date("20"+myDate.substring(6,8),myDate.substring(0,2),myDate.substring(3,5),0,0,0);
			
			difference = toDay.getTime() - myDate.getTime();
			difference = Math.floor(difference / (1000*60*60*24));
			
			if (difference < 0 || difference - diffDays > 0){
				if (i==1)
					alert("<%=error_oddDateNotInRange%>");
				else
					alert("<%=error_evenDateNotInRange%>");
				return false;
			}else
				return true;
		}else{
			if (i==1)
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
	slitOrder1 = document.myForm.slitOrder1.value;
	slitOrder2 = document.myForm.slitOrder2.value;
		
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

	if (((width1 - fromWidth < 0) || (width1 - toWidth > 0)) && (slitOrder1 == '')){
		passEntered1 = prompt("<%=error_OddWidthNotOk%>","");
		if (passEntered1.toLowerCase() != pass)
			return false;
		else
			doNext = 1;
	}
	else
		doNext = 1;
	
	if (doNext == 1){
		if (((width2 - fromWidth < 0) || (width2 > toWidth > 0)) && (slitOrder2 == '')){
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
	slitOrder1 = document.myForm.slitOrder1.value;
	slitOrder2 = document.myForm.slitOrder2.value;
		
	if (document.myForm.roll1Hid.value == ""){
		alert("<%=error_missingRoll%>");
		return false;
	//}else if (document.myForm.width1.value == "" && slitOrder1 == ""){
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
	}else if (document.myForm.weight1.value == "" && slitOrder1 == ""){
		alert("<%=error_missingWeight1%>");
		return false;
	}else if (document.myForm.weight2.value == "" && slitOrder2 == ""){
		alert("<%=error_missingWeight2%>");
		return false;
	}else if (document.myForm.emp1.value == ""){
		alert("<%=error_missingEmp1%>");
		return false;
	}else if (document.myForm.emp2.value == ""){
		alert("<%=error_missingEmp2%>");
		return false;
	}else if (document.myForm.loc1.value == "" && slitOrder1 == ""){
		alert("<%=error_missingLoc1%>");
		return false;
	}else if (document.myForm.loc2.value == "" && slitOrder2 == ""){
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

function checkOrder(slitOrder){
	document.myForm.go.disabled=false;
	
	if (slitOrder.value != ""){
		allOrders = document.myForm.slitOrdersHID.value;
		
		if (allOrders.search(slitOrder.value) < 0){
			alert("Slitting order not Started!!!");
			slitOrder.value = "";
			document.myForm.go.disabled=true;
		}else{
		
			var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
			RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
			RejReas_Collection.MieServer = "<%=MIEServerURL%>";
			
			//set parameters
			RejReas_Collection.AddValue("cono", MvxCompany);
			RejReas_Collection.AddValue("Reference_Order", slitOrder.value);
			
			RejReas_Collection.CreateCollection("MO_GetLoadedRollItemData");//Run model
			
			if (RejReas_Collection.count == 0){
				alert("Slitting order doesn't exists!!!");
				slitOrder.value = "";
				document.myForm.go.disabled=true;
			}else{
				var oStd=RejReas_Collection.Item(0);//row
				
				lItem = oStd.GetValue("VMMTNO");
				
				loadedItem = document.myForm.itnoHid.value;
				
				if (lItem != loadedItem){
					document.myForm.go.disabled=true;
					alert("<%=error_wrongOrder1%>" + lItem + "<%=error_wrongOrder2%>" + loadedItem);
					slitOrder.value = "";
				}
			}
		}
	}
}	

function lengthAndWeightOk(){
	var deviationPermitted = <%=deviation%>;
	var length = document.myForm.length1.value;
	var weight = document.myForm.weight1.value;
	var width = document.myForm.width1.value;
	var density = document.myForm.densityHid.value;
	var ovi = document.myForm.txtOvi.value;
	var slitOrder1 = document.myForm.slitOrder1.value;
	
	if (ovi == "12")
		ovi = 12.5;
		
	if (ovi == "11")
		ovi = 11.2;
		
	if (mvxd.indexOf("1") >= 0)
		computedWeight = (length * width * ovi * density) / 1000000;
	else
		computedWeight = (length * width * ovi * density * 17.067725) / 1000000;
		
	var deviation = Math.abs(computedWeight - weight) / weight;
	
	aaa = new Number(computedWeight);
	
	if (deviation > deviationPermitted && slitOrder1 == ""){
		alert("<%=error_oddWeightNotOk%>" + " - " + aaa.toFixed(0));
		return false;
	}
	else{
		var length = document.myForm.length2.value;
		var weight = document.myForm.weight2.value;
		var width = document.myForm.width2.value;
		var slitOrder2 = document.myForm.slitOrder2.value;
		
		if (mvxd.indexOf("1") >= 0)
			computedWeight = (length * width * ovi * density) / 1000000;
		else
			computedWeight = (length * width * ovi * density * 17.067725) / 1000000;
			
		var deviation = Math.abs(computedWeight - weight) / weight;
		
		if (deviation > deviationPermitted && slitOrder2 == ""){
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
	
	RejReas_Collection.CreateCollection("MO_getDescription");//Run model
	
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

function continueTheJob(){	
	window.location.reload();
}

</SCRIPT>
</HEAD>


<BODY dir=<%=page_dir%> onload="onLoad()">
<!-- oncontextmenu="return false" -->
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

<P align="center"><B><FONT size="+2"><%=title_report%></FONT></B></P>
<P><BR>
<BR>

<form name="myForm" action="mwsfBioReportingAndSlit.jsp" method=post"" target="RepManWin">

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
	 <td align=<%=input_align%>><input type="text" name="txtThick" value="" border="0"  readonly class='readonly' size="5">
	 		<input type="hidden" name="txtOvi" value=""> </td>
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
			onChange='document.myForm.date2.value=document.myForm.date1.value;document.myForm.hour1.value="";
			document.myForm.hour2.value="";enableDo()'></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblHour%></td>
	<td align="<%=input_align%>"><input name="hour1" type="text" tabindex="9" value="<%=currentTimeStr%>"
			onChange="document.myForm.hour2.value=document.myForm.hour1.value;enableDo()">
	</td>
</tr>
<TR>
	<TD>&nbsp;</TD>
</TR>
<tr>
	<td align="<%=labels_align%>"><%=lblSlitOrder%></td>
	<td align="<%=input_align%>"><input name="slitOrder1" type="text" tabindex="10" value="<%=slitOrder1%>" onChange="checkOrder(this)">
	</td>
</tr>
</table></td>


</td>
<td><table border="0" cellpadding="0" valign="top">
<tr>
<th align="center" colspan="2"><%=lblEvenRoll%></th>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblRollNumber%></td>
	<td align="<%=input_align%>"><input name="rollNumber2" type="text" readonly class='readonly' 
				style="font-weight:bolder;color:blue"></td>
</tr> 
<tr>
	<td align="<%=labels_align%>"><%=lblLength%></td>
	<td align="<%=input_align%>"><input name="length2" type="text" tabindex="11" onChange="enableDo()"></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblWidth%></td>
	<td align="<%=input_align%>"><input name="width2" type="text" tabindex="12" onChange="enableDo()"></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblWeight%></td>
	<td align="<%=input_align%>"><input name="weight2" type="text" tabindex="13" onChange="enableDo()"></td>
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
	<td align="<%=input_align%>"><input name="date2" type="text" tabindex="15" value="<%=currentDateStr%>"
			onChange='document.myForm.hour2.value="";enableDo()'></td>
</tr>
<tr>
	<td align="<%=labels_align%>"><%=lblHour%></td>
	<td align="<%=input_align%>"><input name="hour2" type="text" tabindex="16" value="<%=currentTimeStr%>"
			onChange='enableDo()'>
	</td>
</tr>
<TR>
	<TD>&nbsp;</TD>
</TR>
<tr>
	<td align="<%=labels_align%>"><%=lblSlitOrder%></td>
	<td align="<%=input_align%>"><input name="slitOrder2" type="text" tabindex="17" value="<%=slitOrder2%>" onChange="checkOrder(this)">
	</td>
</tr>
</table></td>


</td>
</tr>
</table>
</div>
<br />
<% if (mvxd.indexOf("1") >= 0){ %>
	<div align="center"><%=lblPrint%><input type="checkbox" name="withLabels" value="yes" tabindex="18" checked>
<% }else{ %>
	<div align="center"><%=lblPrint%><input type="checkbox" name="withLabels" value="yes" tabindex="18" checked>
<% } %>
<p>
<INPUT type="button" name="exit" value="<%=exitBtn%>" class="myButton"  onclick="window.location='nipuah-extrusionAndSlitting.jsp'" tabindex="20">
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
<INPUT type="hidden" name="dateHid" value="<%=currentDateStr1%>">
<INPUT type="hidden" name="timeHid" value="<%=currentTimeStr1%>">
<INPUT type="hidden" name="empsHID">
<INPUT type="hidden" name="printTypeHID">
<INPUT type="hidden" name="micronHID">
<INPUT type="hidden" name="slitterHID">
<INPUT type="hidden" name="slitOrdersHID" value="<%=allOrders%>">
<INPUT type="hidden" name="sOrder1" value="<%=sOrder1%>">
<INPUT type="hidden" name="sOrder2" value="<%=sOrder2%>">
<INPUT type="hidden" name="slitter1">
<INPUT type="hidden" name="slitter2">

</form>



</body>
</html>

