<!DOCTYPE html>
<html>
<head>
    <%@ include file="basiccss.jsp" %>
<title>Ray's Grocery CheckOut Line</title>
</head>
<body>
    <%@ include file = "header.jsp" %>
<h1>Enter your userid to complete the transaction:</h1>

<form method="get" action="confirmcheckout.jsp">
    <p>username: </p>
    <input type="text" name="userid" size="50">
    <p>Password:</p>
    <input type="password" name="password" size="50">
    <p></p>
    <input type="submit" value="Submit"><input type="reset" value="Reset">
    </form>
    
    </body>
    </html>

