<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Get the current list of products
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList != null) {
        // Get product ID to remove
        String removeProductId = request.getParameter("removeProductId");

        if (removeProductId != null && productList.containsKey(removeProductId)) {
            ArrayList<Object> product = productList.get(removeProductId);
            int curAmount = ((Integer) product.get(3)).intValue();
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