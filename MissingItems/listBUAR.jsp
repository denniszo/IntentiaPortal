<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>

<%@ page contentType="application/json" pageEncoding="UTF-8"%>

<%
String[] arSelect = { "buar", "tx40", "tx15"};
String rest = "";

String cono = (String) request.getParameter("cono");
if(cono==null) cono="200";


il.co.intentia.getBUAR getList = new il.co.intentia.getBUAR(cono);
//System.out.println(getList);

try {
Stack retStac = getList.getBUARList();

rest = "  {";
rest += "  \"Program\": \"GetErrorLog\",";
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

int i = 0;
String sel = "";
String selResult = "";

while (!retStac.empty()) {
Hashtable retAnserline = (Hashtable) retStac.pop();
if (i > 0)
rest += ",";
rest += " { ";
rest += "\"RowIndex\": \" " + i + " \", ";
rest += "\"NameValue\": [";

for (int j = 0; j < arSelect.length; j++) {
if (j > 0)
rest += ",";
sel = arSelect[j];
selResult = (String) retAnserline.get(sel);
if (selResult == null)
selResult = "";
rest += " {";
rest += " \"Name\": \"" + sel + "\",";
rest += " \"Value\": \"" + selResult + "\"";
rest += " }";
}
rest += " ]}";
i++;


}

rest += " ]}";
} catch (Exception e) {
    e.printStackTrace();
}


out.println(rest);

%>