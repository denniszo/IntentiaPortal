<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@ include file="/sors/ServerInstace.jsp"%>
<%@ page contentType="application/json" pageEncoding="UTF-8"%>




<%


try {
    String barcod = request.getParameter("barcod");
    if(barcod==null) barcod="";

    String select="RCAFNM,RCBCDE";
    String[] arSelect=select.split(",");

    String url = "";

    if(CONECTION_JAVA.equals("SQL")){
        java.sql.DriverManager.registerDriver (new com.microsoft.sqlserver.jdbc.SQLServerDriver ());
        url =  "jdbc:sqlserver://paris:1433;databaseName=M71_DEVL;user="+USER+";password="+PASS+";TrustedConnection=false;";
        //url =  "jdbc:sqlserver://"+SERVER_PORT+";databaseName="+DATABASE+";user="+USER+";password="+PASS+";TrustedConnection=false;";
    }else{
        if(CONECTION_JAVA.equals("AS400")){
            java.sql.DriverManager.registerDriver (new com.ibm.as400.access.AS400JDBCDriver());
            url =  "jdbc:as400://"+SERVER_PORT+";databaseName="+DATABASE+";user="+USER+";password="+PASS;
        }
    }
    Connection conn = DriverManager.getConnection(url);
    Statement stmt = conn.createStatement();
    ResultSet rs;

    String strSQL="";

    strSQL="";
    strSQL +=" SELECT RCAFNM,RCBCDE ";
    strSQL +=" FROM CHRJDTA.ARC001 ";
    strSQL +=" WHERE RCBCDE='"+barcod+"' ";

    rs = stmt.executeQuery(strSQL);
    String rest="";

rest="  {";
rest+="  \"Program\": \"FileBarcodeList\",";
rest+="\"Transaction\": \"LstByNumber\",";
rest+="\"Metadata\": {";
rest+="\"Field\": [";
rest+="{";
rest+="\"@name\": \"RCAFNM\",";
rest+="\"@type\": \"A\",";
rest+="\"@length\": \"10\"";
rest+="},";
rest+="{";
rest+="\"@name\": \"RCBCDE\",";
rest+="\"@type\": \"A\",";
rest+="\"@length\": \"36\"";
rest+="}";
rest+="]";
rest+="},";
rest+="\"MIRecord\": [";



int i=0;
String sel="";
String selResult="";
while ( rs.next() ) {

if(i>0) rest+=",";
rest+=" { ";
rest+= "\"RowIndex\": \" " + i + " \", ";
rest+= "\"NameValue\": [";
for(int j=0;j<arSelect.length;j++){
if(j>0) rest+=",";
sel=arSelect[j];
selResult=rs.getString(sel);
if(selResult==null) selResult="";
rest+=" {";
rest+=" \"Name\": \""   + sel +  "\",";
rest+=" \"Value\": \""   +selResult.trim().replace("\"","\\\"") + "\"";
rest+=" }";
}
rest+=" ]}";
i++;
}
rest+=" ]}";
System.out.println(rest);
rs.close();

conn.close();

out.println(rest);

} catch (Exception e) {
e.printStackTrace();
System.err.println("Got an exception! ");
System.err.println(e.getMessage());
}


%>

