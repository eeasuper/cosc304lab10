<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Currency" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
	<style>
		body{
			font-family: "Avenir Next", "Avenir", sans-serif;
		}
		h1 {
			color: blue
		}
	</style>
<head>
<title>YOUR NAME Grocery Order Processing</title>
</head>
<body>

<% 
// Get customer id
String custId = request.getParameter("customerId");
// Get password
String password = request.getParameter("password");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered
// Determine if there are products in the shopping cart
// If either are not true, display an error message

// Make connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa"; //"testuser";
String pw = "304#sa#PW"; //"304testpw";
NumberFormat currFormat = NumberFormat.getCurrencyInstance();
currFormat.setMaximumFractionDigits(2);
Currency currency = Currency.getInstance("CAD");
currFormat.setCurrency(currency);

try(
Connection con = DriverManager.getConnection(url,uid,pw);
)
{	
	
	String sql = "SELECT customerId,firstName, lastName,password FROM customer WHERE customerId = ?;";
	PreparedStatement pstmt = con.prepareStatement(sql);

	//Validation of customerId, if shopping cart is empty, and if password is correct:
	boolean hasNondigit = custId.matches(".*\\D+.*");
	if(hasNondigit){
		out.println("Error: Invalid Customer Id. Your id contains non-digit characters.");
	}else{
	int cId = Integer.parseInt(custId);
	pstmt.setInt(1, cId);
	ResultSet rst = pstmt.executeQuery();
	rst.next();
	boolean passwordMatches = false;
	if(rst !=null){
		passwordMatches = rst.getString("password").equals(password);
	}
	if (rst==null){
		out.println("Error: Invalid Customer Id. Possibly does not exist.");
	}
	else if(!passwordMatches){
		out.println("Error: wrong password!");
	}
	else if (productList == null || productList.isEmpty()){
		out.println("Error: No items in cart");
	}
	else{
		//out.println(rst.getInt("customerId"));
		//adding to orderSummary
		PreparedStatement pstmt1 = con.prepareStatement("SELECT * FROM customer WHERE customerId=?;");
		pstmt1.setInt(1,cId);
		ResultSet rst1 = pstmt1.executeQuery();
		rst1.next();
		String address = rst1.getString("address");
		String city = rst1.getString("city");
		String state = rst1.getString("state");
		String postalCode = rst1.getString("postalCode");
		String country = rst1.getString("country");

		//PreparedStatement pstmt2 = con.prepareStatement("INSERT INTO orderSummary  VALUES (?,?,?,?,?,?,?,?);", Statement.RETURN_GENERATED_KEYS);
		PreparedStatement pstmt2 = con.prepareStatement("INSERT INTO orderSummary (orderDate, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry, customerId) VALUES (?,?,?,?,?,?,?,?);", Statement.RETURN_GENERATED_KEYS);

		pstmt2.setDate(1, new Date(new Timestamp(System.currentTimeMillis()).getTime()));
		pstmt2.setDouble(2,0);  ///This amount will be updated later.
		pstmt2.setString(3,address);
		pstmt2.setString(4,city);
		pstmt2.setString(5,state);
		pstmt2.setString(6,postalCode);
		pstmt2.setString(7,country);
		pstmt2.setInt(8,cId);
		pstmt2.executeUpdate();

		
		// Insert each item into OrderProduct table using OrderId from previous INSERT
		ResultSet generatedKeys = pstmt2.getGeneratedKeys();

		if (generatedKeys.next()) {

			int orderId = generatedKeys.getInt(1);
			double totalAmount = 0;
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
				while (iterator.hasNext())
				{ 	
					Map.Entry<String, ArrayList<Object>> entry = iterator.next();
					ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
					
					String productId = (String) product.get(0);
					String price = (String) product.get(2);
					double pr = Double.parseDouble(price);
					int qty = ( (Integer)product.get(3)).intValue();
					totalAmount+=pr*qty;
			
					PreparedStatement pstmt3 = con.prepareStatement("INSERT INTO orderproduct VALUES (?,?,?,?);");
					pstmt3.setInt(1,orderId);
					pstmt3.setInt(2, Integer.parseInt(productId));
					pstmt3.setInt(3,qty);
					pstmt3.setDouble(4,pr);
					pstmt3.executeUpdate();
				}
				
				//then, update orderSummary with the totalAmount variable. 

				PreparedStatement pstmt4 = con.prepareStatement("UPDATE orderSummary SET totalAmount=? WHERE orderId=?;");
				pstmt4.setDouble(1,totalAmount);
				pstmt4.setInt(2,orderId);
				pstmt4.executeUpdate();
		
				// Print out order summary
		
				out.println("<h1>ORDER SUMMARY</h1>");
				out.println("<table>");
				out.println("<tr>");
				out.println("<th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th>");
				out.println("</tr>");
				Iterator<Map.Entry<String, ArrayList<Object>>> iterator1 = productList.entrySet().iterator();
					while (iterator1.hasNext())
					{ 	
						
						Map.Entry<String, ArrayList<Object>> entry = iterator1.next();
						ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
						String productId = (String) product.get(0);
						String productName = (String) product.get(1);
						String price = (String) product.get(2);
						double pr = Double.parseDouble(price);
						int qty = ( (Integer)product.get(3)).intValue();
						double subtotal = pr*qty;
						out.println("<tr>");
						out.println("<th>"+productId+"</th>"+"<th>"+productName+"</th>"+"<th>"+qty+"</th>"+"<th>"+pr+"</th>"+"<th>"+currFormat.format(subtotal)+"</th>");
						out.println("</tr>");
					}
				out.println("</table>");
				out.println("<table><tr><th>Order Total:</th><th>"+currFormat.format(totalAmount)+"</th></tr></table>");
				out.println("<h1>Order completed. Will be shipped soon...</h1>");
				out.println("<h1>Your order reference number is: "+orderId+"</h1>");
				// Clear cart if order placed successfully
				productList.clear();		

			}else{
			System.out.println("Failed to retrieve generated keys");
			}
	
	out.println("<h1>Shipping to customer: "+cId+" Name: "+rst.getString("firstName")+" "+rst.getString("lastName")+"</h1>");
	}
	}
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
catch (SQLException ex){
	out.println("SQLException: "+ex);
}
%>
</BODY>
</HTML>

