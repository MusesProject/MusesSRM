<%-- 
    Document   : assets
    Created on : 26-mar-2015, 16:03:53
    Author     : unintendedbear
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
            SELECT * FROM assets;
        </sql:query>

        <title>MUSES tool for CSOs - Assets</title>
    </head>
    <body>
        
        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        
        <h2 class="ui center aligned icon header">
            <i class="sitemap icon"></i>           
            <div class="content">
                Assets Information Panel
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
        
        <c:set var="totalCount" scope="session" value="${result.rowCount}"/>
        
        <c:if test="${totalCount == 0 }">
            <c:redirect url="assets.jsp" >
                <c:param name="errMsg" value="No assets in the database." />
            </c:redirect>
        </c:if>
        
        <c:set var="perPage" scope="session" value="30"/>
        <c:set var="totalPages" scope="session" value="${totalCount/perPage}"/>

        <c:set var="pageIndex" scope="session" value="${param.start/perPage+1}"/>

        <table class="ui celled table">
            <thead>
                <tr>
                    <th>#Asset</th>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Value</th>
                    <th>Confidentiality Level</th>
                    <th>Location</th>
                    <th>Available From</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="rowBody" items="${result.rows}" begin="${param.start}" end="${param.start+perPage}">
                <tr>
                    <td><c:out value="${rowBody.asset_id}"/></td>
                    <td><c:out value="${rowBody.title}"/></td>
                    <td><c:out value="${rowBody.description}"/></td>
                    <c:choose>
                        <c:when test="${not empty param.assetid and rowBody.asset_id == param.assetid}">
                            <td>
                                <form class="ui form" method="POST" action="update_asset_db.jsp?assetid=${rowBody.asset_id}">
                                    <div class="field">
                                        <input placeholder="${rowBody.value}" name="newValue" type="text">
                                    </div>
                                    <button class="ui purple button" type="submit" value="submit">Update Value</button>
                                </form>
                            </td>
                        </c:when>
                        <c:otherwise>
                            <td><c:out value="${rowBody.value}"/> 
                                <div class="right floated content">
                                    <div class="ui button" onclick="location.href = 'assets.jsp?assetid=${rowBody.asset_id}'">Change</div>
                                </div>
                            </td>
                        </c:otherwise>
                    </c:choose>
                    <td><c:out value="${rowBody.confidential_level}"/></td>
                    <td><c:out value="${rowBody.location}"/></td>
                    <td><c:out value="${rowBody.available}"/></td>
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
        <br /><br />

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
