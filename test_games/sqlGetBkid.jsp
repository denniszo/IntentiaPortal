<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@ page contentType="application/json" pageEncoding="UTF-8"%>




<%


try {
	String inputParams = request.getParameter("params");
	
	if(inputParams==null) inputParams="";
	
	String params=inputParams;//"cono;334;divi;100";
	
	String select="BCBKID,BCBKNO,BCAIT1,EATX15,BKIDNAME";
	
	
	String[] arSelect=select.split(",");
	
	 java.sql.DriverManager.registerDriver (new com.microsoft.sqlserver.jdbc.SQLServerDriver ());
	 
	  String url =  "jdbc:sqlserver://singapore:1433;databaseName=M3FDBDEV;user=sa;password=Int12345;TrustedConnection=false;";
      
      //jdbc:sqlserver://paris:1433;databaseName=MVXGRID;user=MDBUSR;password=Int12345;TrustedConnection=false;
      Connection conn = DriverManager.getConnection(url);
      Statement stmt = conn.createStatement();
      ResultSet rs;

      String strSQL="";
      
      strSQL="";

	  strSQL +=" SELECT   BCBKID,BCBKNO,BCAIT1,EATX15,BCBKID + ~ ~ + LTRIM(BCBANA) ";
	  strSQL +=" AS BKIDNAME";
	
	  strSQL +=" FROM ##CBANAC## ";
	  strSQL +=" LEFT JOIN ##FCHACC## ON";
	  strSQL +=" BCCONO=EACONO AND BCDIVI=EADIVI AND EAAITP=1 AND BCAIT1=EAAITM";
	  strSQL +=" WHERE BCCONO=%cono% AND BCDIVI=~%divi%~";
	  strSQL +="  AND LTRIM(BCACHO)=~~ AND BCBKTP=1";
	     
	  strSQL=strSQL.replace("~","'");
	  strSQL=strSQL.replace(" ##"," MVXJDTA.");
	  strSQL=strSQL.replace("##"," ");
	  
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

