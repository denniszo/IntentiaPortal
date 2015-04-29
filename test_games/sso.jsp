<%@page import="sun.misc.BASE64Encoder"%>


<%@page contentType="text/html;charset=UTF-8" language="java" %><!DOCTYPE html>


<%


	BASE64Encoder encoder = new BASE64Encoder();
	String str = "jonathan:atlas"; // username and password
	String encodedStr = encoder.encodeBuffer(str.getBytes());
	out.println(encodedStr);
	
	response.setHeader("Authorization","Basic "+encodedStr );
//	response.
	String url = "soapCUCD.jsp"; // protected url
	//RequestDispatcher view = request.getRequestDispatcher(url);
	//view.forward(request, response);

	response.sendRedirect(url);
	//out.println(response.getHeader("Authorization"));
%>
