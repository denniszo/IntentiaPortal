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
	String MIEserverURLHardCoded = "http://" + request.getServerName() + "/MIE50/MieIsapi.dll";
	
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
	
	boolean doTheJob = true;
	String rollToCheck = request.getParameter("roll1Hid");
	
	if (doTheJob){
		String printer = "";
		String faci = "";
		createRollNum nr = null;	
		
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
				
				out.println("printer  = " + printer + "<BR>");
				out.flush();
					
				// inits the label array
				nr = new createRollNum();
				if (mvxd.indexOf("1") >= 0)
					nr.initLabelArray();
				else
					nr.initLabelArray("US");
			}
		}
			
		String date = "";
		String myDate =	"";
		String time = "";
		String loc = "";
						
		String order = request.getParameter("orderHID"); 
		String atnr = request.getParameter("atnHID");
		String itno = request.getParameter("txtItem"); 
		String whlo = request.getParameter("wrhHID"); 
		String printType = request.getParameter("printTypeHID"); 
		String micron = request.getParameter("micronHID"); 
		String gauge = request.getParameter("gaugeHID");
		String whatToDo = request.getParameter("fix"); 
		String roll = request.getParameter("txtRoll");
		String weight = request.getParameter("newWeightHID"); 
		String length = request.getParameter("length2");
		String width = request.getParameter("width2");
		String note = request.getParameter("note2");
		String oldNote = request.getParameter("noteHID");
		String employee = request.getParameter("emp2");
		String oldEmployee = request.getParameter("empHID");
		String sstatus = request.getParameter("statusHID");
		
		if (note == null)
			note = "";
		
		if (whatToDo.equals("new")){
			date = request.getParameter("date2");
			time = request.getParameter("hour2");
			loc = request.getParameter("loc2");
		}else{
			date = request.getParameter("dateHid");
			time = request.getParameter("timeHid");
			loc = request.getParameter("locHID");
		}
	      
	    out.println("order = " + order + "<BR>");
	    out.println("atnr = " + atnr + "<BR>");
	    out.println("itno = " + itno + "<BR>");
	    out.println("whlo = " + whlo + "<BR>");
	    out.println("printType = " + printType + "<BR>");
	    out.println("micron = " + micron + "<BR>");
	    out.println("gauge = " + gauge + "<BR>");
	    out.println("whatToDo = " + whatToDo + "<BR>");
	    out.println("roll = " + roll + "<BR>");
	    out.println("weight = " + weight + "<BR>");
	    out.println("length = " + length + "<BR>");
	    out.println("width = " + width + "<BR>");
	    out.println("note = " + note + "<BR>");
	    out.println("oldNote = " + oldNote + "<BR>");
	    out.println("employee = " + employee + "<BR>");
	    out.println("oldEmployee = " + oldEmployee + "<BR>");
	    out.println("date = " + date + "<BR>");
	    out.println("time = " + time + "<BR>");
	    out.println("loc = " + loc + "<BR>");
	    out.println("sstatus = " + sstatus + "<BR>");
	    
		//get session information for user
		IRuntimeEnvironmentConfiguration runtimeEnvironment=new RuntimeEnvironmentConfiguration_5_1();
		runtimeEnvironment.init(request);
		String backend = runtimeEnvironment.getMIConfiguration().getServer();
		String port = runtimeEnvironment.getMIConfiguration().getPort();
		String apiuser = runtimeEnvironment.getMIConfiguration().getUser();
		String apiuserpwd = runtimeEnvironment.getMIConfiguration().getPassword();
		String myMsg = null;
		String errMsg = null;
		
		out.println("apiuser = " + apiuser + "<BR>");
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
			
		if (mvxd.indexOf("1") >= 0)
			myDate = "20"+date.substring(6,8)+date.substring(3,5)+date.substring(0,2);
		else
			myDate = "20"+date.substring(6,8)+date.substring(0,2)+date.substring(3,5);
		
		if (whatToDo.equals("new") || ! weight.equals("0")){
			mvxInput = new HashMap();
			mvxInput.put(IMovexConnection.TRANSACTION,"RptReceipt");
			
			out.println("<BR>");
			out.println(".......... running PMS050 RptReceipt<BR>");		
			out.println("CONO = " + mvx + "<BR>");
			out.println("FACI = " + faci + "<BR>");
			out.println("RPTD = " + myDate + "<BR>");
			out.println("TRTM = " + time.replaceAll(":", "") + "<BR>");
			out.println("MFNO = " + order + "<BR>");
			out.println("RPQA = " + weight + "<BR>");
			
			if (mvxd.indexOf("1") >= 0)
				out.println("MAUN = KG<BR>");	
			else
				out.println("MAUN = LBS<BR>");
				
			out.println("WHSL = 02-" + loc + "<BR>");
			out.println("STAS = " + sstatus + "<BR>");
			out.println("BANO = " + roll + "<BR>");
			out.println("BREF = " + length + "<BR>");
			out.println("BRE2 = " + width + "<BR>");
			out.flush();
			
			mvxInput.put("CONO", mvx);
			mvxInput.put("FACI", faci);
			mvxInput.put("RPTD", myDate);
			mvxInput.put("TRTM", time.replaceAll(":", ""));
			mvxInput.put("MFNO", order);
			mvxInput.put("RPQA", weight);
			
			if (mvxd.indexOf("1") >= 0)
				mvxInput.put("MAUN", "KG");
			else
				mvxInput.put("MAUN", "LBS");
				
			mvxInput.put("WHSL", "02-" + loc);
			mvxInput.put("STAS", sstatus);
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
		}
			
		if(! whatToDo.equals("del")){
			if (doTheJob) {
				//if (whatToDo.equals("new")){
					if(mie.endsWith("TEST"))
						sql = "select distinct CHAR(AGATNR) as ATNR FROM MVXJDTATST.MIATTR  WHERE AGCONO=? and AGBANO=? and AGITNO=?";
					else
						sql = "select distinct CHAR(AGATNR) as ATNR FROM MVXJDTA.MIATTR  WHERE AGCONO=? and AGBANO=? and AGITNO=?";
					//sql = "select distinct AGATNR as ATRN, AGBANO from MVXJDTA.MIATTR where AGCONO=1 and AGBANO='4182051' and AGITNO='204VP0015'";
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
				//}
				
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
				out.println("ATNR = " + atnr + "<BR>");
				out.println("ATID = WIDTH<BR>");
				out.println("ATVA = " + width + "<BR>");
				out.flush();
			
				mvxInput.put("CONO", mvx);
				mvxInput.put("ATNR", atnr);
				mvxInput.put("ATID", "WIDTH");
				mvxInput.put("ATVA", width);
				
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
			
			if (! employee.equals(oldEmployee)){
				if (doTheJob) {
					mvxInput = new HashMap();
					mvxInput.put(IMovexConnection.TRANSACTION,"SetAttrValue");
					
					out.println(".......... running ATS101 SetAttrValue for employee<BR>");		
					out.println("CONO = " + mvx + "<BR>");
					out.println("ATNR = " + atnr + "<BR>");
					out.println("ATID = EMPLOYY<BR>");
					if (mvxd.indexOf("1") >= 0)
						out.println("ATVA = " + "E" + employee + "<BR>");
					else
						out.println("ATVA = " + "UE" + employee + "<BR>");
					out.flush();
				
					mvxInput.put("CONO", mvx);
					mvxInput.put("ATNR", atnr);
					mvxInput.put("ATID", "EMPLOYY");
					if (mvxd.indexOf("1") >= 0)
						mvxInput.put("ATVA", "E" + employee);
					else
						mvxInput.put("ATVA", "UE" + employee);
					
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
			}
			
			if (whatToDo.equals("new") || ! note.equals(oldNote)){
				if (doTheJob) {
					mvxInput = new HashMap();
					mvxInput.put(IMovexConnection.TRANSACTION,"SetAttrValue");
					
					out.println(".......... running ATS101 SetAttrValue for note<BR>");		
					out.println("CONO = " + mvx + "<BR>");
					out.println("ATNR = " + atnr + "<BR>");
					out.println("ATID = TEXT1<BR>");
					out.println("ATVA = " + note + "<BR>");
					out.flush();
				
					mvxInput.put("CONO", mvx);
					mvxInput.put("ATNR", atnr);
					mvxInput.put("ATID", "TEXT1");
					mvxInput.put("ATVA", note);
					
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
			}
			 
			if(whatToDo.equals("new")){
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
		
	%>
	<script language="javascript">
		window.close();
		window.opener.returnToFirst();
	</script>
</body>
</html>
