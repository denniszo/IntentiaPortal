
<%@include file="nipuah-const1.jsp"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.SQLException"%>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.PreparedStatement"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import="java.sql.Timestamp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@include file="../rollsAndLabels.jsp"%>

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
	<TITLE>Recycling Reporting</TITLE>
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
	String mie=String.valueOf(MIEAppID);
	String mvx = String.valueOf(MvxCompany);
	
	boolean doTheJob = true;
	
	String chosen = request.getParameter("checked");
	
	String item = request.getParameter("item" + chosen);
	String description = request.getParameter("descHID" + chosen);
	String myDate = request.getParameter("date"); 
	String qty = request.getParameter("qty"); 
	String dateTime = request.getParameter("dateHID") + " " + request.getParameter("hourHID") + " " + request.getParameter("employee");
	
	out.println("item = " +  item + "<BR>");
	out.println("description = " +  description + "<BR>");
	out.println("myDate = " +  myDate + "<BR>");
	out.println("dateTime = " +  dateTime + "<BR>");
	
	String printer = "";
	boolean withLabels = false;

	String addLabels = request.getParameter("withLabels");
	
	String itur = "";
	String wrh = "";
	String faci = "";

	if (mvxd.indexOf("1") >= 0){
		itur = "01";
		wrh = "010";
		faci = "001";
	}else{
		itur = "11";
		wrh = "200";
		faci = "200";
	}
	
	if (addLabels != null){
		if (addLabels.equals("yes")){
			withLabels = true;
			
			Connection dbConn = null;
			try {
		      Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
		
		      //db name
		      String dbName = "Movex";     
		
		      String url = "jdbc:odbc:" + dbName;
		      
		      dbConn = DriverManager.getConnection(url, mws_username, mws_password);
		      //out.println(dbConn.toString());
		      //out.flush();
		
		    } catch (SQLException ex) { // Handle SQL errors
		      	out.println(ex.toString());
		      	doTheJob = false;
		    } catch (ClassNotFoundException ex1) {
		     	out.println(ex1.toString());
		     	doTheJob = false;
		    }
		    
			PreparedStatement stmt = null;
			ResultSet rs = null;
			
			String sql = "select * FROM seijdta.syfprinters as AA WHERE AA.USER=? and AA.SUG='L0' and AA.FACI=?";
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
		    	doTheJob = false;
		    }
		}
	}
	
	out.println("printer = " + printer + "<BR>");
	out.flush();
	
	if (doTheJob){
		//get session information for user
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
		mvxInput.put(IMovexConnection.TRANSACTION,"PutAway");
		
		out.println("...........MWS = PMS260_PutAway<BR>");
		out.println("CONO = " +  mvx + "<BR>");
		out.println("PRNO = " +  item + "<BR>");
		out.println("ORQT = " +  qty + "<BR>");
		out.println("WHLO = " + wrh + "<BR>");
		out.println("WHSL = " + itur + "<BR>");
		out.println("STRT =  001 <BR>");
		
		mvxInput.put("CONO", mvx);
		mvxInput.put("PRNO", item);
		mvxInput.put("ORQT", qty);
		mvxInput.put("WHLO", wrh);
		mvxInput.put("WHSL", itur);
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
	
	if (doTheJob){
		if (withLabels){
			createRollNum nr = new createRollNum();
			nr.initRecycleLabelArray();
			nr.deleteOldFiles();
			
			if (mvxd.indexOf("1") >= 0){
				for (int i=1;i<=2;i++){
					out.println("label no " + i + "<BR>");
					nr.recycleLabels(item, description, qty, myDate, dateTime, printer);
				}
			}else{
				for (int i=1;i<=3;i++){
					out.println("label no " + i + "<BR>");
					nr.recycleLabels(item, description, qty, myDate, dateTime, printer);
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