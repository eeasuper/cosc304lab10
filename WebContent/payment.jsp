<!DOCTYPE html>
<html>
<head>
    <%@ include file="basiccss.jsp" %>
<title>Dup and Max's Grocery</title>
</head>
<body>
    <%@ include file="header.jsp" %>
    <h1>Enter Payment Details</h1>
    <%String customerId = request.getParameter("customerId");
    out.println(customerId);
    %>

    <form action="process_payment.jsp" method="post">
        <!-- Payment Type -->
        <input type="radio" id="visa" name="paymentType" value="Visa">
        <label for="visa">Visa</label>

        <input type="radio" id="mastercard" name="paymentType" value="MasterCard">
        <label for="mastercard">MasterCard</label>

        <br><br>

        <!-- Payment Number -->
        <label for="paymentNumber">Payment Number:</label>
        <input type="text" id="paymentNumber" name="paymentNumber" pattern="\d{16}" title="Enter a 16-digit payment number" maxlength="16" required>

        <br><br>

        <!-- Payment Expiry Date -->
        <label for="expiryMonth">Expiry Month:</label>
        <input type="text" id="expiryMonth" name="expiryMonth" pattern="\d{2}" title="Enter a 2-digit month (e.g., 02)" maxlength="2" required>

        <label for="expiryYear">Expiry Year:</label>
        <input type="text" id="expiryYear" name="expiryYear" pattern="\d{4}" title="Enter a 4-digit year (e.g., 2023)" maxlength="4" required>

        <!-- //allowing customer Id to be sent to payment process page  -->
        <input type="hidden" name="customerId" value="<%= customerId %>">

        <br><br>

        <!-- Other fields or buttons here -->

        <input type="submit" value="Submit Payment">
    </form>
</body>
</html>
