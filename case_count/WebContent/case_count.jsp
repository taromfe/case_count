<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
String connectionStr = "jdbc:sqlite:C:/sqlite/db/case_count.db";
String username = request.getParameter("username");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Your Case Assignment</title>
</head>
<body>
<%
try (Connection conn = DriverManager.getConnection(connectionStr)){
	String query = "SELECT * from case_count where username = ?";
	PreparedStatement selectStmt = conn.prepareStatement(query);
	selectStmt.setString(1, username);
	ResultSet results = selectStmt.executeQuery();
%>
<table>
	<tr>
		<th>DATE</th>
		<th>CASE ID</th>
	</tr>
<%
	while (results.next()) {
		Date pickUpDate = results.getDate("date");
		String caseID = results.getString("caseID");
%>
	<tr>
		<td><%= pickUpDate %></td>
		<td><%= caseID %></td>
	</tr>
<%
	}
%>
</table>
<div><a href="./">Go To Top Page</a></div>
<%
} catch (Exception e) {
	response.setStatus(500);
%>
Internal Server Error.
<%
}
%>
</body>
</html>