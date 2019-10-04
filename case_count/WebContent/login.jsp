<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String username = (String)session.getAttribute("username");
if (username == null || username.length() == 0) { // not logined yet
	response.setHeader("X-Frame-Options", "deny");
	response.setHeader("X-XSS-Protection", "1; mode=block");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="css/styles.css">
<title>Login</title>
</head>
<body>
<%
String errorMessage = (String) session.getAttribute("errorMessage");
if (errorMessage != null && errorMessage.length() > 0) {
%>
<div><%= errorMessage %></div>
<%
	session.removeAttribute("errorMessage");
}
%>
<form action="authentication.jsp" method="post">
<div class="login_header">Login to Case Count Tool</div>
<div class="login">
<div>Email: <input type="text" name="username"/></div>
<div>Password: <input type="password" name="password"/></div>
<div><input type="submit" name="login" value="login"/></div>
</div>
</form>
</body>
</html>
<%
} else {
	response.sendRedirect("./");
}
%>
