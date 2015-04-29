
<%@include file="nipuah-const.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@page import="java.util.Date"%>
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
	String mie=String.valueOf(MIEAppID);
	String mvx = String.valueOf(MvxCompany);
	
	boolean doTheJob = true;

	String date = request.getParameter("date");
	String time = request.getParameter("hour"); 
	 
	String order = request.getParameter("orderNum"); 
	String emp = request.getParameter("emp"); 
	
	int numOfLines = Integer.parseInt(request.getParameter("numOfLinesHID"));
	
	out.println("order  = " + order + "<BR>");
	out.println("emp  = " + emp + "<BR>");
	out.println("numOfLines  = " +numOfLines + "<BR>");
	out.flush();
	
	String silo = "";
	String raw = "";
	String rawName = "";
	String current = "";
	String newVal = "";
	String spe4 = "";
	String spe5 = "";
	String title = "";
	String message = "";
	
	String sendTo = "";
	if(mie.endsWith("TEST"))
		sendTo = "comp_dani@saad.org.il";
	else
		sendTo = "syf_israel@saad.org.il,lab@syfan.co.il,dima@syfan.co.il,syf_genadi@saad.org.il";
	
	String[] envp = null;
	File file = new File("C:\\syfanDB\\");
	
	String kkk = "";
	
//	get session information for user
	IRuntimeEnvironmentConfiguration runtimeEnvironment=new RuntimeEnvironmentConfiguration_5_1();
	runtimeEnvironment.init(request);
	String backend = runtimeEnvironment.getMIConfiguration().getServer();
	String port = runtimeEnvironment.getMIConfiguration().getPort();
	String apiuser = runtimeEnvironment.getMIConfiguration().getUser();
	String apiuserpwd = runtimeEnvironment.getMIConfiguration().getPassword();
	String myMsg = null;
	String errMsg = null;
	
//	lookup connection factory
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
	
	for (int i=1; i<=numOfLines && doTheJob; i++){
		silo = request.getParameter("silo" + i);
		
		out.println("silo  = " +silo + "<BR>");
		out.flush();
		
		if (!silo.equals("")){
			raw = request.getParameter("raw" + i);
			rawName = request.getParameter("rawName" + i);
			current = request.getParameter("current" + i);
			newVal = request.getParameter("new" + i);
			spe4 = request.getParameter("spe4_" + i);
			spe5 = request.getParameter("spe5_" + i);
			
			out.println("raw  = " + raw + "<BR>");
			out.println("rawName  = " + rawName + "<BR>");
			out.println("current  = " + current + "<BR>");
			out.println("newVal  = " + newVal + "<BR>");
			out.println("spe4  = " + spe4 + "<BR>");
			out.println("spe5  = " + spe5 + "<BR>");
			out.flush();
			
			mvxInput = new HashMap();
			mvxInput.put(IMovexConnection.TRANSACTION,"UpdItmMeas");
			
			out.println(".......... running MMS200 UpdItmMeas <BR>");
			out.println("CONO = " + mvx + "<BR>");
			out.println("ITNO = " + raw + "<BR>");	
			
			mvxInput.put("CONO", mvx);
			mvxInput.put("ITNO", raw);
			
			if (! spe4.equals("")){
				out.println("SPE4 = " + spe4 + "<BR>");
				mvxInput.put("SPE4", spe4);
			}
			
			if (! spe5.equals("")){
				out.println("SPE5 = " + spe5 + "<BR>");
				mvxInput.put("SPE5", spe5);
			}
			out.flush();
			
			try {
				connection = factory.getConnection("MMS200MI","", apiuser, apiuserpwd, backend, Integer.parseInt(port));
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
						
						doTheJob = false;
						%>
						<script language="javascript">
					
								alert('<%=errMsg.replaceAll("                    ", "")%>');
								window.close();	
								window.opener.enableGoBtn();
						</script>
						<%
		       		}else{
		       			out.println("Update item measures succeded ...<BR>");
		       			out.flush();
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
			
			if (silo.equals("1")){
				title = "החלפת סילו חומר גלם לשיחול";
				message = "Changing raw material Silo for Extruder ---" + "\\r\\n" + "order: " + order + 
							"\\r\\n" + "raw material: " + rawName + "\\r\\n" + "code: " + raw + 
							"\\r\\n" + "from silo: " + current + "\\r\\n" + "to silo: " + newVal + 
							"\\r\\n" + "employee: " + emp + "\\r\\n" + "date: " + date + " " + time;
			}else{
				title = "הכנסת חומר גלם חדש לשיחול";
				message = "New raw material on Extruder ---" + "\\r\\n" + "order: " + order + 
							"\\r\\n" + "raw material: " + rawName + "\\r\\n" + "code: " + raw + 
							"\\r\\n" + "batch: " + newVal + "\\r\\n" + "employee: " + emp + 
							"\\r\\n" + "date: " + date + " " + time;
			}
			
			kkk = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:" + sendTo + " -s:\"" + title + "\" -msg:\"" + message + "\"";
			
			Runtime.getRuntime().exec(kkk, envp, file);
		}
	}

	%> 
	<script language="javascript">
		window.close();
		window.opener.returnToFirst();
	</script>
</body>
</html>
