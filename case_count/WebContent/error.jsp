<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String errorMessage = (String)session.getAttribute("errorMessage");
session.removeAttribute("errorMessage");
String backURL = (String)session.getAttribute("backURL");
session.removeAttribute("backURL");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ERROR</title>
</head>
<body>
<div>ERROR</div>
<div><%= errorMessage %></div>
<div><a href="<%= backURL %>">back</a></div>
</body>
</html>