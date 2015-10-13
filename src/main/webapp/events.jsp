<%-- 
    Document   : events
    Created on : 26-mar-2015, 16:35:15
    Author     : unintendedbear
    Author     : Juan Luis Martin Acal <jlmacal@gmail.com>
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
        
        <!-- Obtaining today's date and one month ago date -->
        <jsp:useBean id="date" class="java.util.Date" />
        <jsp:useBean id="otherDate" class="java.util.Date" />
        <fmt:formatDate value="${date}" pattern="yyyy-MM-dd" var="currentDate" />
        <jsp:setProperty name="otherDate" property="time" value="${otherDate.time - 2592000000}"/>
        <fmt:formatDate value="${otherDate}" pattern="yyyy-MM-dd" var="pastDate" />
        
        <sql:query dataSource="${snapshot}" var="result">
            SELECT count(*) as e, date FROM simple_events WHERE date(date)<='${currentDate}' AND date(date)>'${pastDate}' GROUP BY date;
        </sql:query>
           
        <!-- Google Charts API -->
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>
        <script type="text/javascript">
            
        google.load('visualization', '1', {packages: ['corechart', 'bar']});
        google.setOnLoadCallback(drawEventsGraph);
        
        function drawEventsGraph() {
            
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Date');
            data.addColumn('number', '# Events');
            data.addRows([
                <c:forEach var="count" items="${result.rows}">
                            ['<c:out value="${count.date}"/>', <c:out value="${count.e}"/>],
                </c:forEach>
            ]);

            var options = {
                title: 'Event statistics from ${pastDate} to ${currentDate}',
                height: '400',
                hAxis: {
                  title: 'Date',
                  slantedText : true,
                  viewWindowMode: 'pretty',
                  slantedTextAngle: '90',
                },
                vAxis: {
                  title: '# Events',
                  minValue: 0,
                },
                bar: {
                  groupWidth: '90%'
                },
                colors: ['#ab207d']
            };

            var chart = new google.charts.Bar(document.getElementById('chart_events'));

            chart.draw(data, options);
        }
        
        </script>

        <title>MUSES tool for CSOs - Monitored Events</title>
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
        
        <h2 class="ui center aligned icon header">
            <i class="mobile icon"></i>           
            <div class="content">
                Monitored Events
            </div>
        </h2>
        <div class="ui divider"></div>
        
        <br>
        
        <div class="ui centered grid">

        <div id="chart_events" class="fifteen wide column"></div></div>
        <div class="ui divider"></div>
        <c:if test="${not empty param.errMsg}">
            <div class="ui negative message"><c:out value="${param.errMsg}" /></div>
            <br>
        </c:if>
        <form class="ui form" method="POST" action="event_date.jsp">
            <h4 class="ui dividing header">For more details in a table, please choose between dates:</h4>
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
                        var yesterday = today.getDate() - 31;
                        $("#datepicker_start").datepicker("setDate", yesterday);
                        $("#datepicker_end").datepicker({
                            dateFormat: "yy-mm-dd",
                            beforeShowDay: function(date) {
                                                return [date < new Date, ""];
                                        }
                        });
                        $("#datepicker_end").datepicker("setDate", new Date);
                    });
                </script>
            </div>      
            <button class="ui purple button" type="submit" value="submit">Show Events</button>
        </form>

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
