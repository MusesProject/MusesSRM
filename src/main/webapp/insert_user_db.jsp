<%-- 
    Document   : insert_user_db
    Created on : 30-sep-2015, 16:24:53
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
    
        <title>MUSES tool for CSOs - New User</title>
    </head>
    <body>

        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        
        <h2 class="ui center aligned icon header">
            <i class="add user icon"></i>
            <div class="content">
                New User
            </div>
        </h2>
        <div class="ui divider"></div>
        <br>
                
                <c:if test="${ empty param.name or empty param.surname or 
                               empty param.username or empty param.email or 
                               empty param.password or empty param.enable or 
                               empty param.surname or empty param.role_id or 
                               empty param.language}">
                <c:redirect url="user_add.jsp" >
                <c:param name="errMsg" value="Please Enter All information" />
            </c:redirect>
 
        </c:if>
 
        <sql:update dataSource="${snapshot}" var="result">
            INSERT INTO users(name,surname,email,username,password,enabled,trust_value,role_id,language) VALUES (?,?,?,?,?,?,1,?,?);
            <sql:param value="${param.name}" />
            <sql:param value="${param.surname}" />
            <sql:param value="${param.email}" />
            <sql:param value="${param.username}" />
            <sql:param value="${param.password}" />
            <sql:param value="${param.enable}" />
            <sql:param value="${param.role_id}" />
            <sql:param value="${param.language}" />
        </sql:update>
        
        <c:if test="${result>=1}">
            <c:redirect url="users.jsp" >
                <c:param name="susMsg" value="The user has been successfully inserted in the Database." />
            </c:redirect>
        </c:if>     

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
