<%-- 
    Document   : users
    Created on : 26-mar-2015, 16:19:10
    Author     : unintendedbear
    Author     : Juan Luis Martin Acal <jlmacal@gmail.com>
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
                   url="jdbc:mysql://localhost/muses"
                   user="muses"  password="muses11"/>

<sql:query dataSource="${snapshot}" var="result">
    SELECT users.user_id, devices.device_id, users.name, users.surname FROM simple_events LEFT JOIN users ON users.user_id=simple_events.user_id LEFT JOIN devices ON devices.device_id=simple_events.device_id;
    <%--The column name in users and devices give problems when print the second name (devices.name)--%>
    <%--the AS clausure in the select query dont solve the problem¿?¿?--%>
    <%--SELECT users.user_id, devices.device_id, users.name, devices.name AS name2 FROM simple_events LEFT JOIN users ON users.user_id=simple_events.user_id LEFT JOIN devices ON devices.device_id=simple_events.device_id;--%>
</sql:query>

<jsp:include page="modules/header.jsp"></jsp:include>
<jsp:include page="modules/menu.jsp"></jsp:include>

<table border="1" width="100%">
    <tr>
        <th>user_id</th>
        <th>device_id</th>
        <th>user name</th>
        <%--<th>device name</th>--%>
        <th>user surname</th>
    </tr>
    <c:forEach var="rowBody" items="${result.rows}">
        <tr>
            <td><c:out value="${rowBody.user_id}"/></td>
            <td><c:out value="${rowBody.device_id}"/></td>
            <td><c:out value="${rowBody.name}"/></td>
            <%--<td><c:out value="${rowBody.name2}"/></td>--%>
            <td><c:out value="${rowBody.surname}"/></td>
            
        </tr>
    </c:forEach>
 </table>

<jsp:include page="modules/footer.jsp"></jsp:include>
