<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@ include file="/sors/ServerInstace.jsp"%>
<%@ page 
contentType="application/json"
pageEncoding="UTF-8"
%>

     
    
    	   
<%


try {
	String inputParams = request.getParameter("params");
	
	if(inputParams==null) inputParams="";
	//out.println(inputParams);
	String params=inputParams;//"cono;334;divi;100";
	
	String select="BDBKID,BDALLN,BDCURD,BDCKNO,BDBLAM,BDVSER,BDVONO,PAGENO,BDRFFD,BDLMDT,BDSDRC";//request.getParameter("returncols");
	
	
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
		
		strSQL +=" SELECT  BDBKID,BDALLN,BDCURD,BDCKNO,BDBLAM,BDVSER,BDVONO ";
		strSQL +=" ,BDSDRC,RTRIM(BDBKID)#PlusSign#SUBSTRING(CAST(BDSDRC AS VARCHAR(10)),7,2) ";
		strSQL +=" #PlusSign#SUBSTRING(CAST(BDSDRC AS VARCHAR(10)),5,2) ";
		strSQL +=" #PlusSign#SUBSTRING(CAST(BDSDRC AS VARCHAR(10)),3,2) AS PAGENO,BDRFFD,BDLMDT ";
		strSQL +=" FROM LOCAL.XERECD";
		strSQL +=" WHERE BDCONO=%cono% AND BDDIVI=~%divi%~ AND BDBKID=~%bkid%~ ";
		strSQL +=" %WhereString% ";
		strSQL +=" ORDER BY  %OrderByStr% ";


strSQL=strSQL.replace("~","'");
strSQL=strSQL.replace("SCHEMA.",SCHEMA_MOVEX);
strSQL=strSQL.replace("LOCAL.",LOCAL_SCHEMA);
strSQL=strSQL.replace("#PlusSign#",PlusSign);


String [] ArParams=params.split(";");
	 String par="";
	 String val="";
	 
	  for(int i=0;i<ArParams.length;i++){
		  par=ArParams[i];
		
		  if(par==null) break;
		  i++;
		  val=ArParams[i];

		  if(val==null) out.println("XXX");

		  strSQL=strSQL.replace("%"+par+"%",val);

	  }
	  
	//  out.println(strSQL);
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
			  sel=arSelect[j].trim(); //21.7.14 added trim
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

