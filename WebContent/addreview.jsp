<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%
boolean isAllowedReview = false;
boolean hasOrdered = false;
if(authenticated){
    int productId = 0;
    String review ="";
    int custId = 0;
    int rating = 0;
    try{
        getConnection();   
        String productName = request.getParameter("revprodname");
        String sql1 = "SELECT productId FROM product WHERE productName = ?;";
        PreparedStatement pstmt1 = con.prepareStatement(sql1);
        pstmt1.setString(1, productName);
        ResultSet rst2 = pstmt1.executeQuery();
        if(rst2.next()){
            productId = rst2.getInt(1);
        }
        review = request.getParameter("review");
        String username = session.getAttribute("authenticatedUser").toString();
        String sql = "SELECT customerId FROM customer WHERE userid = ?;";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, username);
        ResultSet rst = pstmt.executeQuery();
        if(rst.next()){
            custId = rst.getInt(1);
            String sql2 = "SELECT * FROM review WHERE customerId = ? AND productId = ?;";
            PreparedStatement pstmt2 = con.prepareStatement(sql2);
            pstmt2.setInt(1, custId);
            pstmt2.setInt(2, productId);
            ResultSet rst1 = pstmt2.executeQuery();
            if(!rst1.next()){
                isAllowedReview = true;
            }
        }
        //test if it is an item purchased before

        String sql3 = "SELECT O1.orderId, O2.productId FROM ordersummary as O1 JOIN orderproduct as O2  ON O1.orderId=O2.orderId WHERE O1.customerId = ?;";
        PreparedStatement pstmt3 = con.prepareStatement(sql3);
        pstmt3.setInt(1, custId);
        ResultSet rst3 = pstmt3.executeQuery();
        while(rst3.next()){
            if(rst3.getInt(2) == productId){
                hasOrdered = true;
            }
        }
        
        
    }catch(Exception ex){
        session.setAttribute("reviewMessage", "It's possible you already wrote a review for this product or have not ordered this product! prod:"+" "+ ex);
    }finally{
        closeConnection();
    }

    if(isAllowedReview && hasOrdered){
        
        try{
            if( review.length() >0){
                getConnection();
                rating= Integer.parseInt(request.getParameter("rating"));
                long millis=System.currentTimeMillis();  
                //java.sql.Date date=new java.sql.Date(millis);
                java.sql.Timestamp time = new Timestamp(System.currentTimeMillis());
                String sql = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?,?,?,?,?);";
                PreparedStatement pstmt = con.prepareStatement(sql);
                pstmt.setInt(1, rating);
                pstmt.setTimestamp(2, time);
                pstmt.setInt(3, custId);
                pstmt.setInt(4, productId);
                pstmt.setString(5, review);
                pstmt.executeUpdate();
                session.setAttribute("reviewMessage","product "+productId+" has been successfully reviewed! ");
            }
        }catch (SQLException ex) {
            out.println(ex);
        }
        finally
        {
            closeConnection();
        }
    }else{
        session.setAttribute("reviewMessage", "It's possible you already wrote a review for this product or have not ordered this product!");
    }
}


response.sendRedirect("customer.jsp");	
%>
