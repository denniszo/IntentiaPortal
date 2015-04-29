<%@ page import = "Slitter.*"%>
<%@ page import = "java.math.BigInteger"%>
<%@include file="nipuah-slitter-const.jsp"%>
<%@include file="nipuah-slitter-labels-heb.jsp"%>
<%@include file="../rollsAndLabels.jsp"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.SQLException"%>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.PreparedStatement"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.util.Iterator"%> 
<%@ page import = "java.util.List"%>
<%@ page import = "java.util.ArrayList"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.util.Iterator,
    com.intentia.mie.IMieEntity" %>
<%@ page import = "com.intentia.mie.IMieCollection" %>
<%@ page import = "com.intentia.mie.MieCollectionFactory" %>
<%@ page import = "java.io.File"%>

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


<html>
<head>
	<TITLE>Slitter Reporting</TITLE>
	<%@ page 
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	%>
	<META http-equiv="Content-Type"
		content="text/html; charset=UTF-8">
	<META name="GENERATOR" content="IBM WebSphere Studio">
	<META name=VI60_defaultClientScript content=JavaScript>
	<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
</head>
<body  class="ibrx_Bg02"  dir="rtl" marginwidth="0" marginheight="0" topmargin="0" leftmargin="0" LANGUAGE=javascript">
<p>test</p>
<%	    
	int i_rejQty;
	DecimalFormat df = new DecimalFormat("#0.0");
	String mie=String.valueOf(MIEAppID);
	String mvx = String.valueOf(MvxCompany);
	
	String MIEserverURLHardCoded = "http://" + request.getServerName() + "/MIE50/MieIsapi.dll";
	
	String date = request.getParameter("date");
	
	String myDate = "";
	String faci = "";
	
	if (mvxd.indexOf("1") >= 0){
		myDate = "20"+date.substring(6,8)+date.substring(3,5)+date.substring(0,2);
		faci = "001";
	}else{
		myDate = "20"+date.substring(6,8)+date.substring(0,2)+date.substring(3,5);
		faci = "200";
	}
	
	String time = request.getParameter("hour");
	
	String orderNum = request.getParameter("orderNum");
	String machine = request.getParameter("machine");
	String jumbo1Weight = request.getParameter("jumbo1WeightHID");
	String jumbo2Weight = request.getParameter("jumbo2WeightHID");
	
	String prodDate = "";
	
	double originWeight = 0;
	
	boolean doTheJob = true;
	String printer = "";
	boolean withLabels = false;
	String addLabels = request.getParameter("withLabels");
	String emp = request.getParameter("employee");		
	
	//find the origin weight of the roll
	Connection dbConn = null;
	try {
      Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");

      //db name
      String dbName = "Movex";     
      String url = "jdbc:odbc:" + dbName;
      
      dbConn = DriverManager.getConnection(url, mws_username, mws_password);
      out.println(dbConn.toString() + "<BR>");
      out.flush();

    } catch (SQLException ex) { // Handle SQL errors
      	out.println(ex.toString() + "<BR>");
    } catch (ClassNotFoundException ex1) {
     	out.println(ex1.toString() + "<BR>");
    }
	
	PreparedStatement stmt = null;
	ResultSet rs = null;
		
	String sql = "select * from seijdta.syfslitfold as AA where AA.MACHINE = ? and AA.TEST = ? and AA.FACI = ?";
	String test = "";
	String model = "";
	
	if(mie.endsWith("TEST")){
		test = "1";
		model = "MVXJDTATST";
	}else{
		test = "0";
		model = "MVXJDTA";
	}
	
	try {
      stmt = dbConn.prepareStatement(sql);
      //set parameters
      stmt.setString(1, machine);
      stmt.setString(2, test);
      stmt.setString(3, faci);
         
      rs = stmt.executeQuery();
      
      if (rs.next()){				// there is a record for this machine
      	String orderStarted = rs.getString("orderNum");
      	String empRashum = rs.getString("employee");	
      	
  		if (!orderNum.equals(orderStarted)){			// wrong order
  			doTheJob = false;
  			%>
				<script language="javascript">
					alert("<%=error_anotherOrderStarted%>");
					window.close();
					window.opener.returnToFirst();
				</script>
			<%
		/*	
		}else if (! emp.equals("000") && ! emp.equals(empRashum)){
			doTheJob = false;
  			%>
				<script language="javascript">
					alert("<%=error_anotherEmpRecorded1%>" + "<%=empRashum%>" + "<%=error_anotherEmpRecorded2%>");
					window.close();
					window.opener.returnToFirst();
				</script>
			<%  
	   	*/	
  		}else{
      		originWeight = rs.getDouble("weight");  	
      	}
      }
	} catch (Exception e) {}
	
	if (addLabels != null){
		if (addLabels.equals("yes")){
			withLabels = true;
			
			//get the printer for this user
			stmt.close();
			
			sql = "select * FROM seijdta.syfprinters as AA WHERE AA.USER=? and AA.SUG='L0' and AA.FACI=?";
			try {
		      stmt = dbConn.prepareStatement(sql);
		      
		      //set parameters
		      stmt.setString(1, MvxUser);
		      stmt.setString(2, faci);
		         
		      rs = stmt.executeQuery();
		      
		      if (rs.next()){				// there is a record found
		      	String temp = rs.getString("printer");
		      	printer = temp.trim();
		      }
		    } catch (Exception e) {
		    	out.println(e.toString() + "<BR>");
		    }
		}
	}

	if (doTheJob){
		String slitOrder1 = session.getAttribute("slitOrder1").toString();
		String slitOrder2 = session.getAttribute("slitOrder2").toString();
			

		// simuhin1: left digit: 0 if not printed, 1 if printed
		//			 right digit: 0 if not spliced, 1 if spliced
		String simuhinSpliced = "";
		String spliced = request.getParameter("spliced");
		String halchama = request.getParameter("halchama");
		
		if (spliced != null){
			if (spliced.equals("yes"))
				simuhinSpliced = "1";
			else
				simuhinSpliced = "0";
		}else if (halchama != null){
			if (halchama.equals("yes"))
				simuhinSpliced = "2";
			else
				simuhinSpliced = "0";
		}
		else
			simuhinSpliced = "0";
			
	    out.println("simuhinSpliced =  " + simuhinSpliced + "<BR>"); 
	    out.flush();
	    
		int numOfLines = Integer.parseInt(request.getParameter("numOfLinesHID"));
		String orderItem = request.getParameter("orderItemHID");
		String reservationDate = request.getParameter("reservationDateHID");
		String materialStatus = request.getParameter("materialStatusHID");
		//String materialStatusLow = request.getParameter("materialStatusLowHID");
		
		int result = 0;
		int step = 0;
		String title = "";
		String message = "";
		int i = 0;
		int j = 0;
		String attributesFailing = "";
		int lastBlock = 0;
		int lastFinished = 0;
		
		String loadedRoll = request.getParameter("loadedRoll");
		String bioWorkSeq = request.getParameter("bioWorkSeq");
		String bioWidth = request.getParameter("lwidth");
		String bioLength = request.getParameter("llength");
		
		String employee = "";
		if (mvxd.indexOf("1") >= 0)
			employee = "E"+request.getParameter("employee");
		else
			employee = "UE"+request.getParameter("employee");
			
		out.println("Stop 2<BR>"); 
	    out.flush();
	    
		String nipukMachine = request.getParameter("machineHID");
		String myType = request.getParameter("typeHID");
		String loadedWidth = request.getParameter("loadedWidthHID");
		String strLoadedWeight = request.getParameter("loadedWeightHID");
		String attrReference =  request.getParameter("attrReferenceHID");
		String wrh = request.getParameter("wrhHID");
		//String simuhin2 = request.getParameter("simuhin2HID");
		double density = Double.parseDouble(request.getParameter("densityHID"));
		String labels = "";
		String spls = "";
		double totalWeight = 0;
		String loc = "";
		String wt = "";
		String sampleNumber = "";
		String kkind = "";
		int qtyOfRolls = 0;
		String widthForLabel = "";
		String weightToDrop = "";
	    
		out.println("printer =  " + printer + "<BR>");
		out.println("materialStatus =  " + materialStatus + "<BR>");
		out.println("orderItem =  " + orderItem + "<BR>");
		out.println("reservationDate =  " + reservationDate + "<BR>");
		out.println("loadedRoll =  " + loadedRoll + "<BR>");
		out.println("orderNum =  " + orderNum + "<BR>");
		out.println("employee =  " + employee + "<BR>");
		out.println("myType =  " + myType + "<BR>");
		out.println("loadedWidth =  " + loadedWidth + "<BR>");
		out.println("attrReference =  " + attrReference + "<BR>");
		out.println("wrh =  " + wrh + "<BR>");
		out.println("lastBlock =  " + lastBlock + "<BR>");
		out.println("lastFinished =  " + lastFinished + "<BR>");
		out.println("numOfLines =  " + numOfLines + "<BR>");
		out.println("prodDate =  " + prodDate + "<BR>");
		out.flush();
		
		double[] qty = new double[41];
		String[] weight = new String[41];
		String[] length = new String[41];
		String[] lengthFT = new String[41];
		String[] lengthMTR = new String[41];
		int[] qaLabels = new int[41];
		int[] samples = new int[41];
		String[] location = new String[41];
		String[] kind = new String[41];
		String[] sug = new String[41];
		String[] charac = new String[41];
		String[] cf = new String[41];
		String[] widthMm = new String[41];
		String[] widthInch = new String[41];
		String[] sugParit = new String[41];
		String[] workSeq = new String[41];
		String[] parit = new String[41];
		String[] mOrder = new String[41];
		String[] custItem = new String[41];
		String[] subCustItem = new String[41];
		String[] micron = new String[41];
		String[] gauge = new String[41];
		String[] printCode = new String[41];
		String[] spWidth = new String[41];
		String[] simuhin = new String[41];
		String[] partOfRoll = new String[41];
		String[] spWeight = new String[41];
		String[] weightUnit = new String[41];
		String[] twoLabels = new String[41];
		String[] unit = new String[41];
		double[] weightDefault = new double[41];
		String[] specialLabel = new String[41];
		String quantity = "";
		int place = 0;
		double weightTmp = 0;
		
		out.println("Stop 3<BR>"); 
	    out.flush();
	    
		boolean continueTheJob = true;
		int counter = 1;
		
		for (i=1; i<=numOfLines && doTheJob; i++){
			qty[i] = Double.parseDouble(request.getParameter("qty" + i));
			weight[i] = request.getParameter("weight" + i);
			length[i] = request.getParameter("length" + i);
			lengthFT[i] = request.getParameter("lengthFT" + i);
			lengthMTR[i] = request.getParameter("lengthHID" + i);
			micron[i] = request.getParameter("micron" + i);
			gauge[i] = request.getParameter("gauge" + i);
			printCode[i] = request.getParameter("printCode" + i);
			spWidth[i] = request.getParameter("spWidth" + i);
			partOfRoll[i] = request.getParameter("qtyHID" + i);
			spWeight[i] = request.getParameter("spWeight" + i);
			weightUnit[i] = request.getParameter("weightUnit" + i);
			twoLabels[i] = request.getParameter("twoLabels" + i);
			unit[i] = request.getParameter("unit" + i);
			weightDefault[i] = Double.parseDouble(request.getParameter("weightDefaultHID" + i));
		
			labels = request.getParameter("qaLabels" + i);
			if (labels.length() != 0)
				qaLabels[i] = Integer.parseInt(labels);	
			else
				qaLabels[i] = 0;
				
			spls = request.getParameter("samples" + i);
			if (spls.length() != 0)
				samples[i] = Integer.parseInt(spls);
			else
				samples[i] = 0;
				
			kind[i] = request.getParameter("kind" + i);
			sug[i] = request.getParameter("sug" + i);
			charac[i] = request.getParameter("characHID" + i);
			cf[i] = request.getParameter("cfHID" + i);
			widthMm[i] = request.getParameter("widthMm" + i);
			widthInch[i] = request.getParameter("widthInch" + i);
			sugParit[i] = request.getParameter("sugParit" + i);
			parit[i] = request.getParameter("parit" + i);
			workSeq[i] = request.getParameter("workSeq" + i);
			mOrder[i] = request.getParameter("mOrder" + i);
			custItem[i] = request.getParameter("custItem" + i);
			subCustItem[i] = request.getParameter("subCustItem" + i);
			kkind = request.getParameter("kind" + i);
			specialLabel[i] = request.getParameter("specialLabelHID" + i);
			
			loc = request.getParameter("location" + i);
			if (loc.length() == 0){
				if (kind[i].equals("05") || ((kind[i].equals("06") || kind[i].equals("07")) && unit[i].equals("ROL")))
					location[i] = location_Finished;
				else if (kind[i].equals("03") || kind[i].equals("04"))
					location[i] = location_Blocks;
				else if (kind[i].equals("08"))
					location[i] = location_Samples;
				else if (kind[i].equals("02"))
					location[i] = location_Reverted;
				else if (kind[i].equals("06"))
					location[i] = location_COX;
			}else{
				if (kind[i].equals("02"))
					location[i] = "02-" + loc;
				else if (kind[i].equals("03"))
					location[i] = "03-" + loc;
			}
			
			out.println("location =  " + location[i] + "<BR>");
			out.flush();
			
			if (weight[i].length() > 0)
				totalWeight = totalWeight + Double.parseDouble(weight[i]) * qty[i];
				
			if (spWidth[i].equals(""))
				simuhin[i] = "0" + simuhinSpliced;
			else
				simuhin[i] = "1" + simuhinSpliced;
		}
		
		totalWeight = 0;
		
		for (i=1; i<=numOfLines; i++){
			weight[i] = request.getParameter("weight" + i);
			
			out.println("weight[" + i + "] =  " + weight[i] + "<BR>");
			out.println("qty[" + i + "] =  " + qty[i] + "<BR>");
			
			if (weight[i].length() > 0)
				totalWeight = totalWeight + Double.parseDouble(weight[i]) * qty[i];
			
			out.println("totalWeight =  " + totalWeight + "<BR>");
		}
		
		weightToDrop = df.format(totalWeight);
		
		out.println("totalWeight =  " + totalWeight + "<BR>");
		out.println("originWeight =  " + originWeight + "<BR>");
		
		if (doTheJob){
//			get session information for user
			IRuntimeEnvironmentConfiguration runtimeEnvironment=new RuntimeEnvironmentConfiguration_5_1();
			runtimeEnvironment.init(request);
			String backend = runtimeEnvironment.getMIConfiguration().getServer();
			String port = runtimeEnvironment.getMIConfiguration().getPort();
			String apiuser = runtimeEnvironment.getMIConfiguration().getUser();
			String apiuserpwd = runtimeEnvironment.getMIConfiguration().getPassword();
			String myMsg = null;
			String errMsg = null;
			
			//out.println("backend = " + backend + "<BR>");
			//out.println("port = " + port + "<BR>");
			//out.println("apiuser = " + apiuser + "<BR>");
			//out.println("apiuserpwd = " + apiuserpwd + "<BR>");
			//out.flush();
			
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
			mvxInput.put(IMovexConnection.TRANSACTION,"RptReceipt");
			
			out.println("<BR>");
			out.println(".......... running PMS050 RptReceipt For the JUMBO<BR>");		
			out.println("CONO = " + mvx + "<BR>");
			out.println("TRDT = " + myDate + "<BR>");
			out.println("RPDT = " + myDate + "<BR>");
			out.println("TRTM = " + time.replaceAll(":", "") + "<BR>");
			out.println("RPTM = " + time.replaceAll(":", "") + "<BR>");
			out.println("WOSQ = " + bioWorkSeq + "<BR>");
			out.println("RPQA = " + weightToDrop + "<BR>");
			
			if (mvxd.indexOf("1") >= 0)
				out.println("MAUN = KG<BR>");	
			else
				out.println("MAUN = LBS<BR>");
				
			out.println("STAS = 2<BR>");
			out.println("BANO = " + loadedRoll + "<BR>");
			out.println("BREF = " + bioLength + "<BR>");
			out.println("BRE2 = " + bioWidth + "<BR>");
			out.println("WHSL = " + location_bioDirectToSlit + "<BR>");
			out.flush();
			
			mvxInput.put("CONO", mvx);
			mvxInput.put("TRDT", myDate);
			mvxInput.put("RPDT", myDate);
			mvxInput.put("TRTM", time.replaceAll(":", ""));
			mvxInput.put("RPTM", time.replaceAll(":", ""));
			mvxInput.put("WOSQ", bioWorkSeq);
			mvxInput.put("RPQA", weightToDrop);
			
			if (mvxd.indexOf("1") >= 0)
				mvxInput.put("MAUN", "KG");
			else
				mvxInput.put("MAUN", "LBS");
				
			mvxInput.put("STAS", "2");
			mvxInput.put("BANO", loadedRoll);
			mvxInput.put("BREF", bioLength);
			mvxInput.put("BRE2", bioWidth);
			mvxInput.put("WHSL", location_bioDirectToSlit);
			mvxInput.put("REND", "");
			mvxInput.put("DSP1", "1");
			mvxInput.put("DSP2", "1");
			mvxInput.put("DSP3", "1");
			mvxInput.put("DSP4", "1");
			mvxInput.put("DSP5", "1");
				
			try {
				connection = factory.getConnection("PMS050MI","", apiuser, apiuserpwd, backend, Integer.parseInt(port));
				final IMovexCommand command = connection.getCommand(mvxInput);
				
				//execute API
				if (command != null) {
					connection.setMaxRecordsReturned(0); //all you got
					//connection.setDateFormat("YMD8", "-");
					resultset = connection.execute(command);
				
					//any errors
					if (!connection.isOk()) {
		           		errMsg = connection.getLastMessage();  
		        		out.println("=================================<BR>Error found :" + errMsg + "<BR>");
		        		out.flush();
		        		
		        		doTheJob = false;
						
						%>
						<script language="javascript">
					
								alert('<%=errMsg.replaceAll("                    ", "")%>');
								window.close();	
								window.opener.enableGoBtn();
						</script>
						<%
		       		}else{
		       			out.println("PMS050 succeded ...<BR>");
		       			out.flush();
		       			currState=1;
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
			
			
			createRollNum nr = new createRollNum();
			createRollNum labLabel = new createRollNum();
			createRollNum fg = new createRollNum();
			createRollNum fg2 = new createRollNum();
			
			labLabel.initLabLabelArray();
				
			nr.deleteOldFiles();
			
			out.println("111111<BR>");
			out.flush();
			
			for (i=1;i<=numOfLines && doTheJob;i++){
				// inits the label array
				if (mvxd.indexOf("1") >= 0){
					nr.initLabelArray();
					fg.initFgLabelArray();
					fg2.initFgLabelArray("US");
				}else
					nr.initLabelArray("US");
				
				step = 0;
				
				out.println(i + "<BR>");
				out.println("qty =  " + qty[i] + "<BR>");
				out.println("weight =  " + weight[i] + "<BR>");
				out.println("length =  " + length[i] + "<BR>");
				out.println("qaLabels =  " + qaLabels[i] + "<BR>");
				out.println("samples =  " + samples[i] + "<BR>");
				out.println("kind =  " + kind[i] + "<BR>");
				out.println("charac =  " + charac[i] + "<BR>");
				out.println("cf =  " + cf[i] + "<BR>");
				out.println("widthMm =  " + widthMm[i] + "<BR>");
				out.println("widthInch =  " + widthInch[i] + "<BR>");
				out.println("sugParit =  " + sugParit[i] + "<BR>");
				out.println("parit =  " + parit[i] + "<BR>");
				out.println("workSeq =  " + workSeq[i] + "<BR>");
				out.println("totalWeight =  " + totalWeight + "<BR>");
				out.println("spWeight =  " + spWeight[i] + "<BR>");
				out.println("weightUnit =  " + weightUnit[i] + "<BR>");
				out.println("twoLabels =  " + twoLabels[i] + "<BR>");
				out.println("partOfRoll =  " + partOfRoll[i] + "<BR>");
				out.println("unit =  " + unit[i] + "<BR>");
				out.println("custItem =  " + custItem[i] + "<BR>");
				out.println("subCustItem =  " + subCustItem[i] + "<BR>");
				out.println("weightDefault =  " + weightDefault[i] + "<BR>");
				out.flush();
				
				String rollNum = "";
				
				if (qty[i]*10 % 10 != 0)
					qtyOfRolls = (int)qty[i] + 1;
				else
					qtyOfRolls = (int)qty[i];
				
					
				// for finished rolls and samples in USA, creates all the rolls (PMS050) of the line once
				if (mvxd.indexOf("1") < 0  && (kind[i].equals("05") || kind[i].equals("08"))){
					if (doTheJob) {
						mvxInput = new HashMap();
						mvxInput.put(IMovexConnection.TRANSACTION,"RptReceipt");
						
						out.println("CREATES NEW ROLL" + "<BR>");
						out.println("CONO =" + mvx + "<BR>");	
						out.println("BANO = 0<BR>");
						out.println("WOSQ =  " + workSeq[i] + "<BR>");
						out.println("TRDT =  " + myDate + "<BR>");
						out.println("TRTM =  " + time.replaceAll(":", "") + "<BR>");
						out.println("WHSL =  " + location[i] + "<BR>");
						out.println("MAUN =  ROL<BR>");
						out.println("STAS =  1 <BR>");
						
						mvxInput.put("CONO", mvx);
						mvxInput.put("BANO", "0");
						mvxInput.put("WOSQ", workSeq[i]);
						mvxInput.put("TRDT", myDate);
						mvxInput.put("TRTM", time.replaceAll(":", ""));
						mvxInput.put("WHSL", location[i]);
						mvxInput.put("MAUN", "ROL");
						mvxInput.put("STAS", "1");
						mvxInput.put("REND", "");
						
						if (partOfRoll[i].equals("1")){
							out.println("RPQA = " + Integer.toString((int)qty[i]) + "<BR>");
							mvxInput.put("RPQA", Integer.toString((int)qty[i]));
						}else{
							out.println("RPQA =  " + Double.toString(Double.parseDouble(partOfRoll[i]) * qty[i]) + "<BR>");
							mvxInput.put("RPQA", Double.toString(Double.parseDouble(partOfRoll[i]) * qty[i]));
						}
						
						out.println("DSP1 =  1 <BR>");
						out.println("DSP2 =  1 <BR>");
						out.println("DSP3 =  1 <BR>");
						out.println("DSP4 =  1 <BR>");
						out.println("DSP5 =  1 <BR>");
						out.println("DSP6 =  1 <BR>");
						out.println("DSP7 =  1 <BR>");
						out.println("DSP8 =  1 <BR>");
						out.flush();
						
						mvxInput.put("DSP1", "1");
						mvxInput.put("DSP2", "1");
						mvxInput.put("DSP3", "1");
						mvxInput.put("DSP4", "1");
						mvxInput.put("DSP5", "1");
						mvxInput.put("DSP6", "1");
						mvxInput.put("DSP7", "1");
						mvxInput.put("DSP8", "1");
						
						try {
							connection = factory.getConnection("PMS050MI","", apiuser, apiuserpwd, backend, Integer.parseInt(port));
							final IMovexCommand command = connection.getCommand(mvxInput);
							
							//execute API
							if (command != null) {
								connection.setMaxRecordsReturned(0); //all you got
								//connection.setDateFormat("YMD8", "-");
								resultset = connection.execute(command);
							
								//any errors
								if (!connection.isOk()) {
					           		errMsg = connection.getLastMessage();  
					        		out.println("=================================<BR>Error found PMS050:" + errMsg + "<BR>");
					        		out.flush();
					        		
					        		doTheJob = false;
									
									%>
									<script language="javascript">
								
											alert('<%=errMsg.replaceAll("                    ", "")%>');
											window.close();	
											window.opener.enableGoBtn();
									</script>
									<%
					       		}else{
					       			out.println("PMS050 succeded ...<BR>");
					       			out.flush();
					       			currState=1;
					       			
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
					}
				}
				
				if (qty[i] != 0){
					out.println("weight[i] = " + weight[i] + "<BR>");
					out.println("weightDefault[i] = " + weightDefault[i] + "<BR>");
					out.println("qty[i] = " + qty[i] + "<BR>");
					out.flush();
					if (unit[i].equals("ROL")){
						quantity = Double.toString(qty[i]);
						place = quantity.indexOf(".");
						
						if (place > 0)
							quantity = quantity.substring(0,place);
					}else{
						if (mvxd.indexOf("1") >= 0)
							weightTmp = Double.parseDouble(weight[i]) / weightDefault[i] * qty[i];
						else
							weightTmp = Double.parseDouble(weight[i]) / (weightDefault[i] * 2.205) * qty[i];
						
						out.println("weightTmp = " + weightTmp + "<BR>");
						
						DecimalFormat df2 = new DecimalFormat("#0.00");
						quantity = df2.format(weightTmp);
						
						out.println("quantity = " + quantity + "<BR>");
						
						out.println("weightDefault = " + weightDefault[i] + "<BR>");
						out.println("weight = " + weight[i] + "<BR>");
					}
					
					mvxInput = new HashMap();
					mvxInput.put(IMovexConnection.TRANSACTION,"RptOperation");
					
					out.println("..........DO PMS070WS_RptOperation <BR>");				
					out.println("CONO = " + mvx + "<BR>");				
					out.println("FACI = " + faci + "<BR>");
					out.println("MFNO = " + mOrder[i] + "<BR>");	
					out.println("MAQA = " + quantity + "<BR>");
					out.println("RPDT = " + myDate + "<BR>");
					out.println("EMNO = " + emp + "<BR>");
					out.println("OPNO = 30<BR>");
					out.println("DSP1 = 1<BR>");
					out.println("DSP2 = 1<BR>");
					out.println("DSP3 = 1<BR>");
					out.println("DSP4 = 1<BR>");
					out.flush();
					
					mvxInput.put("CONO", mvx);
					mvxInput.put("FACI", faci);
					mvxInput.put("MFNO", mOrder[i]);
					mvxInput.put("MAQA", quantity);
					mvxInput.put("RPDT", myDate);
					mvxInput.put("EMNO", emp);
					mvxInput.put("OPNO", "30");
					mvxInput.put("DSP1", "1");
					mvxInput.put("DSP2", "1");
					mvxInput.put("DSP3", "1");
					mvxInput.put("DSP4", "1");
					
					try {
						connection = factory.getConnection("PMS070MI","", apiuser, apiuserpwd, backend, Integer.parseInt(port));
						final IMovexCommand command = connection.getCommand(mvxInput);
						
						//execute API
						if (command != null) {
							connection.setMaxRecordsReturned(0); //all you got
							//connection.setDateFormat("YMD8", "-");
							resultset = connection.execute(command);
						
							//any errors
							if (!connection.isOk()) {
				           		errMsg = connection.getLastMessage();  
				        		out.println("=================================<BR>Error found PMS070:" + errMsg + "<BR>");
				        		out.flush();
				        		
				        		doTheJob = false;
								
								%>
								<script language="javascript">
							
										alert('<%=errMsg.replaceAll("                    ", "")%>');
										window.close();	
										window.opener.enableGoBtn();
								</script>
								<%
				       		}else{
				       			out.println("PMS070 succeded ...<BR>");
				       			out.flush();
				       			currState=1;
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
						
				}
					
				//	for each roll created in the line
				for (j=1;j<=qtyOfRolls && doTheJob;j++){	
					if (kind[i].equals("05") && mvxd.indexOf("1") >= 0 ){
						rollNum = nr.newRoll(loadedRoll, "04", lastFinished);
						lastFinished++;
					}else if ((kind[i].equals("05") || kind[i].equals("08")) && mvxd.indexOf("1") < 0 ){
						rollNum = loadedRoll;
						lastFinished++;
					}else if (kind[i].equals("03") || kind[i].equals("04")){
						rollNum = nr.newRoll(loadedRoll, "03", lastBlock);
						lastBlock++;
					}else if (kind[i].equals("06") || kind[i].equals("07"))
						rollNum = loadedRoll;
					else{
						rollNum = nr.newRoll(loadedRoll, "02", lastBlock);
						lastBlock++;
					}
					
					out.println("rollNum =  " + rollNum + "<BR>");
					
					if (! (kind[i].equals("06") || kind[i].equals("07") || (mvxd.indexOf("1") < 0  && (kind[i].equals("05") || kind[i].equals("08"))))){
						String newRoll = "";
						
						sql = "SELECT LMBANO as ROLL from " + model + ".MILOMA WHERE LMCONO= ? and LMBANO= ? order by LMBANO desc";
								
						try {
						      stmt = dbConn.prepareStatement(sql);
						      
						      //set parameters
						      stmt.setString(1, mvx);
						      stmt.setString(2, rollNum);
						         
						      rs = stmt.executeQuery();
						      
						      if (rs.next()){				// there is a record found
						    	  newRoll = rs.getString("ROLL");
						      }
						    } catch (Exception e) {}
						
						out.println("XXXXXXXXXXXXXXXXX     newRoll  = " + newRoll + "<BR>");
						out.flush();
						
						if (! newRoll.equals("")){
							String lastRoll = "";
							
							sql = "SELECT LMBANO as LAST_ROLL FROM " + model + ".MILOMA WHERE LMCONO=? AND LMBANO LIKE ? AND LENGTH(TRIM(LMBANO))=? ORDER BY LMBANO desc";
							
							try {
							      stmt = dbConn.prepareStatement(sql);
							      
							      //set parameters
							      stmt.setString(1, mvx);
							      
							      if (rollNum.length() == 9){			
									 	stmt.setString(2, rollNum.substring(0,7) + "%");
									 	stmt.setString(3, "9");
									 }else{
										stmt.setString(2, rollNum.substring(0,9) + "%");
										stmt.setString(3, "12");
									 }
							         
							      rs = stmt.executeQuery();
							      
							      if (rs.next()){				// there is a record found
							    	  lastRoll = rs.getString("LAST_ROLL");
							      }
							    } catch (Exception e) {}
							
							out.println("XXXXXXXXXXXXXXXXXX     lastRoll  = " + lastRoll + "<BR>");
							out.flush();
							
							if (rollNum.length() == 9){
								lastBlock = Integer.valueOf(lastRoll.substring(7,8)).intValue();
								rollNum = nr.newRoll(loadedRoll, "03", lastBlock);
								lastBlock++;
							}else{
								lastFinished = Integer.valueOf(lastRoll.substring(9,11)).intValue();
								rollNum = nr.newRoll(loadedRoll, "04", lastFinished);
								lastFinished++;
							}
						}
						
						out.println("XXXXXXXXXXXXXXXXXX     rollNum  = " + rollNum + "<BR>");
						out.flush();
						
						counter++;
					}
					
					if (!(mvxd.indexOf("1") < 0  && (kind[i].equals("05") || kind[i].equals("08")))){
						mvxInput = new HashMap();
						mvxInput.put(IMovexConnection.TRANSACTION,"RptReceipt");
						
						out.println("CREATES NEW ROLL" + "<BR>");
						out.println("CONO =" + mvx + "<BR>");
						
						if (! (kind[i].equals("06") || kind[i].equals("07")))
							out.println("BANO = " + rollNum + "<BR>");
						
							
						out.println("WOSQ =  " + workSeq[i] + "<BR>");
						
						if (mvxd.indexOf("1") < 0){
							out.println("TRDT =  " + myDate + "<BR>");
							out.println("TRTM =  " + time.replaceAll(":", "") + "<BR>");
						}
						
						out.println("WHSL =  " + location[i] + "<BR>");
						out.println("STAS =  1 <BR>");
						out.println("DSP1 =  1 <BR>");
						out.println("DSP2 =  1 <BR>");
						out.println("DSP3 =  1 <BR>");
						out.println("DSP4 =  1 <BR>");
						out.println("DSP5 =  1 <BR>");
						out.println("DSP6 =  1 <BR>");
						out.println("DSP7 =  1 <BR>");
						out.println("DSP8 =  1 <BR>");
						
						mvxInput.put("CONO", mvx);
						
						if (! (kind[i].equals("06") || kind[i].equals("07")))
							mvxInput.put("BANO", rollNum);
							
						mvxInput.put("WOSQ", workSeq[i]);
						
						if (mvxd.indexOf("1") < 0){
							mvxInput.put("TRDT", myDate);
							mvxInput.put("TRTM", time.replaceAll(":", ""));
						}
						
						mvxInput.put("WHSL", location[i]);
						mvxInput.put("STAS", "1");
						mvxInput.put("REND", "");
						mvxInput.put("DSP1", "1");
						mvxInput.put("DSP2", "1");
						mvxInput.put("DSP3", "1");
						mvxInput.put("DSP4", "1");
						mvxInput.put("DSP5", "1");
						mvxInput.put("DSP6", "1");
						mvxInput.put("DSP7", "1");
						mvxInput.put("DSP8", "1");
						
						if (kind[i].equals("02") || kind[i].equals("03") || kind[i].equals("04")){	
							out.println("BREF = " + length[i] + "<BR>");
							mvxInput.put("BREF", length[i]);
						}else{
							out.println("BREF = " + simuhin[i] + "<BR>");
							mvxInput.put("BREF", simuhin[i]);
						}
						
						if (kind[i].equals("05") || kind[i].equals("08")
								|| ((kind[i].equals("06") || kind[i].equals("07")) && unit[i].equals("ROL"))){
							out.println("MAUN =  ROL<BR>");
							mvxInput.put("MAUN", "ROL");
							
							if (mvxd.indexOf("1") >= 0){
								out.println("CAMU =  " + ContainerAfterKipul + "<BR>");
								mvxInput.put("CAMU", ContainerAfterKipul);
							}
							
							if (partOfRoll[i].equals("1")){
								out.println("RPQA =  1<BR>");
								mvxInput.put("RPQA", "1");
							}else{
								out.println("RPQA =  " + partOfRoll[i] + "<BR>");
								mvxInput.put("RPQA", partOfRoll[i]);
							}
						}else{
							if (mvxd.indexOf("1") >= 0){
								out.println("MAUN =  KG<BR>");
								mvxInput.put("MAUN", "KG");
							}else{
								out.println("MAUN =LBS<BR>");
								mvxInput.put("MAUN", "LBS");
							}
							
							out.println("RPQA =  " + weight[i] + "<BR>");
							mvxInput.put("RPQA", weight[i]);
						}
						
						if (kind[i].equals("02")){
							if (loadedWidth == ""){
								out.println("BRE2 =" + default_Width + "<BR>");
								mvxInput.put("BRE2", default_Width);
							}else{
								out.println("BRE2 =" + loadedWidth + "<BR>");
								mvxInput.put("BRE2", loadedWidth);
							}
						}else{
							if (! printCode[i].equals("")){
								out.println("BRE2 =" + printCode[i] + "<BR>");
								mvxInput.put("BRE2", printCode[i]);
							}
						}
						out.flush();
						
						try {
							connection = factory.getConnection("PMS050MI","", apiuser, apiuserpwd, backend, Integer.parseInt(port));
							final IMovexCommand command = connection.getCommand(mvxInput);
							//execute API
							if (command != null) {
								connection.setMaxRecordsReturned(0); //all you got
								//connection.setDateFormat("YMD8", "-");
								resultset = connection.execute(command);
							
								//any errors
								if (!connection.isOk()) {
					           		errMsg = connection.getLastMessage();  
					        		out.println("=================================<BR>Error found PMS050:" + errMsg + "<BR>");
					        		out.flush();
					        		
					        		doTheJob = false;
					        		
					        		message = "Slitter/Folder reporting failed: machine " + machine + ", Luz " + orderNum + ", loaded roll " + loadedRoll +" failed on roll creation in line " + i + " roll " + j + ".";
					        		title = "Problem in slitter/folder reporting";
									String[] envp = null;
									File file = new File("C:\\syfanDB\\");
									
									String aaa = "";
									
									if (mvxd.indexOf("1") >= 0)
										aaa = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title + "\" -msg:\"" + message + "\"";
									else
										aaa = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title + "\" -msg:\"" + message + "\"";
										
									Runtime.getRuntime().exec(aaa, envp, file);	
								
									%>
									<script language="javascript">
								
											alert('<%=errMsg.replaceAll("                    ", "")%>');
											window.close();	
											window.opener.enableGoBtn();
									</script>
									<%
					       		}else{
					       			out.println("PMS050 succeded ...<BR>");
					       			out.flush();
					       			currState=1;
					       			
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
						
					}
							
					if (doTheJob){	
						step = 1;
						
						attributesFailing = "";
						
						//	 for items 06 and 07, don't set attributes
						if (! (kind[i].equals("06") || kind[i].equals("07") || (mvxd.indexOf("1") < 0  && (kind[i].equals("05") || kind[i].equals("08"))))){
							out.println("mie = " + mie + "<BR>");
							out.println("mvx = " + mvx + "<BR>");
							out.println("roll = " + rollNum + "<BR>");
							out.println("item = " + parit[i] + "<BR>");
							
							String atnr = "";
							
							sql = "select CHAR(AGATNR) as ATNR FROM " + model + ".MIATTR WHERE AGATID = 'LENGHT' AND AGCONO=? and AGBANO=? and AGITNO=?";
							
							try {
						      stmt = dbConn.prepareStatement(sql);
						      
						      //set parameters
						      stmt.setString(1, mvx);
						      stmt.setString(2, rollNum);
						      stmt.setString(3, parit[i]);
						         
						      rs = stmt.executeQuery();
						      
						      if (rs.next()){				// there is a record found
						      	atnr = rs.getString("ATNR").trim();
						      }
						    } catch (Exception e) {}
							
							out.println("atnr  = " + atnr + "<BR>");
							
							attributesFailing = ", new item " + parit[i];
							
							if (! atnr.equals("")){
								attributesFailing = attributesFailing + ", atnr found " + atnr;
								
								out.println("SET ATTRIBUTES" + "<BR>");
								// set attributes of the new rolls
								
								
								//	width
								if (kind[i].equals("02")){
									mvxInput = new HashMap();
									mvxInput.put(IMovexConnection.TRANSACTION,"SetAttrValue");
									
									out.println("SEND WIDTH <BR>");
									
									out.println("CONO =" + mvx + "<BR>");
									out.println("ATNR =" + atnr + "<BR>");
									out.println("ATID = WIDTH<BR>");
									
									mvxInput.put("CONO", mvx);
									mvxInput.put("ATNR", atnr);
									mvxInput.put("ATID", "WIDTH");
									
									if (loadedWidth == ""){
										out.println("ATVA =" + default_Width + "<BR>");
										mvxInput.put("ATVA", default_Width);
										
										attributesFailing = attributesFailing + ", width " + default_Width;
									}else{
										out.println("ATVA =" + loadedWidth + "<BR>");
										mvxInput.put("ATVA", loadedWidth);
										
										attributesFailing = attributesFailing + ", width " + loadedWidth;
									}
									out.flush();
									
									try {
										connection = factory.getConnection("ATS101MI","", apiuser, apiuserpwd, backend, Integer.parseInt(port));
										final IMovexCommand command = connection.getCommand(mvxInput);
										
										//execute API
										if (command != null) {
											connection.setMaxRecordsReturned(0); //all you got
											//connection.setDateFormat("YMD8", "-");
											resultset = connection.execute(command);
										
											//any errors
											if (!connection.isOk()) {
								           		errMsg = connection.getLastMessage();  
								        		out.println("=================================<BR>Error found ATS101 width:" + errMsg + "<BR>");
								        		out.flush();
								        		
								        		doTheJob = false;
								        		
								        		message = "Slitter/Folder reporting failed: machine " + machine + ", Luz " + orderNum + ", loaded roll " + loadedRoll +" failed on new roll attributes update in line " + i + " roll " + j + attributesFailing + ".";
								        		title = "Problem in slitter/folder reporting";
												String[] envp = null;
												File file = new File("C:\\syfanDB\\");
												
												String bbb = "";
												
												if (mvxd.indexOf("1") >= 0)
													bbb = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title + "\" -msg:\"" + message + "\"";
												else
													bbb = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title + "\" -msg:\"" + message + "\"";
													
												Runtime.getRuntime().exec(bbb, envp, file);	
												
												%>
												<script language="javascript">
											
														alert('<%=errMsg.replaceAll("                    ", "")%>');
														window.close();	
														window.opener.enableGoBtn();
												</script>
												<%
								       		}else{
								       			out.println("ATS101 width succeded ...<BR>");
								       			out.flush();
								       			currState=1;
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
								}
								
								if (doTheJob){
									//length
									if (! (kind[i].equals("05") || kind[i].equals("08")) || 
										 (kind[i].equals("05") && ! partOfRoll[i].equals("1"))){
										mvxInput = new HashMap();
										mvxInput.put(IMovexConnection.TRANSACTION,"SetAttrValue");
										
										out.println("SEND LENGTH <BR>");
										
										out.println("CONO =" + mvx + "<BR>");
										out.println("ATNR =" + atnr + "<BR>");
										out.println("ATID = LENGHT<BR>");
										out.println("ATVA =" + length[i] + "<BR>");
										out.flush();
										
										mvxInput.put("CONO", mvx);
										mvxInput.put("ATNR", atnr);
										mvxInput.put("ATID", "LENGHT");
										mvxInput.put("ATVA", length[i]);
										
										attributesFailing = attributesFailing + ", length " + length[i];
										
										try {
											connection = factory.getConnection("ATS101MI","", apiuser, apiuserpwd, backend, Integer.parseInt(port));
											final IMovexCommand command = connection.getCommand(mvxInput);
											
											//execute API
											if (command != null) {
												connection.setMaxRecordsReturned(0); //all you got
												//connection.setDateFormat("YMD8", "-");
												resultset = connection.execute(command);
											
												//any errors
												if (!connection.isOk()) {
									           		errMsg = connection.getLastMessage();  
									        		out.println("=================================<BR>Error found ATS101 length:" + errMsg + "<BR>");
									        		out.flush();
									        		
									        		doTheJob = false;
													
									        		message = "Slitter/Folder reporting failed: machine " + machine + ", Luz " + orderNum + ", loaded roll " + loadedRoll +" failed on new roll attributes update in line " + i + " roll " + j + attributesFailing + ".";
									        		title = "Problem in slitter/folder reporting";
													String[] envp = null;
													File file = new File("C:\\syfanDB\\");
													
													String ccc = "";
													
													if (mvxd.indexOf("1") >= 0)
														ccc = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title + "\" -msg:\"" + message + "\"";
													else
														ccc = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title + "\" -msg:\"" + message + "\"";
														
													Runtime.getRuntime().exec(ccc, envp, file);	
													%>
													<script language="javascript">
												
															alert('<%=errMsg.replaceAll("                    ", "")%>');
															window.close();	
															window.opener.enableGoBtn();
													</script>
													<%
									       		}else{
									       			out.println("ATS101 length succeded ...<BR>");
									       			out.flush();
									       			currState=1;
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
										
									}
								}
								
								// employee
								if (doTheJob){
									mvxInput = new HashMap();
									mvxInput.put(IMovexConnection.TRANSACTION,"SetAttrValue");
									
									out.println("SEND EMPLOYEE <BR>");
									
									out.println("CONO =" + mvx + "<BR>");
									out.println("ATNR =" + atnr + "<BR>");
									out.println("ATID = EMPLOYY<BR>");
									out.println("ATVA =" + employee + "<BR>");
									out.flush();
									
									mvxInput.put("CONO", mvx);
									mvxInput.put("ATNR", atnr);
									mvxInput.put("ATID", "EMPLOYY");
									mvxInput.put("ATVA", employee);
									
									attributesFailing = attributesFailing + ", employee " + employee;
									
									try {
										connection = factory.getConnection("ATS101MI","", apiuser, apiuserpwd, backend, Integer.parseInt(port));
										final IMovexCommand command = connection.getCommand(mvxInput);
										
										//execute API
										if (command != null) {
											connection.setMaxRecordsReturned(0); //all you got
											//connection.setDateFormat("YMD8", "-");
											resultset = connection.execute(command);
										
											//any errors
											if (!connection.isOk()) {
								           		errMsg = connection.getLastMessage();  
								        		out.println("=================================<BR>Error found ATS101 employee:" + errMsg + "<BR>");
								        		out.flush();
								        		
								        		doTheJob = false;
												
								        		message = "Slitter/Folder reporting failed: machine " + machine + ", Luz " + orderNum + ", loaded roll " + loadedRoll +" failed on new roll attributes update in line " + i + " roll " + j + attributesFailing + ".";
								        		title = "Problem in slitter/folder reporting";
												String[] envp = null;
												File file = new File("C:\\syfanDB\\");
												
												String ddd = "";
												
												if (mvxd.indexOf("1") >= 0)
													ddd = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title + "\" -msg:\"" + message + "\"";
												else
													ddd = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title + "\" -msg:\"" + message + "\"";
													
												Runtime.getRuntime().exec(ddd, envp, file);
												%>
												<script language="javascript">
											
														alert('<%=errMsg.replaceAll("                    ", "")%>');
														window.close();	
														window.opener.enableGoBtn();
												</script>
												<%
								       		}else{
								       			out.println("ATS101 employee succeded ...<BR>");
								       			out.flush();
								       			currState=1;
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
								}
								
								// no. 1
								if (doTheJob){
									if (! (kind[i].equals("05") || kind[i].equals("08"))){
										mvxInput = new HashMap();
										mvxInput.put(IMovexConnection.TRANSACTION,"SetAttrValue");
										
										out.println("SEND NO 1 <BR>");
										
										out.println("CONO =" + mvx + "<BR>");
										out.println("ATNR =" + atnr + "<BR>");
										out.println("ATID = NO 1<BR>");
										out.println("ATVA = -1<BR>");
										out.flush();
										
										mvxInput.put("CONO", mvx);
										mvxInput.put("ATNR", atnr);
										mvxInput.put("ATID", "NO 1");
										mvxInput.put("ATVA", "-1");
										
										attributesFailing = attributesFailing + ", No 1";
										
										try {
											connection = factory.getConnection("ATS101MI","", apiuser, apiuserpwd, backend, Integer.parseInt(port));
											final IMovexCommand command = connection.getCommand(mvxInput);
											
											//execute API
											if (command != null) {
												connection.setMaxRecordsReturned(0); //all you got
												//connection.setDateFormat("YMD8", "-");
												resultset = connection.execute(command);
											
												//any errors
												if (!connection.isOk()) {
									           		errMsg = connection.getLastMessage();  
									        		out.println("=================================<BR>Error found ATS101 no 1:" + errMsg + "<BR>");
									        		out.flush();
									        		
									        		doTheJob = false;
													
									        		message = "Slitter/Folder reporting failed: machine " + machine + ", Luz " + orderNum + ", loaded roll " + loadedRoll +" failed on new roll attributes update in line " + i + " roll " + j + attributesFailing + ".";
									        		title = "Problem in slitter/folder reporting";
													String[] envp = null;
													File file = new File("C:\\syfanDB\\");
													
													String eee = "";
													
													if (mvxd.indexOf("1") >= 0)
														eee = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title + "\" -msg:\"" + message + "\"";
													else
														eee = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title + "\" -msg:\"" + message + "\"";
														
													Runtime.getRuntime().exec(eee, envp, file);
													
													%>
													<script language="javascript">
												
															alert('<%=errMsg.replaceAll("                    ", "")%>');
															window.close();	
															window.opener.enableGoBtn();
													</script>
													<%
									       		}else{
									       			out.println("ATS101 no 1 succeded ...<BR>");
									       			out.flush();
									       			currState=1;
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
									}
								}
								
								// no 2
								if (doTheJob){
									mvxInput = new HashMap();
									mvxInput.put(IMovexConnection.TRANSACTION,"SetAttrValue");
									
									out.println("SEND NO 1 <BR>");
									
									out.println("CONO =" + mvx + "<BR>");
									out.println("ATNR =" + atnr + "<BR>");
									out.println("ATID = NO 2<BR>");
									out.println("ATVA = -1<BR>");
									out.flush();
									
									mvxInput.put("CONO", mvx);
									mvxInput.put("ATNR", atnr);
									mvxInput.put("ATID", "NO 2");
									mvxInput.put("ATVA", "-1");
									
									attributesFailing = attributesFailing + ", No 2";
									
									try {
										connection = factory.getConnection("ATS101MI","", apiuser, apiuserpwd, backend, Integer.parseInt(port));
										final IMovexCommand command = connection.getCommand(mvxInput);
										
										//execute API
										if (command != null) {
											connection.setMaxRecordsReturned(0); //all you got
											//connection.setDateFormat("YMD8", "-");
											resultset = connection.execute(command);
										
											//any errors
											if (!connection.isOk()) {
								           		errMsg = connection.getLastMessage();  
								        		out.println("=================================<BR>Error found ATS101 no 2:" + errMsg + "<BR>");
								        		out.flush();
								        		
								        		doTheJob = false;
								        		
								        		message = "Slitter/Folder reporting failed: machine " + machine + ", Luz " + orderNum + ", loaded roll " + loadedRoll +" failed on new roll attributes update in line " + i + " roll " + j + attributesFailing + ".";
								        		title = "Problem in slitter/folder reporting";
												String[] envp = null;
												File file = new File("C:\\syfanDB\\");
												
												String fff = "";
												
												if (mvxd.indexOf("1") >= 0)
													fff = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title + "\" -msg:\"" + message + "\"";
												else
													fff = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title + "\" -msg:\"" + message + "\"";
													
												Runtime.getRuntime().exec(fff, envp, file);
												
												%>
												<script language="javascript">
											
														alert('<%=errMsg.replaceAll("                    ", "")%>');
														window.close();	
														window.opener.enableGoBtn();
												</script>
												<%
								       		}else{
								       			out.println("ATS101 no 2 succeded ...<BR>");
								       			out.flush();
								       			currState=1;
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
								}

								out.println("ATTRIBUTES WHERE SENT.............<BR>");
								out.flush();
							}else{
								String title1 = "Problem in slitter/folder reporting";
								String message1 = "Slitter/Folder reporting - Problem in updating attributes: machine " + machine + ", Luz " + orderNum + ", created roll " + rollNum + ", item number " + parit[i] + ", atnr not found.";
								
								String[] envp1 = null;
								File file1 = new File("C:\\syfanDB\\");
								
								String kkk = "";
								
								if (mvxd.indexOf("1") >= 0)
									kkk = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title1 + "\" -msg:\"" + message1 + "\"";
								else
									kkk = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title1 + "\" -msg:\"" + message1 + "\"";
									
								Runtime.getRuntime().exec(kkk, envp1, file1);	
							}	// found atrn number
							
						}	// set Attributes
						
						step = 2;
						
						// labels
						if (doTheJob){
							out.println("specialLabel =  " + specialLabel[i] + "<BR>");
							out.flush();
							
							// inits the label array
							if (! specialLabel[i].equals("")){
								nr.initLabelArray("", specialLabel[i]);
								out.println("Printing special labels<BR>");
								out.flush();
							}
							
							if (kind[i].equals("02")){
								if (loadedWidth == ""){
									widthForLabel = default_Width;
								}else{
									widthForLabel = loadedWidth;
								}
							}else
								widthForLabel = widthMm[i];
							
							String barcodeForUSA = "";
							
							out.println("weight =  " + weight[i] + "<BR>");
							out.println("widthInch =  " + widthInch[i] + "<BR>");
							out.flush();
							
							if (withLabels){
								out.println("type printed =  " + sug[i] + "<BR>");
								out.println("Print label no. " + j + "<BR>");
								out.flush();
								
								if (mvxd.indexOf("1") >= 0){
									if (! kind[i].equals("05") || (kind[i].equals("05") && spWeight[i].equals(""))){
										if((kind[i].equals("05") || kind[i].equals("07")) && specialLabel[i].equals("")){
											fg.labels(rollNum, sug[i], charac[i], micron[i], gauge[i], length[i], lengthFT[i], cf[i], widthForLabel, 
										   			  widthInch[i], weight[i], kind[i], "roll", printer, simuhinSpliced);
										}else{
											nr.specialLabels(rollNum, sug[i], charac[i], micron[i], gauge[i], length[i], lengthFT[i], cf[i], widthForLabel, 
									   			  widthInch[i], weight[i], kind[i], "roll", printer, simuhinSpliced, mOrder[i]);
										}
									}else{
										if(kind[i].equals("05") || kind[i].equals("07")){
											fg.labels(rollNum, sug[i], charac[i], micron[i], gauge[i], length[i], lengthFT[i], cf[i], widthForLabel, 
										   			  widthInch[i], spWeight[i], kind[i], "roll", printer, simuhinSpliced, 1, weightUnit[i]);
										}else{
											nr.labels(rollNum, sug[i], charac[i], micron[i], gauge[i], length[i], lengthFT[i], cf[i], widthForLabel, 
										   			  widthInch[i], spWeight[i], kind[i], "roll", printer, simuhinSpliced, 1, weightUnit[i]);
										}
									}
								   	if (loadedRoll.length() == 7)
								   		barcodeForUSA = mOrder[i] + loadedRoll + "..0";
								   	else
								   		barcodeForUSA = mOrder[i] + loadedRoll + "0";
								   	
								    if (twoLabels[i].equals("1")){
								    	if (spWeight[i].equals("")){
								    		fg2.labels(loadedRoll, sug[i], charac[i], "", gauge[i], "", length[i], cf[i], "", 
										   		widthInch[i], weight[i], kind[i], "roll", printer, "", "US", barcodeForUSA);
										}else{
											fg2.labels(loadedRoll, sug[i], charac[i], "", gauge[i], "", length[i], cf[i], "", 
										   		widthInch[i], spWeight[i], kind[i], "roll", printer, "", "US", barcodeForUSA, 
										   		1, weightUnit[i]);
										}
										
										out.println("Printed second label<BR>");
								    }
								}else{
									if (! kind[i].equals("05")){
										nr.labels(rollNum, sug[i], charac[i], "", gauge[i], "", length[i], cf[i], "", 
									   		widthInch[i], weight[i], kind[i], "roll", printer, "");
									}else{
										if (rollNum.length() == 7)
									   		barcodeForUSA = mOrder[i] + rollNum + "..0";
									   	else
									   		barcodeForUSA = mOrder[i] + rollNum + "0";
								   		
								   		out.println("barcodeForUSA =  " + barcodeForUSA + "<BR>");
								   		out.flush();
								   		
										if (spWeight[i].equals("")){
											nr.labels(rollNum, sug[i], charac[i], micron[i], gauge[i], lengthMTR[i], length[i], cf[i], widthForLabel, 
										   		widthInch[i], weight[i], kind[i], "roll", printer, "", "US", 
										   		barcodeForUSA, emp, prodDate, parit[i], custItem[i], 
										   		subCustItem[i]);
										}else{
											nr.labels(rollNum, sug[i], charac[i], micron[i], gauge[i], lengthMTR[i], length[i], cf[i], widthForLabel, 
										   		widthInch[i], spWeight[i], kind[i], "roll", printer, "", "US", barcodeForUSA, 
										   		1, weightUnit[i], emp);
										}
										
										if (twoLabels[i].equals("2")){
									    	if (spWeight[i].equals("")){
												nr.labels(rollNum, sug[i], charac[i], micron[i], gauge[i], lengthMTR[i], length[i], cf[i], widthForLabel, 
											   		widthInch[i], weight[i], kind[i], "roll", printer, "", "US", 
											   		barcodeForUSA, emp);
											}else{
												nr.labels(rollNum, sug[i], charac[i], micron[i], gauge[i], lengthMTR[i], length[i], cf[i], widthForLabel, 
											   		widthInch[i], spWeight[i], kind[i], "roll", printer, "", "US", barcodeForUSA, 
											   		1, weightUnit[i], emp);
											}
											
											out.println("Printed second label<BR>");
										}
									}
								}
							}
						} // labels
						
						step = 3;
					} // if (doTheJob)
						
				}	//for (j=1;j<=qtyOfRolls && doTheJob;j++){
				
				out.println("<BR>");
				
				//	samples labels ************ ONLY FOR FINIDSHED ******************* 
				if (doTheJob){
					if (samples[i] > 0 && kind[i].equals("05")){
						sampleNumber = nr.createSampleRoll(mOrder[i]);
					
						String paritSample = request.getParameter("paritSample" + i);
						String lengthSample = request.getParameter("lengthSample" + i);
						
						out.println("paritSample =  " + paritSample + "<BR>");
						out.println("lengthSample =  " + lengthSample + "<BR>");
											
						if (! lengthSample.equals("")){
							/*
							String title2 = "Samples Creation";
							String message2 = "";
							
							if(mie.endsWith("TEST"))
								message2 = "TEST --- Slitter/Folder reporting - Samples Creation: Luz " + orderNum + ", item number " + paritSample + ", width " + widthMm[i] + ", quantity " + samples[i] + ".";
							else
								message2 = "Slitter/Folder reporting - Samples Creation: Luz " + orderNum + ", item number " + paritSample + ", width " + widthMm[i] + ", quantity " + samples[i] + ".";
								
							String[] envp2 = null;
							File file2 = new File("C:\\syfanDB\\");
							
							String ttt = "";
							
							ttt = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il,talyab@syfan.co.il -s:\"" + title2 + "\" -msg:\"" + message2 + "\"";
							Runtime.getRuntime().exec(ttt, envp2, file2);
							*/
							
							// finds weight
							double aa = Double.parseDouble(lengthSample) * Double.parseDouble(widthMm[i]) * Double.parseDouble(cf[i]) * Double.parseDouble(micron[i]) * density;
							double bb = aa / 1000000;
							double cc = bb * samples[i];
							String myWeight = df.format(bb);
							String samplesWeight = df.format(cc);
						
							out.println("CREATES NEW SAMPLE" + "<BR>");
							
							mvxInput = new HashMap();
							mvxInput.put(IMovexConnection.TRANSACTION,"PutAway");
							
							out.println("CONO = " +  mvx + "<BR>");
							out.println("PRNO = " +  paritSample + "<BR>");
							out.println("BANO = " +  sampleNumber + "<BR>");
							out.println("ORQT = " +  samplesWeight + "<BR>");
							out.println("WHLO = " + wrh + "<BR>");
							out.println("WHSL =  SAMPLE<BR>");
							out.println("STRT =  001 <BR>");
							out.flush();
							
							mvxInput.put("CONO", mvx);
							mvxInput.put("PRNO", paritSample);
							mvxInput.put("BANO", sampleNumber);
							mvxInput.put("ORQT", samplesWeight);
							mvxInput.put("WHLO", wrh);
							mvxInput.put("WHSL", "SAMPLE");
							mvxInput.put("STRT", "001");
							
							try {
								connection = factory.getConnection("PMS260MI","", apiuser, apiuserpwd, backend, Integer.parseInt(port));
								final IMovexCommand command = connection.getCommand(mvxInput);
								
								//execute API
								if (command != null) {
									connection.setMaxRecordsReturned(0); //all you got
									//connection.setDateFormat("YMD8", "-");
									resultset = connection.execute(command);
								
									//any errors
									if (!connection.isOk()) {
						           		errMsg = connection.getLastMessage();  
						        		out.println("=================================<BR>Error found PMS260WS:" + errMsg + "<BR>");
						        		out.flush();
						        		
						        		doTheJob = false;
										
										%>
										<script language="javascript">
									
												alert('<%=errMsg.replaceAll("                    ", "")%>');
												window.close();	
												window.opener.enableGoBtn();
										</script>
										<%
						       		}else{
						       			out.println("PMS260WS succeded ...<BR>");
						       			out.flush();
						       			currState=1;
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
							
							
							if (withLabels){
								for (int k=1; k<=samples[i]; k++){
									if (mvxd.indexOf("1") >= 0){				
										fg.labels(loadedRoll, sug[i], charac[i], micron[i], gauge[i], lengthSample, "", cf[i], widthMm[i], 
										   		  widthInch[i], myWeight, kind[i], "samples", printer, simuhinSpliced);
									}else{
										fg.labels(loadedRoll, sug[i], charac[i], "", gauge[i], "", lengthSample, cf[i], "", 
									   		  widthInch[i], myWeight, kind[i], "samples", printer, "");
									}
								}
							}		
							
							totalWeight = totalWeight + Double.parseDouble(myWeight) * samples[i];	
						}	
					}// need samples
				} // samples labels
					
				//	lab labels
				if(doTheJob){
					if (withLabels){
						for (int k=1; k<=qaLabels[i]; k++){
							if (mvxd.indexOf("1") >= 0){
								labLabel.labLabels(loadedRoll, sug[i], charac[i], micron[i], gauge[i], "", "", cf[i], widthMm[i], 
								   		  widthInch[i], "", kind[i], "lab", printer, simuhinSpliced, mOrder[i]);
							}else{
								labLabel.labLabels(loadedRoll, sug[i], charac[i], "", gauge[i], "", "", cf[i], "", 
							   		  	  widthInch[i], "", kind[i], "lab", printer, simuhinSpliced, mOrder[i]);
							}
						}	
					}
				} // lab labels
					
			}	// for (i=1; i<=numOfLines; i++){
				
			boolean isOdd = true;
			
			out.println("slitOrder1 =" + slitOrder1 + "<BR>");
			out.println("slitOrder2 =" + slitOrder2 + "<BR>");
			
			if (! slitOrder1.equals("")){
				session.setAttribute("slitOrder1", "");
				slitOrder1 = "";
				isOdd = true;
			}else{
				session.setAttribute("slitOrder2", "");
				slitOrder2 = "";
				isOdd = false;
			}
				
			out.println("slitOrder1 =" + slitOrder1 + "<BR>");
			out.println("slitOrder2 =" + slitOrder2 + "<BR>");
			
			for (i=1;i<=numOfLines && doTheJob;i++){
				if (qty[i] != 0){
					weightToDrop = Double.toString(Double.parseDouble(weight[i]) * qty[i]);
					
					out.println("Nipuk for line " + i +": " + weightToDrop + "<BR>");
					out.flush();
					
					mvxInput = new HashMap();
					mvxInput.put(IMovexConnection.TRANSACTION,"RptIssue");
					
					
					out.println("..........DO PMS060_RptIssue <BR>");
					out.println("CONO = " + mvx + "<BR>");				
					out.println("FACI = " + faci + "<BR>");
					out.println("WHSL = " + location_bioDirectToSlit + "<BR>");
					out.println("MTNO = " + orderItem + "<BR>");
					out.println("MFNO = " + mOrder[i] + "<BR>");
					out.println("BANO = " + loadedRoll + "<BR>");
					out.println("RPDT = " + myDate + "<BR>");
					out.println("RPTM = " + time.replaceAll(":", "") + "<BR>");
					out.println("RPQA = " + weightToDrop + "<BR>");
					out.println("DSP1 = 1<BR>");
					out.println("DSP2 = 1<BR>");
					out.println("DSP3 = 1<BR>");
					out.println("DSP4 = 1<BR>");
					out.println("DSP5 = 1<BR>");
					out.println("DSP6 = 1<BR>");
					out.println("DSP7 = 1<BR>");
					out.flush();
					
					mvxInput.put("CONO", mvx);
					mvxInput.put("FACI", faci);
					mvxInput.put("WHSL", location_bioDirectToSlit);
					mvxInput.put("MTNO", orderItem);
					mvxInput.put("MFNO", mOrder[i]);
					mvxInput.put("BANO", loadedRoll);
					mvxInput.put("RPDT", myDate);
					mvxInput.put("RPTM", time.replaceAll(":", ""));
					mvxInput.put("RPQA", weightToDrop);
					mvxInput.put("DSP1", "1");
					mvxInput.put("DSP2", "1");
					mvxInput.put("DSP3", "1");
					mvxInput.put("DSP4", "1");
					mvxInput.put("DSP5", "1");
					mvxInput.put("DSP6", "1");
					mvxInput.put("DSP7", "1");
					
					try {
						connection = factory.getConnection("PMS060MI","", apiuser, apiuserpwd, backend, Integer.parseInt(port));
						final IMovexCommand command = connection.getCommand(mvxInput);
						
						//execute API
						if (command != null) {
							connection.setMaxRecordsReturned(0); //all you got
							//connection.setDateFormat("YMD8", "-");
							resultset = connection.execute(command);
						
							//any errors
							if (!connection.isOk()) {
				           		errMsg = connection.getLastMessage();  
				        		out.println("=================================<BR>Error found PMS060:" + errMsg + "<BR>");
				        		out.flush();
				        		
				        		message = "Slitter/Folder reporting failed: machine " + machine + ", Luz " + orderNum + ", loaded roll " + loadedRoll +" - PMS060 failed for column "+ i +", movex order "+ mOrder[i] +" .";
				        		message = message + "weight reported: " + weightToDrop +", date reported " + myDate;
				        		message = message + ".   ------ ERROR: " + errMsg;
				        		
				        		title = "Problem in slitter/folder reporting";
								String[] envp = null;
								File file = new File("C:\\syfanDB\\");
								
								String iii = "";
								
								if (mvxd.indexOf("1") >= 0)
									iii = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title + "\" -msg:\"" + message + "\"";
								else
									iii = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title + "\" -msg:\"" + message + "\"";
									
								Runtime.getRuntime().exec(iii, envp, file);
								
				        		doTheJob = false;
								
								%>
								<script language="javascript">
							
										alert('<%=errMsg.replaceAll("                    ", "")%>');
										window.close();	
										window.opener.enableGoBtn();
								</script>
								<%
				       		}else{
				       			out.println("PMS060 succeded ...<BR>");
				       			out.flush();
				       			currState=1;
				       			
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
					
				}
			}
			
			result = 3;
			
			if (doTheJob){
				if (slitOrder1.equals("") && slitOrder2.equals("")){
					%>
					<script language="javascript">
						window.close();
						window.opener.returnToFirst();
					</script>
				
					<%
				}else{
					%>
					<script language="javascript">
						window.close();
						window.opener.loadAgain();
					</script>
				
					<%
				}
			}
			
			if (! doTheJob){
				switch (result){
					case 0:
						message = "Slitter reporting failed: machine " + machine + ", Luz " + orderNum + ", loaded roll " + loadedRoll +" - no API done.";
						break;
					case 1:
						message = "Slitter reporting failed: machine " + machine + ", Luz " + orderNum + ", loaded roll " + loadedRoll +" - only creation of jumbo done.";
						break;
					case 2:
						message = "Slitter reporting failed: machine " + machine + ", Luz " + orderNum + ", loaded roll " + loadedRoll +" - only creation of jumbo and slitted rolls done.";
						break;
					default:
				}
				
				if (! message.equals("")){
					title = "Problem in Slitter reporting";
					String[] envp = null;
					File file = new File("D:\\syfanDB\\");
					
					String aaa = "";
					
					if (mvxd.indexOf("1") >= 0)
						aaa = "D:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title + "\" -msg:\"" + message + "\"";
					else
						aaa = "D:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:ayeletb@saad.org.il -s:\"" + title + "\" -msg:\"" + message + "\"";
						
					Runtime.getRuntime().exec(aaa, envp, file);	
				}
			}
			
		}
	}
	%> 
	<script language="javascript">
	window.close();
	window.opener.returnToFirst();
</script>
</body>
</html>	
