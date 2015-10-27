<%-- 
    Document   : update_configuration_db
    Created on : 27-oct-2015, 16:54:59
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
    
        <title>MUSES tool for CSOs - MUSES Configuration</title>
    </head>
    <body>

        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        
        <h2 class="ui center aligned icon header">
            <i class="configure icon"></i>           
            <div class="content">
                MUSES Configuration
            </div>
        </h2>
        <div class="ui divider"></div>
        
        <br>
        
        <c:choose>
            <c:when test="${param.parameter == 'timeout' and empty param.newTimeout}">
                <c:redirect url="configuration.jsp" >
                    <c:param name="errMsg" value="Please enter a valid ${parameter} number." />
                </c:redirect>
            </c:when>
            <c:otherwise>
                <sql:update dataSource="${snapshot}" var="result">
                    UPDATE connection_config SET timeout = ? WHERE config_id = '${param.configid}';
                    <sql:param value="${param.newTimeout}" />
                </sql:update>
            </c:otherwise>
        </c:choose>        
        
        <c:if test="${result>=1}">
            <c:redirect url="configuration.jsp" >
                <c:param name="susMsg" value="The value of ${param.parameter} has been successfully updated." />
            </c:redirect>
        </c:if>     

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
