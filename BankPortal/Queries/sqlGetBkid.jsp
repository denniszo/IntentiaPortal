<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@ include file="/sors/ServerInstace.jsp"%>
<%@ page contentType="application/json" pageEncoding="UTF-8"%>




<%


try {
	String inputParams = request.getParameter("params");
	
	if(inputParams==null) inputParams="";
	
	String params=inputParams;//"cono;334;divi;100";
	
	String select="BCBKID,BCBKNO,BCAIT1,EATX15,BKIDNAME";
	
	
	String[] arSelect=select.split(",");

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
      Statement stmt = conn.createStatement();
      ResultSet rs;

      String strSQL="";
      
      strSQL="";

	  strSQL +=" SELECT   BCBKID,BCBKNO,BCAIT1,EATX15,BCBKID #PlusSign# ~ ~ #PlusSign# LTRIM(BCBANA) ";
	  strSQL +=" AS BKIDNAME";
	
	  strSQL +=" FROM SCHEMA.CBANAC ";
	  strSQL +=" LEFT JOIN SCHEMA.FCHACC ON";
	  strSQL +=" BCCONO=EACONO AND BCDIVI=EADIVI AND EAAITP=1 AND BCAIT1=EAAITM";
	  strSQL +=" WHERE BCCONO=%cono% AND BCDIVI=~%divi%~";
	  strSQL +="  AND LTRIM(BCACHO)=~~ AND BCBKTP=1 ";


    //strSQL +=" AND BCBKID='20001' "; //TODO - to developer only to test and prodaction remuve line

strSQL=strSQL.replace("~","'");
strSQL=strSQL.replace("SCHEMA.",SCHEMA_MOVEX);
strSQL=strSQL.replace("LOCAL.",LOCAL_SCHEMA);
strSQL=strSQL.replace("#PlusSign#",PlusSign);
	  
	  String [] ArParams=params.split(";");
	 String par="";
	 String val="";
	 
	  for(int i=0;i<ArParams.length;i++){
		  par=ArParams[i];
		  i++;
		  val=ArParams[i];
		  strSQL=strSQL.replace("%"+par+"%",val);
	  }
	//  System.out.println(strSQL);
  
	  
  
      rs = stmt.executeQuery(strSQL);
      String rest="";
      
	  rest="  {";
	  rest+="  \"Program\": \"CRS610MI\",";
	  rest+="\"Transaction\": \"LstByNumber\",";
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
      while ( rs.next() ) {
    	  
    	  if(i>0) rest+=",";
    	// System.out.println(i);
    	// System.out.println(rs.getString("EATX15").trim());
    		
    	  
		    		  
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
      //System.out.println(rest);
      rs.close();
      
      conn.close();
     
      out.println(rest);
		
		} catch (Exception e) {
			e.printStackTrace();
		    System.err.println("Got an exception! ");
		    System.err.println(e.getMessage());
		}
	

%>

