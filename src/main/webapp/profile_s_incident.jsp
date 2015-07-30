<%-- 
    Document   : profile_s_incident.jsp
    Created on : 30-jul-2015, 11:21:05
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

    <c:catch var ="catchException">
    <c:out value="ENTRO EN LOS SELECTS"/>
    <sql:query dataSource="${snapshot}" var="decision_dated">
        SELECT decision_id FROM decision WHERE time > ? AND time < ? + INTERVAL 1 DAY;
        <sql:param value="${param.date}" />
        <sql:param value="${param.date}" />
    </sql:query>
    
    <sql:query dataSource="${snapshot}" var="event_dated">
        SELECT event_id FROM simple_events WHERE date = ?;
        <sql:param value="${param.date}" />
    </sql:query>
    </c:catch>
    
    <%--FORM INSERT SECURITY EVENT--------------------------------------------%> 
    <form name="usuario" method="post" action="profile_s_incidents.jsp">
        <fieldset>
            <table>
                <tr>
                    <td><label>Name:</label></td>
                    <td><input type="text" name="name" value="Test Security Incident SRM"/></td>
                </tr>
                <tr>
                <td><label>Decision Id:</label></td>
                <td><select name="decision_id">
                    <c:forEach var="rowDecisionId" items="${decision_dated.rows}">
                        <option value="<c:out value="${rowDecisionId.decision_id}"/>"><c:out value="${rowDecisionId.decision_id}"/></option>
                    </c:forEach>
                </select></td>
                </tr>
                <tr>
                   <td><label>Event Id:</label></td>
                   <td><select name="event_id">
                    <c:forEach var="rowEventId" items="${event_dated.rows}">
                        <option value="<c:out value="${rowEventId.event_id}"/>"><c:out value="${rowEventId.event_id}"/></option>
                    </c:forEach>
                </select></td>
                </tr>
                <tr>
                    <td><label>device_id:</label></td>
                    <td><input type="text" name="device_id" value="1"/></td>
                </tr>
                <tr>
                    <td><label>user_id:</label></td>    
                    <td><input type="text" name="enabled" value="1"/></td>
                </tr>
            </table>    

            <input type="submit" name="button" value="New Incident">
        </fieldset>
    </form>
    <%--END FORM INSERT SECURITY EVENT----------------------------------------%> 

<%--Save security incident submited--%>
<c:choose><c:when test="${param.button=='Insert Incident'}">
    <c:catch var ="catchException">
    <sql:update dataSource="${snapshot}" var="result">
        INSERT INTO security_incident(name,decision_id,event_id,device_id,user_id,modification) VALUES (?,?,?,?,?,NOW());
        <sql:param value="${param.name}" />
        <sql:param value="${param.decision_id}" />
        <sql:param value="${param.event_id}" />
        <sql:param value="${param.device_id}" />
        <sql:param value="${param.user_id}" />
    </sql:update>
    </c:catch>
</c:when></c:choose>
<%--A exception was catched--%>
<c:choose><c:when test = "${catchException != null}">
    <h3>There is an exception: ${catchException.message}</h3>
</c:when></c:choose>
</c:if>

    
<%--Debug post parameters--%>
<c:out value="${param}"/>
<c:out value="${decision_dated.rows}"/>
<jsp:include page="modules/footer.jsp"></jsp:include>