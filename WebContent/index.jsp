<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ include file="header.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*,java.net.URLEncoder" %>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="basiccss.jsp" %>
	<title>Dup and Max's Grocery Main Page</title>
</head>
<body>
<h1 align="center">Welcome to Dup and Max's Grocery</h1>
<%
//String authenticUser = session.getParameter(authenticatedUser);
%>
<!-- <h1 align="center">authenticUser</h1> -->

<h2 align="center"><a href="login.jsp">Login</a></h2>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<h2 align="center"><a href="createaccount.jsp">Create Account</a></h2>

<h2 align="center"><a href="logout.jsp">Log out</a></h2>
<%
	String userName = (String) session.getAttribute("authenticatedUser");
	HashMap<Integer, ArrayList<Object>> productList = (HashMap<Integer, ArrayList<Object>>) session.getAttribute("productList");
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
<!-- 
<%
//determine if there are any products that have sales 

try{
	getConnection();
	String productQuery = "SELECT TOP 5 productId FROM productsales ORDER BY totalSales DESC;";
	PreparedStatement productQueryStmt = con.prepareStatement(productQuery);
	ResultSet productRst = productQueryStmt.executeQuery();

	ArrayList<Integer> popularProducts = new ArrayList<Integer>();

	//if there are products with sales, add them to the popularProducts ArrayList
	while (productRst.next()){
		int productid = productRst.getInt("productId");
		popularProducts.add(productid);
	}
	productRst.close();
	productQueryStmt.close();

	//if there were any items added to popularProducts, then query product table for them and include link 
	if (popularProducts!=null && !popularProducts.isEmpty()){
		out.println("<div style=\"text-align: center;\">");
		out.println("Check out our hottest products!");
		PreparedStatement productQueryStmt2 = null;
		ResultSet productRst2 = null;
		int ranking = 1;
		for (Integer productid:popularProducts){
			try {
				String productQuery2 = "SELECT * FROM product WHERE productId = ?;";
				productQueryStmt2 = con.prepareStatement(productQuery2);
				productQueryStmt2.setInt(1,productid);
				productRst2 = productQueryStmt2.executeQuery();
				if (productRst2.next()){
					String productname = productRst2.getString("productName");
					String link = "product.jsp?pId=" + productid + "&name=" + URLEncoder.encode(productname, "UTF-8");
					// Create a hyperlink wrapping the product name
					out.println("<a href=\"" + link + "\">" + ranking + ". " + productname + "</a>");

					// Create a hyperlink wrapping the image
					out.println("<a href=\"" + link + "\">");
					String imageUrl = productRst2.getString("productImageURL");
					out.println("<img src=\"" + imageUrl + "\" width=\"100\" height=\"100\" />");
					out.println("</a>");

					ranking++;
				}
		} catch (SQLException ex) {
			out.println("SQLException " + ex);
		} finally {
			if (productRst2 != null) {
				try {
					productRst2.close();
				} catch (SQLException e) {
					out.println("Error closing productRst2: " + e);
				}
			}
			if (productQueryStmt2 != null) {
				try {
					productQueryStmt2.close();
				} catch (SQLException e) {
					out.println("Error closing productQueryStmt2: " + e);
				}
			}
		}
		}
	}
}catch (SQLException ex){
	out.println("SQLException "+ex);
}
%> -->
<%
try{
	getConnection();
	String productQuery = "SELECT TOP 5 productId FROM productsales ORDER BY totalSales DESC;";
	PreparedStatement productQueryStmt = con.prepareStatement(productQuery);
	ResultSet productRst = productQueryStmt.executeQuery();

	ArrayList<Integer> popularProducts = new ArrayList<Integer>();

	//if there are products with sales, add them to the popularProducts ArrayList
	while (productRst.next()){
		int productid = productRst.getInt("productId");
		popularProducts.add(productid);
	}
	productRst.close();
	productQueryStmt.close();
	
	if (popularProducts!=null && !popularProducts.isEmpty()){
		out.println("<div style='text-align: center;'>");
		out.println("Check out our hottest products!");
		PreparedStatement productQueryStmt2 = null;
		ResultSet productRst2 = null;
		int ranking = 1;
		
		for (Integer productid:popularProducts){
			try {
				String productQuery2 = "SELECT * FROM product WHERE productId = ?;";
				productQueryStmt2 = con.prepareStatement(productQuery2);
				productQueryStmt2.setInt(1,productid);
				productRst2 = productQueryStmt2.executeQuery();
				if (productRst2.next()){
					String productname = productRst2.getString("productName");
					String link = "product.jsp?pId=" + productid + "&name=" + URLEncoder.encode(productname, "UTF-8");
					// Create a hyperlink wrapping the product name
					out.println("<a href=" + link +">" + ranking + ". " + productname + "</a>");

					// Create a hyperlink wrapping the image
					out.println("<a href=" + link + ">");
					String imageUrl = productRst2.getString("productImageURL");
					session.setAttribute("productMessage", imageUrl);
					out.println("<img src=" + imageUrl + " width=100 height=100 />");
					//out.println("<img src='' + imageUrl + '/' width='100' height='100' />");
					out.println("</a>");

					ranking++;
				}
		} catch (SQLException ex) {
			out.println("SQLException " + ex);
		} finally {
			if (productRst2 != null) {
				try {
					productRst2.close();
				} catch (SQLException e) {
					out.println("Error closing productRst2: " + e);
				}
			}
			if (productQueryStmt2 != null) {
				try {
					productQueryStmt2.close();
				} catch (SQLException e) {
					out.println("Error closing productQueryStmt2: " + e);
				}
			}
		}
		}
	}
}catch (SQLException ex){
	out.println("SQLException "+ex);
}
%>

</body>
</html>