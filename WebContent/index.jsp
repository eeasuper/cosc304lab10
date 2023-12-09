<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ include file="header.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Currency" %>

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
}finally{
	closeConnection();
}
%>

<div align="center">
	<h3>Search for the products you want to buy:</h3>
	<form method="get" action="index.jsp">
	<input type="text" name="productName" size="50">
	<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
	</form>
</div>
<%
String name = request.getParameter("productName");
		
try
{	
	getConnection();
	name = name==null?"%%":"%"+name+"%";
	String sql = "SELECT productName, productPrice,productId FROM product WHERE productName LIKE ?;";

	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	currFormat.setMaximumFractionDigits(2);
	Currency currency = Currency.getInstance("CAD");
	currFormat.setCurrency(currency);

	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1,name);
	ResultSet rs = pstmt.executeQuery();


	out.println("<table align='center'>");
	out.println("<tr>");
		out.println("<th>");
		out.println("</th>");
		out.println("<th>");
			out.println("Product Name");
		out.println("</th>");
		out.println("<th>");
			out.println("Price");
		out.println("</th>");
	out.println("</tr>");
	while(rs.next()){
		String productName = rs.getString("productName");
		int pId = rs.getInt("productId");
		double price = rs.getDouble("productPrice");
		out.println("<tr>");
			out.println("<th>");
				try {
					// Create a link to addcart.jsp with product details
					String link = "addcart.jsp?id=" + pId + "&name="
							+ URLEncoder.encode(productName, "UTF-8") + "&price=" + price;
					out.println("<a href=\"" + link + "\">Add to Cart</a>");
				} catch (Exception ex) {
					out.println("Error creating link: " + ex.getMessage());
				}
			out.println("</th>");
			out.println("<th>");
				String link2 = "product.jsp?pId=" + pId + "&name="
							+ URLEncoder.encode(productName, "UTF-8");
				out.println("<a href=\"" + link2 + "\">"+productName+"</a>");
			out.println("</th>");
			out.println("<th>");
			out.println(currFormat.format(rs.getDouble(2))); //productPrice
			out.println("</th>");
		out.println("</tr>");
	}
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
}catch (SQLException ex){
		out.println("SQLException "+ex);
	}finally{
		closeConnection();
	}

%>
</body>
</html>