<%-- 
    Document   : insert_user_db
    Created on : 30-sep-2015, 17:25:33
    Author     : paloma
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
    
        <title>MUSES tool for CSOs - Updating User</title>
    </head>
    <body>

        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        
        <h2 class="ui center aligned icon header">
            <i class="edit icon"></i>
            <div class="content">
                Update User
            </div>
        </h2>
        <div class="ui divider"></div>
        <br>
                
                <c:if test="${ empty param.name and empty param.surname and 
                               empty param.username and empty param.email and 
                               empty param.password and empty param.enable and 
                               empty param.surname and empty param.role_id and 
                               empty param.language}">
                <c:redirect url="user_update?id=${param.id}.jsp" >
                <c:param name="errMsg" value="You are not changing any information" />
            </c:redirect>
 
        </c:if>
        
        <sql:query dataSource="${snapshot}" var="data" scope="session">
   		SELECT role_id, language FROM users WHERE user_id="${param.id}";
        </sql:query>
         
        <sql:update dataSource="${snapshot}" var="result">
            UPDATE users SET name = ?, surname = ?, email = ?, username = ?, password = ?, enabled = ?, trust_value = ?, role_id = ?, language = ? WHERE user_id='${param.id}';
            <sql:param value="${param.name}" />
            <sql:param value="${param.surname}" />
            <sql:param value="${param.email}" />
            <sql:param value="${param.username}" />
            <sql:param value="${param.password}" />
            <c:choose>
                <c:when test="${param.enable==0}"><sql:param value="${param.enable}" /></c:when>
                <c:otherwise><sql:param value="1" /></c:otherwise>
            </c:choose>
            <sql:param value="${param.trust}" />
            <c:choose>
                <c:when test="${empty param.role_id}">
                    <c:forEach var="userdata" items="${data.rows}">
                        <sql:param value="${userdata.role_id}" />
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <sql:param value="${param.role_id}" />
                </c:otherwise>
            </c:choose>
            <c:choose>
                <c:when test="${empty param.language}">
                    <c:forEach var="userdata" items="${data.rows}">
                        <sql:param value="${userdata.language}" />
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <sql:param value="${param.language}" />
                </c:otherwise>
            </c:choose>
        </sql:update>
        
        <c:if test="${result>=1}">
            <c:redirect url="users.jsp" >
                <c:param name="susMsg" value="The user has been successfully updated." />
            </c:redirect>
        </c:if>     

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
