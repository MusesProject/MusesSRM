<%-- 
    Document   : user_add
    Created on : 30-sep-2015, 14:36:45
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
        
        <sql:query dataSource="${snapshot}" var="categories" scope="session">
   		SELECT role_id, name FROM roles;
        </sql:query>        
        
        <h2 class="ui center aligned icon header">
            <i class="add user icon"></i>
            <div class="content">
                New User
            </div>
        </h2>
        <div class="ui divider"></div>
        <br>
        <c:if test="${not empty param.errMsg}">
            <c:out value="${param.errMsg}" />
            <div class="ui purple animated button" onclick="location.href = 'user_add.jsp'">
                <div class="visible content">Back to form</div>
                <div class="hidden content">
                    <i class="left arrow icon"></i>
                </div>
            </div>
            <br>
        </c:if>
        
        <form class="ui form" method="POST" action="insert_user_db.jsp">
            <div class="fields">
                <div class="field">
                    <label>Name</label>
                    <input placeholder="Name" name="name" type="text">
                </div>
                <div class="field">
                    <label>Surname</label>
                    <input placeholder="Surname" name="surname" type="text">
                </div>
                <div class="field">
                    <label>Username</label>
                    <input placeholder="Username" name="username" type="text">
                </div>
            </div>
            <div class="six wide field">
                <label>Email</label>
                <div class="ui left icon input">
                    <input type="text" name="email" placeholder="Email">
                    <i class="at icon"></i>
                </div>
            </div>
            <div class="six wide field">
                <label>Password</label>
                <div class="ui left icon input">
                    <input type="password" name="password" placeholder="******">
                    <i class="lock icon"></i>
                </div>
            </div>
            <div class="six wide field">
                <label>Do you like to enable the account now?</label>
                <select class="ui dropdown" name="language">
                    <option value="1">Yes</option>
                    <option value="0">No</option>
                </select>
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
            <button class="ui purple button" type="submit" value="submit">Add user</button>
        </form>
        

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
