<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Currency" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="basiccss.jsp" %>
<% String userId = (String)session.getAttribute("authenticatedUser"); %>
<% String customerId = request.getParameter("customerId"); %>
<title>Dup Grocery Order List</title>
</head>
<body align ="center">
	<%@ include file="header.jsp" %>
    <h1>Order List for <%= userId %></h1>
<div align="center">



<%


try{		
    getConnection();
    String sql = "SELECT O.orderId, O.orderDate, C.customerId, C.firstName, C.lastName, O.totalAmount " +
    "FROM ordersummary O LEFT OUTER JOIN customer C ON O.customerId = C.customerId " +
    "WHERE C.customerId = ?";
    String sql2 ="SELECT P.productId, P.quantity, P.price FROM orderproduct P WHERE P.orderId = ?;";

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    currFormat.setMaximumFractionDigits(2);
    Currency currency = Currency.getInstance("CAD");
    currFormat.setCurrency(currency);
    
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, customerId);
    ResultSet rs = pstmt.executeQuery();

    out.println("<table>");
    out.println("<tr>");
        out.println("<th>Order Id</th>");
        out.println("<th>Order Date</th>");
        out.println("<th>Customer Id</th>");
        out.println("<th>Customer Name</th>");
        out.println("<th>Total Amount</th>");
    out.println("</tr>");
    while(rs.next()){
        out.println("<tr>");
        out.println("<th>"+rs.getString(1)+"</th>");
        out.println("<th>"+rs.getString(2)+"</th>");
        out.println("<th>"+rs.getString(3)+"</th>");
        out.println("<th>"+rs.getString(4)+" "+rs.getString(5)+"</th>");
        out.println("<th>"+currFormat.format(rs.getDouble(6))+"</th>");
        out.println("</tr>");

        out.println("<tr>");
        out.println("<th></th>");
        out.println("<th></th>");
        out.println("<th>");
            String orderId = rs.getString(1);
            PreparedStatement pstmt2 = con.prepareStatement(sql2);
            pstmt2.setString(1, orderId);
            ResultSet rs2 = pstmt2.executeQuery();
            out.println("<table>");
            out.println("<th>Product Id</th>");
            out.println("<th>Quantity</th>");
            out.println("<th>Price</th>");
            while(rs2.next()){
                out.println("<tr>");
                out.println("<th>"+rs2.getString(1)+"</th>"); //productId
                out.println("<th>"+rs2.getString(2)+"</th>"); //quantity
                out.println("<th>"+currFormat.format(rs2.getDouble(3))+"</th>"); //price
                out.println("</tr>");
            }
            rs2.close();
            out.println("</table>");
        out.println("</th>");

        out.println("</tr>");
    }
    rs.close();
    out.println("</table>");
    try
    {
        if (con != null)
            con.close();
    }
    catch (SQLException e)
    {
        System.out.println(e);
    }

}catch(Exception e){
	out.println("error: "+e);
}

%>