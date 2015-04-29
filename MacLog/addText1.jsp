<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>

<%@ page contentType="application/json" pageEncoding="UTF-8"%>

<%
String rest = "";
System.out.println("------------------------------------------------");

String text1 = (String) request.getParameter("text1");
if(text1==null) text1="";

String uuid = (String) request.getParameter("uuid");
if(uuid==null) uuid="";

String timeStemp = (String) request.getParameter("timeStemp");
if(timeStemp==null) timeStemp="0";
Long log_time = Long.parseLong(timeStemp);


System.out.println("text= "+text1+" uuid= "+uuid);

il.co.intentia.UpdateText updateText = new il.co.intentia.UpdateText(text1,uuid, log_time);
		System.out.println("UpdateText");
		updateText.setTextValOnError();
System.out.println("Done");
System.out.println("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
out.println("OK");

%>