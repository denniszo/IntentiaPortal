<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>

<%@ page contentType="application/json" pageEncoding="UTF-8"%>

<%
String cono = (String) request.getParameter("cono");
if(cono==null) cono="";

String prno = (String) request.getParameter("prno");
if(prno==null) prno="";

String strt = (String) request.getParameter("strt");
if(strt==null) strt="";

String opno = (String) request.getParameter("opno");
if(opno==null) opno="";

String plgr = (String) request.getParameter("plgr");
if(plgr==null) plgr="";

if(cono=="" || prno=="" || strt=="" || opno=="" || plgr=="" ){
    out.println("0");
    return;
}

out.println('1');

%>