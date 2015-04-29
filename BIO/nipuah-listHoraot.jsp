<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@include file="nipuah-const.jsp"%>
<%@include file="nipuah-labels-heb.jsp"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.SQLException"%>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.PreparedStatement"%>
<%@ page import = "java.sql.ResultSet"%>

<%
	String mie=String.valueOf(MIEAppID);
	
	String horaot = "";
	String movOrder = "";
	
	String faci = "";
	if (mvxd.indexOf("1") >= 0)
		faci = "001";
	else
		faci = "200";
		
	String test = "";
	if(mie.endsWith("TEST"))
		test = "1";
	else
		test = "0";
	
	Connection dbConn = null;
	try {
      Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");

      //db name
      String dbName = "Movex";     

      String url = "jdbc:odbc:" + dbName;
      
      dbConn = DriverManager.getConnection(url, mws_username, mws_password);
      //out.println(dbConn.toString());
      //out.flush();

    } catch (SQLException ex) { // Handle SQL errors
      	out.println(ex.toString());
    } catch (ClassNotFoundException ex1) {
     	out.println(ex1.toString());
    }
	
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT * FROM seijdta.syfbio as AA WHERE AA.FACI=? and AA.TEST=?";
	
	try {
      stmt = dbConn.prepareStatement(sql);
         
      stmt.setString(1, faci);
	  stmt.setString(2, test);
		        
      rs = stmt.executeQuery();
      
      while (rs.next()){				// there is already a record for this machine
      	horaot = horaot + rs.getString("syfanOrder") + ",";
	  }
	} catch (Exception e) {}
      
      
     try {
      if (dbConn != null && !dbConn.isClosed()) {
        dbConn.close();
        System.out.println("DB connection is closed.");
      }
    } catch (Exception e) {}
    
   %>
   
<%
int numOfLines = 0;
%>
<HTML>
<HEAD>


<META http-equiv="Content-Type"
	content="text/html; charset=windows-1255">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">


<LINK href="theme/Master.css" rel="stylesheet" type="text/css">

<style type="text/css">
input.myButton {width:150}
input.clReadonly {background-color:#F0F0F0;border-color:steelblue;border-width:1px;border-style:solid}
</style>

<TITLE>nipuah-listHoraot.jsp</TITLE>
<SCRIPT language="javascript">

var MvxCompany = "<%=MvxCompany%>";
var mvxd = "<%=mvxd%>";

function onLoad(){

	initLines();

	list = document.myForm.horaot.value;
	myArr = list.split(",");
	
	for (i=0;i<myArr.length-1;i++)
		myArr[i] = "'" + myArr[i] + "'";
		
	newList = myArr.join();
	
	newList = newList.substr(0,newList.length-1);
	
	var RejReas_Collection = new ActiveXObject("CCWrapperINet.MieCollection.5");
	RejReas_Collection.ApplicationID = "<%=MIEAppID%>";
	RejReas_Collection.MieServer = "<%=MIEServerURL%>";
	
	RejReas_Collection.AddValue("cono", MvxCompany);
	RejReas_Collection.AddValue("horaot", newList);
	
	if (mvxd.indexOf("1") >= 0)
		RejReas_Collection.CreateCollection("MO_GetHoraotOnBio");//Run model
	else
		RejReas_Collection.CreateCollection("MO_GetHoraotOnBioUS");//Run model

	if (RejReas_Collection.count== 0){
		alert("<%=error_NoOrdersOnMachines%>");
	}else{
		numOfLines = RejReas_Collection.count;
		document.myForm.numOfLinesHID.value = numOfLines;
		
		addLines(numOfLines);
		
		for (var j = 0; j < numOfLines; j++){
			var oStd=RejReas_Collection.Item(j);//row
				
			machine = oStd.GetValue("MACHINE");
			horaa = oStd.GetValue("HORAA");
			qty = formatWeight(oStd.GetValue("QTY"),0);
			horaa_movex = oStd.GetValue("HORAA_MOVEX");
			type = oStd.GetValue("TYPE");
			micron = oStd.GetValue("MICRON");
			myItem = oStd.GetValue("ITEM");
			nusha = oStd.GetValue("ETZ");
			width_from = formatWeight(oStd.GetValue("WIDTH_FROM"),0);
			width_to = formatWeight(oStd.GetValue("WIDTH_TO"),0);
			sstatus = oStd.GetValue("STATUS");
			
			k = j + 1;
			
			eval("document.myForm.machine" + k + ".value = '" + machine + "'");
			eval("document.myForm.horaa" + k + ".value = '" + horaa + "'");
			eval("document.myForm.item" + k + ".value = '" + myItem + "'");
			eval("document.myForm.horaa_movex" + k + ".value = '" + horaa_movex + "'");
			eval("document.myForm.qty" + k + ".value = '" + qty + "'");
			eval("document.myForm.type" + k + ".value = '" + type + "'");
			eval("document.myForm.micron" + k + ".value = '" + micron + "'");
			eval("document.myForm.nusha" + k + ".value = '" + nusha + "'");
			eval("document.myForm.width_from" + k + ".value = '" + width_from + "'");
			eval("document.myForm.width_to" + k + ".value = '" + width_to + "'");
			
			if (sstatus == "70"){
				if (mvxd.indexOf("1") >= 0)
					eval("document.myForm.stopped" + k + ".value = 'כן'");
				else
					eval("document.myForm.stopped" + k + ".value = 'yes'");
			}else
				eval("document.myForm.stopped" + k + ".value = ''");
			
		}//end for
		
	}
	
	RejReas_Collection=null;
	
}

// this function reveales a new line for one more field
// the visibility of the new line is set to visible.
function addLines(x){
	for (i=1; i<=x;i++){
		eval("myLine" + i + ".style.display = ''");
	}
}

function initLines(){
	for (i=1; i<=6;i++){
		eval("myLine" + i + ".style.display = 'none'");
	
		eval("document.myForm.machine" + i + ".value = ''");
		eval("document.myForm.item" + i + ".value = ''");
		eval("document.myForm.horaa" + i + ".value = ''");
		eval("document.myForm.qty" + i + ".value = ''");
		eval("document.myForm.horaa_movex" + i + ".value = ''");
		eval("document.myForm.type" + i + ".value = ''");
		eval("document.myForm.micron" + i + ".value = ''");
		eval("document.myForm.nusha" + i + ".value = ''");
		eval("document.myForm.width_from" + i + ".value = ''");
		eval("document.myForm.width_to" + i + ".value = ''");
		eval("document.myForm.stopped" + i + ".value = ''");
	}	
	document.myForm.numOfLinesHID.value = '';
}


function formatWeight(num, decimals){
	num = "" + num;
	var position = num.indexOf(".");
	
	if (position == 0){
		num = "0" + num;
		position = 1;
	}
	
	if (decimals > 0)
		decimals++;
	
	if (position > 0){
		if (num.length > position + 1* decimals)
			return num.substring(0, position + 1 * decimals);
		else
			return num;
	}else
		return num;
}

</SCRIPT>
</HEAD>


<BODY dir=<%=page_dir%> onload="onLoad()">

<P align="center"><B><FONT size="+2"><%=title_listOfOrders%></FONT></B></P>
<P><BR>
<BR>
</P>
<DIV align="center">
<FORM name = "myForm" target="RepManWin" method="POST">


<p>&nbsp;<p>
<% // this loop creates 6 "div", none are visible in the begining.
   // before the first one there are headers.
int i = 1;

for (i=1; i<=6;i++){
	if (i < numOfLines+1){ %>
		<div id='myLine<%=i%>' align=right style='display:on'>
	<% }else{ %>
		<div id='myLine<%=i%>' align=right style='display:none'>
	<% } %>
	<center>
	<table border="0" id="tbl<%=i%>">
	<% if (i == 1){ %>
		<tr>
			<th><%=lblMachine%></th>
			<th><%=lblOrder2%></th>	
			<th><%=lblMovexPO2%></th>		
			<th><%=lblType%></th>
			<th><%=lblOvi%></th>
			<th><%=lblItem%></th>
			<th><%=lblQty%></th>
			<th><%=lblNusha%></th>
			<th><%=lblFromWidth%></th>
			<th><%=lblToWidth%></th>
			<th><%=lblStopped%></th>
		</tr>
	<% } %>
	<tr>
		<TD align="<%=input_align%>"><INPUT type="text" name="machine<%=i%>" value="" size=5  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="horaa<%=i%>" value="" size=5  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="horaa_movex<%=i%>" value="" size=10  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="type<%=i%>" value="" size=10  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="micron<%=i%>" value="" size=5  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="item<%=i%>" value="" size=10  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="qty<%=i%>" value="" size=5  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="nusha<%=i%>" value="" size=5  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="width_from<%=i%>" value="" size=5  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="width_to<%=i%>" value="" size=5  readonly class='clReadonly'></td>
		<TD align="<%=input_align%>"><INPUT type="text" name="stopped<%=i%>" value="" size=5  readonly class='clReadonly'></td>
	</tr>
	
	</TABLE>
	</div>
<% } %>
<p>
<INPUT type="button" name="go" value="<%=exitBtn%>" class="myButton"  onclick="window.location='nipuah-first.jsp'">

<INPUT type="hidden" name="numOfLinesHID">
<INPUT type="hidden" name="horaot" value='<%=horaot%>'>

</FORM>
</DIV>
</BODY>
</HTML>
