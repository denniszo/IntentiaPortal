<%@ page import = "com.intentia.mwsf.client.sdk.connectionmanager.*"%>
<%@ page import = "com.intentia.mwsf.client.sdk.util.MWSFClientException"%>
<%@ page import = "java.math.BigInteger"%>
<%@ page import = "BIO.*"%>
<%@ page import = "Slitter.*"%>
<%@include file="nipuah-const.jsp"%>
<%@include file="../i_IBrixVars.inc"%>
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

<%!
public String GetDTID(String MIEserverURLHardCoded, String MIEAppID, String strCONO, String strBANO)
{
	String strTmpReturn="";
		
		try{
		
		 // Create Mie Java Collection, with model name, MIE AppID, och path to the Workplace MIE bridge
		 IMieCollection instanceCollection = MieCollectionFactory.create("getAtnrOfNewRoll",MIEserverURLHardCoded , MIEAppID);
		 
		
		 instanceCollection.setValue("cono", strCONO);
		 instanceCollection.setValue("roll", strBANO);
				 
		 // Execute model
	     instanceCollection.execute();
		 Iterator instanceIterator = instanceCollection.iterator();
	     IMieEntity entity = null;
	      // Loop over all instances in result and insert them into the combobox
	  
	    
	        while (instanceIterator.hasNext())
	     {
		     	
		    entity = (IMieEntity)instanceIterator.next();
		    strTmpReturn= entity.getValue("ATRN") ;
		    
		}
		
		instanceIterator=null;
		
		}
		catch(com.intentia.mie.MieCollectionException e)
		{
		       //out.println("=================================<BR>MIE error<BR>");
		}
		
		return strTmpReturn;
}


%>
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
	
	String printer = "";
	
	boolean withLabels = false;
	String addLabels = request.getParameter("withLabels");
	
	if (addLabels != null){
		if (addLabels.equals("yes")){
			withLabels = true;
			
			//get the printer for this user
			Connection dbConn = null;
			try {
		      Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
		
		      //db name
		      String dbName = "syfPortal";     
		
		      String url = "jdbc:odbc:" + dbName;
		      
		      dbConn = DriverManager.getConnection(url, "", "");
		      out.println(dbConn.toString());
		      out.flush();
		
		    } catch (SQLException ex) { // Handle SQL errors
		      	out.println(ex.toString());
		    } catch (ClassNotFoundException ex1) {
		     	out.println(ex1.toString());
		    }
			
			PreparedStatement stmt = null;
			ResultSet rs = null;
			
			String sql = "select * from tblPrinters  where userName = ?";
			
			try {
		      stmt = dbConn.prepareStatement(sql);
		      
		      //set parameters
		      stmt.setString(1, MvxUser);
		         
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
	String weight = "";
	String length = "";
	String width = "";
	String roll = "";
      
    out.println("workSeq = " + workSeq + "<BR>");
    out.println("itno = " + itno + "<BR>");
    out.println("whlo = " + whlo + "<BR>");
    out.println("printType = " + printType + "<BR>");
    out.println("micron = " + micron + "<BR>");
    
	//get Active Connection to Webservice server
	ConnectionManager cm = new ConnectionManager();		
	//ConnectionManager cm = new ConnectionManager();
			out.println("user " + mws_username + "<BR>");
			out.println("pass " + mws_password + "<BR>");	
			out.println("url " + mws_url + "<BR>");
	cm.setUseUI(false);
	cm.setUsername(mws_username);
	cm.setPassword(mws_password);
	//cm.setUsername("intentia");
	//cm.setPassword("Int12345");

	cm.setServerUrl(mws_url);
		
	createRollNum nr = new createRollNum();		
	// inits the label array
	nr.initLabelArray();
		
	try{
		for (int i=1;i<=2;i++){
			date = request.getParameter("date" + i);
			myDate =	"20"+date.substring(6,8)+date.substring(3,5)+date.substring(0,2);
			time = request.getParameter("hour"  + i);
	 
			roll = request.getParameter("roll" + i + "Hid");
			weight = request.getParameter("weight" + i);
			length = request.getParameter("length" + i);
			width = request.getParameter("width" + i);
			
			out.println("roll = " + roll + "<BR>");
			out.println("weight = " + weight + "<BR>");
			out.println("length = " + length + "<BR>");
			out.println("width = " + width + "<BR>");
			
			cm.logon();
			
			if(mie.endsWith("TEST")){	
				out.println("DO PMS050WS_RptReceipt_TEST <BR>");						
				PMS050WS_RptReceipt_TEST pms = new PMS050WS_RptReceipt_TEST(); 				
				
				out.println("CONO = " + mvx + "<BR>");
				out.println("RPTD = " + myDate + "<BR>");
				out.println("TRTM = " + time.replaceAll(":", "") + "<BR>");
				out.println("WOSQ = " + workSeq + "<BR>");
				out.println("RPQA = " + weight + "<BR>");
				out.println("MAUN = KG<BR>");	
				out.println("WHSL = 02-" + request.getParameter("loc" + i) + "<BR>");
				out.println("STAS = 1<BR>");
				out.println("BANO = " + roll + "<BR>");
				out.flush();
				
				pms.setCONO(mvx);	
				pms.setRPDT(myDate);
				pms.setTRTM(time.replaceAll(":", ""));
				pms.setWOSQ(workSeq);	
				pms.setRPQA(weight);
				pms.setMAUN("KG");
				pms.setWHSL("02-" + request.getParameter("loc" + i));
				pms.setSTAS("1");
				pms.setBANO(roll);	
				pms.setREND("");
				pms.setDSP4("1");
				pms.setDSP1("1");
				pms.setDSP2("1");
				pms.setDSP3("1");
				pms.setDSP5("1");
				pms.RptReceipt(cm);
			}else{			
				PMS050WS_RptReceipt pms = new PMS050WS_RptReceipt(); 				
				
				pms.setCONO(mvx);
				pms.setRPDT(myDate);
				pms.setTRTM(time.replaceAll(":", ""));	
				pms.setWOSQ(workSeq);	
				pms.setRPQA(weight);
				pms.setMAUN("KG");
				pms.setWHSL("02-" + request.getParameter("loc" + i));
				pms.setSTAS("1");
				pms.setBANO(roll);	
				pms.setREND("");
				pms.setDSP4("1");
				pms.setDSP1("1");
				pms.setDSP2("1");
				pms.setDSP3("1");
				pms.setDSP5("1");
				pms.RptReceipt(cm);	
				
			}
			
			cm.logoff();
			/*
			cm.logon();
			
			String atnrStr = null;
			if(mie.endsWith("TEST")){	
					
				MMS060WS_Get_TEST mms = new MMS060WS_Get_TEST(); 
				mms.setCONO(mvx);
				//mms.setCONO(MvxCompany);
				mms.setWHLO(whlo);
				mms.setITNO(itno);
				mms.setBANO(roll);
				mms.setWHSL("02-" + request.getParameter("loc" + i));
				
				mms.Get(cm);
				
				atnrStr = mms.getATNR();
			}else{
				MMS060WS_Get mms = new MMS060WS_Get(); 
				mms.setCONO(mvx);
				mms.setWHLO(whlo);
				mms.setITNO(itno);
				mms.setBANO(roll);
				mms.setWHSL("02-" + request.getParameter("loc" + i));
				mms.Get(cm);
				
				atnrStr = mms.getATNR();
			}
			if (atnrStr == null){				
				out.println("");//TODO error msg
				continue;
			}
			BigInteger atnr = new BigInteger(atnrStr).add(new BigInteger("1"));
			//out.println("atnrStr " + atnrStr);
			//out.println("atnr " + atnr.toString());
			
			out.flush();
			
			cm.logoff();
			*/
			
			out.println("mie = " + mie + "<BR>");
			out.println("mvx = " + mvx + "<BR>");
			out.println("roll = " + roll + "<BR>");
			
			String atnr;
			String MIEserverURLHardCoded = "http://10.0.0.12/MIE50/MieIsapi.dll";
			atnr=GetDTID(MIEserverURLHardCoded,  mie,  mvx, roll);
			
			out.println("atnr  = " + atnr + "<BR>");
			out.flush();
			cm.logon();
			
			if(mie.endsWith("TEST")){
				ATS101WS_SetAttrValue_TEST ats = new ATS101WS_SetAttrValue_TEST();
				
				//width
				ats.setCONO(mvx);
				ats.setATNR(atnr);
				ats.setATID("WIDTH");
				ats.setATVA(width);
				ats.SetAttrValue(cm);
				
				//length
				ats.setCONO(mvx);
				ats.setATNR(atnr);
				ats.setATID("LENGHT");
				ats.setATVA(length);
				ats.SetAttrValue(cm);
				
				//employee
				ats.setCONO(mvx);
				ats.setATNR(atnr);
				ats.setATID("EMPLOYY");
				ats.setATVA("E" + request.getParameter("emp" + i));
				ats.SetAttrValue(cm);
				
				//note
				ats.setCONO(mvx);
				ats.setATNR(atnr);
				ats.setATID("TEXT1");
				ats.setATVA(request.getParameter("note" + i));
				ats.SetAttrValue(cm);
				
				//no 1
				ats.setCONO(mvx);
				ats.setATNR(atnr);
				ats.setATID("NO 1");
				ats.setATVA("-1");
				ats.SetAttrValue(cm);
				
				//no 2
				ats.setCONO(mvx);
				ats.setATNR(atnr);
				ats.setATID("NO 2");
				ats.setATVA("-1");
				ats.SetAttrValue(cm);
			}else{
				ATS101WS_SetAttrValue ats = new ATS101WS_SetAttrValue();
				
				//width
				ats.setCONO(mvx);
				ats.setATNR(atnr);
				ats.setATID("WIDTH");
				ats.setATVA(width);
				ats.SetAttrValue(cm);
				out.println("WIDTH = " + width + "<BR>");
				
				//length
				ats.setCONO(mvx);
				ats.setATNR(atnr);
				ats.setATID("LENGHT");
				ats.setATVA(length);
				ats.SetAttrValue(cm);
				out.println("LENGTH = " + length + "<BR>");
				
				//employee
				ats.setCONO(mvx);
				ats.setATNR(atnr);
				ats.setATID("EMPLOYY");
				ats.setATVA("E" + request.getParameter("emp" + i));
				ats.SetAttrValue(cm);
				out.println("EMPLOYY = " + "E" + request.getParameter("emp" + i) + "<BR>");
				
				//note
				if (! request.getParameter("note" + i).equals("")){
					ats.setCONO(mvx);
					ats.setATNR(atnr);
					ats.setATID("TEXT1");
					ats.setATVA(request.getParameter("note" + i));
					ats.SetAttrValue(cm);
					out.println("TEXT1 = " + request.getParameter("note" + i) + "<BR>");
				}
				//no 1
				ats.setCONO(mvx);
				ats.setATNR(atnr);
				ats.setATID("NO 1");
				ats.setATVA("-1");
				ats.SetAttrValue(cm);
				out.println("NO 1 = -1<BR>");
				
				//no 2
				ats.setCONO(mvx);
				ats.setATNR(atnr);
				ats.setATID("NO 2");
				ats.setATVA("-1");
				ats.SetAttrValue(cm);
				out.println("NO 2 = -1<BR>");
			}
			
			cm.logoff();
			
			if (withLabels){
				nr.labels(roll, printType, "", micron, "", length, "", "", width, "", weight, "02", "roll", printer, "0");
			}
			
		}//end for
		%>
		<script language="javascript">
			window.close();
			window.opener.returnToFirst();
		</script>
	
	<%}catch (MWSFClientException e){
			
		String errMsg = e.getMessage();
		out.println(errMsg);
		out.flush();
		%>
		<script language="javascript">
	
				alert('<%=errMsg.replaceAll("                    ", "")%>');
				window.close();	
				window.opener.enableGoBtn();
		</script>
			
		<%
	}//end catch
		
	%>	
</body>
</html>
