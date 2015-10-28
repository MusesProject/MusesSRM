<%-- 
    Document   : chart
    Created on : 22-jul-2015, 13:00:56
    Author     : unintendedbear
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
        
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
                   url="jdbc:mysql://localhost/muses"
                   user="muses"  password="muses11"/>
        
        <!-- Obtaining today's date and one month ago date -->
        <jsp:useBean id="date" class="java.util.Date" />
        <jsp:useBean id="otherDate" class="java.util.Date" />
        <fmt:formatDate value="${date}" pattern="yyyy-MM-dd" var="currentDate" />
        <jsp:setProperty name="otherDate" property="time" value="${otherDate.time - 2592000000}"/>
        <fmt:formatDate value="${otherDate}" pattern="yyyy-MM-dd" var="pastDate" />
        
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
        
        <%
        // Page will be auto refresh after 1 seconds
        response.setIntHeader("Refresh", 30);

        // Get Current Time
        //DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        //Calendar cal = Calendar.getInstance();
        //out.println(dateFormat.format(cal.getTime()));
        %>
        
        <div class="ui divider"></div>
        <h2 class="ui center aligned icon header">
        <i class="bar chart icon"></i>
        <div class="content">
            Chief Security Officer's Visualisation Panel
        </div>
        </h2>
        <br>
        
        <form class="ui form" method="POST" action="">
            <h4 class="ui dividing header">Please, choose what to display and the dates:</h4>
            <div class="six wide field">
                <label>I want to display:</label>
                <select class="ui dropdown" name="X" id="X">
                    <option value="">Select Subject...</option>
                    <option value="events">Simple Events</option>
                    <option value="violations">Security Violations</option>
                    <option value="devices">Devices</option>
                    <option value="users">Users</option>
                    <option value="incidents">Reported Security Incidents</option>
                </select>
            </div>
            <div class="six wide field">
                <label>With respect to:</label>
                <select class="ui dropdown" name="Y" id="Y">
                    <option value="">Select Subject...</option>
                </select>
            </div>
            <div class="fields">
                <div class="field">
                    <label>Start date:</label>
                    <input type="text" name="startD" id="datepicker_start">
                </div>
                <div class="field">
                    <label>End date:</label>
                    <input type="text" name="endD" id="datepicker_end">
                </div>
        
                <script>
                    $(function() {
                        $("#datepicker_start").datepicker({
                            dateFormat: "yy-mm-dd"
                        });
                        var today = new Date;
                        var yesterday = new Date;
                        yesterday.setMonth(today.getMonth() - 1);
                        $("#datepicker_start").datepicker("setDate", yesterday);
                        $("#datepicker_end").datepicker({
                            dateFormat: "yy-mm-dd",
                            beforeShowDay: function(date) {
                                                return [date < new Date, ""];
                                        }
                        });
                        $("#datepicker_end").datepicker("setDate", new Date);
                    });                    
                    
                    var xAxis, yAxis;

                    $("#X").change( function() {
                        $("#Y").empty();
                        xAxis = $("#X").val();
                        var yDropdown = document.getElementById("Y");
                        switch(xAxis) {
                            case "events":
                                var option1 = document.createElement("option");
                                var option2 = document.createElement("option");
                                var option3 = document.createElement("option");
                                var option4 = document.createElement("option");
                                var option5 = document.createElement("option");
                                option1.text = "Time";
                                option2.text = "Decisions";
                                option3.text = "Users";
                                option4.text = "Devices";
                                option5.text = "Type";
                                yDropdown.add(option1);
                                yDropdown.add(option2);
                                yDropdown.add(option3);
                                yDropdown.add(option4);
                                yDropdown.add(option5);
                                break;
                            case "violations":
                                var option1 = document.createElement("option");
                                var option2 = document.createElement("option");
                                var option3 = document.createElement("option");
                                option1.text = "Time";
                                option2.text = "Users";
                                option3.text = "Devices";
                                yDropdown.add(option1);
                                yDropdown.add(option2);
                                yDropdown.add(option3);
                                break;
                            case "devices":
                                var option1 = document.createElement("option");
                                var option2 = document.createElement("option");
                                option1.text = "OS distribution";
                                option1.value = "OS";
                                option2.text = "Model distribution";
                                option2.value = "model";
                                yDropdown.add(option1);
                                yDropdown.add(option2);
                                break;
                            case "users":
                                var option = document.createElement("option");
                                option.text = "Roles distribution";
                                option.value = "roles";
                                yDropdown.add(option);
                                break;
                            case "incidents":
                                var option = document.createElement("option");
                                option.text = "Time";
                                yDropdown.add(option);
                                break;
                        }
                    });

                    $("#Y").change( function() { 
                        yAxis = $("#Y").val();
                        alert(xAxis+" VS "+yAxis);
                    });
                    
                </script>
            </div>
            <button class="ui purple button" type="submit" value="submit">Show Events</button>
        </form>
        
        <div id="chart_events"></div>
        <div class="ui divider"></div>
        <div id="chart_violations"></div>
        <div class="ui divider"></div>
        
        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
