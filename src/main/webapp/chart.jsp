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
        <jsp:setProperty name="otherDate" property="time" value="${otherDate.time - 15552000000}"/>
        <fmt:formatDate value="${otherDate}" pattern="yyyy-MM-dd" var="pastDate" />
        
        <sql:query dataSource="${snapshot}" var="devicesOS">
            SELECT distinct OS_name FROM devices WHERE OS_name IS NOT NULL AND OS_name != 'a';
        </sql:query>
            
        <sql:query dataSource="${snapshot}" var="devicesModel">
            SELECT distinct model FROM devices WHERE model IS NOT NULL AND model != 'domemodel' AND model != '1222' AND model != '1223';
        </sql:query>
            
        <sql:query dataSource="${snapshot}" var="roles">
            SELECT role_id, name FROM roles WHERE name IS NOT NULL AND name != 'role';
        </sql:query>
            
        <sql:query dataSource="${snapshot}" var="eventsTime">
            SELECT count(*) as e, date FROM simple_events WHERE date(date)<='${currentDate}' AND date(date)>='${pastDate}' GROUP BY date;
        </sql:query>
            
        <sql:query dataSource="${snapshot}" var="eventsUser">
            SELECT user_id, count(user_id) as c FROM simple_events WHERE date(date)<='${currentDate}' AND date(date)>='${pastDate}' GROUP BY user_id ORDER BY c;
        </sql:query>
        
        <title>MUSES tool for CSOs - Main Page</title>
    </head>
    <body>
        
        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        
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
                    $("#chart_div").empty();
                    yAxis = $("#Y").val();
                    switch(xAxis) {
                        case "events":
                            switch(yAxis) {
                                case "Time":
                                    drawNormalGraph("eventTime");
                                    break;
                                case "Decisions":
                                    drawSpecialColChart();
                                    break;
                                case "Users":
                                    drawNormalGraph("eventUser");
                                    break;
                                case "Devices":
                                    break;
                                case "Type":
                                    break;
                            }
                            break;
                        case "violations":
                            switch(yAxis) {
                                case "Time":
                                    break;
                                case "Users":
                                    break;
                                case "Devices":
                                    break;                                
                            }
                            break;
                        case "devices":
                            switch(yAxis) {
                                case "OS":
                                    drawPieChart("os");
                                    break;
                                case "model":
                                    drawPieChart("model");
                                    break;                                
                            }
                            break;
                        case "users":
                            drawPieChart("users");
                            break;
                        case "incidents":

                            break;
                    }

                });

                google.load("visualization", "1", {packages:["corechart"]});

                function drawSpecialColChart() {
                    var data = google.visualization.arrayToDataTable([
                        ['Genre', 'GRANTED', 'STRONGDENY', { role: 'annotation' } ],                    
                        <sql:query dataSource="${snapshot}" var="dates">
                            SELECT DISTINCT date(event_detection) as d FROM patterns_krs;
                        </sql:query>
                        <c:forEach var="day" items="${dates.rows}">
                            <sql:query dataSource="${snapshot}" var="total">
                               SELECT t1.allow, t2.deny FROM (SELECT count(*) as allow FROM patterns_krs WHERE label = 'GRANTED' AND date(event_detection) = '${day.d}') as t1, (SELECT count(*) as deny FROM patterns_krs WHERE label = 'STRONGDENY' AND date(event_detection) = '${day.d}') as t2;
                            </sql:query>
                            <c:forEach var="row" items="${total.rows}">
                                ['${day.d}', ${row.allow}, ${row.deny}, ''],
                            </c:forEach>
                        </c:forEach>
                    ]);
                    var options = {
                        title: 'MUSES custom Graph',
                        width: 1500,
                        height: 800,
                        hAxis: {
                            title: 'Date'
                        },
                        vAxis: {
                            title: '#Events'
                        },
                        legend: { position: 'top', maxLines: 3 },
                        bar: { groupWidth: '75%' },
                        isStacked: true,
                        colors: ['green','red'],
                    };

                    var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
                    chart.draw(data, options);
                }
                
                function drawPieChart(type) {
                
                    var data;
                
                    if (type == "os") {
                        data = google.visualization.arrayToDataTable([
                        ['OS', '#Devices'],
                        <c:forEach var="OS" items="${devicesOS.rows}">
                              <sql:query dataSource="${snapshot}" var="total">
                                 SELECT OS_name, count(*) as c FROM devices WHERE OS_name = '${OS.OS_name}';
                              </sql:query>
                              <c:forEach var="row" items="${total.rows}">
                                  ['${row.OS_name}', ${row.c}],
                              </c:forEach>
                          </c:forEach>
                      ]);
                    } else if (type == "model"){
                        data = google.visualization.arrayToDataTable([
                        ['Model', '#Devices'],
                        <c:forEach var="model" items="${devicesModel.rows}">
                              <sql:query dataSource="${snapshot}" var="total">
                                 SELECT model, count(*) as c FROM devices WHERE model = '${model.model}';
                              </sql:query>
                              <c:forEach var="row" items="${total.rows}">
                                  ['${row.model}', ${row.c}],
                              </c:forEach>
                          </c:forEach>
                      ]);                    
                    } else {
                        data = google.visualization.arrayToDataTable([
                        ['Role', '#Users'],
                        <c:forEach var="role" items="${roles.rows}">
                              <sql:query dataSource="${snapshot}" var="total">
                                 SELECT count(*) as c FROM users WHERE role_id = '${role.role_id}';
                              </sql:query>
                              <c:forEach var="row" items="${total.rows}">
                                  ['${role.name}', ${row.c}],
                              </c:forEach>
                          </c:forEach>
                      ]);}                  

                    var options = {
                      title: 'MUSES custom Graph',
                        width: 1000,
                        height: 1000,
                        is3D: true,

                    };

                    var chart = new google.visualization.PieChart(document.getElementById('chart_div'));

                    chart.draw(data, options);
                }
        
                function drawNormalGraph(type) {

                    var data;
                    
                    if (type == "eventTime") {
                        data = google.visualization.arrayToDataTable([
                        ['Date', '#Events'],
                        <c:forEach var="count" items="${eventsTime.rows}">
                            ['${count.date}', ${count.e}],
                        </c:forEach>
                        ]);
                    } else if (type == "eventUser") {
                        data = google.visualization.arrayToDataTable([
                        ['User', '#Events'],
                        <c:forEach var="count" items="${eventsUser.rows}">
                            ['${count.user_id}', ${count.c}],
                        </c:forEach>
                        ]);                        
                    } else if (type == "eventDevice") {                        
                    } else if (type == "violationsTime") {                        
                    } else if (type == "violationsUser") {                        
                    } else if (type == "violationsDevice") {                        
                    } else {                        
                    }                    

                    var options = {
                        title: 'MUSES custom Graph, last three months',
                        height: '400',
                        hAxis: {
                          title: yAxis,
                          viewWindowMode: 'pretty',
                        },
                        vAxis: {
                          title: xAxis,
                          minValue: 0,
                        },
                        bar: {
                          groupWidth: '90%'
                        },
                        colors: ['#ab207d']
                    };

                    var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
                    chart.draw(data, options);
                }

            </script>
        </form>
        
        <br /> 
        
        <div class="ui divider"></div>        
        <div id="chart_div" align="center"></div>
        
        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
