<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
﻿<%@include file="nipuah-const.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.Time"%>
<%@page import="java.text.DateFormat"%>

<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.SQLException"%>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.PreparedStatement"%>
<%@ page import = "java.sql.ResultSet"%>

<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.math.BigInteger"%>


<%
String mie = String.valueOf(MIEAppID);

String orderNum = request.getParameter("orderNum");

DecimalFormat df = new DecimalFormat("###,##0");
DecimalFormat df2 = new DecimalFormat("###,##0.00");

	Connection dbConn = null;
	
	try {
      Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");

      //db name
      String dbName = "Movex";     
      String url = "jdbc:odbc:" + dbName;
      
      dbConn = DriverManager.getConnection(url, mws_username, mws_password);
      
    } catch (SQLException ex) { // Handle SQL errors
      	out.println(ex.toString() + "<BR>");
    } catch (ClassNotFoundException ex1) {
     	out.println(ex1.toString() + "<BR>");
    }
	
	
	out.println("<CENTER><H2>" + title_jumboReport + "</H2>");
	
	String databaseSource = "";
	
	if (mie.indexOf("TEST") > 0)
		databaseSource = "MVXJDTATST";
	else
		databaseSource = "MVXJDTA";
		
	String sql = "";
	
	sql = "SELECT VHMFNO, VHPRNO " +
	      "FROM " + databaseSource + ".MWOHED " + 
	      "WHERE VHCONO=? AND VHRORN = ?";

	
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	try {	
		  String parit = "";
		  String horaa = "";
		  boolean doContinue = false;
		  
		  stmt = dbConn.prepareStatement(sql);
		  
		  //set parameters
		  stmt.setInt(1, MvxCompany);
		  stmt.setString(2, orderNum);
		     
		  rs = stmt.executeQuery();
		  
		  int counter = 0;
		  
		  if (rs.next()){				// there is a record found
		  		parit = rs.getString("VHPRNO");
		  		horaa = rs.getString("VHMFNO");
		  		doContinue = true;
		  }
		  
		  if (doContinue){
		  		stmt.close();
		  		
	  			sql = "SELECT LEFT(MTBANO,4) AS ORDER, MTITNO, TYPE, MICRON, GAUGE, MTWHSL LOCATION, " + 
			    	  "MTBANO ROLL, MTBREF LENGTH, LMSTAS STATUS, LMCFI2, " + 
					  "(SELECT AGATVN FROM " + databaseSource + ".MIATTR WHERE AGATID ='LENGHT' AND MTCONO =AGCONO " +
					  "AND MTITNO=AGITNO AND MTBANO=AGBANO)LEN, MTTRQT as WEIGHT, MTTRDT*1000000 + MTTRTM AS DATE_TIME, " +
					  "(SELECT AGATVN FROM " + databaseSource + ".MIATTR WHERE AGATID ='WIDTH' AND MTCONO=AGCONO " + 
					  "AND MTITNO=AGITNO AND MTBANO=AGBANO)WIDTH, " +
					  "(SELECT PFTX30 FROM " + databaseSource + ".MIATTR INNER JOIN MVXCDTA.MPDOPT ON AGCONO=PFCONO " + 
					  "AND AGATVA=PFOPTN WHERE AGATID='EMPLOYY' AND MTCONO=AGCONO AND MTITNO=AGITNO " + 
					  "AND MTBANO=AGBANO) EMP, " +
					  "(SELECT PFTX30 FROM " + databaseSource + ".MIATTR INNER JOIN MVXCDTA.MPDOPT ON AGCONO=PFCONO " + 
					  "AND AGATVA=PFOPTN WHERE AGATID='TEXT1' AND MTCONO=AGCONO AND MTITNO=AGITNO " + 
					  "AND MTBANO=AGBANO) NOTE, MTCONO, MTRIDN, FINIHED_LENGTH, KIND " +
					  "FROM " + databaseSource + ".MITTRA " + 
					  "INNER JOIN " + databaseSource + ".V_ITEM_DESCRIPTION ON MTCONO=MMCONO AND MTITNO=MMITNO " +
					  "LEFT JOIN " + databaseSource + ".MILOMA  ON MTCONO=LMCONO AND MTBANO=LMBANO " +
					  "WHERE MTCONO=? AND MTITNO=? AND MTRIDN=? AND MTTTID IN ('WOP') " +
					  "ORDER BY MTBANO, MTTRDT*1000000 + MTTRTM";
				
		  		try {
		  			  String roll = "";	
		  			  double weight = 0;
				  	  String tmp = "";
				  	  double totalLength = 0;
				  	  double totalWeight = 0;
				  	  double totalWidthAvg = 0;
				  	  int countRoll = 0;
				  	  double myDate = 0;
				  	  double myTime = 0;
				  	  long dateTime = 0;
				  	  String avgWidth = "";
				  	  String oldRoll = "";
				  	  String note = "";
				  	  
				  	  int numOfRoll = 0;
				  	  
				  	  String[] arrRoll = new String[300];
				  	  String[] arrType = new String[300];
				  	  String[] arrMicron = new String[300];
				  	  double[] arrLen = new double[300];
				  	  double[] arrWeight = new double[300];
				  	  String[] arrEmp = new String[300];
				  	  String[] arrNote = new String[300];
				  	  String[] arrLoc = new String[300];
				  	  String[] arrStatus = new String[300];
				  	  String[] arrDate = new String[300];
				  	  String[] arrHour = new String[300];
				  	  String[] arrAvgWidth = new String[300];
				  	  double[] arrWidth = new double[300];
					  	  
		  			  stmt = dbConn.prepareStatement(sql);
					  
					  //set parameters
					  stmt.setInt(1, MvxCompany);
					  stmt.setString(2, parit);
					  stmt.setString(3, horaa);
					     
					  rs = stmt.executeQuery();	
		  			  
		  			  boolean found = false;
		  			  
		  			  while (rs.next()){
		  			  	  found = true;
		  			  	  
		  			  	  roll = rs.getString("ROLL");
							
						  if (roll.trim().length() == 7){
						  	  if (roll.equals(oldRoll)){
						  	  	  weight = Math.round(rs.getDouble("WEIGHT"));
							  	  arrWeight[numOfRoll] = arrWeight[numOfRoll] + weight;
								  
								  totalWeight = totalWeight + weight;
								
								  arrLen[numOfRoll] = Math.round(rs.getDouble("LENGTH"));
								 
								  arrLoc[numOfRoll] = rs.getString("LOCATION");
			  			  	 }else{
			  			  	 	 oldRoll = roll;
			  			  	 	 numOfRoll++;
			  			  	 	 
			  			  	 	 arrRoll[numOfRoll] = roll;
			  			  	 	 
			  			  	 	 arrType[numOfRoll] = rs.getString("TYPE");
								
								  if (mvxd.indexOf("1") >= 0)
									arrMicron[numOfRoll] = rs.getString("MICRON");
								  else
									arrMicron[numOfRoll] = rs.getString("GAUGE");
									
								  arrLen[numOfRoll] = Math.round(rs.getDouble("LENGTH"));
								  arrWeight[numOfRoll] = Math.round(rs.getDouble("WEIGHT"));
								  arrEmp[numOfRoll] = rs.getString("EMP");
								  note = rs.getString("NOTE");
								  arrLoc[numOfRoll] = rs.getString("LOCATION");
								  
								  tmp = rs.getString("LMCFI2");
								  
								  if (! tmp.equals("0")){
									  arrAvgWidth[numOfRoll] = tmp;
									  
									  totalWidthAvg = totalWidthAvg + Double.parseDouble(tmp);
									  countRoll++;
								  }else
								  	  arrAvgWidth[numOfRoll] = "&nbsp;";
								
								  totalLength = totalLength + arrLen[numOfRoll];
								  totalWeight = totalWeight + arrWeight[numOfRoll];
								
								  tmp = rs.getString("STATUS");
								
								  if (mvxd.indexOf("1") >= 0){
									if (tmp.equals("1"))
										arrStatus[numOfRoll] = "לא נבדק";
									else if (tmp.equals("2"))
										arrStatus[numOfRoll] = "נבדק";
									else
										arrStatus[numOfRoll] = "נפסל";
								  }else{
									if (tmp.equals("1"))
										arrStatus[numOfRoll] = "Not checked";
									else if (tmp.equals("2"))
										arrStatus[numOfRoll] = "Checked";
									else
										arrStatus[numOfRoll] = "Scraped";
								 }
									
								 arrWidth[numOfRoll] =  Math.round(rs.getDouble("WIDTH"));
								
								 dateTime = rs.getLong("DATE_TIME");
								 tmp = String.valueOf(dateTime);
								 
								 if (mvxd.indexOf("1") >= 0)
									arrDate[numOfRoll] = tmp.substring(6,8) + "/" + tmp.substring(4,6) + "/" + tmp.substring(2,4);
								 else
									arrDate[numOfRoll] = tmp.substring(4,6) + "/" + tmp.substring(6,8) + "/" + tmp.substring(2,4);
								
								 arrHour[numOfRoll] = tmp.substring(8,10) + ":" + tmp.substring(10,12);
			  			  		 
			  			  		 if (note == null)
			  			  		 	arrNote[numOfRoll] = "&nbsp;";
			  			  		 else
			  			  		 	arrNote[numOfRoll] = note;
			  			  	 }
			  			 }
			  		 }
			  			 
		  			 for (int i=1;i<=numOfRoll;i++){
	  			  		 
	  			  		 if (i == 1){
	  			  		 	 out.println("<CENTER>");
	  			  		 	 
	  			  		 	 out.println("<table border='0'><tr>");
							 out.println("<TD>" + moNumber + ": </TD><TD>" + orderNum + "</TD></tr></TABLE>");
							 
							 out.println("<P>");
							 	
						  	 out.println("<table border=1 BGCOLOR=#ffffff CELLSPACING=0 CELLPADDING=4><TR>");
						  	 
						  	 if (mvxd.indexOf("1") >= 0){
						  	 	out.println("<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblRoll + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblType + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblOvi + "</TH>" + 
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblLength + "</TH>" + 
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblWeight + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblWidth + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblDate + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblHour + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblEmp + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblStatus + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblAvgWidth + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblNote + "</TH></TR>");
						  	 }else{
						  	 	out.println("<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblRoll + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblType + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblOvi + "</TH>" + 
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblLength + "</TH>" + 
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblWeight + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblWidth + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblDate + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblHour + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblEmp + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblStatus + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>Location</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblAvgWidth + "</TH>" +
						  				 "<TH BGCOLOR=#c0c0c0 BORDERCOLOR=#000000>" + lblNote + "</TH></TR>");
						  	 }
	  			  		 }
	  			  		 
	  			  		 if (mvxd.indexOf("1") >= 0){
		  			  		 out.println("<TR><TD BORDERCOLOR=#000000>" + arrRoll[i] + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + arrType[i] + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + arrMicron[i] + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + df.format(arrLen[i]) + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + df.format(arrWeight[i]) + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + df.format(arrWidth[i])  + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + arrDate[i] + "</TD>" + 
						  				"<TD BORDERCOLOR=#000000>" + arrHour[i] + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + arrEmp[i] + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + arrStatus[i] + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + arrAvgWidth[i] + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + arrNote[i] + "</TD></TR>"); 
						 }else{
						 	 out.println("<TR><TD BORDERCOLOR=#000000>" + arrRoll[i] + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + arrType[i] + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + arrMicron[i] + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + df.format(arrLen[i]) + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + df.format(arrWeight[i]) + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + df.format(arrWidth[i])  + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + arrDate[i] + "</TD>" + 
						  				"<TD BORDERCOLOR=#000000>" + arrHour[i] + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + arrEmp[i] + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + arrStatus[i] + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + arrLoc[i] + "</TD>" + 
						  				"<TD BORDERCOLOR=#000000>" + arrAvgWidth[i] + "</TD>" +
						  				"<TD BORDERCOLOR=#000000>" + arrNote[i] + "</TD></TR>"); 
						  }
						  
		  			  }
		  			  
		  			  if (found){
		  			  	if (totalWidthAvg != 0){
			  			  	double AvgWidthAvg = totalWidthAvg / countRoll;
			  			  	
			  			  	out.println("</TABLE>");
		  			  	 	out.println("<P>");
		  			  	 	
		  			  	 	out.println("<table border='0'><tr>");
							out.println("<TD>" + lblMovexPO + ": </TD><TD>" + horaa + "</TD></tr>" +
									 	"<tr><TD>" + lblTotalWeight + ": </TD><TD>" + df.format(totalWeight) + "</TD></tr>" +
									 	"<tr><TD>" + lblTotalLength + ": </TD><TD>" + df.format(totalLength) + "</TD></tr>" + 
									 	"<tr><TD>" + lblAvgWidth + ": </TD><TD>" + df2.format(AvgWidthAvg) + "</TD></tr></TABLE>");
						}else{
							out.println("</TABLE>");
		  			  	 	out.println("<P>");
		  			  	 	
		  			  	 	out.println("<table border='0'><tr>");
							out.println("<TD>" + lblMovexPO + ": </TD><TD>" + horaa + "</TD></tr>" +
									 	"<tr><TD>" + lblTotalWeight + ": </TD><TD>" + df.format(totalWeight) + "</TD></tr>" +
									 	"<tr><TD>" + lblTotalLength + ": </TD><TD>" + df.format(totalLength) + "</TD></tr></TABLE>"); 
						}
	  			  	 }
		  		} catch (Exception e) {
			    	out.println(e.toString() + "<BR>");
			    }
		  		
		  }			
		  		
    } catch (Exception e) {
    	out.println(e.toString() + "<BR>");
    }
%>
<HTML>
<HEAD>


<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">


<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">


<LINK href="theme/Master.css" rel="stylesheet" type="text/css">

<style type="text/css">
input.myButton {width:150}
input.clReadonly {background-color:#F0F0F0}
input.ragil {background-color:white}
</style>

<TITLE>Ahzaka-failuresDescription.jsp</TITLE>

<SCRIPT language="javascript">
function CloseIbrix(){
	var activeIndex = top.QuickSwitch.getActiveIndex();
	top.QuickSwitch.enableDisableScreen('close');
	top.QuickSwitch.closeActiveProgram(activeIndex, "closed");
}


</SCRIPT>
</HEAD>


<BODY  dir=<%=page_dir%> oncontextmenu="return false">
<!-- oncontextmenu="return false" -->
<CENTER>

<p>

<INPUT type="button" name="exit" value="<%=exitBtn%>" class="myButton"  onclick="window.location='nipuah-first.jsp'" tabindex="62">

</DIV>
</BODY>
</HTML>
