<%-- 
    Document   : index
    Created on : 25-mar-2015, 9:47:20
    Author     : szamarripa
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">



<html>
    <head>
        
        <style>
            div.muses {
                font-weight: bold;
                margin: 0em;
                padding: 0em;
                font-size: 1.5rem;
                line-height: 1.2em;
                color: rgba(96, 96, 96, 1);
            }
        </style>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
                   url="jdbc:mysql://localhost/muses"
                   user="muses"  password="muses11"/>
        
        <!-- Obtaining today's date -->
        <jsp:useBean id="date" class="java.util.Date" />
        <fmt:formatDate value="${date}" pattern="yyyy-MM-dd" var="currentDate" />
        
        <sql:query dataSource="${snapshot}" var="result">
            SELECT count(*) as u, user_id, count(user_id) as c FROM simple_events WHERE date(date)='${currentDate}' GROUP BY user_id ORDER BY c;
        </sql:query>
        
        <sql:query dataSource="${snapshot}" var="users">
            SELECT count(distinct user_id) as c FROM simple_events WHERE date(date)='${currentDate}';
        </sql:query>
            <c:forEach var="u" items="${users.rows}"><c:set var="u_n" value="${u.c*26}"/></c:forEach>
        
        <sql:query dataSource="${snapshot}" var="result2">
            SELECT user_id, count(user_id) as c FROM security_violation WHERE date(detection)='${currentDate}' GROUP BY user_id ORDER BY c;
        </sql:query>
        
        <sql:query dataSource="${snapshot}" var="users2">
            SELECT count(distinct user_id) FROM security_violation WHERE date(detection)='${currentDate}';
        </sql:query>
            <c:forEach var="u2" items="${users2.rows}"><c:set var="u2_n" value="${u2.c*26}"/></c:forEach>
        
        <!-- Google Charts API -->
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>
        <script type="text/javascript">
            
        google.load('visualization', '1', {packages: ['corechart', 'bar']});
        google.setOnLoadCallback(drawEventsGraph);
        google.setOnLoadCallback(drawViolationsGraph);
        
        function drawEventsGraph() {
            
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'User #');
            data.addColumn('number', '# Events');
            data.addRows([
                <c:forEach var="count" items="${result.rows}">
                            ['<c:out value="${count.user_id}"/>', <c:out value="${count.c}"/>],
                                                                            <c:set var="max" value="${count.c}"/>
                </c:forEach>                
            ]);

            var options = {
                title: 'Events statistics for ${currentDate}',
                chartArea: {width: '75%'},
                height: '${u_n}',
                hAxis: {
                  title: 'Number of events',
                  minValue: 0,
                  viewWindow: { max: ${max}+20 }
                },
                vAxis: {
                  title: 'User'
                },
                bar: {
                  groupWidth: '90%'
                },
                colors: ['#ab207d']
            };

            var chart = new google.visualization.BarChart(document.getElementById('chart_events'));

            chart.draw(data, options);
        }
        
        function drawViolationsGraph() {
            
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'User #');
            data.addColumn('number', '# Security Violations');
            data.addRows([
                <c:forEach var="count2" items="${result2.rows}">
                            ['<c:out value="${count2.user_id}"/>', <c:out value="${count2.c}"/>],
                                                                            <c:set var="max2" value="${count2.c}"/>
                </c:forEach>                
            ]);

            var options = {
                title: 'Security Violation statistics for ${currentDate}',
                chartArea: {width: '75%'},
                height: '${u2_n}',
                hAxis: {
                  title: 'Number of Security Violations',
                  minValue: 0,
                  viewWindow: { max: ${max2}+20 }
                },
                vAxis: {
                  title: 'User'
                },
                bar: {
                  groupWidth: '90%'
                },
                colors: ['#ab207d']
            };

            var chart = new google.visualization.BarChart(document.getElementById('chart_violations'));

            chart.draw(data, options);
        }
        
        </script>

        <title>MUSES tool for CSOs - Main Page</title>
    </head>
    <body>
        
        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        <jsp:include page="modules/musesintro.jsp"></jsp:include>
        
        <%
        // Page will be auto refresh after 1 seconds
        response.setIntHeader("Refresh", 3);

        // Get Current Time
        //DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        //Calendar cal = Calendar.getInstance();
        //out.println(dateFormat.format(cal.getTime()));
        %>
        
        <div class="ui divider"></div>
        <h2 class="ui center aligned icon header">
        <i class="settings icon"></i>
        <div class="content">
            Chief Security Officer's Dashboard
            <div class="sub header">Today's statistics</div>
        </div>
        </h2>
        <br>
        
        <div id="chart_events"></div>
        <div class="ui divider"></div>
        <div id="chart_violations"></div>
        <div class="ui divider"></div>
        
        
        <div class="muses">Quick Menu: <div class="ui purple animated button" onclick="location.href = 'events.jsp'">
            <div class="visible content">Events Information</div>
            <div class="hidden content">
                <i class="right arrow icon"></i>
            </div>
        </div>
        <div class="ui purple animated button" onclick="location.href = 'users.jsp'">
            <div class="visible content">User Management</div>
            <div class="hidden content">
                <i class="right arrow icon"></i>
            </div>
        </div>        
            <div class="ui purple animated button" onclick="location.href = 'policies.jsp'">
            <div class="visible content">Add Policy</div>
            <div class="hidden content">
                <i class="right arrow icon"></i>
            </div>
        </div>        
        <div class="ui purple animated button" onclick="location.href = 'rules.jsp'">
            <div class="visible content">Check for new rules</div>
            <div class="hidden content">
                <i class="right arrow icon"></i>
            </div>
        </div></div>
        
        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>



