<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="checkcart.jsp" %>


<%
    // Get the current list of products

    if (productList != null) {
        // Get product ID to remove
        int removeProductId = Integer.parseInt(request.getParameter("removeProductId"));

        if (removeProductId != 0 && productList.containsKey(removeProductId)) {
            ArrayList<Object> product = productList.get(removeProductId);
            int curAmount = ((Integer) product.get(3)).intValue();

            if(authenticated && curAmount >1){
                
                try{
                    getConnection();
                    String sql = "UPDATE incart SET quantity = ? WHERE customerId =? AND productId = ?;";
                    PreparedStatement pstmt = con.prepareStatement(sql);
                    pstmt.setInt(1, new Integer(curAmount - 1));
                    pstmt.setInt(2, customerId); //customerId is from checkcart.jsp
                    pstmt.setInt(3, removeProductId);
                    pstmt.executeUpdate();
                }catch (SQLException ex) {
                    out.println(ex);
                }
                finally
                {
                    closeConnection();
                }
                
            }
            if(authenticated && curAmount == 1){
                try{
                    getConnection();
                    String sql = "DELETE FROM incart WHERE customerId = ? AND productId = ?;";
                    PreparedStatement pstmt = con.prepareStatement(sql);
                    pstmt.setInt(1, customerId); //customerId is from checkcart.jsp
                    pstmt.setInt(2, removeProductId);
                    pstmt.executeUpdate();
                }catch (SQLException ex) {
                    out.println(ex);
                }
                finally
                {
                    closeConnection();
                }
                
            }
            if (curAmount == 1) {
                productList.remove(removeProductId);
            } else {
                product.set(3, new Integer(curAmount - 1)); // Reduce the quantity
            }

            session.setAttribute("productList", productList);
        }
    }

    response.sendRedirect("showcart.jsp"); // Redirect back to the shopping cart page
%>