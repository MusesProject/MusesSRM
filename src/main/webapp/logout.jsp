<%-- 
    Document   : logout
    Created on : Mar 25, 2015, 4:57:15 PM
    Author     : Vahid
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" session="true"%>
<!DOCTYPE html>
<jsp:include page="modules/header.jsp"></jsp:include>
<jsp:include page="modules/menu.jsp"></jsp:include>
User '<%=request.getRemoteUser()%>' has been logged out.
<% session.invalidate();%>
<br/>
<a href="index.jsp">Click here to go to index page</a>
<jsp:include page="modules/footer.jsp"></jsp:include>

