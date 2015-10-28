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
        
        <sql:query dataSource="${snapshot}" var="labels">
            SELECT DISTINCT value FROM decision;
        </sql:query>
            
        <sql:query dataSource="${snapshot}" var="event_ids">
            SELECT event_id FROM simple_events;
        </sql:query>
        <c:forEach var="id" items="${event_ids.rows}">
            <sql:query dataSource="${snapshot}" var="event_ids">
               SELECT value FROM decision WHERE access_request_id in (SELECT access_request_id FROM access_request WHERE event_id = '${id.event_id}');
            </sql:query> 
        </c:forEach>
        
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
        
                <script type="text/javascript" src="https://www.google.com/jsapi"></script>
                <script type="text/javascript">
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
                        
                    });
                    
                    google.load('visualization', '1', {packages: ['corechart', 'bar']});
                    google.setOnLoadCallback(drawColColors);

                    function drawColColors() {
                        var data = google.visualization.arrayToDataTable([
                            ['Genre', 
                            <c:forEach var="label" items="${labels.rows}">
                            '${label.value}', 
                            </c:forEach>
                            { role: 'annotation' } ],
                            ['2010', 10, 24,  ''],
                            ['2020', 16, 22, ''],
                            ['2030', 28, 19, '']
                        ]);
                        var options = {
                            title: 'MUSES custom Graph',
                            width: 600,
                            height: 400,
                            legend: { position: 'top', maxLines: 3 },
                            bar: { groupWidth: '75%' },
                            isStacked: true,
                        };
                        
                        var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
                        chart.draw(data, options);
                    }
                    
                </script>
                
            </div>
            <button class="ui purple button" type="submit" value="submit">Show Graph</button>
        </form>
        
        <br /> 
        
        <div class="ui divider"></div>
        
        <br />
        
        <div id="chart_div" align="center"></div>
        
        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
