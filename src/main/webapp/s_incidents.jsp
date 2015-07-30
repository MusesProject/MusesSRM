<%-- 
    Document   : s_incidents
    Created on : 26-mar-2015, 16:58:29
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

<%--CONTROL SECTION-----------------------------------------------------------%>    
<%--POST catched--%>
<c:if test="${pageContext.request.method=='POST'}">

<%--Save user submited--%>
<c:choose><c:when test="${param.button=='New Incident'}">
    <c:catch var ="catchException">
    <sql:update dataSource="${snapshot}" var="result">
        INSERT INTO security_incident(name,decision_id,event_id,device_id,user_id,modification) VALUES (?,?,?,?,?,?);
        <sql:param value="${param.name}" />
        <sql:param value="${param.decision_id}" />
        <sql:param value="${param.event_id}" />
        <sql:param value="${param.device_id}" />
        <sql:param value="${param.user_id}" />
        <sql:param value="${param.modification}" />
    </sql:update>
    </c:catch>
</c:when></c:choose>
<%--A exception was catched--%>
<c:choose><c:when test = "${catchException != null}">
    <h3>There is an exception: ${catchException.message}</h3>
</c:when></c:choose>
</c:if>

<sql:query dataSource="${snapshot}" var="columnNames">
    <%--Uncomment if the name of the tables is the same as the name of the jsp files--%>
    <%--select column_name from information_schema.COLUMNS WHERE TABLE_SCHEMA LIKE 'muses' AND TABLE_NAME = '${fn:replace(fn:replace(pageContext.request.servletPath,'.jsp',''),'/','')}';--%>
    select column_name from information_schema.COLUMNS WHERE TABLE_SCHEMA LIKE 'muses' AND TABLE_NAME = 'security_incident';
</sql:query>

<sql:query dataSource="${snapshot}" var="result">
    <%--Uncomment if the name of the tables is the same as the name of the jsp files--%>
    <%--select * from ${fn:replace(fn:replace(pageContext.request.servletPath,'.jsp',''),'/','')};--%>
    select * from security_incident;
</sql:query>

<jsp:include page="modules/header.jsp"></jsp:include>
<jsp:include page="modules/menu.jsp"></jsp:include>

<%--FORM DATE EVENT-----------------------------------------------------------%>  
<form name="usuario" method="post" action="profile_s_incident.jsp">
    <fieldset>
        <table>
            <tr>
                <td><label>Date:</label></td>
                <td><input type="text" name="date" value="YYYY-MM-DD"/></td>
            </tr>
        </table>    

        <input type="submit" name="button" value="New Incident">
    </fieldset>
</form>    
<%--END FORM DATE EVENT-------------------------------------------------------%>

<%--TABLE SECURITY EVEN-------------------------------------------------------%>
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
            <td><c:out value="${rowBody.security_incident_id}"/></td>
            <td><c:out value="${rowBody.name}"/></td>
            <td><c:out value="${rowBody.decision_id}"/></td>
            <td><c:out value="${rowBody.event_id}"/></td>
            <td><c:out value="${rowBody.device_id}"/></td>
            <td><c:out value="${rowBody.user_id}"/></td>
            <td><c:out value="${rowBody.modification}"/></td>
        </tr>
    </c:forEach>
 </table><br /><br />
<%--END TABLE SECURITY EVEN---------------------------------------------------%>

<%--Debug post parameters--%>
<c:out value="${param}"/>
<jsp:include page="modules/footer.jsp"></jsp:include>

