<%-- 
    Document   : admin
    Created on : Mar 25, 2015, 4:43:29 PM
    Author     : Vahid
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<jsp:include page="modules/header.jsp"></jsp:include>
<jsp:include page="modules/menu.jsp"></jsp:include>
    <h2>Admin page</h2>
    <br/>
    <a href="logout.jsp">Click here to logout</a>
    <br/>
    <h2>The data below has been fetched from the database</h2>
    <h2>In case you are not able to see it make sure that you have ran the startup_db.sql script beforehand</h2>

<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
                   url="jdbc:mysql://localhost/muses"
                   user="muses"  password="muses11"/>

<sql:query dataSource="${snapshot}" var="result">
    select user_id, username, password, email from users;
</sql:query>

<table border="1" width="100%">
    <tr>
        <th>User ID</th>
        <th>Username</th>
        <th>Password</th>
        <th>Email</th>
    </tr>
    <c:forEach var="row" items="${result.rows}">
        <tr>
            <td><c:out value="${row.user_id}"/></td>
            <td><c:out value="${row.username}"/></td>
            <td><c:out value="${row.password}"/></td>
            <td><c:out value="${row.email}"/></td>
        </tr>
    </c:forEach>
</table>

<jsp:include page="modules/footer.jsp"></jsp:include>