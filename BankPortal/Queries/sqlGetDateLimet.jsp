<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@ include file="/sors/ServerInstace.jsp"%>
<%@ page contentType="application/json" pageEncoding="UTF-8"%>


<%

String cono = request.getParameter("cono");
String divi = request.getParameter("divi");
String intn = request.getParameter("intn");

try {
String func = GetNameToLimit(CONECTION_JAVA,SERVER_PORT,DATABASE,USER,PASS,SCHEMA_MOVEX,LOCAL_SCHEMA,PlusSign,cono,divi,intn);
if(func.equals("")){
    out.println(-1);
    return;
}
String json = GetDateToLimit(CONECTION_JAVA,SERVER_PORT,DATABASE,USER,PASS,SCHEMA_MOVEX,LOCAL_SCHEMA,PlusSign, cono, divi,  func);
if(json.equals("")){
    out.println(0);
    return;
}else{
    out.println(json);
}

} catch (Exception e) {
    e.printStackTrace();
    out.println(-1);
    out.println(e.getMessage());
}
%>

<%!

public static String GetNameToLimit(String CONECTION_JAVA,String SERVER_PORT,String DATABASE, String USER,String PASS,String SCHEMA_MOVEX, String LOCAL_SCHEMA,String PlusSign,
                                        String cono,String divi, String intn) throws SQLException{
    String func="";

    String url = "";
    if(CONECTION_JAVA.equals("SQL")){
        java.sql.DriverManager.registerDriver (new com.microsoft.sqlserver.jdbc.SQLServerDriver ());
        url =  "jdbc:sqlserver://"+SERVER_PORT+";databaseName="+DATABASE+";user="+USER+";password="+PASS+";TrustedConnection=false;";
    }else{
        if(CONECTION_JAVA.equals("AS400")){
            java.sql.DriverManager.registerDriver (new com.ibm.as400.access.AS400JDBCDriver());
            url =  "jdbc:as400://"+SERVER_PORT+";databaseName="+DATABASE+";user="+USER+";password="+PASS;
        }
    }

    Connection conn = DriverManager.getConnection(url);

    String strSQL="";
    strSQL +=" SELECT (CAST (DHFEID as VARCHAR(17)) PlusSign''PlusSign CAST (DHFNCN as VARCHAR(17))) AS FUNC ";
    strSQL +=" FROM SCHEMA.FFIHEA ";
    strSQL +=" WHERE DHCONO=? AND DHDIVI=? AND  DHINTN=? ";

    strSQL=strSQL.replace("~","'");
    strSQL=strSQL.replace("SCHEMA.",SCHEMA_MOVEX);
    strSQL=strSQL.replace("LOCAL.",LOCAL_SCHEMA);
    strSQL=strSQL.replace("PlusSign",PlusSign);


    PreparedStatement pstTransQry = conn.prepareStatement(strSQL);
    pstTransQry.setString(1, cono);
    pstTransQry.setString(2, divi);
    pstTransQry.setString(3, intn);


    ResultSet rs = pstTransQry.executeQuery();
    if ( rs.next() ) {
        func =  rs.getString("FUNC");
    }
    conn.close();

    return func;
}

public static String GetDateToLimit(String CONECTION_JAVA,String SERVER_PORT,String DATABASE, String USER,String PASS,String SCHEMA_MOVEX, String LOCAL_SCHEMA,String PlusSign,
                                    String cono,String divi, String func) throws SQLException{
    String[] arSelect= {"START_DATE","END_DATE"};
    String retJson = "";
    java.sql.DriverManager.registerDriver (new com.microsoft.sqlserver.jdbc.SQLServerDriver ());

    String url =  "jdbc:sqlserver://"+SERVER_PORT+";databaseName="+DATABASE+";user="+USER+";password="+PASS+";TrustedConnection=false;";

    Connection conn = DriverManager.getConnection(url);
    String strSQL="";
    strSQL +=" SELECT  SUBSTRING(CTPARM,14,8) AS START_DATE, ";
    strSQL +=" SUBSTRING(CTPARM,22,8) AS END_DATE ";
    strSQL +=" FROM SCHEMA.CSYTAB ";
    strSQL +=" WHERE CTCONO=? AND CTDIVI=? ";
    strSQL +=" AND CTSTCO='FFNC' AND SUBSTRING(CTSTKY,1,7)=? ";


strSQL=strSQL.replace("~","'");
strSQL=strSQL.replace("SCHEMA."," MVXJDTA.");
strSQL=strSQL.replace("LOCAL."," ISRJDTA.");



PreparedStatement pstTransQry = conn.prepareStatement(strSQL);
    pstTransQry.setString(1, cono);
    pstTransQry.setString(2, divi);
    pstTransQry.setString(3, func);

            String rest="";

            rest="  {";
            rest+="  \"Program\": \"GetData\",";
            rest+="\"Transaction\": \"SqlData\",";
            rest+="\"Metadata\": {";
            rest+="\"Field\": [";
            rest+="{";
            rest+="\"@name\": \"CUNO\",";
            rest+="\"@type\": \"A\",";
            rest+="\"@length\": \"10\"";
            rest+="},";
            rest+="{";
            rest+="\"@name\": \"CUNM\",";
            rest+="\"@type\": \"A\",";
            rest+="\"@length\": \"36\"";
            rest+="}";
            rest+="]";
            rest+="},";
            rest+="\"MIRecord\": [";



            int i=0;
            String sel="";
            String selResult="";
    ResultSet rs = pstTransQry.executeQuery();
    if ( rs.next() ) {
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
rest+=" ]}";

    }else{
        rest="";
    }


    conn.close();
    return rest;
}
%>