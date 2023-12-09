<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="checkcart.jsp" %>

<%
// Get the current list of products

if (productList == null)
{	// No products currently in list.  Create a list.
	productList = new HashMap<Integer, ArrayList<Object>>();
}

// Add new product selected
// Get product information
int id = Integer.parseInt(request.getParameter("id"));
String name = request.getParameter("name");
String price = request.getParameter("price");
out.println("Price parameter: " + price); // Add this line
Integer quantity = new Integer(1);

// Store product information in an ArrayList
ArrayList<Object> product = new ArrayList<Object>();
product.add(id);
product.add(name);
product.add(price);
product.add(quantity);

if(authenticated){ //authenticated comes from checkcart.jsp
	try{
		getConnection();
		if(cartExists){//from checkcart.jsp
			
			if (productList.containsKey(id))
			{	
				session.setAttribute("productMessage", "x1");
				product = (ArrayList<Object>) productList.get(id); //overwrites previous product ArrayList created. 
				int curAmount = ((Integer) product.get(3)).intValue();
				String sql = "UPDATE incart SET quantity = ? WHERE customerId = ? AND productId = ?;";
				PreparedStatement pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, curAmount);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, id);
				pstmt.executeUpdate();
				product.set(3, new Integer(curAmount+1)); //session
			}else{
				
				String sql = "INSERT INTO incart VALUES (?,?,?,?);";
				PreparedStatement pstmt = con.prepareStatement(sql);
				
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, id);
				pstmt.setInt(3, quantity);
				pstmt.setDouble(4, Double.parseDouble(price));
				pstmt.executeUpdate();
				
				productList.put(id,product); //session
			}
		}else{
			//
			String sql = "INSERT INTO incart VALUES (?,?,?,?);";
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, id);
			pstmt.setInt(3, quantity);
			pstmt.setDouble(4, Double.parseDouble(price));
			pstmt.executeUpdate();
			productList.put(id,product); //session
		}
	}catch (SQLException ex) {
        out.println(ex);
    }
    finally
    {
        closeConnection();
    }
}else{
	// Update quantity if add same item to order again
	if (productList.containsKey(id))
	{	product = (ArrayList<Object>) productList.get(id);
		int curAmount = ((Integer) product.get(3)).intValue();
		product.set(3, new Integer(curAmount+1));
	}
	else
		productList.put(id,product);
}
session.setAttribute("productList", productList);
%>
<jsp:forward page="showcart.jsp" />