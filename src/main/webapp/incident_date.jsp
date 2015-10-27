<%-- 
    Document   : incident_date
    Created on : 26-oct-2015, 9:51:28
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
        
        <c:if test="${empty param.time}">
            <c:redirect url="s_incidents.jsp" >
                <c:param name="errMsg" value="Please select a valid time." />
            </c:redirect>
        </c:if>
        
        <c:if test="${not empty param.eventid}">
            <sql:query dataSource="${snapshot}" var="decisions" scope="session">
                SELECT decision_id, value, time FROM decision WHERE access_request_id in (SELECT access_request_id FROM access_request WHERE event_id = '${param.eventid}');
           </sql:query>
        </c:if>
                
        <c:if test="${not empty param.eventid and decisions.rowCount <= 0}">
            <c:redirect url="incident_date.jsp?date=${param.date}&time=${param.time}&name=${param.name}" >
                <c:param name="errMsg" value="No decisions for that event." />
            </c:redirect>
        </c:if>
        
        <c:choose>
            <c:when test="${param.time == 1}">
                <sql:query dataSource="${snapshot}" var="events" scope="session">
                    SELECT event_id, user_id, data, time FROM simple_events WHERE date = '${param.date}' AND time <= '01:59:59';
                </sql:query>
            </c:when>
            <c:when test="${param.time == 2}">
                <sql:query dataSource="${snapshot}" var="events" scope="session">
                    SELECT event_id, user_id, data, time FROM simple_events WHERE date = '${param.date}' AND time >= '02:00:00' AND time <= '03:59:59';
                </sql:query>
            </c:when>
            <c:when test="${param.time == 3}">
                <sql:query dataSource="${snapshot}" var="events" scope="session">
                    SELECT event_id, user_id, data, time FROM simple_events WHERE date = '${param.date}' AND time >= '04:00:00' AND time <= '05:59:59';
                </sql:query>
            </c:when>
            <c:when test="${param.time == 4}">
                <sql:query dataSource="${snapshot}" var="events" scope="session">
                    SELECT event_id, user_id, data, time FROM simple_events WHERE date = '${param.date}' AND time >= '06:00:00' AND time <= '07:59:59';
                </sql:query>
            </c:when>
            <c:when test="${param.time == 5}">
                <sql:query dataSource="${snapshot}" var="events" scope="session">
                    SELECT event_id, user_id, data, time FROM simple_events WHERE date = '${param.date}' AND time >= '08:00:00' AND time <= '09:59:59';
                </sql:query>
            </c:when>
            <c:when test="${param.time == 6}">
                <sql:query dataSource="${snapshot}" var="events" scope="session">
                    SELECT event_id, user_id, data, time FROM simple_events WHERE date = '${param.date}' AND time >= '10:00:00' AND time <= '11:59:59';
                </sql:query>
            </c:when>
            <c:when test="${param.time == 7}">
                <sql:query dataSource="${snapshot}" var="events" scope="session">
                    SELECT event_id, user_id, data, time FROM simple_events WHERE date = '${param.date}' AND time >= '12:00:00' AND time <= '13:59:59';
                </sql:query>
            </c:when>
            <c:when test="${param.time == 8}">
                <sql:query dataSource="${snapshot}" var="events" scope="session">
                    SELECT event_id, user_id, data, time FROM simple_events WHERE date = '${param.date}' AND time >= '14:00:00' AND time <= '15:59:59';
                </sql:query>
            </c:when>
            <c:when test="${param.time == 9}">
                <sql:query dataSource="${snapshot}" var="events" scope="session">
                    SELECT event_id, user_id, data, time FROM simple_events WHERE date = '${param.date}' AND time >= '16:00:00' AND time <= '17:59:59';
                </sql:query>
            </c:when>
            <c:when test="${param.time == 10}">
                <sql:query dataSource="${snapshot}" var="events" scope="session">
                    SELECT event_id, user_id, data, time FROM simple_events WHERE date = '${param.date}' AND time >= '18:00:00' AND time <= '19:59:59';
                </sql:query>
            </c:when>
            <c:when test="${param.time == 11}">
                <sql:query dataSource="${snapshot}" var="events" scope="session">
                    SELECT event_id, user_id, data, time FROM simple_events WHERE date = '${param.date}' AND time >= '20:00:00' AND time <= '21:59:59';
                </sql:query>
            </c:when>
            <c:when test="${param.time == 12}">
                <sql:query dataSource="${snapshot}" var="events" scope="session">
                    SELECT event_id, user_id, data, time FROM simple_events WHERE date = '${param.date}' AND time >= '22:00:00' AND time <= '23:59:59';
                </sql:query>
            </c:when>
        </c:choose>        
        
        <c:if test="${events.rowCount == 0}">
            <c:redirect url="s_incidents.jsp" >
                <c:param name="errMsg" value="No events registered for that day." />
            </c:redirect>
        </c:if>

        <title>MUSES tool for CSOs - Security Incidents</title>
    </head>
    <body>
        
        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        
        <h2 class="ui center aligned icon header">
            <i class="warning sign icon"></i>           
            <div class="content">
                Security Incidents Management
                <div class="sub header">Report here any security incident to be taken into account</div>
            </div>
        </h2>
        <div class="ui divider"></div>
        
        <br/>
        
        <c:if test="${not empty param.errMsg}">
            <div class="ui negative message"><c:out value="${param.errMsg}" /></div>
            <br>
        </c:if>
            
        <form class="ui form" method="POST" action="incident_date.jsp">
            <div class="fields">
                <div class="field">
                    <label>New date:</label>
                    <input type="text" name="date" id="datepicker">
                </div>
            </div>      
            <button class="ui purple button" type="submit" value="submit">Change date</button>
        </form>
        <br/>
        
        <form class="ui form" method="POST" action="insert_incident_db.jsp">
            <h4 class="ui dividing header">Please, insert the data for the incident on ${param.date}:</h4>
            <div class="fields">
                <div class="six wide field">
                    <c:choose>
                        <c:when test="${not empty param.name}">
                            <label>Name</label>
                            <input name="name" type="text" id="name" value="${param.name}">
                        </c:when>
                        <c:otherwise>
                            <label>Name</label>
                            <input name="name" placeholder="Name" type="text" id="name">
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="six wide field">
                <select class="ui dropdown" name="event_id" id="event_dropdown">
                    <option value="">Select associated event...</option>
                    <c:forEach var="event" items="${events.rows}">
                        <c:choose>
                            <c:when test="${not empty param.eventid and event.event_id == param.eventid}">
                                <option value="<c:out value='${event.event_id}'/>" selected>#<c:out value="${event.event_id}"/> by <c:out value="${event.user_id}"/> at (<c:out value="${event.time}"/>), data <c:out value="${event.data}"/></option>
                            </c:when>
                            <c:otherwise>
                                <option value="<c:out value='${event.event_id}'/>">#<c:out value="${event.event_id}"/> by <c:out value="${event.user_id}"/> at (<c:out value="${event.time}"/>), data <c:out value="${event.data}"/></option>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </select>
            </div>
            <div class="six wide field">
                <select class="ui dropdown" name="decision_id" id="decision_dropdown">
                    <option value="">Select associated decision...</option>
                    <c:forEach var="decision" items="${decisions.rows}">
                        <option value="<c:out value='${decision.decision_id}'/>">#<c:out value="${decision.decision_id}"/> at (<c:out value="${decision.time}"/>), value <c:out value="${decision.value}"/></option>
                    </c:forEach>                      
                </select>
            </div>                  
            <button class="ui purple button" type="submit" value="submit">Insert Security Incident</button>
        </form>
        
        <script>            
            $(function() {
                $("#datepicker").datepicker({
                    dateFormat: "yy-mm-dd",
                    beforeShowDay: function(date) {
                                        return [date < new Date, ""];
                                }
                });
                $("#datepicker").datepicker("setDate", new Date);
            });
            
            $("#event_dropdown").change(function() {
                var value =  $("#event_dropdown").val();
                if (value !== "${param.eventid}"){
                    var name = $("#name").val();
                    window.location.href = "?eventid="+value+"&name="+name+"&date=${param.date}&time=${param.time}";   
                }                             
            });
        </script>
            
        <br/><br/>

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
