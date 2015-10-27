<%-- 
    Document   : s_incidents
    Created on : 26-mar-2015, 16:58:29
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
        
        <sql:query dataSource="${snapshot}" var="decision" scope="session">
            SELECT decision_id, time, value FROM decision;
        </sql:query>
        
        <!-- Obtaining today's date -->
        <jsp:useBean id="date" class="java.util.Date" />
        <fmt:formatDate value="${date}" pattern="yyyy-MM-dd" var="currentDate" />      
        
        <sql:query dataSource="${snapshot}" var="events" scope="session">
            SELECT event_id, time FROM simple_events WHERE date = '${currentDate}';
        </sql:query>

        <title>MUSES tool for CSOs - Security Incidents</title>
    </head>
    <body>
        
        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        
        <h2 class="ui center aligned icon header">
            <i class="warning sign icon"></i>           
            <div class="content">
                Security Incidents Management
                <div class="sub header">Report or analyse here any Security Incident</div>
            </div>
        </h2>
        <div class="ui divider"></div>
        
        <br/>
        
        <c:if test="${not empty param.errMsg}">
            <div class="ui negative message"><c:out value="${param.errMsg}" /></div>
            <br>
        </c:if>
         
        <c:if test="${not empty param.susMsg}">
            <div class="ui positive message"><c:out value="${param.susMsg}" /></div>
        </c:if>
            
        <form class="ui form" method="POST" action="incident_date.jsp">
            <h4 class="ui dividing header">Please select the date when the security incident occurred, or was reported:</h4>
            <div class="fields">
                <div class="field">
                    <label>Select date:</label>
                    <input type="text" name="date" id="datepicker">
                </div>
            </div>
                
            <div class="six wide field">
                <select class="ui dropdown" name="time">
                    <option value="">Select time...</option>
                    <option value="1">00:00:00 - 01:59:59</option>
                    <option value="2">02:00:00 - 03:59:59</option>
                    <option value="3">04:00:00 - 05:59:59</option>
                    <option value="4">06:00:00 - 07:59:59</option>
                    <option value="5">08:00:00 - 09:59:59</option>
                    <option value="6">10:00:00 - 11:59:59</option>
                    <option value="7">12:00:00 - 13:59:59</option>
                    <option value="8">14:00:00 - 15:59:59</option>
                    <option value="9">16:00:00 - 17:59:59</option>
                    <option value="10">18:00:00 - 19:59:59</option>
                    <option value="11">20:00:00 - 21:59:59</option>
                    <option value="12">22:00:00 - 23:59:59</option>
                </select>
            </div>

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
            </script>      
            <button class="ui purple button" type="submit" value="submit">Create new Security Incident</button>
        </form>
        <br/>
        
        <button class="ui purple button" id="button">Check for Security Incidents</button>
        <script>
            $("#button").click(function(){
               var date = $("#datepicker").val();
               window.location.href = "incident_info.jsp?date="+date;
            });
        </script>
        <br/><br/>

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>

