<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
    <h1 align="center"><a href="index.jsp">Dup and Max's Grocery!</a></h1>
    <nav>
        <a href="index.jsp">Home</a>
        <a href="login.jsp">Login</a>
        <a href="listprod.jsp">Begin Shopping</a>
        <a href="listorder.jsp">List All Orders</a>
        <a href="customer.jsp">Customer Info</a>
        <a href="admin.jsp">Administrators</a>
        <a href="logout.jsp">Log out</a>
        <%
        String userNa = (String) session.getAttribute("authenticatedUser");
        if(userNa == null){
            out.println("<a >Not signed in.</a>");
        }else{
            out.println("<a id=\"loginname\" >Signed in as: "+userNa+"</a>");
        
        }
        //if (userNa != null){

            //@SuppressWarnings({"unchecked"})
            //HashMap<Integer, ArrayList<Object>> productList = (HashMap<Integer, ArrayList<Object>>) session.getAttribute("productList");
            //if (productList != null && !productList.isEmpty()) {
            
                out.println("<a href=\"showcart.jsp\">View Shopping Cart</a>");
                
            //}
        //}
    %>
    </nav>
    
</header>

<hr>
