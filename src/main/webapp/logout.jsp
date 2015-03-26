<%-- 
    Document   : logout
    Created on : Mar 25, 2015, 4:57:15 PM
    Author     : Vahid
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" session="true"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Logout Page</title>
    </head>
    <body>
        User '<%=request.getRemoteUser()%>' has been logged out.
        <% session.invalidate();%>
        <br/>
        <a href="index.jsp">Click here to go to index page</a>
    </body>
</html>

