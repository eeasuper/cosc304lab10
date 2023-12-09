
<%@ include file="jdbc.jsp" %>

<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Currency" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%
//get userid 
String userId= request.getParameter("userid");
// Get password
String password = request.getParameter("password");

@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

NumberFormat currFormat = NumberFormat.getCurrencyInstance();
currFormat.setMaximumFractionDigits(2);
Currency currency = Currency.getInstance("CAD");
currFormat.setCurrency(currency);


try
{
    getConnection();
    String sql = "SELECT * FROM customer WHERE userid=?;";
	PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1,userId);
    ResultSet rst = pstmt.executeQuery();
    
    boolean passwordMatches = false;
    if (!rst.next()){
        out.println("Error: Invalid userid. Possibly does not exist.");
        %><br/><button onclick="goBack()">Go Back</button><%
    }
    else{
        passwordMatches = rst.getString("password").equals(password);
        if (!passwordMatches){
            out.println("Error: Wrong password");
            %><br/><button onclick="goBack()">Go Back</button><%
        }
        else if (productList == null || productList.isEmpty()){
            out.println("Error: No items in cart");
            %><br/><button onclick="goBack()">Go Back</button><%
        }
        else{
            int custId = rst.getInt("customerId");
            //redirecting to payment
            response.sendRedirect("payment.jsp?customerId=" + custId);
        }
    }
}catch (SQLException ex){
    out.println("SQLException: "+ex);
}
%>
<script>
    function goBack() {
        window.history.back();
    }
</script>