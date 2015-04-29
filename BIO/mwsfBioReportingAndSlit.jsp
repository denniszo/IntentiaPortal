<%@ page import = "java.math.BigInteger"%>
<%@include file="nipuah-const1.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@include file="../rollsAndLabels.jsp"%>

<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.SQLException"%>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.PreparedStatement"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.io.FileNotFoundException"%>
<%@ page import = "java.io.IOException"%>

<%@ page import = "java.util.Iterator,
    com.intentia.mie.IMieEntity" %>
<%@ page import = "com.intentia.mie.IMieCollection" %>
<%@ page import = "com.intentia.mie.MieCollectionFactory" %>

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
	int i_rejQty;
	String mie=String.valueOf(MIEAppID);
	String mvx = String.valueOf(MvxCompany);
	
	boolean doTheJob = true;
	String rollToCheck = request.getParameter("roll1Hid");
	
	String model = "";
	if(mie.endsWith("TEST"))
		model = "MVXJDTATST";
	else
		model = "MVXJDTA";
	
	String newRoll = "";
		
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
      	out.println(ex.toString());
    } catch (ClassNotFoundException ex1) {
     	out.println(ex1.toString());
    }

	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	String sql = "";
	
	sql = "SELECT LMBANO as ROLL from " + model + ".MILOMA WHERE LMCONO= ? and LMBANO= ? order by LMBANO desc";
			
	try {
      stmt = dbConn.prepareStatement(sql);
      
      //set parameters
      stmt.setString(1, mvx);
      stmt.setString(2, rollToCheck);
         
      rs = stmt.executeQuery();
      
      if (rs.next()){				// there is a record found
    	  newRoll = rs.getString("ROLL");
      }
    } catch (Exception e) {}
	
	out.println("newRoll  = " + newRoll + "<BR>");
	out.flush();
	
	if (! newRoll.equals("")){
		doTheJob = false;
	%>
		<script language="javascript">
	
				alert("<%=error_AlreadyCreated%>");
				window.close();	
				window.opener.returnToFirst();
		</script>
			
		<%
	
	}
	
	String slitOrder1 = request.getParameter("slitOrder1");
	String slitOrder2 = request.getParameter("slitOrder2");
	
	String slitter1 = request.getParameter("slitter1");
	String slitter2 = request.getParameter("slitter2");
	
	out.println("slitOrder1 = " + slitOrder1 + "<BR>");
	out.println("slitOrder2 = " + slitOrder2 + "<BR>");
	
	session.setAttribute("slitOrder1", slitOrder1);
	session.setAttribute("slitOrder2", slitOrder2);
	session.setAttribute("slitter1", slitter1);
	session.setAttribute("slitter2", slitter2);
	
	if (! (slitOrder1.equals("") && slitOrder2.equals(""))){
		String machine = request.getParameter("slitterHID");
		String loadedItem = request.getParameter("itnoHid");
		String employee = request.getParameter("emp1");
		
		out.println("machine = " + machine + "<BR>");
		out.println("loadedItem = " + loadedItem + "<BR>");
		out.println("employee = " + employee + "<BR>");
		
		session.setAttribute("machine", machine);
		session.setAttribute("loadedItem", loadedItem);
		session.setAttribute("employee", employee);
	}
	
	if (doTheJob){
		String printer = "";
		String faci = "";
		
		if (mvxd.indexOf("1") >= 0)
			faci = "001";
		else
			faci = "200";
				
		boolean withLabels = false;
		String addLabels = request.getParameter("withLabels");
		
		if (addLabels != null){
			if (addLabels.equals("yes")){
				withLabels = true;
				
				//get the printer for this user
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
			    } catch (Exception e) {}
			}
		}
			
		String date = "";
		String myDate =	"";
		String time = "";
						
		String workSeq = request.getParameter("workSeqHid"); 
		String itno = request.getParameter("itnoHid"); 
		String whlo = request.getParameter("whloHid"); 
		String printType = request.getParameter("printTypeHID"); 
		String micron = request.getParameter("micronHID"); 
		String gauge = request.getParameter("txtThick"); 
		
		String weight = "";
		String length = "";
		String width = "";
		String roll = "";
		String slitOrder = "";
	      
	    out.println("workSeq = " + workSeq + "<BR>");
	    out.println("itno = " + itno + "<BR>");
	    out.println("whlo = " + whlo + "<BR>");
	    out.println("printType = " + printType + "<BR>");
	    out.println("micron = " + micron + "<BR>");
	    
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
		
		createRollNum nr = new createRollNum();	
			
		if (slitOrder1 == "" && slitOrder2 == ""){		
			// inits the label array
			
			if (mvxd.indexOf("1") >= 0)
				nr.initLabelArray();
			else
				nr.initLabelArray("US");
	    }
			
		for (int i=1;i<=2 && doTheJob;i++){
			date = request.getParameter("date" + i);
			if (mvxd.indexOf("1") >= 0)
				myDate = "20"+date.substring(6,8)+date.substring(3,5)+date.substring(0,2);
			else
				myDate = "20"+date.substring(6,8)+date.substring(0,2)+date.substring(3,5);

			time = request.getParameter("hour"  + i);
	 
			roll = request.getParameter("roll" + i + "Hid");
			weight = request.getParameter("weight" + i);
			length = request.getParameter("length" + i);
			width = request.getParameter("width" + i);
			
			slitOrder = request.getParameter("slitOrder" + i);
			
			if (! slitOrder.equals("")){
				session.setAttribute("date" + i, myDate);
				session.setAttribute("time" + i, time);
				session.setAttribute("workSeq" + i, workSeq);
				session.setAttribute("roll" + i, roll);
				session.setAttribute("length" + i, length);
				session.setAttribute("width" + i, width);
				
				out.println("slitOrder = " + slitOrder + "<BR>");
				out.println("Do Not Do Anything<BR>");
			}else{
			
				out.println("roll = " + roll + "<BR>");
				out.println("weight = " + weight + "<BR>");
				out.println("length = " + length + "<BR>");
				out.println("width = " + width + "<BR>");	
				
				mvxInput = new HashMap();
				mvxInput.put(IMovexConnection.TRANSACTION,"RptReceipt");
				
				out.println("<BR>");
				out.println(".......... running PMS050 RptReceipt<BR>");		
				out.println("CONO = " + mvx + "<BR>");
				out.println("TRDT = " + myDate + "<BR>");
				out.println("RPDT = " + myDate + "<BR>");
				out.println("TRTM = " + time.replaceAll(":", "") + "<BR>");
				out.println("RPTM = " + time.replaceAll(":", "") + "<BR>");
				out.println("WOSQ = " + workSeq + "<BR>");
				out.println("RPQA = " + weight + "<BR>");
				
				if (mvxd.indexOf("1") >= 0)
					out.println("MAUN = KG<BR>");	
				else
					out.println("MAUN = LBS<BR>");
					
				out.println("WHSL = 02-" + request.getParameter("loc" + i) + "<BR>");
				out.println("STAS = 1<BR>");
				out.println("BANO = " + roll + "<BR>");
				out.println("BREF = " + length + "<BR>");
				out.println("BRE2 = " + width + "<BR>");
				out.flush();
				
				mvxInput.put("CONO", mvx);
				mvxInput.put("TRDT", myDate);
				mvxInput.put("RPDT", myDate);
				mvxInput.put("TRTM", time.replaceAll(":", ""));
				mvxInput.put("RPTM", time.replaceAll(":", ""));
				mvxInput.put("WOSQ", workSeq);
				mvxInput.put("RPQA", weight);
				
				if (mvxd.indexOf("1") >= 0)
					mvxInput.put("MAUN", "KG");
				else
					mvxInput.put("MAUN", "LBS");
					
				mvxInput.put("WHSL", "02-" + request.getParameter("loc" + i));
				mvxInput.put("STAS", "1");
				mvxInput.put("BANO", roll);
				mvxInput.put("BREF", length);
				mvxInput.put("BRE2", width);
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
				
				String atnr = "";
				
				if (doTheJob) {
					out.println("mie = " + mie + "<BR>");
					out.println("mvx = " + mvx + "<BR>");
					out.println("roll = " + roll + "<BR>");
					out.println("item = " + itno + "<BR>");
					
					sql = "select CHAR(AGATNR) as ATNR FROM " + model + ".MIATTR WHERE AGATID = 'LENGHT' AND AGCONO=? and AGBANO=? and AGITNO=?";
					
					try {
				      stmt = dbConn.prepareStatement(sql);
				      
				      //set parameters
				      stmt.setString(1, mvx);
				      stmt.setString(2, roll);
				      stmt.setString(3, itno);
				         
				      rs = stmt.executeQuery();
				      
				      if (rs.next()){				// there is a record found
				      	atnr = rs.getString("ATNR").trim();
				      }
				    } catch (Exception e) {}
					
					out.println("atnr  = " + atnr + "<BR>");
					out.flush();
					
					String widthInt = "";
					int place = width.indexOf(".");
					
					if (place >= 0)
						widthInt = width.substring(0,place);
					else
						widthInt = width;
						
					mvxInput = new HashMap();
					mvxInput.put(IMovexConnection.TRANSACTION,"SetAttrValue");
					
					out.println(".......... running ATS101 SetAttrValue for width<BR>");		
					out.println("CONO = " + mvx + "<BR>");
					out.println("ATNR = x" + atnr + "x<BR>");
					out.println("ATID = WIDTH<BR>");
					out.println("ATVA = " + width + "<BR>");
					out.flush();
				
					mvxInput.put("CONO", mvx);
					mvxInput.put("ATNR", atnr);
					mvxInput.put("ATID", "WIDTH");
					mvxInput.put("ATVA", width);
					
					try {out.println("ATS101 try 00000<BR>");
	       				out.flush();
						connection = factory.getConnection("ATS101MI","", apiuser, apiuserpwd, backend, Integer.parseInt(port));
						
						out.println("ATS101 try 111111.<BR>");
		       			out.flush();
						final IMovexCommand command = connection.getCommand(mvxInput);
						
						out.println("ATS101 try ...<BR>");
		       			out.flush();
		       			
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
				       			out.println("ATS101 succeded ...<BR>");
				       			out.flush();
				       			currState=1;
				       		}
				         }
					} catch (ConnectorException e) {
						e.printStackTrace();
						out.println("ATS101 failed ...<BR>");
		       			out.flush();
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
				
				if (doTheJob) {
					mvxInput = new HashMap();
					mvxInput.put(IMovexConnection.TRANSACTION,"SetAttrValue");
					
					out.println(".......... running ATS101 SetAttrValue for length<BR>");		
					out.println("CONO = " + mvx + "<BR>");
					out.println("ATNR = " + atnr + "<BR>");
					out.println("ATID = LENGHT<BR>");
					out.println("ATVA = " + length + "<BR>");
					out.flush();
				
					mvxInput.put("CONO", mvx);
					mvxInput.put("ATNR", atnr);
					mvxInput.put("ATID", "LENGHT");
					mvxInput.put("ATVA", length);
					
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
				       			out.println("ATS101 succeded ...<BR>");
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
				
				
				if (doTheJob) {
					mvxInput = new HashMap();
					mvxInput.put(IMovexConnection.TRANSACTION,"SetAttrValue");
					
					out.println(".......... running ATS101 SetAttrValue for employee<BR>");		
					out.println("CONO = " + mvx + "<BR>");
					out.println("ATNR = " + atnr + "<BR>");
					out.println("ATID = EMPLOYY<BR>");
					if (mvxd.indexOf("1") >= 0)
						out.println("ATVA = " + "E" + request.getParameter("emp" + i) + "<BR>");
					else
						out.println("ATVA = " + "UE" + request.getParameter("emp" + i) + "<BR>");
					out.flush();
				
					mvxInput.put("CONO", mvx);
					mvxInput.put("ATNR", atnr);
					mvxInput.put("ATID", "EMPLOYY");
					if (mvxd.indexOf("1") >= 0)
						mvxInput.put("ATVA", "E" + request.getParameter("emp" + i));
					else
						mvxInput.put("ATVA", "UE" + request.getParameter("emp" + i));
					
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
				       			out.println("ATS101 succeded ...<BR>");
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
				
				if (doTheJob) {
					mvxInput = new HashMap();
					mvxInput.put(IMovexConnection.TRANSACTION,"SetAttrValue");
					
					out.println(".......... running ATS101 SetAttrValue for note<BR>");		
					out.println("CONO = " + mvx + "<BR>");
					out.println("ATNR = " + atnr + "<BR>");
					out.println("ATID = TEXT1<BR>");
					out.println("ATVA = " + request.getParameter("note" + i) + "<BR>");
					out.flush();
				
					mvxInput.put("CONO", mvx);
					mvxInput.put("ATNR", atnr);
					mvxInput.put("ATID", "TEXT1");
					mvxInput.put("ATVA", request.getParameter("note" + i));
					
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
				       			out.println("ATS101 succeded ...<BR>");
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
				
				
				if (doTheJob) {
					mvxInput = new HashMap();
					mvxInput.put(IMovexConnection.TRANSACTION,"SetAttrValue");
					
					out.println(".......... running ATS101 SetAttrValue for no 1<BR>");		
					out.println("CONO = " + mvx + "<BR>");
					out.println("ATNR = " + atnr + "<BR>");
					out.println("ATID = NO 1<BR>");
					out.println("ATVA = -1<BR>");
					out.flush();
				
					mvxInput.put("CONO", mvx);
					mvxInput.put("ATNR", atnr);
					mvxInput.put("ATID", "NO 1");
					mvxInput.put("ATVA", "-1");
					
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
				       			out.println("ATS101 succeded ...<BR>");
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
					
				if (doTheJob) {
					mvxInput = new HashMap();
					mvxInput.put(IMovexConnection.TRANSACTION,"SetAttrValue");
					
					out.println(".......... running ATS101 SetAttrValue for no 2<BR>");		
					out.println("CONO = " + mvx + "<BR>");
					out.println("ATNR = " + atnr + "<BR>");
					out.println("ATID = NO 2<BR>");
					out.println("ATVA = -1<BR>");
					out.flush();
				
					mvxInput.put("CONO", mvx);
					mvxInput.put("ATNR", atnr);
					mvxInput.put("ATID", "NO 2");
					mvxInput.put("ATVA", "-1");
					
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
				       			out.println("ATS101 succeded ...<BR>");
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
				
				if (doTheJob) {
					if (withLabels){
						if (mvxd.indexOf("1") >= 0)
							nr.labels(roll, printType, "", micron, "", length, "", "", width, "", weight, "02", "roll", printer, "0");
						else{
							nr.labels(roll, printType, "", "", gauge, "", length, "", "", width, weight, "02", "roll", printer, "0");
							nr.labels(roll, printType, "", "", gauge, "", length, "", "", width, weight, "02", "roll", printer, "0");
						}
					}
				}
			}
		}
	}		
		
	%>
	<script language="javascript">
		window.close();
		window.opener.continueTheJob();
	</script>
</body>
</html>
