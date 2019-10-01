<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*" %>
<%
String connectionStr = "jdbc:sqlite:C:/sqlite3/db/case_count.db";
try {
	Class.forName("org.sqlite.JDBC");
} catch (Exception e) {
	e.printStackTrace();
}

String username = request.getParameter("username");
String password = request.getParameter("password");

if (username == null || username.length() == 0) {
	session.setAttribute("errorMessage", "Invalid credentials.");
	response.sendRedirect("login.jsp");
} else {
	try (Connection conn = DriverManager.getConnection(connectionStr)) {
		try (PreparedStatement stmt = conn.prepareStatement("SELECT id, password FROM user WHERE email=?")) {
			stmt.setString(1, username);
			ResultSet rs = stmt.executeQuery();
			if (!rs.next()) { // No user with the email address.
				session.setAttribute("errorMessage", "Invalid credentials");
				response.sendRedirect("login.jsp");
			} else {
				String actualPassword = rs.getString("password");
				if (actualPassword != null && actualPassword.equals(password)) { // Login succeeded.
					int user_id = rs.getInt("id");
					session.setAttribute("username", username);
					session.setAttribute("user_id", new Integer(user_id));
					session.setAttribute("csrf_token", Long.toString(Calendar.getInstance().getTimeInMillis()));
					response.sendRedirect("./");
				} else { // Login failed with wrong password.
					session.setAttribute("errorMessage", "Invalid credentials");
					response.sendRedirect("login.jsp");
				}
			}
		}
	}
}
%>