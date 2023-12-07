<%@ include file="jdbc.jsp" %>
<%@ include file = "header.jsp" %>
<%@ include file = "auth.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Currency" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<%
String firstName = request.getParameter("firstName");
String lastName = request.getParameter("lastName");
String email = request.getParameter("email");
String phonenum = request.getParameter("phonenum");
String address = request.getParameter("address");
String city = request.getParameter("city");
String state = request.getParameter("state");
String postalCode = request.getParameter("postalCode");
String country = request.getParameter("country");
String userId = request.getParameter("userid");
String password = request.getParameter("password");

//check if the username already exists 

try{
    getConnection();
    PreparedStatement pstmt = con.prepareStatement("SELECT * FROM customer WHERE userid=?;");
    pstmt.setString(1,userId);
    ResultSet rst = pstmt.executeQuery();
    if (rst.next()){
        out.println("Sorry, that username already exists");
    }
    else{
        String insertQuery = "INSERT INTO customer VALUES (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password); ";
        PreparedStatement insertStatement = con.prepareStatement(insertQuery);
        insertStatement.setString(1, firstName);
        insertStatement.setString(2, lastName);
        insertStatement.setString(3, email);
        insertStatement.setString(4, phonenum);
        insertStatement.setString(5, address);
        insertStatement.setString(6, city);
        insertStatement.setString(7, state);
        insertStatement.setString(8, postalCode);
        insertStatement.setString(9, country);
        insertStatement.setString(10, userId);
        insertStatement.setString(11, password);
        insertStatement.executeUpdate();
        response.sendRedirect("accountconfirmation.jsp");
    }
}catch (SQLException ex){
    out.println(ex);
}
%>