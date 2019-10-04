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
response.setHeader("X-Frame-Options", "deny");
response.setHeader("X-XSS-Protection", "1; mode=block");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<link rel="stylesheet" href="css/styles.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script>
var cases = [];
var i = 0;
<%
for (SupportCase supportCase: cases.toArray(new SupportCase[cases.size()])) {
%>
cases[i++] = {year: <%= supportCase.getYear() %>, month: <%= supportCase.getMonth() %>, day: <%= supportCase.getDay() %>, interactionID: '<%= supportCase.getInteractionID() %>'};
<%
}
%>
var year_month = {};
for (i = 0; i < cases.length; i++) {
	c = cases[i];
	tmpStr = (c['year'] + '-' + c['month']);
	year_month[tmpStr] = {year: c['year'], month: c['month']};
}
</script>
<title>Case Assignment of <%= username %></title>
</head>
<body>
<div class="case_count_header">Case Assignment of <%= username %></div>
<div class="year_month_selector"><select id="year_month_options"><option value="all" selected>all</option></select></div>
<div id="case_table"></div>
<div><a href="./">top page</a></div>
<div id="message"></div>
<script type="text/javascript">
$(document).ready(function(){
	// set year-month option for filtering cases
	year_month_list = Object.keys(year_month);
	for (i = 0; i < year_month_list.length; i++) {
		option_str = "<option value='" + year_month_list[i] + "'>" + year_month_list[i] + "</option>";
		$("#year_month_options").append(option_str);
	}

	// creata case count table
	var table_element = "<table>";
	table_element += "<tr><th>DATE (yyyy/mm/dd)</th><th>CASE ID</th></tr>";
	for (i = 0; i < cases.length; i++) {
		c = cases[i];
		table_element += ("<tr><td>" + c['year'] + "/" + c['month'] + "/" + c['day'] + "</td><td>" + c['interactionID'] + "</td></tr>");
	};
	table_element += "</table>";
	$("#case_table").append(table_element);
	
	// year_month_options select change
	$('#year_month_options').change(function() {
		console.log('#year_month_options on change');
		year_month_value = $('#year_month_options').val();
		console.log("year_month_value=" + year_month_value)
		$("#message").text(year_month_value);
	});
});
</script>
</body>
</html>