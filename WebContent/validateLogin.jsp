<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);
	boolean isAdmin = false;

	try
	{
		authenticatedUser = validateLogin(out,request,session);
		if(authenticatedUser != null){
			HashMap<Integer, ArrayList<Object>> productList = checkCart(out, request, session);
			session.setAttribute("productList", productList);
		}
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
	//this function is kind of a copy and paste of checkcart.jsp
	HashMap<Integer, ArrayList<Object>> checkCart(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		HashMap<Integer, ArrayList<Object>> productList =  new HashMap<Integer, ArrayList<Object>>();
		try{
			int customerId = 0;
			getConnection();
			String username = session.getAttribute("authenticatedUser").toString();
			//get customer Id
			String sql1 = "SELECT customerId FROM customer WHERE userid = ?;";
			PreparedStatement custpstmt = con.prepareStatement(sql1);
			custpstmt.setString(1, username);
			ResultSet custrs = custpstmt.executeQuery();
			if(custrs.next()){
				customerId = custrs.getInt(1);
			}
			//continue to do cart query
			String sql = "SELECT product.productId, product.productName, quantity, price FROM incart JOIN product ON incart.productId = product.productId WHERE customerId = ?;";
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, customerId);
			ResultSet rs = pstmt.executeQuery();
			while(rs.next()){
				ArrayList<Object> product = new ArrayList<Object>();
				Integer pid = new Integer(rs.getInt(1));	
				if(productList == null || !productList.containsKey(pid)){ //updating the session and hashmap
					product.add(pid);
					
					product.add(rs.getString(2));
					product.add(rs.getDouble(4));
					product.add(rs.getInt(3));
					productList.put(pid,product);
				}
			}
		}catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}
		return productList;
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
	
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr != null) //user has been validated if it is not null.
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