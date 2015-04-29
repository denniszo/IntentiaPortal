
<%@include file="nipuah-const.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@page import="java.util.Date"%>
<%@ page import = "java.io.File"%>

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

	String date = request.getParameter("date");
	String time = request.getParameter("hour"); 
	 
	String order = request.getParameter("orderNum"); 
	String emp = request.getParameter("emp"); 
	String raw = request.getParameter("rawHID"); 
	String rawName = request.getParameter("rawNameHID"); 
	String siloFrom = request.getParameter("siloFrom"); 
	String siloTo = request.getParameter("siloTo"); 
	
	String title = "החלפת סילו חומר גלם לשיחול";
	String message = "Changing raw material Silo for Extruder ---" + "\\r\\n" + "order: " + order + 
						"\\r\\n" + "raw material: " + rawName + "\\r\\n" + "code: " + raw + 
						"\\r\\n" + "from silo: " + siloFrom + "\\r\\n" + "to silo: " + siloTo + 
						"\\r\\n" + "employee: " + emp + "\\r\\n" + "date: " + date + " " + time;
	
	String sendTo = "";
	if(mie.endsWith("TEST"))
		sendTo = "comp_dani@saad.org.il";
	else
		sendTo = "syf_israel@saad.org.il,lab@syfan.co.il,dima@syfan.co.il,syf_genadi@saad.org.il";
		
	String[] envp = null;
	File file = new File("C:\\syfanDB\\");
	
	String kkk = "C:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:" + sendTo + " -s:\"" + title + "\" -msg:\"" + message + "\"";
	
	out.println(kkk + "<BR>");
    out.flush();
       			
	Runtime.getRuntime().exec(kkk, envp, file);
	
    
    

	%> 
	<script language="javascript">
		window.close();
		window.opener.returnToFirst();
	</script>
</body>
</html>
