<%@ page import="java.sql.*,java.net.URLEncoder" %>

<p>
    a
    <%
        // use session.getAttribute("debugMessage").toString(); after setting it somewhere else
        String debugMessage = "debugMessage HERE";    
        session.setAttribute("debugMessage",debugMessage);    
    %>
</p>
<hr>