<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
String username = (String)session.getAttribute("username");
if (username == null || username.equals("")) { // not logged in
	response.sendRedirect(request.getContextPath() + "/login.jsp");
} else {
	response.setHeader("X-Frame-Options", "deny");
	response.setHeader("X-XSS-Protection", "1; mode=block");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<link rel="stylesheet" href="css/styles.css">
  <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" />
  <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
  <script type="text/javascript">
  $(function() {
	 $("#datepicker").datepicker(); 
  });
  </script>
<title>Case Count</title>
</head>
<body>
<div class="user_info">Login as <%= username %> | <a href="logout.jsp">Logout</a></div>
<div class="add_case_header">Add Picked Up Case</div>
<div class="add_case">
<form action="add_case_count.jsp" method="post">
<div>DATE: <input type="text" name="date" id="datepicker" placeholder="click here to input date" size="24"/></div>
<div>CASE ID: <input type="text" name="case_id"></div>
<div><input type="submit" name="add_case" value="Add Case"/></div>
<input type="hidden" name="csrf_token" value="<%= session.getAttribute("csrf_token")%>"/>
<input type="hidden" name="username" value="<%= username %>"/>
</form>
</div>
<div class="show_your_case"><form action="case_count.jsp" method="post"><input type="hidden" name="username" value="<%= username %>"/><input type="submit" name="case_count" value="show your case"/></form></div>
</body>
</html>
<%
}
%>