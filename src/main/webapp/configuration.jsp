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
            UPDATE muses_config SET silent_mode=0, date=NOW() WHERE config_name='SILENT';
        </sql:update>
        </c:catch>
    </c:when></c:choose>

    <%--Disable Silent Mode--%>
    <c:choose><c:when test="${param.button=='ON'}">
        <c:catch var ="catchException">
        <sql:update dataSource="${snapshot}" var="result">
            UPDATE muses_config SET silent_mode=1, date=NOW() WHERE config_name='SILENT';
        </sql:update>
        </c:catch>
    </c:when></c:choose>
    
    <%--Modify connection config--%>
    <c:choose><c:when test="${param.button=='Modify Config'}">
        <c:catch var ="catchException">
        <sql:update dataSource="${snapshot}" var="result">
            UPDATE connection_config SET timeout = ?, poll_timeout = ?, sleep_poll_timeout = ?, polling_enabled = ?, login_attempts = ? WHERE config_id = "1";
            <sql:param value="${param.timeout}" />
            <sql:param value="${param.poll_timeout}" />
            <sql:param value="${param.sleep_poll_timeout}" />
            <sql:param value="${param.polling_enabled}" />
            <sql:param value="${param.login_attempts}" />
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
    select silent_mode from muses_config where config_name='SILENT';
</sql:query>

<%--From enable to disable--%>
<h3>The status is</h3>
<c:if test="${statusMode.rows[0].silent_mode=='1'}">
    <h3>The silent mode is ENABLED</h3><br/>
    <form name="modifyStatusMode" method="post" action="configuration.jsp">
        <fieldset>
            Silent Mode:<input type="submit" name="button" value="OFF">
        </fieldset>
    </form><br /><br />
</c:if>

<%--From disable to enable--%>
<c:if test="${statusMode.rows[0].silent_mode=='0'}">
        <h3>The silent mode is DISABLED</h3><br/>
        <form name="modifyStatusMode" method="post" action="configuration.jsp">
            <fieldset>
                Silent Mode:<input type="submit" name="button" value="ON">
            </fieldset>
        </form><br /><br />
</c:if>
<%--END SILENT MODE STATUS----------------------------------------------------%>


<%--CONNECTIONS CONFIG TABLE--------------------------------------------------%> 
<sql:query dataSource="${snapshot}" var="result">
    SELECT * FROM connection_config WHERE config_id = "1";
</sql:query>
    
<form name="modifyStatusMode" method="post" action="configuration.jsp">
    <fieldset>
        timeout: <input type="text" name="timeout" value="${result.rows[0].timeout}"><br />
        poll_timeout: <input type="text" name="poll_timeout" value="${result.rows[0].poll_timeout}"><br />
        sleep_poll_timeout: <input type="text" name="sleep_poll_timeout" value="${result.rows[0].sleep_poll_timeout}"><br />
        <select name="polling_enabled">
            <c:choose>
                <c:when test="${result.rows[0].polling_enabled==true}">
                    <option value="1"/>enabled</option>
                    <option value="0"/>disabled</option>
                </c:when>
                <c:when test="${result.rows[0].polling_enabled==false}">
                    <option value="0"/>disabled</option>
                    <option value="1"/>enabled</option>
                </c:when>
            </c:choose>
        </select><br />
        login_attempts: <input type="text" name="login_attempts" value="${result.rows[0].login_attempts}"><br />
        
        <input type="submit" name="button" value="Modify Config">
    </fieldset>
</form><br /><br />
<%--CONNECTIONS CONFIG TABLE--------------------------------------------------%> 

<%--Debug post parameters--%>
<c:out value="${param}"/>
<c:out value="${result.rows[0].polling_enabled}"/>
<jsp:include page="modules/footer.jsp"></jsp:include>

