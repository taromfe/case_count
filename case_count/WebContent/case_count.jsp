<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,com.microfocus.sugahara.taro.case_count.*" %>
<%
String connectionStr = "jdbc:sqlite:C:/sqlite3/db/case_count.db";
try {
	Class.forName("org.sqlite.JDBC");
} catch (Exception e) {
	e.printStackTrace();
}

String username = request.getParameter("username");

List<SupportCase> cases = new ArrayList<SupportCase>();
try (Connection conn = DriverManager.getConnection(connectionStr)){
	try (PreparedStatement stmt0 = conn.prepareStatement("SELECT id FROM user WHERE email=?")) {
		stmt0.setString(1, username);
		ResultSet rs0 = stmt0.executeQuery();
		if (rs0.next()) {
			int user_id = rs0.getInt("id");
			try (PreparedStatement stmt1 = conn.prepareStatement("SELECT * FROM support_case WHERE user_id=?")) {
				stmt1.setInt(1, user_id);
				ResultSet rs1 = stmt1.executeQuery();
				while (rs1.next()) {
					String interactionID = rs1.getString("interaction_id");
					int year = rs1.getInt("pickup_year");
					int month = rs1.getInt("pickup_month");
					int day = rs1.getInt("pickup_day");
					cases.add(new SupportCase(interactionID, username, year, month, day, "UNKNOWN"));
				}
				rs1.close();
			}
			rs0.close();
		}
	}
}
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Case Assignment of <%= username %></title>
</head>
<body>
<div>Case Assignment of <%= username %></div>
<table>
	<tr>
		<th>DATE (yyyy/mm/dd)</th>
		<th>CASE ID</th>
	</tr>
<%
for (SupportCase supportCase: cases.toArray(new SupportCase[cases.size()])) {
%>
	<tr>
		<td><%= supportCase.getYear()%>/<%= supportCase.getMonth() %>/<%= supportCase.getDay() %></td>
		<td><%= supportCase.getInteractionID() %></td>
	</tr>
<%
}
%>
</table>
<div><a href="./">top page</a></div>
</body>
</html>