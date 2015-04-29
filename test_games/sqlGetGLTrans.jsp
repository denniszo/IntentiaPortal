<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@ page contentType="application/json" pageEncoding="UTF-8"%>




<%


try {
String inputParams = request.getParameter("params");
	
	if(inputParams==null) inputParams="";
	//out.println(inputParams);
	String params=inputParams;//"cono;334;divi;100";
	
	String select=" EGAIT1, EGCUAM,EGCODT,VSER,RECNO,CHKNO,EGJRNO,EGJSNO,EGYEA4,EGACAM, TRDATE,EGVTXT,SHOVAR,EGERDT";
	String[] arSelect=select.split(",");
			
	//String[] arSelect=["EGAIT1"," EGCUAM","EGCODT","VSER","RECNO","CHKNO","EGJRNO","EGJSNO","EGYEA4","EGACAM","TRDATE","EGVTXT","SHOVAR","EGERDT"];
	
	 java.sql.DriverManager.registerDriver (new com.microsoft.sqlserver.jdbc.SQLServerDriver ());
	 
	  String url =  "jdbc:sqlserver://singapore:1433;databaseName=M3FDBDEV;user=sa;password=Int12345;TrustedConnection=false;";
      
      //jdbc:sqlserver://paris:1433;databaseName=MVXGRID;user=MDBUSR;password=Int12345;TrustedConnection=false;
      Connection conn = DriverManager.getConnection(url);
      Statement stmt = conn.createStatement();
      ResultSet rs;

      String strSQL="";
      
      strSQL=" SELECT FG.EGAIT1 AS EGAIT1,FG.EGCUAM AS EGCUAM "+
    		 " ,FG.EGOCDT AS EGCODT,LTRIM(SUBSTRING(FX1.EGGEXI,1,3)) AS VSER "+
    		 " ,LTRIM(SUBSTRING(FX1.EGGEXI,4,8)) AS RECNO, "+
    		 " FX2.EGGEXI AS CHKNO,FG.EGJRNO AS EGJRNO,FG.EGJSNO AS EGJSNO, "+
    		 " FG.EGYEA4 AS EGYEA4,FG.EGACAM AS EGACAM, "+
    		 " CASE WHEN FB.EGCURD IS NULL THEN FG.EGOCDT  ELSE FB.EGCURD END AS TRDATE, "+
    		 " EGVTXT,LTRIM(FG.EGVSER) + LTRIM(CAST(FG.EGVONO AS VARCHAR(10))) AS SHOVAR,FG.EGERDT AS EGERDT "+
    		 " FROM ##FGLEDG## FG LEFT JOIN ##FGLEDX## FX1 "+
    		 "  ON FX1.EGCONO = FG.EGCONO and FX1.EGDIVI = FG.EGDIVI "+ 
    		 "  and FX1.EGJRNO = FG.EGJRNO and FX1.EGJSNO = FG.EGJSNO  "+
    		 "  and FX1.EGYEA4 = FG.EGYEA4 and FX1.EGGEXN=103 "+
    		 "  LEFT JOIN ##FGLEDX## FX2 "+
    		 "  ON FX2.EGCONO = FG.EGCONO and FX2.EGDIVI = FG.EGDIVI "+ 
    		 "  and FX2.EGJRNO = FG.EGJRNO and FX2.EGJSNO = FG.EGJSNO "+
    		 "  and FX2.EGYEA4 = FG.EGYEA4 and FX2.EGGEXN=2 "+
    		 "  LEFT JOIN ##FGLEDB## FB "+
    		 "  ON FB.EGCONO = FG.EGCONO and FB.EGDIVI = FG.EGDIVI "+ 
    		 "  and FB.EGJRNO = FG.EGJRNO and FB.EGJSNO = FG.EGJSNO "+
    		 "  and FB.EGYEA4 = FG.EGYEA4 "+
    		 "  WHERE FG.EGCONO=%cono% and EGCUAM <> 0  AND FG.EGDIVI=~%divi%~ AND FG.EGAIT1=~%ait%~ "+
    		 "   %WhereString% "+
    		 "  ORDER BY  %OrderByStr% "; 
		
		

		     
	  strSQL=strSQL.replace("~","'");
	  strSQL=strSQL.replace("||","+");
	  strSQL=strSQL.replace(" ##"," MVXJDTA.");
	  strSQL=strSQL.replace("##"," ");
	
	  String [] ArParams=params.split(";");
	 String par="";
	 String val="";
	 
	  for(int i=0;i<ArParams.length;i++){
		  par=ArParams[i];
		
		  if(par==null) break;
		  i++;
		  val=ArParams[i];
		  
		  if(val==null) out.println("XXX");
	//	  out.println("par=" + par + " val=" + val + " <br />");
		//  out.println(i);
		  strSQL=strSQL.replace("%"+par+"%",val);
		//  out.println(i);
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
      System.out.println(rest);
      rs.close();
      
      conn.close();
     
      out.println(rest);
		
		} catch (Exception e) {
			e.printStackTrace();
			out.println("Got an exception! ");
			out.println(e.getMessage());
		}
	

%>

