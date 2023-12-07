<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>
<%
    // Retrieve the product name from the request parameter
    String productName = request.getParameter("productName");

    try {
        getConnection();
        // Your SQL DELETE query to remove the product using productName
        // Example:
        String deleteQuery = "DELETE FROM product WHERE productName = ?";
        PreparedStatement pstmt = con.prepareStatement(deleteQuery);
        pstmt.setString(1, productName);
        pstmt.executeUpdate();

        // Display a success message
%>
        <div style="text-align: center;">
            <h3>Product Removed Successfully</h3>
            <p>The product <%= productName %> has been removed.</p>
        </div>
<%
    } catch (SQLException ex) {
        out.println(ex);
    }
%>
