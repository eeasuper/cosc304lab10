<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>

<!DOCTYPE html>
<html>
<head>
        <title>Dup and Max's Grocery Main Page</title>
</head>
<body>
<h1 align="center">Welcome to Dup and Max's Grocery</h1>
<%
String authenticUser = session.getParameter(authenticatedUser);
%>
<h1 align="center">authenticUser</h1>

<h2 align="center"><a href="login.jsp">Login</a></h2>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<h2 align="center"><a href="createaccount.jsp">Create Account</a></h2>

<h2 align="center"><a href="logout.jsp">Log out</a></h2>
<%
	String userName = (String) session.getAttribute("authenticatedUser");
	HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
	if (userName != null) {
		out.println("<h3 align=\"center\">Signed in as: "+userName+"</h3>");
		if (productList != null && !productList.isEmpty()) {
			%>
			<h2 align="center"><a href="showcart.jsp">View Shopping Cart</a></h2>
			<%
		}
	}
%>

<h4 align="center"><a href="ship.jsp?orderId=1">Test Ship orderId=1</a></h4>

<h4 align="center"><a href="ship.jsp?orderId=3">Test Ship orderId=3</a></h4>

</body>
</head>


