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
    
        <title>MUSES tool for CSOs - Delete User</title>
    </head>
    <body>

        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        
        <h2 class="ui center aligned icon header">
            <i class="add user icon"></i>
            <div class="content">
                Deleting User
            </div>
        </h2>
        <div class="ui divider"></div>
        <br>
                
        <sql:update dataSource="${snapshot}" var="count">
            DELETE FROM users WHERE user_id='${param.id}';
        </sql:update>
            
        <c:if test="${count>=1}">
            <c:redirect url="users.jsp" >
                <c:param name="susMsg" value="The user has been successfully deleted from the Database." />
            </c:redirect>          
        </c:if>     

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
