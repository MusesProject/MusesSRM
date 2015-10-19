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

<html>
    <head>

        <sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
                           url="jdbc:mysql://localhost/muses"
                           user="muses"  password="muses11"/>      
    
        <title>MUSES tool for CSOs - User Management</title>
    </head>
    <body>

        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        
        
        <h2 class="ui center aligned icon header">
            <i class="users icon"></i>
            <div class="content">
                User Management
            </div>
        </h2>
        <div class="ui divider"></div>
        
        <c:if test="${not empty param.susMsg}">
            <div class="ui positive message"><c:out value="${param.susMsg}" /></div>
        </c:if>
        
        <div class="ui grid">
            <div class="row">
            <div class="ui purple animated right floated button" onclick="location.href = 'user_add.jsp'">
                <div class="visible content">New User</div>
                <div class="hidden content">
                    <i class="add user icon"></i>
                </div>
            </div>
            </div>
        </div>
        
        
        <sql:query dataSource="${snapshot}" var="categories" scope="session">
   		SELECT user_id, name, surname FROM users;
        </sql:query>
                
        <c:set var="totalCount" scope="session" value="${categories.rowCount}"/>
        <c:set var="perPage" scope="session" value="10"/>
        <c:set var="totalPages" scope="session" value="${totalCount/perPage}"/>

        <c:set var="pageIndex" scope="session" value="${param.start/perPage+1}"/>
        
        
        <div  id="list">
        <div class="ui middle aligned divided list" id="userlist">
            <c:forEach var="user" items="${categories.rows}" begin="${param.start}" end="${param.start+perPage}">
                <div class="item">
                    <div class="right floated content">
                        <div class="ui button" onclick="location.href = 'user_profile.jsp?userid=${user.user_id}'">View</div>
                    </div>
                    <img class="ui avatar image" src="./resources/profile.png">
                    <div class="content">
                        #<c:out value="${user.user_id}"/> - <c:out value="${user.surname}"/>, <c:out value="${user.name}"/>
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
