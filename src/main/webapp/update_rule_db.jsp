<%-- 
    Document   : update_rule_db
    Created on : 19-oct-2015, 19:53:52
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
    
        <title>MUSES tool for CSOs - Updating Rule</title>
    </head>
    <body>

        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        
        <h2 class="ui center aligned icon header">
            <i class="file text icon"></i>           
            <div class="content">
                Rule Management
            </div>
        </h2>
        <div class="ui divider"></div>
        
        <br>
                
        <sql:update dataSource="${snapshot}" var="result">
            UPDATE security_rules SET status = ? WHERE security_rule_id='${param.id}';
            <sql:param value="${param.status}" />
        </sql:update>
        
        <c:if test="${result>=1}">
            <c:redirect url="rules.jsp" >
                <c:param name="susMsg" value="The rule has been successfully marked as ${param.status}." />
            </c:redirect>
        </c:if>
        
        <c:if test="${result<1}">
            <c:redirect url="rules.jsp" >
                <c:param name="errMsg" value="There has been an error updating the database." />
            </c:redirect>
        </c:if>

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
