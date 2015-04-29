<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@include file="nipuah-slitter-const1.jsp"%>
<%@include file="nipuah-slitter-labels-heb.jsp"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.SQLException"%>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.PreparedStatement"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import="java.sql.Timestamp"%>

<%	
	String mie=String.valueOf(MIEAppID);
	
	Connection dbConn = null;
	try {
      Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");

      //db name
      String dbName = "Movex";     

      String url = "jdbc:odbc:" + dbName;
      
      dbConn = DriverManager.getConnection(url, mws_username, mws_password);
      out.println(dbConn.toString());
      out.flush();

    } catch (SQLException ex) { // Handle SQL errors
      	out.println(ex.toString());
    } catch (ClassNotFoundException ex1) {
     	out.println(ex1.toString());
    }

	String machine = request.getParameter("machine");
	String orderNum = request.getParameter("orderNum");
	String weight = request.getParameter("weightHID");
	
	String faci = "";
	String myDay = "";
	String myMonth = "";
	
	if (mvxd.indexOf("1") >= 0){
		myDay = request.getParameter("date").substring(0,2);
		myMonth = request.getParameter("date").substring(3,5);
		faci = "001";
	}else{
		myDay = request.getParameter("date").substring(3,5);
		myMonth = request.getParameter("date").substring(0,2);
		faci = "200";
	}
	
	String myYear = "20" + request.getParameter("date").substring(6,8);
	String myTime = request.getParameter("hour").substring(0,5);
	
	Timestamp dateTime = Timestamp.valueOf(myYear + "-" + myMonth + "-" + myDay + " " + myTime + ":00");
	
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	out.println("orderNum = " + orderNum + "<BR>");
	
	String sql = "select * from seijdta.syfslitfold as AA where AA.MACHINE = ? and AA.TEST = ? and AA.FACI = ?";
	String test = "";
	
	if(mie.endsWith("TEST"))
		test = "1";
	else
		test = "0";
	
	try {
      stmt = dbConn.prepareStatement(sql);
      //set parameters
      stmt.setString(1, machine);
      stmt.setString(2, test);
      stmt.setString(3, faci);
         
      rs = stmt.executeQuery();
      
      if (rs.next()){				// there is already a record for this machine
      	Timestamp dbDate = rs.getTimestamp("timeIn");
      	
      	if (dbDate != null){		// the machine was already started
      		%>
				<script language="javascript">
					alert("<%=error_machineAlreadyStarted%>");
					window.close();
					window.opener.returnToFirst();
				</script>
			<%
      	}else{						// the machine was stopped
      		
      		String orderStarted = rs.getString("orderNum");
      		
      		if (!orderNum.equals(orderStarted)){
      			%>
					<script language="javascript">
						alert("<%=error_anotherOrderStarted%>");
						window.close();
						window.opener.returnToFirst();
					</script>
				<%     		
      		}else{
	       		stmt.close();
	       		
	       		sql = "UPDATE seijdta.syfslitfold as AA SET TIMEIN = ? WHERE  AA>MACHINE = ? and AA.TEST = ? and AA.FACI = ?";
	       		
	       		try {
		       		stmt = dbConn.prepareStatement(sql);
			        //set parameters
			        stmt.setTimestamp(1,dateTime);
			        stmt.setString(2, machine);
			        stmt.setString(3, test);
      				stmt.setString(4, faci);
			        
			        stmt.executeUpdate();
			     } catch (SQLException sqlEx) {
			      	out.println(sqlEx);
			      	sqlEx.printStackTrace();
			     } finally {
				      try {
				        stmt.close();
				      } catch (Exception e) {}
			     } //end finally
			}
      	}
      }else{
      	out.println("weight = " + weight + "<BR>");
      	if (weight.equals("")){
      		sql = "INSERT INTO seijdta.syfslitfold (MACHINE,EMPLOYEE,TIMEIN,ORDERNUM,FACI,TEST) VALUES(?,?,?,?,?,?)";
				
			out.println("111 orderNum = " + orderNum + "<BR>");
			try {
		      stmt = dbConn.prepareStatement(sql);
		      //set parameters
		      stmt.setString(1, machine);
		      stmt.setString(2, genEmp);
		      stmt.setTimestamp(3,dateTime);
		      stmt.setString(4, orderNum);
		      stmt.setString(5, faci);
      		  stmt.setString(6, test);
		      
		      stmt.executeUpdate();
		      } catch (SQLException sqlEx) {
		      	out.println(sqlEx.toString());
		      	sqlEx.printStackTrace();
		      } finally {
			      try {
			        stmt.close();
			      } catch (Exception e) {out.println(e.toString());}
		      } //end finally
		 }else{
		 	sql = "INSERT INTO seijdta.syfslitfold (MACHINE,EMPLOYEE,TIMEIN,ORDERNUM,WEIGHT,FACI,TEST) VALUES(?,?,?,?,?,?,?)";
		 		
			out.println("orderNum = " + orderNum + "<BR>");
			try {
		      stmt = dbConn.prepareStatement(sql);
		      //set parameters
		      stmt.setString(1, machine);
		      stmt.setString(2, genEmp);
		      stmt.setTimestamp(3,dateTime);
		      stmt.setString(4, orderNum);
		      stmt.setDouble(5,Double.parseDouble(weight));
		      stmt.setString(6, faci);
      		  stmt.setString(7, test);
		      
		      stmt.executeUpdate();
		      } catch (SQLException sqlEx) {
		      	out.println(sqlEx.toString());
		      	sqlEx.printStackTrace();
		      } finally {
			      try {
			        stmt.close();
			      } catch (Exception e) {out.println(e.toString());}
		      } //end finally
		 }
	  }// end if
	} catch (Exception e) {}
      
      
     try {
      if (dbConn != null && !dbConn.isClosed()) {
        dbConn.close();
        System.out.println("DB connection is closed.");
      }
    } catch (Exception e) {}
    
   %>
	<script language="javascript">
		window.close();
		window.opener.returnToFirst();
	</script>