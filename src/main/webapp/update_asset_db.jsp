<%-- 
    Document   : update_asset_db
    Created on : 20-oct-2015, 12:25:53
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
                
        <c:if test="${empty param.newValue}">
            <c:redirect url="assets.jsp?assetid=${param.assetid}" >
                <c:param name="errMsg" value="Please enter a valid value number." />
            </c:redirect>
        </c:if>
        
        <sql:update dataSource="${snapshot}" var="result">
            UPDATE assets SET value = ? WHERE asset_id = '${param.assetid}';
            <sql:param value="${param.newValue}" />
        </sql:update>
        
        <c:if test="${result>=1}">
            <c:redirect url="assets.jsp" >
                <c:param name="susMsg" value="The value of asset #${param.assetid} has been successfully updated." />
            </c:redirect>
        </c:if>     

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
