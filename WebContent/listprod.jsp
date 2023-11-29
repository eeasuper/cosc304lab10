<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Currency" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#PW";

//String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
//String uid = "sa"; //"testuser";
//String pw = "304#sa#pw"; //"304testpw";

try(Connection con = DriverManager.getConnection(url, uid, pw); Statement
stmt = con.createStatement();	)
{
	name = name==null?"%%":"%"+name+"%";
	String sql = "SELECT productName, productPrice,productId FROM product WHERE productName LIKE ?;";

	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	currFormat.setMaximumFractionDigits(2);
	Currency currency = Currency.getInstance("CAD");
	currFormat.setCurrency(currency);

	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1,name);
	ResultSet rs = pstmt.executeQuery();


	out.println("<table>");
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
}


// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

// Make the connection

// Print out the ResultSet

// For each product create a link of the form
// addcart.jsp?id=productId&name=productName&price=productPrice
// Close connection

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
%>

</body>
</html>