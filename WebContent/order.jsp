<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Currency" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="checkcart.jsp" %>

<!DOCTYPE html>
<html>
	<%@ include file="basiccss.jsp" %>
<head>
<title>YOUR NAME Grocery Order Processing</title>
</head>
<body>
	<%@ include file = "header.jsp" %>
<% 

//get customerId
int custId = Integer.parseInt(request.getParameter("customerId"));
// Get password
String password = request.getParameter("password");

//@SuppressWarnings({"unchecked"})
//HashMap<Integer, ArrayList<Object>> productList = (HashMap<Integer, ArrayList<Object>>) session.getAttribute("productList");

NumberFormat currFormat = NumberFormat.getCurrencyInstance();
currFormat.setMaximumFractionDigits(2);
Currency currency = Currency.getInstance("CAD");
currFormat.setCurrency(currency);

try
{	
	getConnection();
	String sql = "SELECT * FROM customer WHERE customerId=?;";
    PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setInt(1,custId);
    ResultSet rst = pstmt.executeQuery();
	String confirmation = (String) session.getAttribute("confirmation");

	if (confirmation==null || !confirmation.equals("success")){
		out.println("Sorry, your payment details were not able to be stored in the database");
		out.println("Confirmation: "+confirmation);
	}
	else{
		//after receiving confirmation that payment information has been saved, and orderSummary can now be updated
		//adding to orderSummary
		rst.next();
		String address = rst.getString("address");
		String city = rst.getString("city");
		String state = rst.getString("state");
		String postalCode = rst.getString("postalCode");
		String country = rst.getString("country");

		//PreparedStatement pstmt2 = con.prepareStatement("INSERT INTO orderSummary  VALUES (?,?,?,?,?,?,?,?);", Statement.RETURN_GENERATED_KEYS);
		PreparedStatement pstmt2 = con.prepareStatement("INSERT INTO orderSummary (orderDate, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry, customerId) VALUES (?,?,?,?,?,?,?,?);", Statement.RETURN_GENERATED_KEYS);

		pstmt2.setDate(1, new Date(new Timestamp(System.currentTimeMillis()).getTime()));
		pstmt2.setDouble(2,0);  ///This amount will be updated later.
		pstmt2.setString(3,address);
		pstmt2.setString(4,city);
		pstmt2.setString(5,state);
		pstmt2.setString(6,postalCode);
		pstmt2.setString(7,country);
		pstmt2.setInt(8,custId);
		pstmt2.executeUpdate();

		// Insert each item into OrderProduct table using OrderId from previous INSERT
		ResultSet generatedKeys = pstmt2.getGeneratedKeys();

		if (generatedKeys.next()) {
			int orderId = generatedKeys.getInt(1);
			double totalAmount = 0;
			Iterator<Map.Entry<Integer, ArrayList<Object>>> iterator = productList.entrySet().iterator();
				while (iterator.hasNext())
				{ 	
					Map.Entry<Integer, ArrayList<Object>> entry = iterator.next();
					ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
					
					int productId = Integer.parseInt(product.get(0).toString());
					String price =  product.get(2).toString();
					double pr = Double.parseDouble(price);
					int qty = ( (Integer)product.get(3)).intValue();
					totalAmount+=pr*qty;
			
					PreparedStatement pstmt3 = con.prepareStatement("INSERT INTO orderproduct VALUES (?,?,?,?);");
					pstmt3.setInt(1,orderId);
					pstmt3.setInt(2, productId);
					pstmt3.setInt(3,qty);
					pstmt3.setDouble(4,pr);
					pstmt3.executeUpdate();

					//updating productSales relation with the productId and quantity 
					//Updating quantity if product already in table
					String updateQuery = "UPDATE productsales SET totalSales = totalSales + ? WHERE productId = ?";
					PreparedStatement updateStmt = con.prepareStatement(updateQuery);
					updateStmt.setInt(1,qty);
					updateStmt.setInt(2,productId);
					int rowsUpdated = updateStmt.executeUpdate();
					updateStmt.close();

					//inserting product into table if not already present
					if (rowsUpdated==0){
						String insertQuery = "INSERT INTO productsales (productId, totalSales) VALUES (?, ?)";
						PreparedStatement insertStmt = con.prepareStatement(insertQuery);
						insertStmt.setInt(1,productId);
						insertStmt.setInt(2,qty);
						insertStmt.executeUpdate();
						insertStmt.close();
					}
				}			
				//then, update orderSummary with the totalAmount variable. 

				PreparedStatement pstmt4 = con.prepareStatement("UPDATE orderSummary SET totalAmount=? WHERE orderId=?;");
				pstmt4.setDouble(1,totalAmount);
				pstmt4.setInt(2,orderId);
				pstmt4.executeUpdate();
		
				// Print out order summary
				
				out.println("<h2>Successfully added new payment information to the database!</h2>");
				out.println("<h1>ORDER SUMMARY</h1>");
				out.println("<table>");
				out.println("<tr>");
				out.println("<th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th>");
				out.println("</tr>");
				Iterator<Map.Entry<Integer, ArrayList<Object>>> iterator1 = productList.entrySet().iterator();
					while (iterator1.hasNext()){ 	
						
						Map.Entry<Integer, ArrayList<Object>> entry = iterator1.next();
						ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
						int productId = Integer.parseInt(product.get(0).toString());
						String productName = (String) product.get(1);
						String price =  product.get(2).toString();
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
				//
				if(authenticated && cartExists){
					try{
						getConnection();
						String sql1 = "DELETE FROM incart WHERE customerId = ?;";
						PreparedStatement pstmt1 = con.prepareStatement(sql1);
						pstmt1.setInt(1, customerId); //customerId is from checkcart.jsp
						//pstmt1.setInt(2, removeProductId);
						pstmt1.executeUpdate();
						
					}catch (SQLException ex) {
						out.println(ex);
					}
					finally
					{
						closeConnection();
					}
					
				}
				session.setAttribute("productList", null); //reset cart
		}else{
			System.out.println("Failed to retrieve generated keys");
		}
		out.println("<h1>Shipping to customer: " + custId + "</h1>");
		out.println("<h1>Name: " + rst.getString("firstName") + " " + rst.getString("lastName") + "</h1>");				
	try
		{
			if (con != null)
				con.close();
		}
		catch (SQLException ex)
		{
			out.println("SQLException: inner loop"+ex);
		}
	}
}catch (SQLException ex){
	out.println("SQLException: main loop"+ex);
}	
%>
</BODY>
</HTML>

<!-- 

	}


	//Validation of customerId, if shopping cart is empty, and if password is correct:
	boolean passwordMatches = false;
	if (!rst.next()){
		out.println("Error: Invalid userid. Possibly does not exist.");
	}
	else{
		passwordMatches = rst.getString("password").equals(password);
		if (!passwordMatches){
			out.println("Error: wrong password!");
		}
		else if (productList == null || productList.isEmpty()){
			out.println("Error: No items in cart");
		}
		else{
			int custId = rst.getInt("customerId");

			response.sendRedirect("payment.jsp?customerId=" + custId);
			String confirmation = (String) session.getAttribute("confirmation");
			if (confirmation != null && confirmation.equals("success")) {

				//adding to orderSummary
				String address = rst.getString("address");
				String city = rst.getString("city");
				String state = rst.getString("state");
				String postalCode = rst.getString("postalCode");
				String country = rst.getString("country");

				//PreparedStatement pstmt2 = con.prepareStatement("INSERT INTO orderSummary  VALUES (?,?,?,?,?,?,?,?);", Statement.RETURN_GENERATED_KEYS);
				PreparedStatement pstmt2 = con.prepareStatement("INSERT INTO orderSummary (orderDate, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry, customerId) VALUES (?,?,?,?,?,?,?,?);", Statement.RETURN_GENERATED_KEYS);

				pstmt2.setDate(1, new Date(new Timestamp(System.currentTimeMillis()).getTime()));
				pstmt2.setDouble(2,0);  ///This amount will be updated later.
				pstmt2.setString(3,address);
				pstmt2.setString(4,city);
				pstmt2.setString(5,state);
				pstmt2.setString(6,postalCode);
				pstmt2.setString(7,country);
				pstmt2.setInt(8,custId);
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
						
						out.println("<h2>Successfully added new payment information to the database!</h2>");
						out.println("<h1>ORDER SUMMARY</h1>");
						out.println("<table>");
						out.println("<tr>");
						out.println("<th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th>");
						out.println("</tr>");
						Iterator<Map.Entry<String, ArrayList<Object>>> iterator1 = productList.entrySet().iterator();
							while (iterator1.hasNext()){ 	
								
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
				out.println("<h1>Shipping to customer: " + custId + "</h1>");
				out.println("<h1>Name: " + rst.getString("firstName") + " " + rst.getString("lastName") + "</h1>");		
			}else{
				out.println("<h1>Payment Failed! Please try again.</h1>");
			}
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
 -->
