<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="checkcart.jsp" %>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="basiccss.jsp" %>
<title>Your Shopping Cart</title>
</head>
<body>
<%@ include file="header.jsp" %>
<%

//if (productList == null)
//{	
//	productList = new HashMap<Integer, ArrayList<Object>>();
//}

if (productList == null)
{	
	out.println("<H1>Your shopping cart is empty!</H1>");
	//session.setAttribute("productMessage", "xx");
}
else
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	out.println("<h1>Your Shopping Cart</h1>");
	out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
	out.println("<th>Price</th><th>Subtotal</th></tr>");
	double total =0;
	Iterator<Map.Entry<Integer, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	// session.setAttribute("productMessage", productList);
	while (iterator.hasNext()) 
	{	Map.Entry<Integer, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
		out.print("<tr><td>"+product.get(0)+"</td>");
		out.print("<td>"+product.get(1)+"</td>");

		out.print("<td align=\"center\">"+product.get(3)+"</td>");
		Object price = product.get(2);
		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;
		
		try
		{
			pr = Double.parseDouble(price.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid price for product: "+product.get(0)+" price: "+price);
		}
		try
		{
			qty = Integer.parseInt(itemqty.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
		}		

		int productId = (int)product.get(0);
		out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
		out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td>");
		%>
		<td align="right">
			<form action="removecart.jsp" method="post">
				<input type="hidden" name="removeProductId" value="<%= productId %>">
				<input type="submit" value="Remove">
			</form>
		</td>
		<%

		out.println("</tr>");
		total = total +pr*qty;
	}
	out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
			+"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
	out.println("</table>");

	out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
}
%>
<h2><a href="listprod.jsp">Continue Shopping</a></h2>
<h2><a href="index.jsp">Back to Home Page</a></h2> 

</body>
</html> 

