<%@include file="../i_IBrixVars.inc"%>
<%
	String mvxd = String.valueOf(MvxDivision);
	
	String mws_username = "syfan";
	String mws_password = "Syf12345";
	
	/*
	String mws_url = "";
	if (mvxd.indexOf("1") >= 0)
		mws_url = "http://10.0.0.12/mwsf/runtime";
	else
		//mws_url = "http://mwpus/mwsf/runtime";
	*/
	
	String mws_url = mws_url = "http://" + request.getServerName() + "/mwsf/runtime";
		
		
	String genEmp = "100";
 	String WinParam="height=360,width=400,status=no,toolbar=no,menubar=no,location=no,titlebar=no,top=150,left = 250";
 	
 	String ContainerAfterKipul = "000";
 	
 	String location_Jumbos = "02-000";
 	String location_Reverted = "02-999";
 	String location_Blocks = "03";
 	String location_Finished = "04";
 	String location_SellBlocks = "07";
 	String location_Destroyed = "FINISH";
 	String location_COX = "COX";
 	String loaction_LiverLeft = "02-998";
 	
 	String default_Width = "2000";
 	
 	double deviation = 0.2;
 	double unloadingDeviation = 0.15;
 	
 	int mustWait = 1;
 	
 	boolean debug = false;
%>
