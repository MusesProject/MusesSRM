<%-- 
    Document   : behaviour
    Created on : 26-mar-2015, 16:59:05
    Author     : unintendedbear
    Author     : Juan Luis Martin Acal <jlmacal@gmail.com>
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
        
        <sql:query dataSource="${snapshot}" var="result" scope="session" >
            SELECT * FROM simple_events WHERE event_type_id = '27' ORDER BY date, time DESC;
        </sql:query>

        <title>MUSES tool for CSOs - User Behaviour</title>
    </head>
    <body>
        
        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        
        <h2 class="ui center aligned icon header">
            <i class="user icon"></i>           
            <div class="content">
                User Behaviour Information
            </div>
        </h2>
        <div class="ui divider"></div>
        
        <br>
        
        <c:set var="totalCount" scope="session" value="${result.rowCount}"/>
        
        <c:if test="${totalCount == 0 }">
            <c:redirect url="assets.jsp" >
                <c:param name="errMsg" value="No assets in the database." />
            </c:redirect>
        </c:if>
        
        <c:set var="perPage" scope="session" value="15"/>
        <c:set var="totalPages" scope="session" value="${totalCount/perPage}"/>

        <c:set var="pageIndex" scope="session" value="${param.start/perPage+1}"/>

        <table class="ui celled table">
            <thead>
                <tr>
                    <th>#Event</th>
                    <th>#User</th>
                    <th>#Device</th>
                    <th>#App</th>
                    <th>#Asset</th>
                    <th>JSON message</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>#Source</th>
                    <th>EP</th>
                    <th>RT2AE</th>
                    <th>KRS</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="rowBody" items="${result.rows}" begin="${param.start}" end="${param.start+perPage}">
                <tr>
                    <td><c:out value="${rowBody.event_id}"/></td>
                    <td><c:out value="${rowBody.user_id}"/></td>
                    <td><c:out value="${rowBody.device_id}"/></td>
                    <td><c:out value="${rowBody.app_id}"/></td>
                    <td><c:out value="${rowBody.asset_id}"/></td>
                    <td>
                        <c:choose>
                            <c:when test="${fn:length(rowBody.data)>130}">
                                <c:set var="string" value="${fn:substring(rowBody.data, 0, 130)}" />
                                <c:out value="${string}"/>...
                                <div class="ui warning message">
                                    Text is too long, use a MySQL client.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:out value="${rowBody.data}"/>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td><c:out value="${rowBody.date}"/></td>
                    <td><c:out value="${rowBody.time}"/></td>
                    <td><c:out value="${rowBody.source_id}"/></td>
                    <td><c:out value="${rowBody.EP_can_access}"/></td>
                    <td><c:out value="${rowBody.RT2AE_can_access}"/></td>
                    <td><c:out value="${rowBody.KRS_can_access}"/></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>       
        
        <div class="ui purple right floated pagination inverted menu" id="pages">
            <c:if test="${!empty param.start && param.start >(perPage-1) && param.start !=0 }">
              <a class="icon item" href="?start=<c:out value="${param.start - perPage}"/>">
                   <i class="left chevron icon"></i>
              </a>
            </c:if>

            <c:if test="${empty param.start || param.start<(totalCount-perPage)}">
                <a class="icon item" href="?start=<c:out value="${param.start + perPage}"/>">
                     <i class="right chevron icon"></i>
                </a>
            </c:if>
        </div>
        <br /><br />

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
