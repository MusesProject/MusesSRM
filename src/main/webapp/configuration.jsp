<%-- 
    Document   : configuration
    Created on : 08-jun-2015, 9:38:38
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
        
    <%--Enable Silent Mode--%>
    <c:choose><c:when test="${param.button=='OFF'}">
        <c:catch var ="catchException">
        <sql:update dataSource="${snapshot}" var="result">
            update muses_config set silent_mode = 0 where config_name='SILENT';
        </sql:update>
        </c:catch>
    </c:when></c:choose>

    <%--Disable Silent Mode--%>
    <c:choose><c:when test="${param.button=='ON'}">
        <c:catch var ="catchException">
        <sql:update dataSource="${snapshot}" var="result">
            update muses_config set silent_mode = 1 where config_name='SILENT';
        </sql:update>
        </c:catch>
    </c:when></c:choose>

    <%--A exception was catched--%>
    <c:choose><c:when test = "${catchException != null}">
        <h3>There is an exception: ${catchException.message}</h3>
    </c:when></c:choose>

</c:if>
<%--END CONTROL SECTION-------------------------------------------------------%>

<%--SILENT MODE STATUS--------------------------------------------------------%> 
<sql:query dataSource="${snapshot}" var="statusMode">
    <%--Uncomment if the name of the tables is the same as the name of the jsp files--%>
    <%--select column_name from information_schema.COLUMNS WHERE TABLE_SCHEMA LIKE 'muses' AND TABLE_NAME = '${fn:replace(fn:replace(pageContext.request.servletPath,'.jsp',''),'/','')}';--%>
    select silent_mode from muses_config where config_name='SILENT';
</sql:query>

<%--From enable to disable--%>
<h3>The status is</h3>
<c:if test="${statusMode.rows[0].silent_mode=='1'}">
    <h3>The silent mode is ENABLE</h3><br/>
    <form name="modifyStatusMode" method="post" action="configuration.jsp">
        <fieldset>
            Silent Mode:<input type="submit" name="button" value="OFF">
        </fieldset>
    </form>
</c:if>

<%--From disable to enable--%>
<c:if test="${statusMode.rows[0].silent_mode=='0'}">
        <h3>The silent mode is DISABLE</h3><br/>
        <form name="modifyStatusMode" method="post" action="configuration.jsp">
            <fieldset>
                Silent Mode:<input type="submit" name="button" value="ON">
            </fieldset>
        </form>
</c:if>
<%--SILENT MODE STATUS--------------------------------------------------------%>     

<%--Debug post parameters--%>
<%--<c:out value="${param}"/>--%>
<jsp:include page="modules/footer.jsp"></jsp:include>

