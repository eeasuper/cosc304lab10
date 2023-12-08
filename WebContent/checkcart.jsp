
<%
//This file requires the inclusion of the jdbc.jsp file that this file is used in in the line BEFORE the inclusion of this file.

boolean authenticated = session.getAttribute("authenticatedUser") == null ? false : true;
boolean cartExists = false;
int customerId = 0;

@SuppressWarnings({"unchecked"})
HashMap<Integer, ArrayList<Object>> productList = (HashMap<Integer, ArrayList<Object>>) session.getAttribute("productList");
if(authenticated){
    try{
        getConnection();
        String username = session.getAttribute("authenticatedUser").toString();
		//get customer Id
		String sql1 = "SELECT customerId FROM customer WHERE userid = ?;";
		PreparedStatement custpstmt = con.prepareStatement(sql1);
		custpstmt.setString(1, username);
		ResultSet custrs = custpstmt.executeQuery();
		if(custrs.next()){
			customerId = custrs.getInt(1);
		}
        //continue to do cart query
        String sql = "SELECT product.productId, product.productName, quantity, price FROM incart JOIN product ON incart.productId = product.productId WHERE customerId = ?;";
        PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, customerId);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()){
            cartExists = true;
			ArrayList<Object> product = new ArrayList<Object>();
			int pid = rs.getInt(1);	
			if(productList == null || !productList.containsKey(pid)){ //updating the session and hashmap
				product.add(pid);
				product.add(rs.getString(2));
				product.add(rs.getDouble(4));
				product.add(rs.getInt(3));
				productList.put(pid,product);
			}else if (productList.containsKey(pid)){
				//product = (ArrayList<Object>) productList.get(pid);
				//int curAmount = ((Integer) product.get(3)).intValue();
				//product.set(3, new Integer(curAmount+1));
			}
		}
    }catch (SQLException ex) {
        out.println(ex);
    }
    finally
    {
        closeConnection();
    }
}
%>