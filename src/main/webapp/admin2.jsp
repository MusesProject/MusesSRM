<%-- 
    Document   : admin2.jsp
    Created on : 19-jun-2015, 8:32:09
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

<%--Save user submited--%>
<c:choose><c:when test="${param.button=='New User'}">
    <c:catch var ="catchException">
    <sql:update dataSource="${snapshot}" var="result">
        INSERT INTO users(user_id,name,surname,email,username,password,trust_value,role_id,language) VALUES (?,?,?,?,?,?,?,?,?);
        <sql:param value="${param.user_id}" />
        <sql:param value="${param.name}" />
        <sql:param value="${param.surname}" />
        <sql:param value="${param.email}" />
        <sql:param value="${param.username}" />
        <sql:param value="${param.password}" />
        <sql:param value="${param.trust_value}" />
        <sql:param value="${param.role_id}" />
        <sql:param value="${param.language}" />
    </sql:update>
    </c:catch>
</c:when></c:choose>
        
<%--Remove user submited--%>
<c:choose><c:when test="${param.button=='Remove User'}">
    <c:catch var ="catchException">
    <sql:update dataSource="${snapshot}" var="result">
        DELETE FROM users WHERE user_id = ?
        <sql:param value="${param.user_id}" />
    </sql:update>
    </c:catch>
</c:when></c:choose>
      
<%--Save role submited--%>
<c:choose><c:when test="${param.button=='New Role'}">
    <c:catch var ="catchException">
    <sql:update dataSource="${snapshot}" var="result">
        INSERT INTO roles(role_id,name,description,security_level) VALUES (?,?,?,?);
        <sql:param value="${param.role_id}" />
        <sql:param value="${param.name}" />
        <sql:param value="${param.description}" />
        <sql:param value="${param.security_level}" />
    </sql:update>
    </c:catch>
</c:when></c:choose>
      
<%--Remove user submited--%>
<c:choose><c:when test="${param.button=='Remove Role'}">
    <c:catch var ="catchException">
    <sql:update dataSource="${snapshot}" var="result">
        DELETE FROM roles WHERE role_id = ?
        <sql:param value="${param.role_id}" />
    </sql:update>
    </c:catch>
</c:when></c:choose>
        
<%--Modify role submited--%>
<c:choose><c:when test="${param.button=='Modify Role'}">
    <c:catch var ="catchException">
    <sql:update dataSource="${snapshot}" var="result">
        UPDATE roles SET name = ?, description = ?, security_level = ? WHERE role_id = ?;
        <sql:param value="${param.name}" />
        <sql:param value="${param.description}" />
        <sql:param value="${param.security_level}" />
        <sql:param value="${param.role_id}" />
    </sql:update>
    </c:catch>
</c:when></c:choose>
        
<%--A exception was catched--%>
<c:choose><c:when test = "${catchException != null}">
    <h3>There is an exception: ${catchException.message}</h3>
</c:when></c:choose>
</c:if>
<%--END CONTROL SECTION-------------------------------------------------------%>

<%--FORM USER SECTION---------------------------------------------------------%>         
<sql:query dataSource="${snapshot}" var="result">
    SELECT role_id,name FROM roles;
</sql:query>
<form name="usuario" method="post" action="admin2.jsp">
    <fieldset>
        user_id: <input type="text" name="user_id" value="666"><br />
        name: <input type="text" name="name" value="proofdev"><br />
        surname: <input type="text" name="surname" value="proofdev"><br />
        email: <input type="text" name="email" value="proofdev@proofdev.com"><br />
        username: <input type="text" name="username" value="proofdev"><br />
        password: <input type="text" name="password" value="proofdev"><br />
        enabled: <input type="text" name="enabled" value="0"><br />
        trust_value: <input type="text" name="trust_value" value="666"><br />
        role:
        <select name="role_id">
            <c:forEach var="rowRoles" items="${result.rows}">
                <option value="<c:out value="${rowRoles.role_id}"/>"><c:out value="${rowRoles.name}"/></option>
            </c:forEach>
        </select>
        <br />
        language: <input type="text" name="language" value="en"><br />
            
        <input type="submit" name="button" value="New User">
        <input type="submit" name="button" value="Remove User">
    </fieldset>
</form>
<%--END FORM USER SECTION-----------------------------------------------------%> 
<br /><br />

<%--FORM ROLE SECTION---------------------------------------------------------%> 
<form name="rol" method="post" action="admin2.jsp">
    <fieldset>
        role_id: <input type="text" name="role_id" value="666"><br />
        name: <input type="text" name="name" value="The name of the role"><br />
        description: <input type="text" name="description" value="this is a description"><br />
        security_level: <input type="text" name="security_level" value="1"><br />
        <input type="submit" name="button" value="New Role">
        <input type="submit" name="button" value="Remove Role">
        <input type="submit" name="button" value="Modify Role">
    </fieldset>
</form>
<br /><br />
<%--END FORM ROLE SECTION-----------------------------------------------------%> 
<br /><br />

<%--USERS PREVIEW LIST--------------------------------------------------------%> 
<sql:query dataSource="${snapshot}" var="result">
    SELECT user_id, name, surname, email FROM users;
</sql:query>
      
<c:forEach var="rowBody" items="${result.rows}">
<form name="rol" method="post" action="profile.jsp">
    <fieldset>
        name: <c:out value="${rowBody.name}"/><br />
        surname: <c:out value="${rowBody.surname}"/><br />
        email: <c:out value="${rowBody.email}"/><br />
        <input type="hidden" name="user_id" value="${rowBody.user_id}">
        <input type="submit" name="button" value="Profile">
    </fieldset>
</form>
<br /><br />
</c:forEach>
<%--END USER PREVIEW LIST-----------------------------------------------------%>     

<%--TABLE ROLE SECTION--------------------------------------------------------%> 
<sql:query dataSource="${snapshot}" var="columnNames">
    SELECT column_name FROM information_schema.COLUMNS WHERE TABLE_SCHEMA LIKE 'muses' AND TABLE_NAME = 'roles';
</sql:query>
<sql:query dataSource="${snapshot}" var="result">
    SELECT * FROM roles;
</sql:query>
    
<table border="1" width="100%">
    <tr>
        <c:forEach var="rowHeader" items="${columnNames.rows}">
            <th><c:out value="${rowHeader.COLUMN_NAME}"/></th>
        </c:forEach>
    </tr>

    <c:forEach var="rowBody" items="${result.rows}">
        <tr>
            <td><c:out value="${rowBody.role_id}"/></td>
            <td><c:out value="${rowBody.name}"/></td>
            <td><c:out value="${rowBody.description}"/></td>
            <td><c:out value="${rowBody.security_level}"/></td>
        </tr>
    </c:forEach>
 </table><br /><br />
<%--END TABLE ROLE SECTION---------------------------------------------------%>     

<%--Debug post parameters--%>
<%--<c:out value="${param}"/>--%>
<jsp:include page="modules/footer.jsp"></jsp:include>

