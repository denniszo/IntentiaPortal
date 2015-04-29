<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>

<%@ include file="/sors/ServerInstace.jsp"%>
<%@ page contentType="application/json" pageEncoding="UTF-8"%>

<%
String[] arSelect = { "MMITNO", "MMITDS","MMFUDS","MMRESP"}; //return fiels
String rest = "";//json string

/*
*incuming parameters
*/
String cono = (String) request.getParameter("cono");
if(cono==null) cono="";

String stat = (String) request.getParameter("stat");
if(stat==null || stat.equals("") ){
	stat="";
}

String itno = (String) request.getParameter("itno");
if(itno==null || itno.equals("")){
    itno="";
}

String itds = (String) request.getParameter("itds");
if(itds==null || itds.equals("")){
	itds="";
}


////////----start SQL qwery
try {
		//SQL string 
	  String strSQL = "select MMITNO,REPLACE(MMITDS,'\"','''') AS MMITDS,REPLACE(MMFUDS,'\"','''') AS MMFUDS,MMRESP "+
		" from "+SCHEMA_MOVEX+"MITMAS "+
		" where MMCONO=? ";
	  if(!stat.equals("")){
		  strSQL+=" and MMSTAT=? " ;
	  }
	 
	  
	  java.sql.DriverManager.registerDriver (new com.microsoft.sqlserver.jdbc.SQLServerDriver ());//conection JAR
	  String url =  "jdbc:sqlserver://singapore:1433;databaseName=M3FDBDEV;user=sa;password=Int12345;TrustedConnection=false;";//conection parameters
      
      Connection conn = DriverManager.getConnection(url); //set connection
      PreparedStatement pstTransQry = conn.prepareStatement(strSQL); //set property to statemens
      
    /* for As400
	  java.sql.DriverManager.registerDriver (new com.ibm.as400.access.AS400JDBCDriver());
      url =  "jdbc:as400://"+SERVER_PORT+";databaseName="+DATABASE+";user="+USER+";password="+PASS;
   	*/
   	int cont=1;
      pstTransQry.setString(cont, cono);//statment 1
      cont++;
      if(!stat.equals("")){//statment 2
	      pstTransQry.setString(cont, stat);
	      cont++;
      }
      
     // System.out.println("strSQL= "+strSQL);
      ResultSet rs = pstTransQry.executeQuery();//set result 
      //create head for jeson
rest = "{";
rest += "  \"Program\": \"GetErrorLog\",";
rest += "\"Transaction\": \"lines\",";
rest += "\"Metadata\": {";
rest += "\"Field\": [";
rest += "{";
rest += "\"@name\": \"CUNO\",";
rest += "\"@type\": \"A\",";
rest += "\"@length\": \"10\"";
rest += "},";
rest += "{";
rest += "\"@name\": \"CUNM\",";
rest += "\"@type\": \"A\",";
rest += "\"@length\": \"36\"";
rest += "}";
rest += "]";
rest += "},";
rest += "\"MIRecord\": [";

int i = 0;
String sel = "";
String selResult = "";

while ( rs.next() ){ //lines from qwery to body json
if (i > 0)
rest += ",";
rest += " { ";
rest += "\"RowIndex\": \" " + i + " \", ";
rest += "\"NameValue\": [";

for (int j = 0; j < arSelect.length; j++) {
if (j > 0)
rest += ",";
sel = arSelect[j];//insert name of feald
selResult = rs.getString(sel);//insert result

if (selResult == null){
    selResult = "";
}else{
   selResult= selResult.trim().replace("\"","\\\"");
   selResult= selResult.replace("\\","/");
}


rest += " {";
rest += " \"Name\": \"" + sel + "\",";
rest += " \"Value\": \"" + selResult + "\"";
rest += " }";

}
rest += " ]}";
i++;


}

rest += " ]}";
rs.close();
conn.close();

} catch (Exception e) {
    e.printStackTrace();
}

//System.out.println("rest= "+rest);
out.println(rest);

%>