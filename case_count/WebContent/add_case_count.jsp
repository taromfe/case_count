<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
String connectionStr = "jdbc:sqlite:C:/sqlite3/db/case_count.db";
try {
	Class.forName("org.sqlite.JDBC");
} catch (Exception e) {
	e.printStackTrace();
}

String username = request.getParameter("username");
String date = request.getParameter("date");
String caseId = request.getParameter("case_id");
String[] dateItems = date.split("/");
if (dateItems.length != 3) {
	session.setAttribute("errorMessage", "Invalid date string: " + date);
	session.setAttribute("backURL", "./");
	response.sendRedirect("error.jsp");
} else {
	int year = 0;
	int month = 0;
	int day = 0;
	try {
		year = Integer.parseInt(dateItems[2]);
		month = Integer.parseInt(dateItems[0]);
		day = Integer.parseInt(dateItems[1]);
	} catch (Exception e) {
		session.setAttribute("errorMessage", "Invalid date string: " + date);
		session.setAttribute("backURL", "./");
		response.sendRedirect("error.jsp");
	}
	try (Connection conn = DriverManager.getConnection(connectionStr)) {
		try (PreparedStatement stmt0 = conn.prepareStatement("SELECT id FROM user WHERE email=?")) {
			stmt0.setString(1, username);
			ResultSet rs0 = stmt0.executeQuery();
			if (rs0.next()) {
				int userId = rs0.getInt("id");
				try (PreparedStatement stmt1 = conn.prepareStatement("INSERT INTO support_case(interaction_id, user_id, pickup_year, pickup_month, pickup_day) VALUES(?, ?, ?, ?, ?)")) {
					stmt1.setString(1, caseId);
					stmt1.setInt(2, userId);
					stmt1.setInt(3, year);
					stmt1.setInt(4, month);
					stmt1.setInt(5, day);
					stmt1.execute();
				}
				rs0.close();
				response.sendRedirect("./");
			} else {
				// Invalid username.
				session.setAttribute("errorMessage", "Invalid username: " + username);
				session.setAttribute("backURL", "./");
				response.sendRedirect("error.jsp");
			}
		}
	}
}
%>