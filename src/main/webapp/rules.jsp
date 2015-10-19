<%-- 
    Document   : rules
    Created on : 09-jun-2015, 12:03:54
    Author     : paloma
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.io.*,java.text.*,java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">



<html>
    <head>
        
        <sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
                           url="jdbc:mysql://localhost/muses"
                           user="muses"  password="muses11"/> 
        
        <!-- Obtaining today's date -->
        <jsp:useBean id="date" class="java.util.Date" />
        <fmt:formatDate value="${date}" pattern="yyyy-MM-dd HH:mm:ss" var="currentDate" />
        
        <sql:query dataSource="${snapshot}" var="result">
            SELECT * FROM security_rules WHERE status = 'DRAFT';
        </sql:query>
        

        <title>MUSES tool for CSOs - Rule Management</title>
    </head>
    <body>
        
        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        
        
        
        <h2 class="ui center aligned icon header">
            <i class="file text icon"></i>           
            <div class="content">
                Rule Management
            </div>
        </h2>
        <div class="ui divider"></div>
        
        <br>
        
        <c:if test="${not empty param.errMsg}">
            <div class="ui negative message"><c:out value="${param.errMsg}" /></div>
            <br>
        </c:if>
            
        <c:if test="${not empty param.susMsg}">
            <div class="ui positive message"><c:out value="${param.susMsg}" /></div>
        </c:if>
        
        <c:set var="totalCount" scope="session" value="${result.rowCount}"/>
        <c:set var="perPage" scope="session" value="10"/>
        <c:set var="totalPages" scope="session" value="${totalCount/perPage}"/>

        <c:set var="pageIndex" scope="session" value="${param.start/perPage+1}"/>
        
        
        <div  id="list">
        <div class="ui middle aligned divided list" id="userlist">
            <c:forEach var="rule" items="${result.rows}" begin="${param.start}" end="${param.start+perPage}">
                <div class="item">
                    <div class="right floated content">
                        <div class="ui button" onclick="location.href = 'update_rule_db.jsp?id=${rule.security_rule_id}'">Approve</div>
                    </div>
                    <img class="ui avatar image" src="./resources/rule_profile.png">
                    <div class="content">
                        #<c:out value="${rule.security_rule_id}"/> - <c:out value="${rule.description}"/> (<c:out value="${rule.modification}"/>)
                    </div>
                </div>
            </c:forEach>
        </div>

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

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>


