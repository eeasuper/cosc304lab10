
<%@ include file="jdbc.jsp" %>


<//%@ include file = "header.jsp" %>
<//%@ include file = "auth.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*" %>
<%  String custId = request.getParameter("customerId") ;
    String paymentType = request.getParameter("paymentType"); 
    String paymentNumber = request.getParameter("paymentNumber");
    String expiryMonth = request.getParameter("expiryMonth"); 
    String expiryYear = request.getParameter("expiryYear"); 
    String customerIdParam = request.getParameter("customerId");
    int customerId = (custId != null && !custId.isEmpty()) ? Integer.parseInt(custId) : 0;
    boolean isPaymentNumberValid = paymentNumber.matches("\\d{16}");
    int month = Integer.parseInt(expiryMonth);
    boolean isExpiryMonthValid = (month >= 1 && month <= 12);
    int currentYear = Calendar.getInstance().get(Calendar.YEAR);
    boolean isExpiryYearValid = Integer.parseInt(expiryYear) >= currentYear;

    String errorMessage = "";
    if (!isPaymentNumberValid){
        errorMessage = "Invalid payment number. Must be 16 digits.";
    }
    else if (!isExpiryMonthValid){
        errorMessage = "Invalid expiry month. Must be between 01 and 12.";
    }
    else if (!isExpiryYearValid) {
        errorMessage = "Invalid expiry year. Should be current year or later.";
    }
    else {
        try{
            getConnection();
            String insertQuery = "INSERT INTO paymentmethod (paymentType, paymentNumber, paymentExpiryDate, customerId) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = con.prepareStatement(insertQuery);

            //setting values 
            pstmt.setString(1,paymentType);
            pstmt.setString(2,paymentNumber);
            String expiryDate = expiryYear + "-" + expiryMonth + "-01"; // Format the expiry date as needed
            pstmt.setDate(3, java.sql.Date.valueOf(expiryDate));
            pstmt.setInt(4, customerId);
            
            // Execute the INSERT statement
            int rowsAffected = pstmt.executeUpdate();

            // Check if the insertion was successful
            if (rowsAffected > 0) {
                session.setAttribute("confirmation", "success");
                response.sendRedirect("order.jsp?customerId=" + customerId);
                return;
            } else {
                // Insertion failed, display error or redirect back to the form
                response.sendRedirect("payment.jsp?error=insertionFailed");
                return;
            }
        }catch (SQLException ex){
            ex.printStackTrace(); 
        }
    }
%>

<% if (!errorMessage.isEmpty()) { %>
    <p>Error: <%= errorMessage %></p>
    <button onclick="goBack()">Go Back</button>
    <script>
        function goBack() {
            window.history.back();
        }
    </script>
<% } %>