<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@ page 
contentType="application/json"
pageEncoding="UTF-8"
%>

     
     {
    	  "Program": "CRS610MI",
    	  "Transaction": "LstByNumber",
    	  "Metadata": {
    	    "Field": [
    	      {
    	        "@name": "CUNO",
    	        "@type": "A",
    	        "@length": "10"
    	      },
    	      {
    	        "@name": "CUNM",
    	        "@type": "A",
    	        "@length": "36"
    	      }
    	    ]
    	  },
    	  "MIRecord": [
    	   
<%


try {
	 
	 java.sql.DriverManager.registerDriver (new com.microsoft.sqlserver.jdbc.SQLServerDriver ());
	 
	  String url =  "jdbc:sqlserver://singapore:1433;databaseName=M3FDBDEV;user=sa;password=Int12345;TrustedConnection=false;";
      
      //jdbc:sqlserver://paris:1433;databaseName=MVXGRID;user=MDBUSR;password=Int12345;TrustedConnection=false;
      Connection conn = DriverManager.getConnection(url);
      Statement stmt = conn.createStatement();
      ResultSet rs;

      String strSQL="";
      
      strSQL="";
						  strSQL +=" SELECT FG.EGAIT1 AS EGAIT1,FG.EGCUAM AS EGCUAM ";
						  strSQL +=" ,FG.EGOCDT AS EGCODT,LTRIM(SUBSTRING(FX1.EGGEXI,1,3)) AS VSER";
						  strSQL +=" ,LTRIM(SUBSTRING(FX1.EGGEXI,4,8)) AS RECNO,";
						  strSQL +=" FX2.EGGEXI AS CHKNO,FG.EGJRNO AS EGJRNO,FG.EGJSNO AS EGJSNO,";
						  strSQL +=" FG.EGYEA4 AS EGYEA4,FG.EGACAM AS EGACAM,";
						  strSQL +=" CASE WHEN FB.EGCURD IS NULL THEN FG.EGOCDT  ELSE FB.EGCURD END AS TRDATE,";
						  strSQL +=" EGVTXT,LTRIM(FG.EGVSER) + LTRIM(CAST(FG.EGVONO AS VARCHAR(10))) AS SHOVAR,FG.EGERDT AS EGERDT";
						  strSQL +=" FROM MVXJDTA.FGLEDG  FG LEFT JOIN MVXJDTA.FGLEDX  FX1";
						  strSQL +=" ON FX1.EGCONO = FG.EGCONO and FX1.EGDIVI = FG.EGDIVI"; 
						  strSQL +=" and FX1.EGJRNO = FG.EGJRNO and FX1.EGJSNO = FG.EGJSNO"; 
						  strSQL +=" and FX1.EGYEA4 = FG.EGYEA4 and FX1.EGGEXN=103";
						  strSQL +=" LEFT JOIN MVXJDTA.FGLEDX  FX2";
						  strSQL +=" ON FX2.EGCONO = FG.EGCONO and FX2.EGDIVI = FG.EGDIVI"; 
						  strSQL +=" and FX2.EGJRNO = FG.EGJRNO and FX2.EGJSNO = FG.EGJSNO"; 
						  strSQL +=" and FX2.EGYEA4 = FG.EGYEA4 and FX2.EGGEXN=2";
						  strSQL +=" LEFT JOIN MVXJDTA.FGLEDB  FB";
						  strSQL +=" ON FB.EGCONO = FG.EGCONO and FB.EGDIVI = FG.EGDIVI"; 
						  strSQL +=" and FB.EGJRNO = FG.EGJRNO and FB.EGJSNO = FG.EGJSNO"; 
						  strSQL +=" and FB.EGYEA4 = FG.EGYEA4";
						  strSQL +=" WHERE FG.EGCONO=334 and EGCUAM <> 0  AND FG.EGDIVI='100' AND FG.EGAIT1='11100000'";
						  strSQL +=" AND FG.EGTOCD!='9'";
						  strSQL +=" ORDER BY  TRDATE,ABS(FG.EGCUAM)";
      rs = stmt.executeQuery(strSQL);
      int i=0;
      while ( rs.next() ) {
    	  if(i>0) out.println(",");
    	  %>
    	   {
    		      "RowIndex": "<%=i%>",
    		      "NameValue": [
    		        {
    		        	   "Name": "EGAIT1",
    		               "Value": "<%=rs.getString("EGAIT1").trim()%>" 
    		             },
  		    
					        {
					        	   "Name": "EGCUAM",
					               "Value": "<%=rs.getString("EGCUAM").trim()%>" 
					             },
					             
					             
					             {
						        	   "Name": "EGCODT",
						               "Value": "<%=rs.getString("EGCODT").trim()%>" 
						             }  
    	    		             ]
    	    }
    		        	  <%
		  
		   i++;
      }
      
      rs.close();
      conn.close();
      
      %>
      
      ]
     }

<%
} catch (Exception e) {
    System.err.println("Got an exception! ");
    System.err.println(e.getMessage());
}
%>
