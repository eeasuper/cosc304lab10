<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Currency" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
  <%@ include file="basiccss.jsp" %>
<title>Dup and Max's Grocery - Product Information</title>

</head>
<body>

<%@ include file="header.jsp" %>
<div align="center">
<%

// Get product name to search for
// TODO: Retrieve and display info for the product
String productId = request.getParameter("pId");

try
{
  String sql = "SELECT * FROM product WHERE productId = ?;"; //productId, productName, productPrice, productImageURL, productImage, productDesc, categoryId
    getConnection();
    int pId = new Integer(0);
    try
		{
			pId = Integer.parseInt(productId);
		}
		catch (Exception e)
		{
			out.println("Invalid parameter for productId");
		}
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setInt(1,pId);
    ResultSet rs = pstmt.executeQuery();
    while(rs.next()){
        String name = rs.getString("productName");
        String price = rs.getString("productPrice");
        String description = rs.getString("productDesc");
        out.println("<h1>"+rs.getString(2)+"</h1>");
        String imgLink1 = "displayImage.jsp?id="+pId;
        out.println("<img src="+rs.getString("productImageURL")+" />");
        //out.println("<img src="+imgLink1+" />");
        out.println("<p>Id: "+pId+"</p>");
        out.println("<p> Price:"+price+"</p>");

        //displaying product description; if none available, displays that its out of stock 
        out.println("<p>Description: "+ description + "</p>"); 
        String inventoryQuery = "SELECT wi.warehouseId, wi.quantity, w.warehouseName FROM ProductInventory wi JOIN Warehouse w ON wi.warehouseId = w.warehouseId WHERE wi.productId = ?";
        try {
            PreparedStatement inventoryStmt = con.prepareStatement(inventoryQuery);
            inventoryStmt.setInt(1, pId);
            ResultSet inventoryResult = inventoryStmt.executeQuery();


            int totalInventory = 0;
            out.println("<h3>Inventory:</h3>");
            out.println("<ul>");
            while (inventoryResult.next()) {
                String warehouseName = inventoryResult.getString("warehouseName");
                int inventoryQuantity = inventoryResult.getInt("quantity");
                totalInventory+=inventoryQuantity;
                out.println("<li>" + warehouseName + ": " + inventoryQuantity + " units</li>");
            }
            out.println("</ul>");
            if (totalInventory == 0) {
              out.println("<p>This product is currently out of stock in all warehouses.</p>");
          }  
        } catch (SQLException ex) {
            out.println(ex);
        }
        String cartLink = "addcart.jsp?id=" + pId + "&name=" + name + "&price=" + price;
        out.println("<h2><a href="+ cartLink+">Add to Cart</a></h2>");
      }
}catch (SQLException ex) {
	out.println(ex);
}
finally
{
	closeConnection();
}

try{
  getConnection();
  int pId = Integer.parseInt(productId);
  String sql = "SELECT reviewRating, reviewComment, customerId FROM review WHERE productId = ?;";
  PreparedStatement pstmt = con.prepareStatement(sql);
  pstmt.setInt(1,pId);
  ResultSet rs = pstmt.executeQuery();
  out.println("<h2>REVIEWS:</h2>");
  out.println("<table>");
  out.println("<tr>");
    out.println("<th>Customer Id:</th>");
    out.println("<th>Review</th>");
    out.println("<th>Rating</th>");
  out.println("</tr>");
  while(rs.next()){
    int rating = rs.getInt(1);
    String review = rs.getString(2);
    int custId = rs.getInt(3);
    out.println("<tr>");
      out.println("<th>"+custId+"</th>");
      out.println("<th>"+review+"</th>");
      out.println("<th>"+rating+"</th>");
    out.println("</tr>");
  }
  out.println("</table>");

}catch (SQLException ex) {
	out.println(ex);
}
finally
{
	closeConnection();
}
%>

<h2><a href="listprod.jsp">Continue Shopping</a></h2>
</div>
</body>
</html>

