<%-- 
    Document   : user_update
    Created on : 30-sep-2015, 17:49:10
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
        
        <sql:query dataSource="${snapshot}" var="data" scope="session">
   		SELECT * FROM users WHERE user_id="${param.id}";
        </sql:query>
                
        <sql:query dataSource="${snapshot}" var="categories" scope="session">
   		SELECT role_id, name FROM roles;
        </sql:query>
        
        <h2 class="ui center aligned icon header">
            <i class="edit icon"></i>
            <div class="content">
                Update User
            </div>
        </h2>
        <div class="ui divider"></div>
        <br>
        <c:if test="${not empty param.errMsg}">
            <div class="ui negative message"><c:out value="${param.errMsg}" /></div>
            <div class="ui purple animated button" onclick="location.href = 'users.jsp'">
                <div class="visible content">Back to User list</div>
                <div class="hidden content">
                    <i class="left arrow icon"></i>
                </div>
            </div>
            <br>
        </c:if>
        
        <c:forEach var="userdata" items="${data.rows}">
        <form class="ui form" method="POST" action="update_user_db.jsp?id=${userdata.user_id}">
            <div class="fields">
                <div class="field">
                    <label>Name</label>
                    <input placeholder="${userdata.name}" value="${userdata.name}" name="name" type="text">
                </div>
                <div class="field">
                    <label>Surname</label>
                    <input placeholder="${userdata.surname}" value="${userdata.surname}" name="surname" type="text">
                </div>
                <div class="field">
                    <label>Username</label>
                    <input placeholder="${userdata.username}" value="${userdata.username}" name="username" type="text">
                </div>
            </div>
            <div class="six wide field">
                <label>Email</label>
                <input placeholder="${userdata.email}" value="${userdata.email}" name="email" type="text">
            </div>
            <div class="six wide field">
                <label>Password</label>
                <input placeholder="******" value="${userdata.password}" name="password" type="password">
            </div>
            <div class="six wide field">
                <label>Do you like to enable or disable the account now?</label>
                <select class="ui dropdown" name="language">
                    <option value="1">Enable</option>
                    <option value="0">Disable</option>
                </select>
            </div>
            <div class="six wide field">
                <label>Trust value</label>
                <input placeholder="${userdata.trust_value}" value="${userdata.trust_value}" name="trust" type="text">
            </div>
            <div class="six wide field">
                <label>User role</label>
                <select class="ui dropdown" name="role_id">
                    <option value="">Select Role...</option>
                    <c:forEach var="role" items="${categories.rows}">
                    <option value="<c:out value='${role.role_id}'/>"><c:out value="${role.name}"/></option>
                    </c:forEach>
                </select>
            </div>
            <div class="six wide field">
                <label>Language</label>
                <select class="ui dropdown" name="language">
                    <option value="">Select Language...</option>
                    <option value="es">Spanish</option>
                    <option value="en">English</option>
                    <option value="fr">French</option>
                    <option value="de">German</option>
                    <option value="it">Italian</option>
                </select>
            </div>
            </c:forEach>
            <button class="ui purple button" type="submit" value="submit">Update user</button>
        </form>
        

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
