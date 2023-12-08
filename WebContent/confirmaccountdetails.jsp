<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*,java.net.URLEncoder" %>


<%
String userid = (String) session.getAttribute("authenticatedUser");
String currentPassword = request.getParameter("currentPassword");
String newPassword = request.getParameter("newPassword");
String confirmNewPassword = request.getParameter("confirmNewPassword");
String email = request.getParameter("email");
String phone = request.getParameter("phone");
String address = request.getParameter("address");
String city = request.getParameter("city");
String state = request.getParameter("state");
String postalCode = request.getParameter("postalCode");
String country = request.getParameter("country");
String message="";

//first, check that the password matches the current password for the given user

try{
    getConnection();
    PreparedStatement pstmt = con.prepareStatement("SELECT password FROM customer WHERE userid = ?");
    pstmt.setString(1,userid);
    ResultSet rst = pstmt.executeQuery();
    if (rst.next()){
        String databasePassword = rst.getString("password");
        //if your input password is wrong
        if (!currentPassword.equals(databasePassword)){
            //redirect to an error page with message "Sorry, your password was incorrect"
            message = "Sorry, your password was incorrect";
        }

        //if your input password is right - check to see if the newPassword and confirmNewPassword are the same 
        else if (!newPassword.equals(confirmNewPassword)){
            //redirect to error with message "Your new password did not match"
            message = "Error: Your new passwords did not match";
        }

        //if your password matches the database, and your new password input is correct in both cases
        //now, we are going to save the new information into the database
        else{
            try{
                PreparedStatement updateStatement = con.prepareStatement("UPDATE customer SET email=?,phonenum=?,address=?,city=?,state=?,postalCode=?,country=?,password=? WHERE userid=?");
                updateStatement.setString(1,email);
                updateStatement.setString(2,phone);
                updateStatement.setString(3,address);
                updateStatement.setString(4,city);
                updateStatement.setString(5,state);
                updateStatement.setString(6,postalCode);
                updateStatement.setString(7,country);
                updateStatement.setString(8,newPassword);
                updateStatement.setString(9,userid);
                updateStatement.executeUpdate();
                message = "Your account details were successfully changed";
            }catch (SQLException ex){
                out.println("SQLException: "+ex);
            }
        }
    }
    else{
        message = "Sorry, something went wrong";
    }
    response.sendRedirect("changeaccountdetails.jsp?message=" + URLEncoder.encode(message, "UTF-8"));
}catch (SQLException ex){
    out.println("SQLException "+ex);
}

//then, check that the newpassword matches the confirmNewPassword





%>
