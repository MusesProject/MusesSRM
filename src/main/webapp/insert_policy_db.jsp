<%-- 
    Document   : insert_policy_db
    Created on : 19-oct-2015, 10:49:45
    Author     : paloma
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>

        <sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
                           url="jdbc:mysql://localhost/muses"
                           user="muses"  password="muses11"/>
        
        <!-- Obtaining today's date -->
        <jsp:useBean id="date" class="java.util.Date" />
        <fmt:formatDate value="${date}" pattern="yyyy-MM-dd HH:mm:ss" var="currentDate" />
    
        <title>MUSES tool for CSOs - New Policy</title>
    </head>
    <body>

        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        
        <h2 class="ui center aligned icon header">
            <i class="file text icon"></i>           
            <div class="content">
                Policy Management
            </div>
        </h2>
        <div class="ui divider"></div>
        
        <br>
                
                <c:if test="${ empty param.name or empty param.description or 
                               empty param.file or empty param.source_id}">
                <c:redirect url="policies.jsp" >
                <c:param name="errMsg" value="Please Enter All information" />
            </c:redirect>
 
        </c:if>
 
        <sql:update dataSource="${snapshot}" var="result">
            INSERT INTO security_rules(name,description,file,status,refined,source_id,modification) VALUES (?,?,?,'VALIDATED',0,?,?);
            <sql:param value="${param.name}" />
            <sql:param value="${param.description}" />
            <sql:param value="${param.file}" />
            <sql:param value="${param.source_id}" />
            <sql:param value="${currentDate}" />
        </sql:update>
        
        <c:if test="${result>=1}">
            <c:redirect url="policies.jsp" >
                <c:param name="susMsg" value="The policy has been successfully inserted in the Database." />
            </c:redirect>
        </c:if>     

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
