<%@include file="../i_IBrixVars.inc"%>
<%
	String mvxd = String.valueOf(MvxDivision);
	
	String mws_username = "syfan";
	String mws_password = "Syf12345";
	
	String genEmp = "";
	if (mvxd.indexOf("1") >= 0)
		genEmp = "100";
	else
		genEmp = "200";
		
	String mws_url = mws_url = "http://" + request.getServerName() + "/mwsf/runtime";
		
 	String WinParam="height=360,width=400,status=no,toolbar=no,menubar=no,location=no,titlebar=no,top=150,left = 250";
 	
 	double deviation = 0.2;
 	double slitDeviation = 0.7;
 	
 	int diffDays = 5;
 	
 	boolean debug = false;
 	
 	String location_bioDirectToSlit1 = "02-000";
%>
