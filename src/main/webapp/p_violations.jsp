<%-- 
    Document   : p_violations
    Created on : 26-mar-2015, 16:36:33
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

<sql:query dataSource="${snapshot}" var="columnNames">
    <%--Uncomment if the name of the tables is the same as the name of the jsp files--%>
    <%--select column_name from information_schema.COLUMNS WHERE TABLE_SCHEMA LIKE 'muses' AND TABLE_NAME = '${fn:replace(fn:replace(pageContext.request.servletPath,'.jsp',''),'/','')}';--%>
    select column_name from information_schema.COLUMNS WHERE TABLE_SCHEMA LIKE 'muses' AND TABLE_NAME = 'security_violation';
</sql:query>

<sql:query dataSource="${snapshot}" var="result">
    <%--Uncomment if the name of the tables is the same as the name of the jsp files--%>
    <%--select * from ${fn:replace(fn:replace(pageContext.request.servletPath,'.jsp',''),'/','')};--%>
    select * from security_violation;
</sql:query>

<jsp:include page="modules/header.jsp"></jsp:include>
<jsp:include page="modules/menu.jsp"></jsp:include>
	 	 	 	 	 	 	
<table border="1" width="100%">
    <tr>
        <c:forEach var="rowHeader" items="${columnNames.rows}">
            <th><c:out value="${rowHeader.COLUMN_NAME}"/></th>
        </c:forEach>
    </tr>

    <c:forEach var="rowBody" items="${result.rows}">
            <%--Get row ordered alphabetically-- ¿?¿? WHY--%>
            <%--<tr><c:forEach var="cell" items="${rowBody}">
                <td><c:out value="${cell}"/></td>
            </c:forEach></tr>--%>
        <tr>
            <td><c:out value="${rowBody.security_violation_id}"/></td>
            <td><c:out value="${rowBody.message}"/></td>
            <td><c:out value="${rowBody.conditionText}"/></td>
            <td><c:out value="${rowBody.modeText}"/></td>
            <td><c:out value="${rowBody.user_id}"/></td>
            <td><c:out value="${rowBody.decision_id}"/></td>
            <td><c:out value="${rowBody.event_id}"/></td>
            <td><c:out value="${rowBody.device_id}"/></td>
            <td><c:out value="${rowBody.detection}"/></td>
        </tr>
    </c:forEach>
 </table>

<jsp:include page="modules/footer.jsp"></jsp:include>
