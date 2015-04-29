<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>

<%@ page contentType="application/json" pageEncoding="UTF-8"%>

<%
String[] arSelect = { "agreement", "log_time", "uuid", "state", "log_file", "Text1"};
String rest = "";

String hh = (String) request.getParameter("hh");
if(hh==null) hh="2";
int int_hh = Integer.parseInt(hh);

il.co.intentia.GetList getList = null;

String mes=(String) request.getParameter("mes");
if(mes==null || mes.trim().equals("") || mes.equals("0")){
   getList = new il.co.intentia.GetList(int_hh);
}else{
   getList = new il.co.intentia.GetList(int_hh,mes);
}


System.out.println(getList);
System.out.println(getList.getMiliseconds());
try {
Stack retStac = getList.getErrorList();

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