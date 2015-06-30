<%-- 
    Document   : rules
    Created on : 09-jun-2015, 12:03:54
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

<jsp:include page="modules/header.jsp"></jsp:include>
<jsp:include page="modules/menu.jsp"></jsp:include>


<%--CHECK ALL NEW RULES IN REFINED RULES--------------------------------------%>
<sql:query dataSource="${snapshot}" var="check">
    select refined_security_rules.refined_security_rules_id, refined_security_rules.original_security_rule_id FROM refined_security_rules WHERE refined_security_rules.original_security_rule_id NOT IN (SELECT security_rules.security_rule_id FROM security_rules);
</sql:query>
    
<c:if test="${fn:length(check.rows) != 0}">
    <h3>Warning: Some refined rules do not match with any entry in security rules table</h3>           
    <table border="1" width="100%">
    <tr>
        <c:forEach var="row" items="${check.rows}">
            <td><c:out value="${row.refined_security_rules_id}"/></th>
            <td><c:out value="${row.original_security_rule_id}"/></th>
        </c:forEach>
    </tr>
    </table><br /><br />
</c:if>
<%--END CHECK ALL NEW RULES IN REFINED RULES----------------------------------%>


<%--CHECK DRAFT RULES---------------------------------------------------------%>
<sql:query dataSource="${snapshot}" var="check">
    select refined_security_rules_id, original_security_rule_id FROM refined_security_rules WHERE status="DRAFT";
</sql:query>
    
<c:if test="${fn:length(check.rows) != 0}">
    <h3>Warning: There are still rules in DRAFT status.</h3>           
    <table border="1" width="100%">
    <tr>
        <c:forEach var="row" items="${check.rows}">
            <td><c:out value="${row.refined_security_rules_id}"/></th>
            <td><c:out value="${row.original_security_rule_id}"/></th>
        </c:forEach>
    </tr>
    </table><br /><br />
</c:if>
<%--END CHECK DRAFT RULES-----------------------------------------------------%>


<%--TABLE RULES---------------------------------------------------------------%>
<sql:query dataSource="${snapshot}" var="columnNames">
    <%--Uncomment if the name of the tables is the same as the name of the jsp files--%>
    <%--select column_name from information_schema.COLUMNS WHERE TABLE_SCHEMA LIKE 'muses' AND TABLE_NAME = '${fn:replace(fn:replace(pageContext.request.servletPath,'.jsp',''),'/','')}';--%>
    SELECT column_name FROM information_schema.COLUMNS WHERE TABLE_SCHEMA LIKE 'muses' AND TABLE_NAME = 'security_rules';
</sql:query>

<sql:query dataSource="${snapshot}" var="result">
    <%--Uncomment if the name of the tables is the same as the name of the jsp files--%>
    <%--select * from ${fn:replace(fn:replace(pageContext.request.servletPath,'.jsp',''),'/','')};--%>
    SELECT * FROM security_rules;
</sql:query>

<table border="1" width="100%">
    <tr>
        <c:forEach var="rowHeader" items="${columnNames.rows}">
            <th><c:out value="${rowHeader.COLUMN_NAME}"/></th>
        </c:forEach>
    </tr>

    <c:forEach var="rowBody" items="${result.rows}">
        <tr>
            <td><c:out value="${rowBody.security_rule_id}"/></td>
            <td><c:out value="${rowBody.name}"/></td>
            <td><c:out value="${rowBody.description}"/></td>
            <td><c:out value="${rowBody.file}"/></td>
            <td><c:out value="${rowBody.status}"/></td>
            <%--Strage value returned [B@43de6a4f instead of 0 or 1--%>
            <td><c:out value="${rowBody.refined}"/></td>
            <td><c:out value="${rowBody.source_id}"/></td>
            <td><c:out value="${rowBody.modification}"/></td>
        </tr>
    </c:forEach>
 </table><br /><br />
<%--END TABLE RULES-----------------------------------------------------------%>

<jsp:include page="modules/footer.jsp"></jsp:include>

