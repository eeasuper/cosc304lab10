<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);
	boolean isAdmin = false;

	try
	{
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null){
		isAdmin = validateAdmin(out, request, session);
		response.sendRedirect("index.jsp");		// Successful login
	}
	else{
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message 
	}				
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0))
				return null;

		try 
		{
			getConnection();
			String sql = "SELECT userid, password FROM customer WHERE userid=?;";
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setString(1, username);
			ResultSet rs = pstmt.executeQuery();
			boolean passwordMatches = false;
			while(rs.next()){
				passwordMatches = rs.getString(2).equals(password);
			}
			if(passwordMatches){
				retStr = username;
			}

			// TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
					
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
		}
		else
			session.setAttribute("loginMessage","Could not connect to the system using that username/password.");

		return retStr;
	}
%>

<%!
	boolean validateAdmin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = session.getAttribute("authenticatedUser").toString();
		boolean isAdmin = false;
		int customerId = 0;
		try{
			getConnection();
			String sql1 = "SELECT customerId FROM customer WHERE userid = ?;";
			PreparedStatement pstmt1 = con.prepareStatement(sql1);
			pstmt1.setString(1, username);
			ResultSet rs1 = pstmt1.executeQuery();
			if(rs1.next()){
				customerId = rs1.getInt(1);
			}
			String sql = "SELECT customerId, userid FROM customer JOIN admin ON customer.customerId = admin.adminId WHERE customerId = ?;";
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, customerId);
			ResultSet rs = pstmt.executeQuery();
			if(rs.next()){
				isAdmin = true;
				session.setAttribute("isAdmin", true);
			}else{
				session.setAttribute("isAdmin", false);
			}
		}
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		return isAdmin;
	}
%>