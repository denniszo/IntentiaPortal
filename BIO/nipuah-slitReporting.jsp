<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@include file="nipuah-slitter-const1.jsp"%>
<%@include file="nipuah-slitter-labels-heb.jsp"%>
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
	
	String slitOrder1 = session.getAttribute("slitOrder1").toString();
	String slitOrder2 = session.getAttribute("slitOrder2").toString();
	String roll1 = session.getAttribute("roll1").toString();
	String roll2 = session.getAttribute("roll2").toString();
	String machine = session.getAttribute("machine").toString();
	String loadedItem = session.getAttribute("loadedItem").toString();
	String employee = session.getAttribute("employee").toString();
	
	String workSeq1 = session.getAttribute("workSeq1").toString();
	String workSeq2 = session.getAttribute("workSeq2").toString();
	String length1 = session.getAttribute("length1").toString();
	String length2 = session.getAttribute("length2").toString();
	String width1 = session.getAttribute("width1").toString();
	String width2 = session.getAttribute("width2").toString();
	String slitter1 = session.getAttribute("slitter1").toString();
	String slitter2 = session.getAttribute("slitter2").toString();
	
	
	
	String llength = "";
	String loadedRoll = "";
	String bioWorkSeq = "";
	String lwidth = "";
	String slitter = "";
	
	if (slitOrder1.equals("")){
		llength = length2;
		loadedRoll = roll2;
		bioWorkSeq = workSeq2;
		lwidth = width2;
		slitter = slitter2;
	}else{
		llength = length1;
		loadedRoll = roll1;
		bioWorkSeq = workSeq1;
		lwidth = width1;
		slitter = slitter1;
	}
	
int numOfLines = 0;
%>
<HTML>
<HEAD>


<META http-equiv="Content-Type"
	content="text/html; charset=windows-1255">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">


<LINK href="workplace.css" rel="stylesheet" type="text/css">

<style type="text/css">
input.myButton {width:150}
input.clReadonly {background-color:#F0F0F0;border-color:steelblue;border-width:1px;border-style:solid}
</style>

<TITLE>slitter-rollLoading.jsp</TITLE>
<SCRIPT language="javascript">

var MvxCompany = "<%=MvxCompany%>";
var slitOrder1 = "<%=slitOrder1%>";
var slitOrder2 = "<%=slitOrder2%>";
var roll1 = "<%=roll1%>";
var roll2 = "<%=roll2%>";
var mach;

if (mvxd.indexOf("1") >= 0)
	mach = "<%=slitter%>";
else
	mach = "<%=machine%>";

var loadedItem = "<%=loadedItem%>";
var employee = "<%=employee%>";
var delay;

function onLoad(){
	//alert("Prepare Slitting Data...");
	
	document.myForm.machine.value = mach;
	document.myForm.employee.value = employee;
	
	if (slitOrder1 != ""){
		document.myForm.orderNum.value = slitOrder1;
		
	}else{
		document.myForm.orderNum.value = slitOrder2;

	}
		
	getOrderItem();
	
	document.myForm.weight1.focus();
}

function getOrderItem(){
	
	
	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	
	//set parameters
	RejReas_Collection.AddValue("cono", MvxCompany);
	RejReas_Collection.AddValue("Reference_Order", document.myForm.orderNum.value);
		
	RejReas_Collection.CreateCollection("MO_GetLoadedRollItemData");//Run model
	
	if (RejReas_Collection.count > 0){
		var oStd=RejReas_Collection.Item(0);//row
		
		parit = "";
		
		mySug = oStd.GetValue("MMITGR");
		sug = mySug.substring(1,4);
		charac = oStd.GetValue("MMITCL");
		lItem = oStd.GetValue("VMMTNO");
		
		if (charac == "")
			parit = sug;
		else
			parit = sug + " " + charac;
			
		gauge = oStd.GetValue("MMCFI3");
		
		document.myForm.typeHID.value = sug;	
		document.myForm.micronHID.value = findTeur("CFI3", gauge, "description");	
		document.myForm.gaugeHID.value = findTeur("CFI3", gauge, "name");	
	}else
		lItem = "";
	
	RejReas_Collection=null;
	
	if (lItem == loadedItem){
		initLines();
			
		var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
		RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
		RejReas_Collection.MieServer = "<%=MIEServerURL%>";
		
		RejReas_Collection.AddValue("cono", MvxCompany);
		RejReas_Collection.AddValue("Reference_Order", document.myForm.orderNum.value);
		RejReas_Collection.CreateCollection("MO_GetSlitterInputItem");//Run model
		
		var numOfLines = 0;
		
		if (RejReas_Collection.count > 0){
			var found = false;
			for (var i = 0; i < RejReas_Collection.count && ! found; i++){
				var oStd=RejReas_Collection.Item(i);//row
				
				var orderMachine = oStd.GetValue("MACHINE");
				
				if (orderMachine != "99")
					found = true;
			}
			
			var currMachine = document.myForm.machine.value;
			
			
			document.myForm.orderItemHID.value = oStd.GetValue("VMMTNO");
			document.myForm.machineHID.value = oStd.GetValue("VOPLGR");
			document.myForm.materialStatusHID.value = oStd.GetValue("VMWMST");
			document.myForm.precisionProducedHID.value = oStd.GetValue("PRECIS");
			document.myForm.go.disabled = false;
			document.myForm.rollNumber.disabled = false;
			
			numOfLines = RejReas_Collection.count;
			document.myForm.numOfLinesHID.value = numOfLines;
			
			addLines(numOfLines);
			line = 0;
			var lastSeder = "";
			
			for (var i = 0; i < numOfLines; i++){
				var oStd=RejReas_Collection.Item(i);//row
				
				materialStatus = document.myForm.materialStatusHID.value;
				
				itemNo = oStd.GetValue("VMPRNO");
				sug =  oStd.GetValue("MMITGR");
				orSug =  oStd.GetValue("ORSUG");
				speSug =  oStd.GetValue("MMSPE1");
				gauge = oStd.GetValue("MMCFI3");
				charac = oStd.GetValue("MMITCL");
				widthMm = oStd.GetValue("MMCFI1");
				widthInch = oStd.GetValue("MMCFI4");
				cf = oStd.GetValue("MMCFI5");
				wantedLength = oStd.GetValue("MMDIM2");
				kind = oStd.GetValue("MMITTY");
				done = oStd.GetValue("DONE");
				wanted = oStd.GetValue("WANTED");
				workSeq = oStd.GetValue("VHWOSQ");
				custOrder =  oStd.GetValue("VHRORN");
				seder = oStd.GetValue("VHWCLN");
				MOrder = oStd.GetValue("VHMFNO");
				sstatus = oStd.GetValue("VMWMST");
				tmp = oStd.GetValue("VHMAQA");
				unit = oStd.GetValue("PROD_UNITS");
				weightDefault = oStd.GetValue("MMCFI2");
				
				if (sstatus != materialStatus){
					if (sstatus < materialStatus)
						document.myForm.materialStatusHID.value = sstatus;
				}
						
				
				
				var inch = '"';
				widthInch = findTeur("CFI4", widthInch, "description");
				widthMm = findTeur("CFI1",widthMm, "description");
				
				//if (itemNo.substring(0,2)=="33" || itemNo.substring(0,1) == "B")
				if (itemNo.substring(0,2)=="33" || mvxd.indexOf("1") < 0)
					width = widthInch + inch;
				else
					width = widthMm + "<%=unit_mm%>";
					
				k = i+1;
				
				if (line % 2 == 1)
					eval("document.all.tbl" + k + ".bgColor  = '#6F6FFF'");
					//A1A1A1		9FCFEF
				else
					eval("document.all.tbl" + k + ".bgColor  = '#E5E5E5'");
					
				if (charac != "")
					eval("document.myForm.characHID" + k + ".value = '" + findTeur("ITCL", charac, "description") + "'");
					
				if (speSug == "")
					eval("document.myForm.sug" + k + ".value = '" + findTeur("ITGR", sug, "description") + "'");
				else{
					eval("document.myForm.sug" + k + ".value = '" + speSug + "'");
					eval("document.myForm.characHID" + k + ".value = ''");
				}
				
				eval("document.myForm.no" + k + ".value = " + line);
				eval("document.myForm.charac" + k + ".value = '" + charac + "'");
				
				gauge = oStd.GetValue("MMCFI3");
				eval("document.myForm.micron" + k + ".value = '" + findTeur("CFI3", gauge, "description") + "'");
				eval("document.myForm.gauge" + k + ".value = '" + findTeur("CFI3", gauge, "name") + "'");
				
				eval("document.myForm.orSug" + k + ".value = '" + orSug + "'");
				eval("document.myForm.width" + k + ".value = '" + width + "'");
				
				if (widthMm != "")
					eval("document.myForm.widthMm" + k + ".value = " + widthMm);
					
				if(widthInch != "")
					eval("document.myForm.widthInch" + k + ".value = " + widthInch);
					
				eval("document.myForm.sugParit" + k + ".value = '" + itemNo.substring(0,2) + "'");
				eval("document.myForm.parit" + k + ".value = '" + itemNo + "'");
				eval("document.myForm.cf" + k + ".value = " + cf);
				eval("document.myForm.cfHID" + k + ".value = " + cf);
				eval("document.myForm.mOrder" + k + ".value = '" + MOrder + "'");
				eval("document.myForm.unit" + k + ".value = '" + unit + "'");
				
				if (custOrder != "")
					eval("document.myForm.custOrder" + k + ".value = '" + custOrder + "'");
				
				if (kind == "03" || kind == "04"){
					eval("document.myForm.kindWanted" + k + ".value = 'B'");
					//eval("document.myForm.qty" + k + ".value = 1");
				}else if (kind == "02"){
					eval("document.myForm.kindWanted" + k + ".value = 'J'");
					//eval("document.myForm.qty" + k + ".value = 1");
				}else if (kind == "08"){
					eval("document.myForm.kindWanted" + k + ".value = 'S'");
				}else
					eval("document.myForm.kindWanted" + k + ".value = 'G'");
				
				eval("document.myForm.kind" + k + ".value = '" + kind + "'");
				eval("document.myForm.workSeq" + k + ".value = '" + workSeq + "'");
				
				if (wantedLength != "" && (kind == "06" || kind == "07")){
					eval("document.myForm.length" + k + ".value = '" + wantedLength + "'");
					eval("document.myForm.lengthHID" + k + ".value = '" + wantedLength + "'");
				}
				
				if (wanted != ""){
					eval("document.myForm.wanted" + k + ".value = " + wanted);
					eval("document.myForm.wantedHID" + k + ".value = " + wanted);
				}
					
				//if (done != "")
				//	eval("document.myForm.done" + k + ".value = " + done);	
				
				if (tmp.charAt(0) == ".")
					tmp = "0" + tmp;
					
				if (kind == "05" || kind == "08")
					eval("document.myForm.done" + k + ".value = '" + formatWeight(tmp, 0) + "'");
				else
					eval("document.myForm.done" + k + ".value = '" + formatWeight(tmp, 1) + "'");
					
				eval("document.myForm.weightDefaultHID" + k + ".value = '" + weightDefault + "'");
					
				document.myForm.orderItemHID.value = oStd.GetValue("VMMTNO");
				document.myForm.reservationDateHID.value = oStd.GetValue("VMRDAT");
				document.myForm.densityHID.value = oStd.GetValue("MMDIM1");	
			}
			
			document.myForm.go.disabled = false;
			
			//get default weight and length
			for (var i = 0; i < numOfLines; i++){
				k= i+1;
				
				itemNumber = eval("document.myForm.parit" + k + ".value");
				paritSample = "45" + itemNumber.substring(2,9) + itemNumber.substring(13,14);
				eval("document.myForm.paritSample" + k + ".value = '" + paritSample + "'");
					
				if (eval("document.myForm.kindWanted" + k + ".value == 'G'") || eval("document.myForm.kindWanted" + k + ".value == 'S'")){
					sugParit = eval("document.myForm.kind" + k + ".value");
					
					var getDefault_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
					getDefault_Collection.ApplicationID = "<%=MIEAppID%>";
					getDefault_Collection.MieServer = "<%=MIEServerURL%>";
					
					getDefault_Collection.AddValue("cono", MvxCompany);
					getDefault_Collection.AddValue("itemNumber", itemNumber);
					getDefault_Collection.CreateCollection("MO_GetItemDefaultWeightAndLength");//Run model
					
					if (getDefault_Collection.count > 0){	
						num = getDefault_Collection.count;
						
						for (j=0;j<num;j++){
							var oStd=getDefault_Collection.Item(j);//row
				
							key = oStd.GetValue("KEY");
							value = oStd.GetValue("VALUE");
						
							if (mvxd.indexOf("1") >= 0){
								if (key == "KG" && (sugParit == "05" || ((sugParit == "06" || sugParit == "07") && unit == "ROL")))
									eval("document.myForm.weight" + k + ".value = '" + value + "'");
								if (key == "ROL" && (sugParit == "06" || sugParit == "07"))
									eval("document.myForm.weight" + k + ".value = '" + value + "'");
								else if (key == "MTR" && (sugParit == "05" || ((sugParit == "06" || sugParit == "07") && unit == "ROL"))){
									eval("document.myForm.length" + k + ".value = '" + formatWeight(value,0) + "'");
									eval("document.myForm.lengthHID" + k + ".value = '" + formatWeight(value,0) + "'");
								}else if (key == "FT")
									eval("document.myForm.lengthFT" + k + ".value = '" + formatWeight(value,0) + "'");
							}else{
								if (key == "LBS" && (sugParit == "05" || sugParit == "08"))
									eval("document.myForm.weight" + k + ".value = '" + value + "'");
								if (key == "ROL" && sugParit == "06")
									eval("document.myForm.weight" + k + ".value = '" + value + "'");
								else if (key == "FT" && (sugParit == "05" || sugParit == "08")){
									eval("document.myForm.length" + k + ".value = '" + formatWeight(value,0) + "'");
									eval("document.myForm.lengthFT" + k + ".value = '" + formatWeight(value,0) + "'");
								}else if (key == "MTR")
									eval("document.myForm.lengthHID" + k + ".value = '" + formatWeight(value,0) + "'");
							}
						}
					}
					getDefault_Collection=null;
				}
			}
			
			//getSpecial width and printingCode
			for (var i = 0; i < numOfLines; i++){
				k= i+1;
				
				O_Order = eval("document.myForm.mOrder" + k + ".value");
				parit = eval("document.myForm.parit" + k + ".value");
				
				var getDefault_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
				getDefault_Collection.ApplicationID = "<%=MIEAppID%>";
				getDefault_Collection.MieServer = "<%=MIEServerURL%>";
				
				getDefault_Collection.AddValue("cono", MvxCompany);
				getDefault_Collection.AddValue("order", O_Order);
				getDefault_Collection.AddValue("Reference_Order", document.myForm.orderNum.value);
				getDefault_Collection.AddValue("item", parit);
				getDefault_Collection.CreateCollection("MO_GetAttributesOfOrder");//Run model
				
				if (getDefault_Collection.count > 0){	
					num = getDefault_Collection.count
					
					for (j=0;j<num;j++){
						var oStd=getDefault_Collection.Item(j);//row
						
						sug = oStd.GetValue("AHATID");
						
						if (sug == "WIDTH"){
							tmp = oStd.GetValue("AHATAN");
							if (tmp == "0" || tmp == "")
								tmp = oStd.GetValue("AHANUF");
							
							if (!(parseInt(tmp) == "0" || tmp == ""))
								eval("document.myForm.spWidth" + k + ".value = '" + formatWeight(tmp,0) + "'");
							else
								eval("document.myForm.spWidth" + k + ".value = ''");
						}
						if (sug == "PRINT"){
							tmp = oStd.GetValue("AHATAV");
							if (tmp != "")
								eval("document.myForm.printCode" + k + ".value = '" + tmp + "'");
							else
								eval("document.myForm.printCode" + k + ".value = ''");
						}
					}
				}else{
					eval("document.myForm.spWidth" + k + ".value = ''");
					eval("document.myForm.printCode" + k + ".value = ''");
				}
				getDefault_Collection=null;
			}
			
			//get customer order data for finished rolls
			for (var i = 0; i < numOfLines; i++){
				k= i+1;
				
				if (eval("document.myForm.kindWanted" + k + ".value == 'G'")){
					custOrder = eval("document.myForm.custOrder" + k + ".value");
					 
					if (custOrder != ""){
						var getDefault_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
						getDefault_Collection.ApplicationID = "<%=MIEAppID%>";
						getDefault_Collection.MieServer = "<%=MIEServerURL%>";
						
						getDefault_Collection.AddValue("cono", MvxCompany);
						getDefault_Collection.AddValue("custOrder", custOrder);
						
						if (mvxd.indexOf("1") >= 0)
							getDefault_Collection.AddValue("faci", "001");
						else
							getDefault_Collection.AddValue("faci", "200");
						
						getDefault_Collection.CreateCollection("MO_getCustomerSlitterOrderData");//Run model
						
						if (getDefault_Collection.count > 0){	
							num = getDefault_Collection.count
							
							var oStd=getDefault_Collection.Item(0);//row
							custName = oStd.GetValue("OKCUNM");
							custCode = oStd.GetValue("OKCUNO");
							
							weightUnit = oStd.GetValue("WEIGHT_SUG");
							speWeight = oStd.GetValue("SPE_WEIGHT");
							
							eval("document.myForm.specialLabelHID" + k + ".value = '" + oStd.GetValue("OKCFC8") + "'");
							
							twoLabels = oStd.GetValue("TWO_LABELS");
							
							if (twoLabels != '')
								eval("document.myForm.twoLabels" + k + ".value = '" + twoLabels + "'");
							
							if (speWeight != ''){
								parit = eval("document.myForm.parit" + k + ".value");
								
								var newDefault_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
								newDefault_Collection.ApplicationID = "<%=MIEAppID%>";
								newDefault_Collection.MieServer = "<%=MIEServerURL%>";
								
								newDefault_Collection.AddValue("cono", MvxCompany);
								newDefault_Collection.AddValue("itemNumber", parit);
								newDefault_Collection.CreateCollection("MO_GetItemDefaultWeightAndLength");//Run model
								
								if (newDefault_Collection.count > 0){
									num1 = newDefault_Collection.count;
									
									for (p=0;p<num1;p++){
										var std=newDefault_Collection.Item(p);//row
							
										key = std.GetValue("KEY");
										value = std.GetValue("VALUE");
										
										if (key == speWeight){
											eval("document.myForm.spWeight" + k + ".value = '" + value + "'");
											eval("document.myForm.weightUnit" + k + ".value = '" + weightUnit + "'");
										}
									}
								}										
							}
							
							var typeForCust = "";
							
							if (custCode != ""){
								parit = eval("document.myForm.parit" + k + ".value");
								
								// finds customer special request for that item
								var newDefault_Collection1 = new ActiveXObject("CCWrapperINet.MieCollection.5");
								newDefault_Collection1.ApplicationID = "<%=MIEAppID%>";
								newDefault_Collection1.MieServer = "<%=MIEServerURL%>";
								
								newDefault_Collection1.AddValue("cono", MvxCompany);
								newDefault_Collection1.AddValue("cust", custCode);
								newDefault_Collection1.AddValue("item", parit);
								newDefault_Collection1.CreateCollection("MO_GetTypeItemCust");//Run model
								
								if (newDefault_Collection1.count > 0){	
									oStd1=newDefault_Collection1.Item(0);//row
									
									if (oStd1.GetValue("ADD4") != ""){
										custItem = oStd1.GetValue("ADD4");
										eval("document.myForm.custItem" + k + ".value = '" + custItem + "'");
									}
									
									if (oStd1.GetValue("ADD3") != ""){
										subCustItem = oStd1.GetValue("ADD3");
										eval("document.myForm.subCustItem" + k + ".value = '" + subCustItem + "'");
									}
									
									orSug = eval("document.myForm.orSug" + k + ".value");
									
									line = oStd1.GetValue("TLTX60");
									typeForCust = parseText(line, orSug);
								}
							}
							
							if (custName != "")
								eval("document.myForm.custName" + k + ".value = '" + custName + "'");
							
							//orSug = eval("document.myForm.orSug" + k + ".value");
							
							if (mvxd.indexOf("1") >= 0)
								orSug = parit.substr(2,3);
							else
								orSug = parit.substr(1,3);
							
							if (orSug != ""){
								var newSug = "";
								var line = "";
								
								syfTypeCharac = trim(orSug) + trim(charac);
								
								for (j=0;j<num;j++){
									oStd=getDefault_Collection.Item(j);//row
									
									line = oStd.GetValue("TLTX60");
									
									if (syfTypeCharac != orSug){
										newSug = parseText(line, syfTypeCharac);
									
										if (newSug != ""){
											eval("document.myForm.sug" + k + ".value = '" + newSug + "'");
										}
									}
							
									newSug = parseText(line, orSug);
									
									if (charac == "H0" && newSug != "")
										newSug = newSug + " H";
							
									if (newSug != "")
										eval("document.myForm.sug" + k + ".value = '" + newSug + "'");
								}
							}
							
							if (typeForCust != "")
								eval("document.myForm.sug" + k + ".value = '" + typeForCust + "'");
						}
					}
				}
			}
			
			// get length of sample item for that item (only for "G" items)
			if (paritSample !== ""){
				var getDefault_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
				getDefault_Collection.ApplicationID = "<%=MIEAppID%>";
				getDefault_Collection.MieServer = "<%=MIEServerURL%>";
				
				getDefault_Collection.AddValue("cono", MvxCompany);
				getDefault_Collection.AddValue("itemNumber", paritSample);
				getDefault_Collection.CreateCollection("MO_GetSampleLength");//Run model
				
				if (getDefault_Collection.count > 0){	
					var oStd=getDefault_Collection.Item(0);//row
					//document.myForm.lengthSampleHID.value = oStd.GetValue("MMDIM2");
					eval("document.myForm.lengthSample" + k + ".value = '" + oStd.GetValue("MMDIM2") + "'");
				}
				getDefault_Collection=null;
			}
		}else{
			document.myForm.go.disabled = true;
			alert("<%=error_orderNotExists%>");
		}
		RejReas_Collection=null;	
		
		if (slitOrder1 != "")
			document.myForm.rollNumber.value = roll1;
		else
			document.myForm.rollNumber.value = roll2;
			
		document.myForm.lastBlockHID.value = 0;
		document.myForm.lastFinishedHID.value = 0;
		
		if (document.myForm.kindWanted1.value == 'J')
			changeDisplayedWidth();
		
		document.myForm.qty1.focus();
						
		document.myForm.go.disabled=false;
	}else{		
		alert("<%=error_wrongOrder1%>" + lItem + "<%=error_wrongOrder2%>" + loadedItem);
		document.myForm.orderNum.value = "";				
		document.myForm.orderNum.focus();
	}
}// end function getOrderItem()

function parseText(line, orSug){
	def = line.split("=");
	
	if (def.length = 2){
		if (def[0] == orSug)
			return def[1];
		else
			return "";
	} else 
		return "";
}	// end of function parseText(line, orSug)

function findTeur(field, key, sug){
	if (key == ""){
		return "";
	}else{
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
}

function initLines(){
	for (i=1; i<=40;i++){
		eval("myLine" + i + ".style.display = 'none'");
	
		eval("document.myForm.no" + i + ".value = ''");
		eval("document.myForm.charac" + i + ".value = ''");
		eval("document.myForm.width" + i + ".value = ''");
		eval("document.myForm.widthMm" + i + ".value = ''");
		eval("document.myForm.cf" + i + ".value = ''");
		eval("document.myForm.kindWanted" + i + ".value = ''");
		eval("document.myForm.qty" + i + ".value = '1'");
		eval("document.myForm.qtyHID" + i + ".value = '1'");
		eval("document.myForm.oldQtyHID" + i + ".value = '1'");
		eval("document.myForm.kind" + i + ".value = ''");
		eval("document.myForm.workSeq" + i + ".value = ''");
		eval("document.myForm.wanted" + i + ".value = ''");
		eval("document.myForm.wantedHID" + i + ".value = ''");
		eval("document.myForm.done" + i + ".value = ''");	
		eval("document.myForm.length" + i + ".value = '<%=llength%>'");	
		eval("document.myForm.lengthHID" + i + ".value = '<%=llength%>'");
		eval("document.myForm.weight" + i + ".value = ''");		
		eval("document.myForm.qaLabels" + i + ".value = ''");
		eval("document.myForm.location" + i + ".value = ''");
		eval("document.myForm.unit" + i + ".value = ''");	
		eval("document.myForm.weightDefaultHID" + i + ".value = ''");
	}	
	document.myForm.orderItemHID.value = '';
	document.myForm.densityHID.value = '';	
}

// this function reveales a new line for one more field
// the visibility of the new line is set to visible.
function addLines(x){
	for (i=1; i<=x;i++){
		eval("myLine" + i + ".style.display = ''");
	}
}

function changeDisplayedWidth(){
	numOfLines = document.myForm.numOfLinesHID.value;
	sourceWidth = document.myForm.loadedWidthHID.value;
	
	for (i=1;i<=numOfLines;i++){
		if (eval("document.myForm.kindWanted" + k + ".value == 'J'")){
			eval("document.myForm.width" + k + ".value = '" + sourceWidth + "'");
			eval("document.myForm.width" + k + ".readOnly = false");
			eval("document.myForm.width" + k + ".className = 'None'");
		}
	}
}		// end of function changeDisplayedWidth()
	
function loadAgain(){
	window.location.reload();
}

function returnToFirst(){	
	window.location='nipuah-extrusionAndSlitting.jsp';
}

function enableGoBtn(){
	document.myForm.go.disabled=false;
}

function redraw(){
	changeWidth.style.display = 'none';
	
	initLines();
	
	//window.setTimeout('getOrderItem()',60000);
	delay = window.setInterval('checkIfOrderAdded()',15000);
}	// end of function redraw()

function checkIfOrderAdded(){
	numOfLines = document.myForm.numOfLinesHID.value;
	
	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	
	RejReas_Collection.AddValue("cono", MvxCompany);
	RejReas_Collection.AddValue("Reference_Order", document.myForm.orderNum.value);
	RejReas_Collection.CreateCollection("MO_GetSlitterInputItem");//Run model
	
	if (RejReas_Collection.count > numOfLines){
		window.clearInterval(delay);
		getOrderItem();
	}
}	// end of function checkIfOrderAdded()

function slitReport(){
	document.myForm.go.disabled=true;
	if (allDataFull() && checkDateAndTime()){
		document.myForm.changeWidthHID.value = 0;
		document.myForm.go.disabled=true;
		var WinParam="<%=WinParam%>";
		document.myForm.go.disabled=true;
		var w = window.open("blank.jsp","RepManWin",WinParam);
		//var w = window.open("blank.jsp","RepManWin");
		
		if (!<%=debug%>)
			w.blur();
			
		document.myForm.submit();
	}else
		document.myForm.go.disabled=false;

}//end function loadRoll()

function weightOk(){
	var loadedWeight = document.myForm.loadedWeightHID.value;
	var totalWeight = 0;
	for (i=1;i<=numOfLines;i++){
		if (! (eval("document.myForm.qty" + i + ".value == ''") || eval("document.myForm.qty" + i + ".value == '0'"))){
			totalWeight = totalWeight*1 + eval("document.myForm.qty" + i + ".value") * eval("document.myForm.weight" + i + ".value");
		}
	}
	
	if ((totalWeight - loadedWeight) / loadedWeight < 0.05 )
		return true;
	else{
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
		var pass = "slit" + passNum;
		
		passEntered = prompt("<%=prompt_weightNotOK1%>" + totalWeight + "<%=prompt_weightNotOK2%>" + loadedWeight + "<%=prompt_weightNotOK1%>","");
		if (passEntered.toLowerCase() != pass)
			return false;
		else
			return true;
	}
}		//end of function weightOk()

function changeParit(parit, width){
	var sug = "";
	
	if (mvxd.indexOf("1") >= 0)
		sug = parit.substring(0, 2);
	else
		sug = parit.substring(0, 1);
	
	if (sug == "33" || sug == "B"){
		tmpWidth = Math.floor(width * 100) + "";
		
		switch (tmpWidth.length){
			case 1:
				newWidth = "000" + tmpWidth;
				break;
			case 2:
				newWidth = "00" + tmpWidth;
				break;
			case 3:
				newWidth = "0" + tmpWidth;
				break;
			case 4:
				newWidth = tmpWidth;
				break;
		}
		
		//length is 15
		if (mvxd.indexOf("1") >= 0)
			newParit = parit.substring(0,10) + newWidth + parit.substring(14);
		else
			newParit = parit.substring(0,9) + newWidth + parit.substring(13);
		
	}else{
		switch (width.length){
			case 1:
				newWidth = "000" + width;
				break;
			case 2:
				newWidth = "00" + width;
				break;
			case 3:
				newWidth = "0" + width;
				break;
			case 4:
				newWidth = width;
				break;
		}
		
		//length is 15
		newParit = parit.substring(0,9) + newWidth + parit.substring(13);
	}
	
	return newParit;
}	// end of function changeParit(parit)

function areLinesEntered(){
	found = false;
	numOfLines = document.myForm.numOfLinesHID.value;
		
	for (i=1;i<=numOfLines;i++){
		if (! (eval("document.myForm.qty" + i + ".value == ''") || eval("document.myForm.qty" + i + ".value == '0'"))){
			found = true;
			
			eval("document.myForm.qty" + i + ".value = '0'");
			eval("document.myForm.length" + i + ".value = ''");
			eval("document.myForm.weight" + i + ".value = ''");
			eval("document.myForm.qaLabels" + i + ".value = ''");
			eval("document.myForm.samples" + i + ".value = ''");
			eval("document.myForm.location" + i + ".value = ''");
		}
	}
	
	return found;	
}	// end of function areLinesEntered()

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
	if (document.myForm.lastBlockHID.value >= 9){
		alert("<%=error_moreThan9Blocks%>");
		return false;
	}else if (document.myForm.lastFinishedHID.value >= 99){
		alert("<%=error_moreThan99Rolls%>");
		return false;
	}else if (document.myForm.machine.value == ""){
		alert("<%=error_missingMachine%>");
		return false;
	}else if (document.myForm.orderNum.value == ""){
		alert("<%=error_missingOrder%>");
		return false;
	}else if (document.myForm.rollNumber.value == ""){
		alert("<%=error_missingRoll%>");
		return false;
	}else if (document.myForm.date.value == ""){
		alert("<%=error_missingDate%>");
		return false;
	}else if (document.myForm.hour.value == ""){
		alert("<%=error_missingHour%>");
		return false;
	}else if (document.myForm.employee.value == ""){
		alert("<%=error_missingEmployee%>");
		return false;
	}else if (document.myForm.kindWanted1.value == 'J' && document.myForm.loadedWidthHID.value == ""){
		alert("<%=error_missingWidth%>");
		return false;
	}else{
		numOfLines = document.myForm.numOfLinesHID.value;
		
		for (i=1;i<=numOfLines;i++){
			// cheks that if qry is entered, weight and length also entered
			if (! (eval("document.myForm.qty" + i + ".value == ''") || eval("document.myForm.qty" + i + ".value == '0'"))){
				if (eval("document.myForm.length" + i + ".value == ''")){
					alert("<%=error_missingLength%>" + i);
					return false;
				}else if (eval("document.myForm.weight" + i + ".value == ''")){
					alert("<%=error_missingWeight%>" + i);
					return false;
				}
			}else
				eval("document.myForm.qty" + i + ".value = '0'");
		
	
		}
		return true;
	}
}

function otherQtyNull(profile, line){
	for (j=1;j<=numOfLines;j++){
		if (eval("document.myForm.no" + j + ".value == " + profile) && (j != line)){
			if (eval("document.myForm.qty" + j + ".value == ''"))
				return true;
		}
	}
	eval("document.myForm.qty" + line + ".value = '0'")
	return false;
}	//end of function otherQtyNull(profile)

function lengthAndWeightOk(i){
	var kind = eval("document.myForm.kind" + i + ".value");
	
	if (kind == "06"){
		length = eval("document.myForm.length" + i + ".value");
		oldLength = eval("document.myForm.lengthHID" + i + ".value");
		oldWeight = eval("document.myForm.weight" + i + ".value");
		
		aaa = formatWeight(oldWeight * length / oldLength, 2);
		
		eval("document.myForm.weight" + i + ".value = '" + aaa + "'");
		eval("document.myForm.lengthHID" + i + ".value = '" + length + "'");
	}
	
	if (kind =="05"){
		precision = document.myForm.precisionProducedHID.value;
		length = eval("document.myForm.length" + i + ".value");
		oldLength = eval("document.myForm.lengthHID" + i + ".value");
		oldWeight = eval("document.myForm.weight" + i + ".value");
		oldQty = eval("document.myForm.oldQtyHID" + i + ".value");
		
		if (precision == 0)
			eval("document.myForm.length" + i + ".value = '" + oldLength + "'");
		else{
			aaa = formatWeight(oldWeight * length / oldLength, 2);
			
			eval("document.myForm.weight" + i + ".value = '" + aaa + "'");
			eval("document.myForm.lengthHID" + i + ".value = '" + length + "'");
			
			aaa = formatWeight(Math.round(oldQty * length / oldLength * 10)/10, 1);
			bbb = oldQty * length / oldLength;
			
			eval("document.myForm.qtyHID" + i + ".value = '" + aaa + "'");
			eval("document.myForm.oldQtyHID" + i + ".value = '" + bbb + "'");
		}
	}
	
	var deviationPermitted = <%=slitDeviation%>;
	var density = document.myForm.densityHID.value;
	var ovi = eval("document.myForm.micron" + i + ".value");
	var length = eval("document.myForm.length" + i + ".value");
	var weight = eval("document.myForm.weight" + i + ".value");
	
	if (kind == '02')
		width = eval("document.myForm.width" + i + ".value");
	else{
		if (mvxd.indexOf("1") >= 0)
			width = eval("document.myForm.widthMm" + i + ".value");
		else
			width = eval("document.myForm.widthInch" + i + ".value");
	}
	
	var cf = eval("document.myForm.cf" + i + ".value");
	
	if (!(length == "" || weight == "")){
		var computedWeight; 
		
		if (mvxd.indexOf("1") >= 0)
			computedWeight = (length * width * cf * ovi * density) / 1000000;
		else
			computedWeight = (length * width * cf * ovi * density * 17.067725) / 1000000;
			
		var deviation = Math.abs(computedWeight - weight) / weight;
		
		if (deviation > deviationPermitted){
			alert("<%=error_weightNotOk%>" + i + " - " + computedWeight);
			//alert("<%=error_weightNotOk%>" + i);
			document.myForm.go.disabled = true;
		}else{
			document.myForm.go.disabled = false;
		}		
	}
}

function checkQty(i){
	var wanted = eval("document.myForm.wanted" + i + ".value");
	var done = eval("document.myForm.done" + i + ".value");
	var qty = eval("document.myForm.qty" + i + ".value");
	var cf = eval("document.myForm.cf" + i + ".value");
	var sug = eval("document.myForm.kind" + i + ".value");
	
	if (sug == "05"){
		if (cf == 1)
			tooMuch = 3;
		else
			tooMuch = 5;
	}else
		tooMuch = 1;
		
	if (done == "")
		done = 0;
	
	result = done * 1 + qty * 1 - wanted - tooMuch;

	if (result > 0){
		
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
		var pass = "slit" + passNum;
		
		passEntered = prompt("<%=prompt_QtNotOK1%>" + i + "<%=prompt_QtNotOK2%>","");
		if (passEntered.toLowerCase() != pass)
			document.myForm.go.disabled = true;
		else
			document.myForm.go.disabled = false;
	}else
		document.myForm.go.disabled = false;
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

function employeeExists(){
	var empStr = document.myForm.empsHID.value;
	var emp = "";
	
	if (mvxd.indexOf("1") >= 0)
		emp = ",E" + document.myForm.employee.value + ",";
	else
		emp = ",UE" + document.myForm.employee.value + ",";

	if (empStr.search(emp) >= 0){
		return true;
	}else{
		alert("<%=error_employeeNotExists%>");
		return false;
	}
}//end function employeeExists()

function updateUnit(source){
	var newParit = source.value;
	
	if (newParit.substring(0,2) == "33" || newParit.substring(0,1) == "B"){
		document.myForm.newUnit.value = "<%=unit_inch%>"
		document.myForm.newUnitHID.value = "<%=unit_inch%>"
	}else{
		document.myForm.newUnit.value = "<%=unit_mm%>"
		document.myForm.newUnitHID.value = "<%=unit_mm%>"
	}
}	// end of function updateUnit()

function exitWindow(){
	if (confirm("<%=error_closeWithoutReporting%>"))
		window.location='nipuah-extrusionAndSlitting.jsp';
}

function saderD(date){
	date.value = saderDate(date.value);
}

function saderT(time){
	time.value = saderTime(time.value);
}

function checkQtyLbl(qty){
	if (qty.value > 10){
		alert("<%=error_tooMuchMoreThan10%>");
		qty.value = "";
	}
}

</SCRIPT>
</HEAD>


<BODY dir=<%=page_dir%> onload="onLoad()">
<!-- oncontextmenu="return false" -->
<%
String currentDateStr = "";
String currentDateStr1 = "";
String currentTimeStr1 = "";
String currentTomorowStr = "";

int myYear = Integer.parseInt(myDate.substring(0,4)) - 1900;
int myMonth = Integer.parseInt(myDate.substring(4,6)) - 1;
int myDay = Integer.parseInt(myDate.substring(6,8));
int myHour = Integer.parseInt(myTime.substring(0,2));
int myMin = Integer.parseInt(myTime.substring(2,4));
int mySec = Integer.parseInt(myTime.substring(4,6));

Calendar cal = Calendar.getInstance();
Calendar tomorow = Calendar.getInstance();
cal.set(myYear,myMonth,myDay,myHour,myMin,mySec);
tomorow.setTimeInMillis(cal.getTimeInMillis() + 86400000);

if (mvxd.indexOf("1") >= 0){
	currentDateStr1 = DateFormat.getDateInstance(DateFormat.SHORT).format(cal.getTime());
	currentTomorowStr = DateFormat.getDateInstance(DateFormat.SHORT).format(tomorow.getTime());
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
	tomorow.add(Calendar.HOUR_OF_DAY, difHours);
	
	currentDateStr1 = DateFormat.getDateInstance(DateFormat.SHORT).format(cal.getTime());
	currentTomorowStr = DateFormat.getDateInstance(DateFormat.SHORT).format(tomorow.getTime());
	
	currentDateStr = currentDateStr1.substring(3,5) + currentDateStr1.substring(0,2) + currentDateStr1.substring(6,8);

	currentTimeStr1 = DateFormat.getTimeInstance(DateFormat.SHORT).format(cal.getTime());
}

String currentTimeStr = currentTimeStr1.substring(0,2) + currentTimeStr1.substring(3,5);
%>

<P align="center"><B><FONT size="+2"><%=title_slitReporting%></FONT></B><BR>
<font size="+1">
<% if (! slitOrder1.equals("")){ %>
	<font color=blue><%=roll1%></font>
<% }else{ %>
	<font color=red><%=roll2%></font>
<% } %>

</font></P>
<P><BR>
<BR>
</P>
<DIV align="center">
<FORM name = "myForm" action="nipuah-doSlitReporting.jsp" target="RepManWin" method="POST">
<TABLE border="0">
	<TBODY align="center">
		<TR>
			<TD align="<%=labels_align%>"><%=lblMachine%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="machine" size="5" tabindex="1" readonly class='clReadonly'></TD>
			<TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
			<TD align="<%=labels_align%>"><%=lblMoNumber%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="orderNum" size="10" tabindex="2" onchange="getOrderItem()"></TD>
			<TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
			<TD align="<%=labels_align%>"><%=lblRollNumber%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="rollNumber" size="10" tabindex="3" readonly class='clReadonly'></TD>			
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>
		<TR>
			<TD align="<%=labels_align%>"><%=reportDate%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="date" 
					value='<%=currentDateStr%>' size="10"></TD>
			<TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
			<TD align="<%=labels_align%>"><%=reportHour%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="hour" 
					value='<%=currentTimeStr%>' size="10"></TD>
			<TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>		
			<TD align="<%=labels_align%>"><%=lblEmp%></TD>
			<TD align="<%=input_align%>"><INPUT type="text" name="employee" size="10" tabindex="6" readonly class='clReadonly'></TD>
		</TR>
		<TR>
			<TD align="center"></TD>
			<TD align="center"></TD>
		</TR>		
	</TBODY>
</TABLE>

<p>&nbsp;<p>
<% // this loop creates 25 "div", only 3 are visible in the begining.
   // before the first one there are headers.
int i = 1;

for (i=1; i<=40;i++){
	if (i < numOfLines+1){ %>
		<div id='myLine<%=i%>' align=right style='display:on'>
	<% }else{ %>
		<div id='myLine<%=i%>' align=right style='display:none'>
	<% } %>
	<center>
	<table border="0" id="tbl<%=i%>">
	<% if (i == 1){ %>
		<tr bgColor="#E5E5E5">
			<th><%=lblNo%></th>
			<th><%=lblCharac%></th>	
			<th><%=lblThick%></th>		
			<th><%=lblWidth%></th>
			<th><%=lblCF%></th>
			<th><%=lblKind%></th>
			<!--<th><%=lblLengthWanted%></th>-->
			<th><%=lblWanted%></th>
			<th><%=lblDone%></th>
			<th>&nbsp;&nbsp;&nbsp;</th>
			<th><%=lblQuantity%></th>
			<th><%=lblLength%></th>
			<th><%=lblWeight%></th>
			<th><%=lblQALabels%></th>
			
			<% if (mvxd.indexOf("1") >= 0){ %>
				<th><%=lblSamples%></th>
			<% } %>
			
			<th><%=lblLocation%></th>
		</tr>
	<% } %>

	<tr>
		<TD align="<%=input_align%>"><INPUT type="text" name="no<%=i%>" value="" size=1  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="charac<%=i%>" value="" size=1  readonly class='clReadonly'>
			<INPUT type="hidden" name="sug<%=i%>" value="">
			<INPUT type="hidden" name="characHID<%=i%>" value=""></td>
		
		<% if (mvxd.indexOf("1") >= 0){ %>
			<TD align="<%=input_align%>"><INPUT type="text" name="micron<%=i%>" value="" size=1  readonly class='clReadonly'>
				<INPUT type="hidden" name="gauge<%=i%>" value=""></td>
		<% }else{ %>
			<TD align="<%=input_align%>"><INPUT type="text" name="gauge<%=i%>" value="" size=1  readonly class='clReadonly'>
				<INPUT type="hidden" name="micron<%=i%>" value=""></td>
		<% } %>
		
		<TD align="<%=input_align%>"><INPUT type="text" name="width<%=i%>" value="" size=5  readonly class='clReadonly'
				onchange='document.myForm.loadedWidthHID.value=this.value'>
			<INPUT type="hidden" name="widthMm<%=i%>" value="">
			<INPUT type="hidden" name="widthInch<%=i%>" value="">
			<INPUT type="hidden" name="sugParit<%=i%>" value="">
			<INPUT type="hidden" name="parit<%=i%>" value="">
			<INPUT type="hidden" name="custOrder<%=i%>" value="">
			<INPUT type="hidden" name="custName<%=i%>" value="">
			<INPUT type="hidden" name="custItem<%=i%>" value="">
			<INPUT type="hidden" name="subCustItem<%=i%>" value="">
			<INPUT type="hidden" name="orSug<%=i%>" value="">
			<INPUT type="hidden" name="mOrder<%=i%>" value="">
			<INPUT type="hidden" name="paritSample<%=i%>" value="">
			<INPUT type="hidden" name="lengthSample<%=i%>" value="">
			<INPUT type="hidden" name="spWidth<%=i%>" value="">
			<INPUT type="hidden" name="printCode<%=i%>" value="">
			<INPUT type="hidden" name="spWeight<%=i%>" value="">
			<INPUT type="hidden" name="weightUnit<%=i%>" value="">
			<INPUT type="hidden" name="twoLabels<%=i%>" value="">
			<INPUT type="hidden" name="unit<%=i%>" value="">
			<INPUT type="hidden" name="weightDefaultHID<%=i%>" value="">
			<INPUT type="hidden" name="specialLabelHID<%=i%>" value=""></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="cf<%=i%>" value="" size=1  readonly class='clReadonly'>
			<INPUT type="hidden" name="cfHID<%=i%>" value="" size=1></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="kindWanted<%=i%>" value="" size=1  readonly class='clReadonly'>
			<INPUT type="hidden" name="kind<%=i%>" value=""></td>
		<!--<TD align="<%=input_align%>"><INPUT type="text" name="wantedLength<%=i%>" value="" size=5  readonly class='clReadonly'></td>-->
		<TD align="<%=input_align%>"><INPUT type="text" name="wanted<%=i%>" value="" size=1  readonly class='clReadonly'>
			<INPUT type="hidden" name="wantedHID<%=i%>" value=""></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="done<%=i%>" value="" size=1  readonly class='clReadonly'></td>
		<th>&nbsp;&nbsp;&nbsp;</th>
		
		<TD align="<%=input_align%>"><INPUT type="text" name="qty<%=i%>" value="" size=1 tabindex=""
						onChange='checkQty(<%=i%>)'>
						<INPUT type="hidden" name="qtyHID<%=i%>" value="1">
						<INPUT type="hidden" name="oldQtyHID<%=i%>" value="1"></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="length<%=i%>" value="<%=llength%>" size=5 tabindex="" 
						onChange='lengthAndWeightOk(<%=i%>)'>
						<INPUT type="hidden" name="lengthFT<%=i%>" value="">
						<INPUT type="hidden" name="lengthHID<%=i%>" value="<%=llength%>"></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="weight<%=i%>" value="" size=5 tabindex="6*<%=i%>+3" 
						onChange='lengthAndWeightOk(<%=i%>)'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="qaLabels<%=i%>" value="" size=5 tabindex="6*<%=i%>+4" onblur='checkQtyLbl(this)'></td>
		
		<% if (mvxd.indexOf("1") >= 0){ %>
			<TD align="<%=input_align%>"><INPUT type="text" name="samples<%=i%>" value="" size=5 tabindex="6*<%=i%>+5" onblur='checkQtyLbl(this)'></td>
		<% }else{ %>
			<INPUT type="hidden" name="samples<%=i%>">
		<% } %>
	
		<TD align="<%=input_align%>"><INPUT type="text" name="location<%=i%>" value="" size=5 tabindex="6*<%=i%>+6">
			<INPUT type="hidden" name="workSeq<%=i%>" value=""></td>
	</tr>
	</TABLE>
	</div>
<% } %>
<p><div align="center"><%=lblLabels%><input type="checkbox" tabindex="6*<%=i%>+7" name="withLabels" value="yes" checked>
<% if (mvxd.indexOf("1") >= 0){ %>
	&nbsp;&nbsp;&nbsp;<%=lblSpliced%><input type="checkbox" name="spliced" value="yes"> 
<% } %>
<p>
<INPUT type="button" name="exit" value="<%=exitBtn%>" class="myButton"  onclick="exitWindow()" tabindex="6*<%=i%>+9">
&nbsp;&nbsp;&nbsp;
<INPUT type="button" name="go" value="<%=doBtn%>" class="myButton" onclick="slitReport()" tabindex="6*<%=i%>+8">


<INPUT type="hidden" name="orderItemHID">
<INPUT type="hidden" name="reservationDateHID">
<INPUT type="hidden" name="rollNumberHID">
<INPUT type="hidden" name="allMachinesHID">
<INPUT type="hidden" name="empsHID">
<INPUT type="hidden" name="numOfLinesHID">
<INPUT type="hidden" name="densityHID">
<INPUT type="hidden" name="loadedWeightHID">
<INPUT type="hidden" name="loadedWidthHID">
<INPUT type="hidden" name="loadedLengthHID">
<INPUT type="hidden" name="lastBlockHID">
<INPUT type="hidden" name="lastFinishedHID">
<INPUT type="hidden" name="typeHID">
<INPUT type="hidden" name="attrReferenceHID">
<INPUT type="hidden" name="wrhHID">
<INPUT type="hidden" name="simuhin1HID">
<INPUT type="hidden" name="simuhin2HID">
<INPUT type="hidden" name="changeWidthHID">
<INPUT type="hidden" name="micronHID">
<INPUT type="hidden" name="gaugeHID">
<INPUT type="hidden" name="newParitHID">
<INPUT type="hidden" name="newParitUnitHID">
<INPUT type="hidden" name="newParitWeightHID">
<INPUT type="hidden" name="toMorowHID" value='<%=currentTomorowStr%>'>
<INPUT type="hidden" name="paritSampleHID">
<INPUT type="hidden" name="lengthSampleHID">
<INPUT type="hidden" name="machineHID">
<INPUT type="hidden" name="materialStatusHID">
<INPUT type="hidden" name="materialStatusLowHID">
<INPUT type="hidden" name="precisionHID">
<INPUT type="hidden" name="precisionProducedHID">

<INPUT type="hidden" name="loadedRoll" value='<%=loadedRoll%>'>
<INPUT type="hidden" name="bioWorkSeq" value='<%=bioWorkSeq%>'>
<INPUT type="hidden" name="lwidth" value='<%=lwidth%>'>
<INPUT type="hidden" name="llength" value='<%=llength%>'>

</FORM>
</DIV>
</BODY>
</HTML>
