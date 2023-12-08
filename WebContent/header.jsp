    <h1 align="center"><a href="index.jsp">Dup and Max's Grocery!</a></h1>
    <nav>
        <a href="index.jsp">Home</a>
        <a href="login.jsp">Login</a>
        <a href="listprod.jsp">Begin Shopping</a>
        <a href="listorder.jsp">List All Orders</a>
        <a href="customer.jsp">Customer Info</a>
        <a href="admin.jsp">Administrators</a>
        <a href="logout.jsp">Log out</a>
    </nav>
    <%
	String userNa = (String) session.getAttribute("authenticatedUser");
	if (userNa != null)
		out.println("<div id=\"loginname\" align=\"center\">Signed in as: "+userNa+"</div>");
    %>
</header>

<hr>
