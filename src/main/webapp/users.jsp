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



        <sql:query dataSource="${snapshot}" var="users">
            SELECT user_id, name, surname FROM users;
        </sql:query>
    
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
                <br>

        <div class="ui middle aligned divided list">
          <c:forEach var="user" items="${users.rows}">
            <div class="item">
              <div class="right floated content">
                <div class="ui button">Modify</div>
              </div>
              <img class="ui avatar image" src="./resources/profile.png">
              <div class="content">
                #<c:out value="${user.user_id}"/> - <c:out value="${user.surname}"/>, <c:out value="${user.name}"/>
              </div>
            </div>
          </c:forEach>
        </div>





        <table class="ui celled table">
            <thead><tr>
                <th>user_id</th>

                <th>user name</th>
                <%--<th>device name</th>--%>
                <th>user surname</th>
            </tr></thead>
            <tbody>
            <c:forEach var="rowBody" items="${users.rows}">
                <tr>
                    <td><c:out value="${rowBody.user_id}"/></td>
                    <td><c:out value="${rowBody.name}"/></td>
                    <%--<td><c:out value="${rowBody.name2}"/></td>--%>
                    <td><c:out value="${rowBody.surname}"/></td>

                </tr>
            </c:forEach>
            </tbody>
            <tfoot>
            <tr><th colspan="3">
              <div class="ui right floated pagination menu">
                <a class="icon item">
                  <i class="left chevron icon"></i>
                </a>
                <a class="item">1</a>
                <a class="item">2</a>
                <a class="item">3</a>
                <a class="item">4</a>
                <a class="icon item">
                  <i class="right chevron icon"></i>
                </a>
              </div>
            </th>
          </tr></tfoot>
         </table><br /><br />

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
