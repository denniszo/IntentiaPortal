<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@include file="nipuah-const.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@include file="../checkDateNEW.inc"%>

<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.SQLException"%>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.PreparedStatement"%>
<%@ page import = "java.sql.ResultSet"%>


<%
	String passBio = "";
	String passAhzaka = "";
	
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
    
    String faci = "";
    if (mvxd.indexOf("1") >= 0){
		faci = "001";
	}else{
		faci = "200";
	}
	
    String sql = "select * FROM seijdta.syfpasw as AA WHERE AA.FACI=?";
    
    PreparedStatement stmt = null;
	ResultSet rs = null;
	
	try {
      stmt = dbConn.prepareStatement(sql);
      
      stmt.setString(1, faci);
      
      rs = stmt.executeQuery();
      
      if (rs.next()){				// there is a record found
      	String temp = rs.getString("passbio");
      	
      	if (temp != null)
      		passBio = temp.trim();
      	
      	temp = rs.getString("passahzaka");
      	
      	if (temp != null)
      		passAhzaka = temp.trim();
      }
    } catch (Exception e) {
    	out.println(e.toString() + "<BR>");
    }
    
	session.setAttribute("comFrom2", "1");
	session.setAttribute("comFromAhzaka", "1");
	session.setAttribute("slitOrder1", "");
	session.setAttribute("slitOrder2", "");
	session.setAttribute("roll1", "");
	session.setAttribute("roll2", "");
	session.setAttribute("machine", "");
	session.setAttribute("worqSeq", "");
	session.setAttribute("loadedItem", "");
	session.setAttribute("comFrom", "0");
	session.setAttribute("doMinomen", "1");
%>
  
<HTML>
<HEAD>

<META http-equiv="Content-Type"
	content="text/html; charset=WINDOWS-1255">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="theme/Master.css" rel="stylesheet" type="text/css">

<style type="text/css">
input.myButton {width:180}
input.myButtonSp {width:180;color:white; background-color:blue}
input.myButtonOrange {width:180;color:white; background-color:orange}
</style>
	
<TITLE>nipuah-first.jsp</TITLE>

<SCRIPT language="javascript">


function CloseIbrix(){
	var activeIndex = top.QuickSwitch.getActiveIndex();
	top.QuickSwitch.enableDisableScreen('close');
	top.QuickSwitch.closeActiveProgram(activeIndex, "closed");
}

// opens a window to find item
function popPassword(){
	var ans = window.showModalDialog("enterPassword.jsp","name", "dialogWidth:350px;dialogHeight:200px");
	
	hello = document.myForm.passBio.value;
	
	if (ans.toUpperCase() == hello.toUpperCase())
		window.location='nipuah-management.jsp';
	else
		alert("Wrong Password");
}

function popPassAhzaka(){
	var ans = window.showModalDialog("enterPasswordHeb.jsp","name", "dialogWidth:350px;dialogHeight:200px");
	
	//hello = getAhzakaPass();
	hello = document.myForm.passAhzaka.value;
	
	if (ans.toUpperCase() == hello.toUpperCase())
		window.location='../Ahzaka/Ahzaka-failuresReport.jsp';
	else
		alert("Wrong Password");		
}

</SCRIPT>

</HEAD>
<BODY oncontextmenu="return false">

<P align="center"><FONT size="+2"><B><%=title_first%></B></FONT></P>

<P><BR>

</P>
<DIV align="center">
<TABLE border="0">
	<TBODY align="center">
		<% if (mvxd.indexOf("1") >= 0){ %>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="start" class="myButton" 
					value="1. <%=startWork%>" onclick="window.location='nipuah-start.jsp'"></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="production" class="myButton" value="2. <%=prodReport%>"
				 onclick="window.location='nipuah-report.jsp'"></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="nipuah_stopNew" class="myButton" value="<%=extrusionAndSlittingReport%>"
				 onclick="window.location='nipuah-extrusionAndSlitting.jsp'"></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="stop" class="myButton" value="3. <%=stopWork%>"
				 onclick="window.location='nipuah-stop.jsp'"></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="4. <%=endWork%>"
				 onclick="window.location='nipuah-end.jsp'"></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="5. <%=jumboReport%>"
				 onclick="window.location='../../../ibrix/IBRIX_BIO_REPORT-1.0.0/index.ibrix?mwp=true'"></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="6. <%=listOfOrders%>"
				 onclick="window.location='nipuah-listHoraot.jsp'"></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="7. <%=suspendedReport%>"
				 onclick="window.location='nipuah-suspendedReport.jsp'"></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="8. <%=insertRaw%>"
				 onclick="window.location='nipuah-insertRaw.jsp'"></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			 <TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="slitResizing" class="myButton" value="9. תיקון כיוון מדפסת"
				 onclick="window.location='../Slitter/slitter-fixPrinter.jsp'"></TD>
			</TR>
			 <TR>
				<TD></TD>
			</TR>
			<!--
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="9. <%=changeSilo%>"
				 onclick="window.location='nipuah-changeSilo.jsp'"></TD>
			</TR>
			<TR>
				<TD>&nbsp;</TD>
			</TR>
			-->	
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="10. <%=exitBtn%>"
				 onclick="CloseIbrix()"></TD>
			</TR>
			
			<TR>
				<TD>&nbsp;</TD>
			</TR>
			<TR>
				<TD>&nbsp;</TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><font color=red><INPUT type="button" name="slitResizing" class="myButtonSp" value="20. <%=recycleReport%>"
				 onclick="window.location='nipuah-recycleReport.jsp'"></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="slitResizing" class="myButtonOrange" value="21. <%=failuresReport%>"
				 onclick="popPassAhzaka()"></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="closeAll" class="myButtonOrange" 
				value="22. <%=ahzakaReport%>" onclick="window.location='../../../ibrix/IBRIX_AHZAKA_REPORT-1.0.0/index.ibrix'"></TD>
			</TR>
			
			<!--
			<TR>
				<TD>&nbsp;</TD>
			</TR>
			<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="closeAll" class="myButton" 
				value="1 פיתוח" onclick="window.location='nipuah-reportAndSlit.jsp'"></TD>
			</TR>
			
			<TR>
			<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="closeAll" class="myButton" 
				value="2 פיתוח" onclick="window.location='nipuah-slitter-startWork.jsp'"></TD>
			</TR>
			
			<TR>
			<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="closeAll" class="myButton" 
				value="3 פיתוח" onclick="window.location='nipuah-slitter-endOrder.jsp'"></TD>
			</TR>
			-->
		<% }else{ %>
			<!--
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="start" class="myButton" 
					value="1. Management" onclick="window.location='nipuah-management.jsp'"></TD>
			</TR>
			-->
			
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="start" class="myButton" 
					value="1. Management" onclick="popPassword()"></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="production" class="myButton" value="2. <%=prodReport%>"
				 onclick="window.location='nipuah-report.jsp'"></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="nipuah_stopNew" class="myButton" value="<%=extrusionAndSlittingReport%>"
				 onclick="window.location='nipuah-reportAndSlit.jsp'" DISABLED></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="3. Start Slitting Order"
				 onclick="window.location='nipuah-slitter-startWork.jsp'"></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="4. Finish Slitting Order"
				 onclick="window.location='nipuah-slitter-endOrder.jsp'"></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="5. <%=jumboReport%>"
				 onclick="window.location='../../../ibrix/IBRIX_BIO_REPORT-1.0.0/index.ibrix'"></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="6. <%=listOfOrders%>"
				 onclick="window.location='nipuah-listHoraot.jsp'"></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="7. <%=suspendedReport%>"
				 onclick="window.location='nipuah-suspendedReport.jsp'"></TD>
			</TR>
			<TR>
				<TD>&nbsp;</TD>
			</TR>
		
			<TR>
				<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="end" class="myButton" value="8. <%=exitBtn%>"
				 onclick="CloseIbrix()"></TD>
			</TR>
			<TR>
				<TD>&nbsp;</TD>
			</TR>
			<TR>
				<TD>&nbsp;</TD>
			</TR>
			<TR>
				<TD align="center" dir='<%=page_dir%>'><font color=red><INPUT type="button" name="slitResizing" class="myButtonSp" value="20. <%=recycleReport%>"
				 onclick="window.location='nipuah-recycleReport.jsp'"></TD>
			</TR>
			<!--
			<TD align="center" dir='<%=page_dir%>'><INPUT type="button" name="closeAll" class="myButton" 
				value="DEVELOPMENT" onclick="window.location='dev.jsp'"></TD>
			</TR>
			-->
		<% } %>
	</TBODY>
</TABLE>
<FORM name = "myForm">
<INPUT type="hidden" name="passAhzaka" value='<%=passAhzaka%>'>
<INPUT type="hidden" name="passBio" value='<%=passBio%>'>
</FORM>

</DIV>
</BODY>
</HTML>
