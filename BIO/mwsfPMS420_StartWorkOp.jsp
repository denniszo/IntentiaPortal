
<%@include file="nipuah-const.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
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

<html>
<head>
	<TITLE>Start Setup</TITLE>
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
	Connection dbConn = null;
	try {
      Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");

      //db name
      String dbName = "Movex";     

      String url = "jdbc:odbc:" + dbName;
      
      dbConn = DriverManager.getConnection(url, mws_username, mws_password);
      out.println(dbConn.toString()+"<BR>");
      out.flush();

    } catch (SQLException ex) { // Handle SQL errors
      	out.println(ex.toString());
    } catch (ClassNotFoundException ex1) {
     	out.println(ex1.toString());
    }
    
    
	int i_rejQty;
	String mie=String.valueOf(MIEAppID);
	boolean doTheJob = true;
	
	String date = request.getParameter("date");
	String time = request.getParameter("hour"); 
	 
	String workSeq = request.getParameter("workSeqHid"); 
	String order = request.getParameter("orderHID");
	String syfanOrder = request.getParameter("orderNum"); 
	String bio = "B" + syfanOrder.charAt(0); 
	
	String myDate = "";
	String faci = "";
	String test = "";
	
	if (mvxd.indexOf("1") >= 0){
		myDate = "20"+date.substring(6,8)+date.substring(3,5)+date.substring(0,2);
		faci = "001";
	}else{
		myDate = "20"+date.substring(6,8)+date.substring(0,2)+date.substring(3,5);
		faci = "200";
	}
	
	if(mie.endsWith("TEST"))
		test = "1";
	else
		test = "0";
		
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	String sql = "";
	
	sql = "select * from seijdta.syfbio as AA WHERE AA.BIO=? and AA.FACI=? and AA.TEST=?";
	
	try {
	    	
      stmt = dbConn.prepareStatement(sql);
      //set parameters
      stmt.setString(1, bio);
      stmt.setString(2, faci);
      stmt.setString(3, test);
         
      rs = stmt.executeQuery();
      
      if (rs.next()){				// there is already a record for this machine
      	String sOrder = rs.getString("syfanOrder");
      	String sMovOrder = rs.getString("movexOrder");
      	
      	if (! sOrder.equals(syfanOrder)){		// another order on this machine
      		out.println("Another order on bio ...<BR>");
	    	out.flush();
	    		
      		doTheJob = false;
      		stmt.close();
      		%>
				<script language="javascript">
					alert("<%=error_otherOrderOnMachine%>");
					window.close();
					window.opener.returnToFirst();
				</script>
			<%
      	}else{						// this order already started
      				
      		if (sMovOrder==null || sMovOrder.equals("")){	//	order was stoped
      			out.println("Update record in bio table ...<BR>");
	    		out.flush();
	    
      			doTheJob = true;
      			stmt.close();
      			
      			sql = "UPDATE seijdta.syfbio as AA SET MOVEXORDER = ? WHERE AA.BIO=? and AA.FACI=? and AA.TEST=?";
	       		
	       		try {
		       		stmt = dbConn.prepareStatement(sql);
			        //set parameters
			        stmt.setString(1,order);
			        stmt.setString(2, bio);
			        stmt.setString(3, faci);
			        stmt.setString(4, test);
			        
			        stmt.executeUpdate();
			     } catch (SQLException sqlEx) {
			      	out.println(sqlEx);
			      	sqlEx.printStackTrace();
			     } finally {
				      try {
				        stmt.close();
				      } catch (Exception e) {}
			     } //end finally
			     
			     //stmt.close();
      		}else{
      			stmt.close();
      			doTheJob = false;
	      		%>
					<script language="javascript">
						alert("<%=error_orderAlreadyStarted%>");
						window.close();
						window.opener.returnToFirst();
					</script>
				<%
			}     		
      		
      	}
      }else{
      	out.println("Insert new record in bio table ...<BR>");
	    out.flush();
	       			
      	doTheJob = true;
      	stmt.close();
      	
      	sql = "INSERT INTO seijdta.syfbio (BIO,MOVEXORDER,SYFANORDER,FACI,TEST) VALUES(?,?,?,?,?)";
		
		try {
	      stmt = dbConn.prepareStatement(sql);
	      //set parameters
	      stmt.setString(1, bio);
	      stmt.setString(2, order);
	      stmt.setString(3, syfanOrder);
	      stmt.setString(4, faci);
		  stmt.setString(5, test);
	      
	      stmt.executeUpdate();
	      } catch (SQLException sqlEx) {
	      	out.println(sqlEx.toString());
	      	sqlEx.printStackTrace();
	      } finally {
		      try {
		        stmt.close();
		      } catch (Exception e) {out.println(e.toString());}
	      } //end finally
	  }// end if
	} catch (Exception e) {}
      
      
     try {
      if (dbConn != null && !dbConn.isClosed()) {
        dbConn.close();
        System.out.println("DB connection is closed.");
      }
    } catch (Exception e) {}
    
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
		out.println("apiuser = " + apiuser + "<BR>");
		//out.println("apiuserpwd = " + apiuserpwd + "<BR>");
		out.flush();
		
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
		mvxInput.put(IMovexConnection.TRANSACTION,"StartWorkOp");
		
		out.println(".......... running PMS420 StartWorkOp<BR>");		
		out.println("SDAT = " + myDate + "<BR>");
		out.println("STTE = " + time.replaceAll(":", "") + "<BR>");
		out.println("WOSQ = " + workSeq + "<BR>");
		out.println("CANO = " + genEmp + "<BR>");
    
    	mvxInput.put("SDAT", myDate);
    	mvxInput.put("STTE", time.replaceAll(":", ""));
    	mvxInput.put("WOSQ", workSeq);
    	mvxInput.put("CANO", genEmp);
    	
    	try {
			connection = factory.getConnection("PMS420MI","", apiuser, apiuserpwd, backend, Integer.parseInt(port));
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
	       			out.println("PMS420 succeded ...<BR>");
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

	%> 
	<script language="javascript">
		window.close();
		window.opener.returnToFirst();
	</script>
</body>
</html>
