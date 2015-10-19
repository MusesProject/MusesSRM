<%-- 
    Document   : policies
    Created on : 13-oct-2015, 10:55:30
    Author     : paloma
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.io.*,java.text.*,java.util.*"%>
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
        <fmt:formatDate value="${date}" pattern="yyyy-MM-dd" var="currentDate" />
        
        <sql:query dataSource="${snapshot}" var="result">
            SELECT count(*) as e, date FROM simple_events WHERE date(date)<='${currentDate}' AND date(date)>'${pastDate}' GROUP BY date;
        </sql:query>
        
        <sql:query dataSource="${snapshot}" var="sources">
   		SELECT source_id, name FROM sources;
        </sql:query>
        

        <title>MUSES tool for CSOs - Policy Management</title>
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
        
        <c:if test="${not empty param.errMsg}">
            <div class="ui negative message"><c:out value="${param.errMsg}" /></div>
            <br>
        </c:if>
            
        <c:if test="${not empty param.susMsg}">
            <div class="ui positive message"><c:out value="${param.susMsg}" /></div>
        </c:if>
        
        <form class="ui form" method="POST" action="insert_policy_db.jsp">
            <div class="field">
                <label>Name</label>
                <input type="text" name="name">
            </div>
            <div class="field">
                <label>Description</label>
                <textarea name="description"></textarea>
            </div>
            <div class="field">
                <label>File</label>
                <input type="file" name="file">
            </div>
            <div class="field">
                <label>Source</label>
                <select class="ui dropdown" name="source_id">
                    <option value="">Select Source...</option>
                    <c:forEach var="source" items="${sources.rows}">
                    <option value="<c:out value='${source.source_id}'/>"><c:out value="${source.name}"/></option>
                    </c:forEach>
                </select>
            </div>
            <button class="ui purple button" type="submit" value="submit">Add Policy</button>
        </form>

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
