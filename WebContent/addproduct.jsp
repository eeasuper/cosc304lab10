<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%

if(authenticated && isAdmin){
    String productName = "";
    double productPrice = 0;
    String productImageURL = "";
    String productDesc = "";
    int categoryId = 0;
    try{
        productName = request.getParameter("productname");
        productPrice = Double.parseDouble(request.getParameter("price"));
        productImageURL = request.getParameter("imageURL");
        productDesc = request.getParameter("desc");
        categoryId = Integer.parseInt(request.getParameter("catId"));
    }catch(Exception ex){
        session.setAttribute("productMessage","It is possible you entered the wrong input value for one of the boxes. " +ex);
    }
    if(productName.length() >0){
    try{
        getConnection();
        String sql = "INSERT INTO product (productName, productPrice, productImageURL, productImage, productDesc, categoryId) VALUES (?,?,?,?,?,?);";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, productName);
        pstmt.setDouble(2, productPrice);
        pstmt.setString(3, productImageURL);
        //making image upload work requires Servlets. This project does not use servlets.
        pstmt.setBinaryStream(4, null);
        pstmt.setString(5, productDesc);
        pstmt.setInt(6, categoryId);
        pstmt.executeUpdate();
        session.setAttribute("productMessage","product "+productName+" has been successfully added!");
    }catch (SQLException ex) {
        out.println(ex);
    }
    finally
    {
        closeConnection();
    }
    }
}
response.sendRedirect("admin.jsp");	

%>