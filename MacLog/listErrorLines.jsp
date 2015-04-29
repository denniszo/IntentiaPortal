<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@ page contentType="application/json" pageEncoding="UTF-8"%>

<%
String[] arSelect = { "agreement", "log_time", "uuid", "state" };
String rest = "";

try {

rest = "  {";
rest += "  \"Program\": \"GetErrorLog\",";
rest += "\"Transaction\": \"lines\",";
rest += "\"Metadata\": {";
rest += "},";
rest += "\"MIRecord\": [";

int i = 0;
String sel = "";
String selResult = "";

java.sql.DriverManager.registerDriver(new com.microsoft.sqlserver.jdbc.SQLServerDriver());
String url = "jdbc:sqlserver://dbs01:1433;databaseName=MEC_Storage;user=mecuser;password=Int12345;TrustedConnection=false";
java.sql.Connection con = DriverManager.getConnection(url);

String strSQL = " SELECT DocStates.LogTime as log_time ,DocStates.UUID as uuid, "
    + "DocStates.State as state, DocManifestsHeader.Agreement as agreement "
    + " FROM DocStates "
    + " join DocManifestsHeader on DocStates.UUID=DocManifestsHeader.UUID "
    + " where DocStates.LogTime>? and DocStates.State !='Finished' "
    + " order by DocStates.LogTime";
java.sql.PreparedStatement pstTransQry = con.prepareStatement(strSQL);
pstTransQry.setString(1, "1421704800000");
System.out.println(strSQL);
java.sql.ResultSet rs = pstTransQry.executeQuery();

while (rs.next()) {
if (i > 0)
rest += ",";
rest += " { ";
rest += "\"RowIndex\": \" " + i + " \", ";
rest += "\"NameValue\": [";

for (int j = 0; j < arSelect.length; j++) {
if (j > 0)
rest += ",";
sel = arSelect[j];
selResult = rs.getString(sel);
if (selResult == null)
selResult = "";
rest += " {";
rest += " \"Name\": \"" + sel + "\",";
rest += " \"Value\": \"" + selResult.trim().replace("\"", "\\\"") + "\"";
rest += " }";
}
rest += " ]}";
i++;



}
rest += " ]}";
con.close();
System.out.println("No Error --------------------------------------------------------------");
System.out.println(rest);
out.println(rest);

} catch (Exception e) {
System.out.println("Error----------------------------------------------------------------------------------------");
out.println(rest);
e.printStackTrace();
}




%>