<%-- 
    Document   : policies
    Created on : 26-mar-2015, 16:19:57
    Author     : unintendedbear
    Author     : Juan Luis Martin Acal <jlmacal@gmail.com>
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">



<html>
    <head>
        
        <sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
                           url="jdbc:mysql://localhost/muses"
                           user="muses"  password="muses11"/> 
        
        <sql:query dataSource="${snapshot}" var="columnNames">
        <%--Uncomment if the name of the tables is the same as the name of the jsp files--%>
        <%--select column_name from information_schema.COLUMNS WHERE TABLE_SCHEMA LIKE 'muses' AND TABLE_NAME = '${fn:replace(fn:replace(pageContext.request.servletPath,'.jsp',''),'/','')}';--%>
            SELECT column_name FROM information_schema.COLUMNS WHERE TABLE_SCHEMA LIKE 'muses' AND TABLE_NAME = 'security_rules';
        </sql:query>

        <sql:query dataSource="${snapshot}" var="result">
            SELECT * FROM security_rules;
        </sql:query>

        <title>MUSES tool for CSOs - Security Rules</title>
    </head>
    <body>
        
        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        
        <h2 class="ui center aligned icon header">
            <i class="university icon"></i>
            <div class="content">
                Security Rules
            </div>
        </h2>
        <div class="ui divider"></div>
        
        <c:set var="totalCount" scope="session" value="${result.rowCount}"/>
        <c:set var="perPage" scope="session" value="2"/>
        <c:set var="totalPages" scope="session" value="${totalCount/perPage}"/>

        <c:set var="pageIndex" scope="session" value="${param.start/perPage+1}"/>

        <table class="ui celled table">
            <thead><tr>
                <c:forEach var="rowHeader" items="${columnNames.rows}">
                    <th><c:out value="${rowHeader.COLUMN_NAME}"/></th>
                </c:forEach>
            </tr></thead>
        <tbody>
        <c:forEach var="rowBody" items="${result.rows}" begin="${param.start}" end="${param.start+perPage}">
            <tr>
                <td><c:out value="${rowBody.security_rule_id}"/></td>
                <td><c:out value="${rowBody.name}"/></td>
                <td><c:out value="${rowBody.description}"/></td>
                <td><c:out value="${rowBody.file}"/></td>
                <td><c:out value="${rowBody.status}"/></td>
                <td><c:out value="${rowBody.refined}"/></td>
                <td><c:out value="${rowBody.source_id}"/></td>
                <td><c:out value="${rowBody.modification}"/></td>
            </tr>
        </c:forEach>
        </tbody>
        
 </table>
        
 <div class="ui purple right floated pagination inverted menu" id="pages">
    <c:if test="${!empty param.start && param.start >(perPage-1) && param.start !=0 }">
      <a class="icon item" href="?start=<c:out value="${param.start - perPage}"/>">
           <i class="left chevron icon"></i>
      </a>
    </c:if>

    <c:forEach var="boundaryStart" varStatus="status" begin="0" end="${totalCount - 1}" step="${perPage}">
        <c:choose>
            <c:when test="${status.count>0 && status.count != pageIndex}">
                <a class="item" href="?start=<c:out value='${boundaryStart}'/>">
                    <c:out value="${status.count}"/>
                </a>
            </c:when>
            <c:otherwise>
                <a class="active item">
                    <c:out value="${status.count}"/>
                </a>
            </c:otherwise>
        </c:choose>
    </c:forEach>

    <c:if test="${empty param.start || param.start<(totalCount-perPage)}">
        <a class="icon item" href="?start=<c:out value="${param.start + perPage}"/>">
             <i class="right chevron icon"></i>
        </a>
    </c:if>
</div>
        <br /><br />

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
