<%
	boolean authenticated = session.getAttribute("authenticatedUser") == null ? false : true;
	boolean isAdmin = session.getAttribute("isAdmin").toString() == "true" ? true : false;
	//boolean isAdmin = true;
	if (!authenticated)
	{
		String loginMessage = "You have not been authorized to access the URL "+request.getRequestURL().toString();
        session.setAttribute("loginMessage",loginMessage);        
		response.sendRedirect("login.jsp");
	}
%>
