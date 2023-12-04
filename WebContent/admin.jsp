<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Currency" %>
<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>
<%@ include file = "header.jsp" %>
<%
    if(authenticated && isAdmin){
        out.println("<h3>Administrator Sales Report by Day</h3>");
        out.println("<table>");
        out.println("<tr>");
            out.println("<th>Order Date</th>");
            out.println("<th>Total Order Amount</th>");
        out.println("</tr>");
        try{
            getConnection();
            String sql = "SELECT FORMAT(orderDate,'yyyy-MM-dd') as date, SUM(totalAmount) as 'totalAmount' FROM ordersummary GROUP BY FORMAT(orderDate,'yyyy-MM-dd') ORDER BY FORMAT(orderDate,'yyyy-MM-dd');";
            PreparedStatement pstmt = con.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();
            while(rs.next()){
                out.println("<tr>");
                    out.println("<th>"+rs.getString("date")+"</th>");
                    out.println("<th>"+rs.getString("totalAmount")+"</th>");
                out.println("</tr>");
            }

        }catch (SQLException ex) {
            out.println(ex);
        }
        finally
        {
            closeConnection();
        }
        out.println("</table>");
    } else{
        out.println("you are not logged in or you do not have access to this page");
    }
// TODO: Write SQL query that prints out total order amount by day
String sql = "";

%>
<a href="loaddata.jsp">Reinitialize the database!</a> 
<br>   
<a href="addproductform.jsp">Add a product!</a>  
<hr>
<%
if (session.getAttribute("productMessage") != null){
	out.println("<p>"+session.getAttribute("productMessage").toString()+"</p>");
    session.setAttribute("productMessage", null);
}
%>
</body>
</html>

