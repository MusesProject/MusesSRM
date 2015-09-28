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
        
        <script>
            function displayUser(user_id) {
                <sql:query dataSource="${snapshot}" var="categories" scope="session">
                    SELECT user_id, name, surname, username, role_id, email, trust_value FROM users;
                </sql:query>
                    
                var parent = document.getElementById("list");
                var child1 = document.getElementById("userlist");
                var child2 = document.getElementById("pages");
                parent.removeChild(child1);
                parent.removeChild(child2);
                
                <c:forEach var="data" items="${categories.rows}">
                    var profile = document.createElement("div");
                    profile.setAttribute("class", "ui items");
                    var item = document.createElement("div");
                    item.setAttribute("class", "item");
                    var image = document.createElement("div");
                    image.setAttribute("class", "image");
                    var img_src = document.createElement("img");
                    img_src.setAttribute("src", "./resources/profile.png");
                    image.appendChild(img_src);
                    var content = document.createElement("div");
                    content.setAttribute("class", "content");
                    var header = document.createElement("div");
                    header.setAttribute("class", "header");
                    var header_text = document.createTextNode("#${data.user_id} - ${data.name} ${data.surname}");
                    header.appendChild(header_text);
                    var meta = document.createElement("div");
                    meta.setAttribute("class", "meta");
                    var username = document.createElement("span");
                    username.setAttribute("class", "stay");
                    var username_text = document.createTextNode("${data.username}");
                    username.appendChild(username_text);
                    meta.appendChild(username);
                    var description = document.createElement("div");
                    description.setAttribute("class", "description");
                    var role = document.createElement("p");
                    var role_text = document.createTextNode("Role: ${data.role_id}");
                    role.appendChild(role_text);
                    var email = document.createElement("p");
                    var email_text = document.createTextNode("${data.email}");
                    email.appendChild(email_text);
                    var trust = document.createElement("p");
                    var trust_text = document.createTextNode("Updated trust value = ${data.trust_value}");
                    trust.appendChild(trust_text);
                    description.appendChild(role);
                    description.appendChild(email);
                    description.appendChild(trust);
                    content.appendChild(header);
                    content.appendChild(meta);
                    content.appendChild(description);
                    item.appendChild(image);
                    item.appendChild(content);
                    profile.appendChild(item);
                </c:forEach>
                parent.appendChild(profile);
            }
        </script>

        <h2 class="ui center aligned icon header">
                <i class="users icon"></i>
                <div class="content">
                    User Management
                </div>
                </h2>
        <div class="ui divider"></div>
        <br>
        
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
                        <div class="ui button" onclick="displayUser(${user.user_id})">View</div>
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
