<%@include file="slitter-const.jsp"%>
<%@include file="slitter-labels-heb.jsp"%>
<%@include file="../rollsAndLabels.jsp"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.SQLException"%>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.PreparedStatement"%>
<%@ page import = "java.sql.ResultSet"%>

<html>
<head>
	<TITLE>Pack to Invoice</TITLE>
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
	
	String faci = "";
		
	if (mvxd.indexOf("1") >= 0)
		faci = "001";
	else
		faci = "200";
	
	String rollNumber = request.getParameter("rollNumber");
	String father = request.getParameter("fatherHID");
	
	String type = request.getParameter("type");
	String charac = request.getParameter("charac");
	String micron = request.getParameter("micron");
	String gauge = request.getParameter("gauge");
	String widthMm = request.getParameter("widthMm");
	String widthInch = request.getParameter("widthInch");
	String lengthMtr = request.getParameter("lengthMtr");
	String lengthFt = request.getParameter("lengthFt");
	String weightKg = request.getParameter("weightKg");
	String cf = request.getParameter("cf");
	String kind = request.getParameter("kind");
	
	session.setAttribute("type", type);
	session.setAttribute("charac", charac);
	session.setAttribute("micron", micron);
	session.setAttribute("gauge", gauge);
	session.setAttribute("widthMm", widthMm);
	session.setAttribute("widthInch", widthInch);
	session.setAttribute("cf", cf);
	session.setAttribute("lengthMtr", lengthMtr);
	session.setAttribute("lengthFt", lengthFt);
	session.setAttribute("weightKg", weightKg);
	session.setAttribute("kind", kind);	
	
	out.println("kind = " + kind + "<BR>");
	
	String CF = "";
	if (cf.equals("f") || cf.equals("F"))
		CF = "1";
	else
		CF = cf;
		
	int qty = Integer.parseInt(request.getParameter("qty"));
	 
	createRollNum pl = new createRollNum();
			
	//finds the printer of this user
	Connection dbConn = null;
	try {
	      Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
	
	      //db name
	      String dbName = "Movex";     
	      String url = "jdbc:odbc:" + dbName;
	      
	      dbConn = DriverManager.getConnection(url, mws_username, mws_password);
	      //out.println(dbConn.toString() + "<BR>");
	      //out.flush();

    } catch (SQLException ex) { // Handle SQL errors
    	out.println(ex.toString() + "<BR>");
    } catch (ClassNotFoundException ex1) {
     	out.println(ex1.toString() + "<BR>");
    }
	
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	String sql = "select * FROM seijdta.syfprinters as AA WHERE AA.USER=? and AA.SUG='L0' and AA.FACI=?";
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
    } catch (Exception e) {
    	 out.println(e.toString() + "<BR>");
    }
    out.println("printer = " + printer + "<BR>");
    out.println("rollNumber = " + rollNumber + "<BR>");
    out.println("type = " + type + "<BR>");
    out.println("charac = " + charac + "<BR>");
    out.println("micron = " + micron + "<BR>");
    out.println("gauge = " + gauge + "<BR>");
    out.println("lengthMtr = " + lengthMtr + "<BR>");
    out.println("lengthFt = " + lengthFt + "<BR>");
    out.println("CF = " + CF + "<BR>");
    out.println("widthMm = " + widthMm + "<BR>");
    out.println("widthInch = " + widthInch + "<BR>");
    out.println("weightKg = " + weightKg + "<BR>");
    out.println("kind = " + kind + "<BR>");
    out.println("qty = " + qty + "<BR>");
    out.println("father = " + father + "<BR>");
	out.flush();
    //pl.deleteOldFiles(); 
		
	out.println("111<BR>");
	out.flush();
	
	if (mvxd.indexOf("1") >= 0)
		pl.initLabelArray();
	else
		pl.initLabelArray("US");
	
	out.println("222<BR>");
	out.flush();
	
	for (int i=1;i<=qty;i++){
		if (mvxd.indexOf("1") >= 0){
			pl.labels(rollNumber, type, charac, micron, gauge, lengthMtr, lengthFt, CF, widthMm, 
					  widthInch, weightKg, kind, "roll", printer, "0");
		}else{
			if (father.equals("")){
				pl.labels(rollNumber, type, charac, "", gauge, "", lengthMtr, CF, "", 
					  widthInch, weightKg, kind, "roll", printer, "0");
			}else{
				pl.labels(father, type, charac, "", gauge, "", lengthMtr, CF, "", 
					  widthInch, weightKg, kind, "roll", printer, "0", "US", rollNumber);
			}
		}
	}
				  
	out.println("333<BR>");
	out.flush();
	
	
	%>
	<script language="javascript">
		window.close();
		window.opener.reload();
	</script>
		
</body>
</html>
