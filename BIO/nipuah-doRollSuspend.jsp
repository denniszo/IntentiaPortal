
<%@ page import = "com.intentia.mwsf.client.sdk.connectionmanager.*"%>
<%@ page import = "com.intentia.mwsf.client.sdk.util.MWSFClientException"%>
<%@ page import = "BIO.*"%>
<%@ page import = "java.io.File"%>

<%@include file="nipuah-const1.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>

<html>
<head>
	<TITLE>Slitter Loading</TITLE>
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
	
	out.println("111<BR>");
	out.flush();
	
	String item = request.getParameter("item");
	String status = request.getParameter("status"); 
	String rollNumber = request.getParameter("rollNumber");
	
	String cause = "";
	String causeText = "";
	String note = "";
	
	if (status.equals("3")){
		cause = request.getParameter("causeKeyHID");
		causeText = request.getParameter("causeTextHID");
		note = request.getParameter("note");
	}
	
	out.println("item = " + item + "<BR>");
	out.println("rollNumber = " + rollNumber + "<BR>");
	out.println("status = " + status + "<BR>");
	out.println("cause = " + cause + "<BR>");
	out.println("note = " + note + "<BR>");
	out.flush();
	
	try{
		//get Active Connection to Webservice server		
		ConnectionManager cm = new ConnectionManager();
			out.println("user " + mws_username + "<BR>");
			out.println("pass " + mws_password + "<BR>");	
			out.println("url " + mws_url + "<BR>");
		cm.setUseUI(false);
		cm.setUsername(mws_username);
		cm.setPassword(mws_password);
		cm.setServerUrl(mws_url);
		cm.logon();
	
		if(mie.endsWith("TEST")){							
			Syfan_MMS130_TEST pms = new Syfan_MMS130_TEST(); 				
			out.println("WWBANO = " + rollNumber + "<BR>");
			out.println("WWITNO = " + item + "<BR>");	
			out.println("WLSTAS = " + status + "<BR>");	
			
			pms.setWWBANO(rollNumber);
			pms.setWWITNO(item);	
			pms.setWLSTAS(status);	
			
			if (!cause.equals("")){
				out.println("WWRSCD = " + cause + "<BR>");
				pms.setWWRSCD(cause);	
			}
			
			if (!note.equals("")){
				out.println("WLBREM = " + note + "<BR>");
				pms.setWLBREM(note);	
			}
			
			out.flush();
			pms.Change(cm);
		}else{			
			Syfan_MMS130 pms = new Syfan_MMS130(); 	
			out.println("WWBANO = " + rollNumber + "<BR>");
			out.println("WWITNO = " + item + "<BR>");	
			out.println("WLSTAS = " + status + "<BR>");	
			
			pms.setWWBANO(rollNumber);
			pms.setWWITNO(item);	
			pms.setWLSTAS(status);	
			
			if (!cause.equals("")){
				out.println("WWRSCD = " + cause + "<BR>");
				pms.setWWRSCD(cause);	
			}
			
			if (!note.equals("")){
				out.println("WLBREM = " + note + "<BR>");
				pms.setWLBREM(note);	
			}
			
			out.flush();
			pms.Change(cm);
		}
		
		cm.logoff();
	}catch (MWSFClientException e){
		
		String errMsg = e.getMessage();
		
		if (status.equals("3")){
			String message = "Roll suspended: item " + item + ", roll " + rollNumber;
			
			if (!cause.equals("")){
				message = message + ", reason: " + causeText;
			}
			
			if (!note.equals("")){
				message = message + ", " + note;
			}
			
			String title = "Roll suspended";
			String[] envp = null;
			File file = new File("D:\\syfanDB\\");
			
			String aaa = "";
			
			if(mie.endsWith("TEST"))
				aaa = "D:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:comp_dani@saad.org.il -s:\"" + title + "\" -msg:\"" + message + "\"";
			else{
				if (mvxd.indexOf("1") >= 0)
					aaa = "D:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:carmelh@syfan.co.il -s:\"" + title + "\" -msg:\"" + message + "\"";
				else
					aaa = "D:\\syfanDB\\postie.exe  -host:mail.saad.org.il  -from:intentia@saad.org.il -charset:windows-1255 -to:barak@syfanmfg.com -s:\"" + title + "\" -msg:\"" + message + "\"";
			}
			
			Runtime.getRuntime().exec(aaa, envp, file);
		}
		%>
		<script language="javascript">
			window.close();	
			window.opener.returnToFirst();
		</script>
		
		<%
	}
	%>
	<script language="javascript">
		window.close();
		window.opener.returnToFirst();
	</script>
	
</body>
</html>
