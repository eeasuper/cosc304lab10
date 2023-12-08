<!DOCTYPE html>
<html>
<%@ include file="jdbc.jsp" %>
<head>
    <%@ include file="basiccss.jsp" %>
<%@ include file = "header.jsp" %>
<title>Remove a Product</title>
</head>
<body>
<div style="margin:0 auto;text-align:center;">
    <h3>Remove a product!</h3>
    <div style="display: inline-block;">
        <table>
        <%
            String sql = "SELECT * FROM product ORDER BY productName ASC";
            try{
                getConnection();
                PreparedStatement pstmt = con.prepareStatement(sql);
                ResultSet rst = pstmt.executeQuery();
                while (rst.next()){
                    String productName = rst.getString("productName");
        %>              
                    <tr>
                        <td><%= productName %></td>
                        <td>
                            <form method="post" action="removeproduct.jsp">
                                <input type="hidden" name="productName" value="<%= productName %>">
                                <input type="submit" value="Remove">
                            </form>
                        </td>
                    </tr>
        <%
                }
            }catch(SQLException ex){
                out.println(ex);
            }
        %>
        </table>
    </div>
</div>
</body>
</html>






