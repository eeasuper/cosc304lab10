<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>

<html>
<head>
<title>YOUR NAME Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>
<%@ include file="jdbc.jsp" %>

<%
	// TODO: Get order id
	String orderId = (String) request.getParameter("orderId");
    
	try {
		getConnection();
		PreparedStatement pstmt = con.prepareStatement("SELECT orderId FROM ordersummary WHERE orderId = ?;");
		pstmt.setString(1,orderId);
		ResultSet rst = pstmt.executeQuery();

	// TODO: Check if valid order id in database (In ordersummary?)

		if (!rst.next()){
		out.println("Incorrect orderId. You wrote: "+ rst.getString(1));
		}
		else{

	// TODO: Start a transaction (turn-off auto-commit)

		con.setAutoCommit(false);

	// TODO: Retrieve all items in order with given id

		PreparedStatement pstmt2 = con.prepareStatement("SELECT * FROM orderproduct WHERE orderId = ?;");
		pstmt2.setInt(1,Integer.parseInt(orderId));
		ResultSet rst2 = pstmt2.executeQuery();

	//adding the product Id and quantity to a hashmap to be referenced later when updating warehouse quantities
		Map<Integer, Integer> productIdQuantityMap = new HashMap<>();
		boolean allItemsValid=true;
		while (rst2.next()){
				int productId = rst2.getInt("productId");
				int requiredAmount = rst2.getInt("quantity");
				productIdQuantityMap.put(productId, requiredAmount);

		// TODO: Create a new shipment record.
			try(PreparedStatement updateStatement = con.prepareStatement("INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES (?,?,?);"))
			{
				updateStatement.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
				updateStatement.setString(2,"Description Here");
				updateStatement.setInt(3,1); //assuming warehouse id is 1 
				updateStatement.executeUpdate();
			}
				catch (SQLException ex){
				out.println("SQLException: "+ex);
			}
			// TODO: For each item verify sufficient quantity available in warehouse 1.
			try(PreparedStatement pstmt3 = con.prepareStatement("SELECT * FROM productinventory WHERE productId = ? AND warehouseId = ?;"))
			{
			pstmt3.setInt(1,productId);
			pstmt3.setInt(2,1); //sets warehouseId to warehouse1
					
			try(ResultSet rst3 = pstmt3.executeQuery();)
					{
						if (rst3.next()){
							int availableAmount = rst3.getInt("quantity");

			// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
			
							if (!productIdQuantityMap.containsKey(productId)){
								out.println("Product " + productId + " not found in quantity map");
        						continue; 
							}
							if (availableAmount < requiredAmount){
								allItemsValid=false;
								con.rollback();
								out.println("Insufficient inventory for productId: " + productId+"<br>");
								break;
							}
						}
					}catch (SQLException innerEx){
						out.println("SQLExceptionInner: "+innerEx);
					}
				}catch (SQLException ex){
					out.println("SQLException: "+ex);
				}
		
				// Fetch current available amount again before updating
				try{
					PreparedStatement pstmt3 = con.prepareStatement("SELECT quantity FROM productInventory WHERE productId = ? AND warehouseId = ?;");
					pstmt3.setInt(1, productId);
					pstmt3.setInt(2, 1); // Assuming warehouseId is 1
					ResultSet rst3 = pstmt3.executeQuery();
		
					if (rst3.next()) {
							int availableAmount = rst3.getInt("quantity");
							int newQuantity = availableAmount - requiredAmount;
		
							PreparedStatement pstmt4 = con.prepareStatement("UPDATE productInventory SET quantity=? WHERE productId=? AND warehouseId=?;");
							pstmt4.setInt(1, newQuantity);
							pstmt4.setInt(2, productId);
							pstmt4.setInt(3, 1); // Assuming warehouseId is 1
							pstmt4.executeUpdate();

							out.println("Ordered product ID: " + productId + "<br>");
        					out.println("Quantity: " + requiredAmount + "<br>");
        					out.println("Previous inventory: " + availableAmount + "<br>");
        					out.println("New inventory: " + (availableAmount - requiredAmount) + "<br>");

					} else {
							out.println("Product " + productId + " not found in warehouse");
					}
				} catch (SQLException ex) {
					out.println("Exception: " + ex);
				}
		} //end of while loop
			if(allItemsValid){
				try{
						con.commit();
						out.println("Shipment successful<br><br>");
					}
					
				catch (SQLException ex) {
					try {
						con.rollback(); // Rollback the transaction if an exception occurs
					} catch (SQLException rollbackEx) {
						out.println("Rollback Exception: " + rollbackEx);
					}
				} finally {
					try {
						con.setAutoCommit(true); // Reset auto-commit to true
					} catch (SQLException setAutoCommitEx) {				
						out.println("Auto-commit Exception: " + setAutoCommitEx);
					}
				}
		}
			
		}
	}catch (SQLException ex) {
		out.println(ex);
	}
	finally
	{
		closeConnection();
	}
%>                   				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
