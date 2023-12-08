<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Currency" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="basiccss.jsp" %>
<title>Dup Grocery Order List</title>
</head>
<body>
    <%@ include file="header.jsp" %>
<h1>Customer List</h1>

<table>
    <tr>
        <th>Customer ID</th>
        <th>First Name</th>
        <th>Last Name</th>
        <th>Email</th>
        <th>Phone Number</th>
        <th>Address</th>
        <th>City</th>
        <th>State</th>
        <th>Postal Code</th>
        <th>Country</th>
        <th>User ID</th>
    </tr>

    <%  // Java code to fetch customer data and display in the table
        try {

            getConnection();
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM customer");

            // Loop through the result set and populate the table rows
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("customerId") + "</td>");
                out.println("<td>" + rs.getString("firstName") + "</td>");
                out.println("<td>" + rs.getString("lastName") + "</td>");
                out.println("<td>" + rs.getString("email") + "</td>");
                out.println("<td>" + rs.getString("phonenum") + "</td>");
                out.println("<td>" + rs.getString("address") + "</td>");
                out.println("<td>" + rs.getString("city") + "</td>");
                out.println("<td>" + rs.getString("state") + "</td>");
                out.println("<td>" + rs.getString("postalCode") + "</td>");
                out.println("<td>" + rs.getString("country") + "</td>");
                out.println("<td>" + rs.getString("userid") + "</td>");
                out.println("</tr>");
            }

            // Close the database connections
            rs.close();
            stmt.close();
            con.close();
        } catch (Exception e) {
            out.println(e);
        }
    %>
</table>

</body>
</html>
