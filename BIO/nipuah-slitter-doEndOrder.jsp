<%@ page import = "Slitter.*"%>
<%@ page import = "BIO.*"%>
<%@ page import = "Pack.*"%>
<%@include file="nipuah-slitter-const1.jsp"%>
<%@include file="nipuah-slitter-labels-heb.jsp"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.SQLException"%>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.PreparedStatement"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import = "java.text.DecimalFormat"%>

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
	Connection dbConn = null;
	try {
      Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");

      //db name    
	  String dbName = "Movex"; 
	  
      String url = "jdbc:odbc:" + dbName;
      
      dbConn = DriverManager.getConnection(url, mws_username, mws_password);
      out.println(dbConn.toString());
      out.flush();

    } catch (SQLException ex) { // Handle SQL errors
      	out.println(ex.toString());
    } catch (ClassNotFoundException ex1) {
     	out.println(ex1.toString());
    }
	
	int i_rejQty;
	String mie=String.valueOf(MIEAppID);
	String mvx = String.valueOf(MvxCompany);
	boolean doTheJob = true;
	
	DecimalFormat df = new DecimalFormat("#0.00");
	String totalTime = "";
	String machine = request.getParameter("machine");
	String workCenter =  request.getParameter("machineHID");
	String order = request.getParameter("orderNum");
	String status = request.getParameter("statusHID");
	String statusLow = request.getParameter("statusLowHID");
	String done = request.getParameter("doneHID");
	String itemFrom = request.getParameter("itemFromHID");
	
	String date = request.getParameter("date");
	String faci = "";
	String myDay = "";
	String myMonth = "";
	String myDate = "";
	
	if (mvxd.indexOf("1") >= 0){
		myDay = date.substring(0,2);
		myMonth = date.substring(3,5);
		myDate = "20"+date.substring(6,8)+date.substring(3,5)+date.substring(0,2);
		faci = "001";
	}else{
		myDay = request.getParameter("date").substring(3,5);
		myMonth = request.getParameter("date").substring(0,2);
		myDate = "20"+date.substring(6,8)+date.substring(0,2)+date.substring(3,5);
		faci = "200";
	}
	String myYear = "20" + date.substring(6,8);
	String myTime = request.getParameter("hour").substring(0,5);
	
	Timestamp dateTime = Timestamp.valueOf(myYear + "-" + myMonth + "-" + myDay + " " + myTime + ":00");
	
	int numOfOrders = Integer.parseInt(request.getParameter("numOfOrdersHID"));
	
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	String sql = "select * from seijdta.syfslitfold as AA where AA.MACHINE = ? and AA.TEST = ? and AA.FACI = ?";
	String test = "";
	
	if(mie.endsWith("TEST"))
		test = "1";
	else
		test = "0";
	
	try {
      stmt = dbConn.prepareStatement(sql);
      //set parameters
      stmt.setString(1, machine);
      stmt.setString(2, test);
      stmt.setString(3, faci);
         
      rs = stmt.executeQuery();
      
      if (rs.next()){				// there is already a record for this machine
			String orderStarted = rs.getString("orderNum");
      		String empRashum = rs.getString("employee");
      		
      		if (!order.equals(orderStarted)){			// wrong order
      			doTheJob = false;
      			%>
					<script language="javascript">
						alert("<%=error_anotherOrderStarted%>");
						window.close();
						window.opener.returnToFirst();
					</script>
				<%  
			}else{
		      	
		      	
	  			stmt.close();
	  			
	  			sql = "DELETE FROM seijdta.syfslitfold as AA WHERE MACHINE=? and AA.FACI=? and AA.TEST=?";
	   			
	   			try {
		       		stmt = dbConn.prepareStatement(sql);
			        //set parameters
			        stmt.setString(1, machine);
			        stmt.setString(2, faci);
      				stmt.setString(3, test);
			        
			        stmt.executeUpdate();
			     } catch (SQLException sqlEx) {
			      	out.println(sqlEx);
			      	sqlEx.printStackTrace();
			     } finally {
				      try {
				        stmt.close();
				      } catch (Exception e) {}
			     } //end finally
			    
			}
      }else{  // the machine is not working
      		doTheJob = false;
			%>
				<script language="javascript">
					alert("<%=error_machineNotWorking%>");
					window.close();
					window.opener.returnToFirst();
				</script>
			<%
	  }// end if
	} catch (Exception e) {}
      
    try {
      if (dbConn != null && !dbConn.isClosed()) {
        dbConn.close();
        System.out.println("DB connection is closed.");
      }
    } catch (Exception e) {}
    
    
    if (doTheJob){
    	// get session information for user
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
    	
		String lineOrder = "";
		String item = "";
		String col = "";
		String qtyDone = "";
		String rollStatus = "";
		
		for (int i=1;i<=numOfOrders && doTheJob;i++){
			lineOrder = request.getParameter("order" + i);
			item = request.getParameter("item" + i);
			col = request.getParameter("col" + i);
			qtyDone = request.getParameter("done" + i);
			rollStatus = request.getParameter("rollStatus" + i);
			
			mvxInput = new HashMap();
			mvxInput.put(IMovexConnection.TRANSACTION,"RptOperation");
			
			out.println("..........DO PMS070_RptOperation <BR>");
			out.println("CONO = " + mvx + "<BR>");				
			out.println("FACI = " + faci + "<BR>");
			out.println("MFNO = " + lineOrder + "<BR>");	
			out.println("MAQA = 0<BR>");
			out.println("RPDT = " + myDate + "<BR>");
			out.println("EMNO = " + genEmp + "<BR>");
			out.println("REND = 1<BR>");
			out.println("OPNO = 30<BR>");
			out.println("DSP1 = 1<BR>");
			out.println("DSP2 = 1<BR>");
			out.println("DSP3 = 1<BR>");
			out.println("DSP4 = 1<BR>");
			out.flush();
			
			mvxInput.put("CONO", mvx);
			mvxInput.put("FACI", faci);
			mvxInput.put("MFNO", lineOrder);
			mvxInput.put("MAQA", "0");
			mvxInput.put("RPDT", myDate);
			mvxInput.put("EMNO", genEmp);
			mvxInput.put("REND", "1");
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
			
			if (doTheJob){
				mvxInput = new HashMap();
				mvxInput.put(IMovexConnection.TRANSACTION,"RptReceipt");
				
				out.println("..........DO PMS050_RptReceipt <BR>");
				out.println("CONO = " + mvx + "<BR>");				
				out.println("FACI = " + faci + "<BR>");
				out.println("PRNO = " + item + "<BR>");
				out.println("MFNO = " + lineOrder + "<BR>");
				out.println("RPQA = 0<BR>");
				out.println("REND = 1<BR>");	
				out.println("DSP1 = 1<BR>");
				out.println("DSP2 = 1<BR>");
				out.println("DSP3 = 1<BR>");
				out.println("DSP4 = 1<BR>");
				out.println("DSP5 = 1<BR>");
				out.flush();
				
				mvxInput.put("CONO", mvx);
				mvxInput.put("FACI", faci);
				mvxInput.put("PRNO", item);
				mvxInput.put("MFNO", lineOrder);
				mvxInput.put("RPQA", "0");
				mvxInput.put("REND", "1");
				mvxInput.put("DSP1", "1");
				mvxInput.put("DSP2", "1");
				mvxInput.put("DSP3", "1");
				mvxInput.put("DSP4", "1");
				mvxInput.put("DSP5", "1");
				
				if (! rollStatus.equals("0")){
					out.println("STAS = " + rollStatus + "<BR>");
					mvxInput.put("STAS", rollStatus);
				}
				
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
			
			if (doTheJob){
				mvxInput = new HashMap();
				mvxInput.put(IMovexConnection.TRANSACTION,"RptIssue");
				
				out.println("..........DO PMS060_RptIssue <BR>");
				out.println("CONO = " + mvx + "<BR>");				
				out.println("FACI = " + faci + "<BR>");
				out.println("MTNO = " + itemFrom + "<BR>");
				out.println("MFNO = " + lineOrder + "<BR>");
				out.println("RPDT = " + myDate + "<BR>");
				out.println("RPQA = 0<BR>");
				out.println("REND = 1<BR>");
				out.println("DSP1 = 1<BR>");
				out.println("DSP2 = 1<BR>");
				out.println("DSP3 = 1<BR>");
				out.println("DSP4 = 1<BR>");
				out.println("DSP5 = 1<BR>");
				out.flush();
				
				mvxInput.put("CONO", mvx);
				mvxInput.put("FACI", faci);
				mvxInput.put("MTNO", itemFrom);
				mvxInput.put("MFNO", lineOrder);
				mvxInput.put("RPDT", myDate);
				mvxInput.put("RPQA", "0");
				mvxInput.put("REND", "1");
				mvxInput.put("DSP1", "1");
				mvxInput.put("DSP2", "1");
				mvxInput.put("DSP3", "1");
				mvxInput.put("DSP4", "1");
				mvxInput.put("DSP5", "1");
				
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
    }	
    %> 
	<script language="javascript">
		window.close();
		window.opener.returnToFirst();
	</script>
</body>
</html>	
    	
	
	