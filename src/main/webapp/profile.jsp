<%-- 
    Document   : profile
    Created on : 19-jun-2015, 9:12:38
    Author     : Juan Luis Martin Acal <jlmacal@gmail.com>
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
                   url="jdbc:mysql://localhost/muses"
                   user="muses"  password="muses11"/>

<jsp:include page="modules/header.jsp"></jsp:include>
<jsp:include page="modules/menu.jsp"></jsp:include>

<%--CONTROL SECTION-----------------------------------------------------------%>    
<%--POST catched--%>
<c:if test="${pageContext.request.method=='POST'}">
 
<%--Show user submited profile--%>
    <c:choose><c:when test="${param.button=='Profile'}">    
        <sql:query dataSource="${snapshot}" var="rowBody">
            SELECT user_id, name, surname, email, username, SHA2(password,512) AS password, enabled, trust_value, role_id, language FROM users WHERE user_id = ?;
            <sql:param value="${param.user_id}" />
        </sql:query>
        <form name="usuario" method="post" action="profile.jsp">
            <fieldset>
            <legend>USER PROFILE:</legend>
                ID:<input type="text" name="user_id" value="${rowBody.rows[0].user_id}"/><br /><br />
                Name:<input type="text" name="name" value="${rowBody.rows[0].name}"/><br /><br />
                Surname:<input type="text" name="surname" value="${rowBody.rows[0].surname}"/><br /><br />
                Email:<input type="text" name="email" value="${rowBody.rows[0].email}"/><br /><br />
                Username:<input type="text" name="username" value="${rowBody.rows[0].username}"/><br /><br />
                Password:<input type="text" name="password" value=""/><br /><br />
                Enable:<input type="text" name="enabled" value="${rowBody.rows[0].enabled}"/><br /><br />
                Trust:<input type="text" name="trust_value" value="${rowBody.rows[0].trust_value}"/><br /><br />
                ID Role:<input type="text" name="role_id" value="${rowBody.rows[0].role_id}"/><br /><br />
                Laguage:<input type="text" name="language" value="${rowBody.rows[0].language}"/><br /><br />
                <input type="hidden" name="user_id" value="${rowBody.rows[0].user_id}">
                <input type="submit" name="button" value="Modify User">
            </fieldset>
        </form>
    </c:when></c:choose>
    
<%--Modify user submited--%>
    <c:choose><c:when test="${param.button=='Modify User'}">
        <c:catch var ="catchException">
        <sql:update dataSource="${snapshot}" var="result">
            UPDATE users SET name = ?, surname = ?, email = ?, username = ?, password = ?, trust_value = ?, role_id = ?, language = ? WHERE user_id = ?;
            <sql:param value="${param.name}" />
            <sql:param value="${param.surname}" />
            <sql:param value="${param.email}" />
            <sql:param value="${param.username}" />
            <sql:param value="${param.password}" />
            <sql:param value="${param.trust_value}" />
            <sql:param value="${param.role_id}" />
            <sql:param value="${param.language}" />
            <sql:param value="${param.user_id}" />
        </sql:update>
            
        <sql:query dataSource="${snapshot}" var="rowBody">
            SELECT user_id, name, surname, email, username, SHA2(password,512) AS password, enabled, trust_value, role_id, language FROM users WHERE user_id = ?;
            <sql:param value="${param.user_id}" />
        </sql:query>

        <form name="usuario" method="post" action="profile.jsp">
            <fieldset>
            <legend>USER PROFILE:</legend>
                ID:<input type="text" name="user_id" value="${rowBody.rows[0].user_id}"/><br /><br />
                Name:<input type="text" name="name" value="${rowBody.rows[0].name}"/><br /><br />
                Surname:<input type="text" name="surname" value="${rowBody.rows[0].surname}"/><br /><br />
                Email:<input type="text" name="email" value="${rowBody.rows[0].email}"/><br /><br />
                Username:<input type="text" name="username" value="${rowBody.rows[0].username}"/><br /><br />
                Password:<input type="text" name="password" value=""/><br /><br />
                Enable:<input type="text" name="trust_value" value="${rowBody.rows[0].enabled}"/><br /><br />
                Trust:<input type="text" name="trust_value" value="${rowBody.rows[0].trust_value}"/><br /><br />
                ID Role:<input type="text" name="role_id" value="${rowBody.rows[0].role_id}"/><br /><br />
                Laguage:<input type="text" name="language" value="${rowBody.rows[0].language}"/><br /><br />
                <input type="hidden" name="user_id" value="${rowBody.rows[0].user_id}">
                <input type="submit" name="button" value="Modify User">
            </fieldset>
        </form>
        </c:catch>
    </c:when></c:choose>
            
<%--A exception was catched--%>
    <c:choose><c:when test = "${catchException != null}">
        <h3>There is an exception: ${catchException.message}</h3>
    </c:when></c:choose>
        
</c:if>
<%--END CONTROL SECTION-------------------------------------------------------%>

<%--Debug post parameters--%>
<%--<c:out value="${param}"/>--%>
<jsp:include page="modules/footer.jsp"></jsp:include>