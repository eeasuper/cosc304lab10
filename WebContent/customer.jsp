<!DOCTYPE html>
<html>
<head>
<%@ include file="basiccss.jsp" %>

<title>Customer Page</title>
</head>
<body>
<%@ include file="header.jsp" %>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%
try(Connection con = DriverManager.getConnection(url,uid,pw);)
{
String sql = "SELECT * FROM customer WHERE userid=?";

PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setString(1,userName);
ResultSet rst = pstmt.executeQuery();


while (rst.next()) {
    out.println("<div>");
    out.println("<h2>Customer Details</h2>");
    out.println("<p><strong>ID:</strong> " + rst.getInt("customerId") + "</p>");
    out.println("<p><strong>First Name:</strong> " + rst.getString("firstName") + "</p>");
    out.println("<p><strong>Last Name:</strong> " + rst.getString("lastName") + "</p>");
    out.println("<p><strong>Email:</strong> " + rst.getString("email") + "</p>");
    out.println("<p><strong>Phone:</strong> " + rst.getString("phonenum") + "</p>");
    out.println("<p><strong>Address:</strong> " + rst.getString("address") + "</p>");
    out.println("<p><strong>City:</strong> " + rst.getString("city") + "</p>");
    out.println("<p><strong>State:</strong> " + rst.getString("state") + "</p>");
    out.println("<p><strong>Postal Code:</strong> " + rst.getString("postalCode") + "</p>");
    out.println("<p><strong>Country:</strong> " + rst.getString("country") + "</p>");
    out.println("<p><strong>User ID:</strong> " + rst.getString("userid") + "</p>");
    out.println("</div>");
}

}catch (SQLException ex){
	out.println("SQLException "+ex);
}
finally {
    // Close the connection in the finally block to ensure it's always executed
    try {
        if (con != null && !con.isClosed()) {
            con.close();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
// TODO: Print Customer information
String sql = "";

// Make sure to close connection
%>
<a href="addreviewform.jsp">Make a Review!</a>
<hr>
<h2>MESSAGE:</h2>
<%
if (session.getAttribute("reviewMessage") != null){
	out.println("<p>"+session.getAttribute("reviewMessage").toString()+"</p>");
    session.setAttribute("reviewMessage", null);
}
%>
</body>
</html>

