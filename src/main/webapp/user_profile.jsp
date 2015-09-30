<%-- 
    Document   : user_profile
    Created on : 30-sep-2015, 10:41:28
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
    
        <title>MUSES tool for CSOs - User Management</title>
    </head>
    <body>

        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        
        <c:set var="userid" value="${param.userid}"/>
        
        <sql:query dataSource="${snapshot}" var="user" scope="session">
            SELECT user_id, name, surname, username, role_id, email, trust_value FROM users WHERE user_id = '${userid}';
        </sql:query>

        <h2 class="ui center aligned icon header">
                <i class="users icon"></i>
                <div class="content">
                    User Profile
                </div>
                </h2>
        <div class="ui divider"></div>
        <br>
        
        <div class="ui items">
            <c:forEach var="data" items="${user.rows}">
            <div class="item">
                <div class="image">
                    <img src="./resources/profile.png">
                </div>
                <div class="content">
                    <a class="header">#${data.user_id} - ${data.name} ${data.surname}</a>
                    <div class="meta">
                        <span>${data.username}</span>
                    </div>
                    <div class="description">
                        <sql:query dataSource="${snapshot}" var="role" scope="session">
                            SELECT name FROM roles WHERE role_id = '${data.role_id}';
                        </sql:query>
                        <c:forEach var="roledata" items="${role.rows}">
                        <p>User role: ${roledata.name}</p>
                        </c:forEach>
                        <p>Email: ${data.email}</p>
                    </div>
                    <div class="extra">
                        Updated trust value: ${data.trust_value}
                    </div>
                </div>
            </div>
            </c:forEach>
        </div>
        
        
                    
        <div class="ui purple animated button" tabindex="0" onclick="location.href = 'policies.jsp'">
            <div class="visible content">Update User</div>
            <div class="hidden content">
                <i class="edit icon"></i>
            </div>
        </div>        
        <div class="ui purple animated button" tabindex="0"  onclick="location.href = 'rules.jsp'">
            <div class="visible content">Delete User</div>
            <div class="hidden content">
                <i class="remove user icon"></i>
            </div>
        </div>        
        <div class="ui purple animated button" tabindex="0"  onclick="location.href = 'users.jsp'">
            <div class="visible content">Back</div>
            <div class="hidden content">
                <i class="left arrow icon"></i>
            </div>
        </div>
        
        

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
