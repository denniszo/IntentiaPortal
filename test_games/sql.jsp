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
      
      strSQL="SELECT OKCUNO, OKCUNM from MVXJDTA.OCUSMA where OKCONO=790";
      
      rs = stmt.executeQuery(strSQL);
      int i=0;
      while ( rs.next() ) {
    	  if(i>0) out.println(",");
    	  %>
    	   {
    		      "RowIndex": "<%=i%>",
    		      "NameValue": [
    		        {
    		        	   "Name": "CUNO",
    		               "Value": "<%=rs.getString("OKCUNO").trim()%>" 
    		             },
  		    
    	    		        {
    	    		        	   "Name": "CUNM",
    	    		               "Value": "<%=rs.getString("OKCUNM").trim()%>" 
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
