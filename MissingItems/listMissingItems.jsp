<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>

<%@ page contentType="application/json" pageEncoding="UTF-8"%>

<%
String[] arSelect = { "itno", "itds","DeliveredQty","MissingQty","AvailableQty","NET","buar","date","leadTime"};
String rest = "";

String cono = (String) request.getParameter("cono");
if(cono==null) cono="200";

String buar = (String) request.getParameter("buar");
if(buar==null || buar.equals("") || buar.equals("0")){
    buar="";
}

String itno = (String) request.getParameter("itno");
if(itno==null || itno.equals("")){
    itno="";
}

String itds = (String) request.getParameter("itds");
if(itds==null || itds.equals("")){
    itds="";
}

try {
il.co.intentia.listItems items = new il.co.intentia.listItems("200");

items.setITDS(itds);
items.setITNO(itno);
items.setBUAR(buar);

Stack retStac = items.getList();

rest = "{";
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

if (selResult == null){
    selResult = "";
}else{
   selResult= selResult.trim().replace("\"","\\\"");
   selResult= selResult.replace("\\","/");
}


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