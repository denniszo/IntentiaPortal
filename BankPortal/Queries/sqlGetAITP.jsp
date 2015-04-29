<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@ include file="/sors/ServerInstace.jsp"%>
<%@ page contentType="application/json" pageEncoding="UTF-8"%>




<%
String rest="";
String select="EAAITM,EATX40,EATX15,DIM2,DIM3,DIM4,DIM5,DIM6,DIM7";
String[] arSelect=select.split(",");

String cono =  request.getParameter("cono");
if(cono==null) cono="";
String divi =  request.getParameter("divi");
if(divi==null) divi="";
String aitp =  request.getParameter("aitp");
if(aitp==null) aitp="";
String name =  request.getParameter("name");
if(name==null) name="";
String number =  request.getParameter("number");
if(number==null) number="";

//System.out.println("aitp= "+aitp+" cono= "+cono+" divi= "+divi+" name="+name+" number="+number );
try {

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
    String strSQL =" SELECT EAAITM, EATX40, EATX15,EAACR2 AS DIM2,EAACR3 AS DIM3,EAACR4 AS DIM4,EAACR5 AS DIM5,EAACR6 AS DIM6,EAACR7 AS DIM7 ";
    strSQL +=" FROM SCHEMA.FCHACC ";
    strSQL +=" WHERE EACONO=? AND (EADIVI='' or EADIVI=?) ";
    strSQL +=" AND EAAITP=?  ";
    strSQL +=" AND EAAT03 <> '1' AND EAAT11 <> '1' ";

    if(name.length()>0){
        strSQL +=" AND  EATX40 like N'"+name+"%' ";
    }
    if(number.length()>0){
        strSQL +=" AND  EAAITM like N'"+number+"%' ";
    }




    strSQL=strSQL.replace("~","'");
    strSQL=strSQL.replace("SCHEMA.",SCHEMA_MOVEX);
    strSQL=strSQL.replace("LOCAL.",LOCAL_SCHEMA);
    strSQL=strSQL.replace("#PlusSign#",PlusSign);

    Connection conn = DriverManager.getConnection(url);
    PreparedStatement pstTransQry = conn.prepareStatement(strSQL);
    pstTransQry.setString(1, cono);
    pstTransQry.setString(2, divi);
    pstTransQry.setString(3, aitp);


    //System.out.println("sqlGetAITP= "+strSQL);

ResultSet rs = pstTransQry.executeQuery();

   //--rest--//

    rest = "  {";
    rest += "  \"Program\": \"GetAITP\",";
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


    int i=0;
    String sel="";
    String selResult="";

    while ( rs.next() ) {
        if(i>0) rest+=",";
        rest += " { ";
        rest += "\"RowIndex\": \" " + i + " \", ";
        rest += "\"NameValue\": [";

        for (int j = 0; j < arSelect.length; j++) {
        if (j > 0)   rest += ",";

        sel = arSelect[j];
        selResult=rs.getString(sel);
        if (selResult == null)    selResult = "";

        rest += " {";
        rest += " \"Name\": \"" + sel + "\",";
        rest += " \"Value\": \"" + selResult.trim().replace("\"","\\\"")  + "\"";
        rest += " }";
        }
        rest += " ]}";
        i++;
    }
    rest += " ]}";

    rs.close();
    conn.close();
   // System.out.println("rest= "+rest);
    out.println(rest);


} catch (Exception e) {
    e.printStackTrace();
}



%>