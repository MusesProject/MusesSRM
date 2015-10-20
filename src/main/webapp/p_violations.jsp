<%-- 
    Document   : p_violations
    Created on : 26-mar-2015, 16:36:33
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
        
        <!-- Obtaining today's date -->
        <jsp:useBean id="date" class="java.util.Date" />
        <fmt:formatDate value="${date}" pattern="yyyy-MM-dd" var="currentDate" />
        
        <sql:query dataSource="${snapshot}" var="result2">
            SELECT user_id, count(user_id) as c FROM security_violation WHERE date(detection)='${currentDate}' GROUP BY user_id ORDER BY c;
        </sql:query>
        
        <sql:query dataSource="${snapshot}" var="users2">
            SELECT count(distinct user_id) FROM security_violation WHERE date(detection)='${currentDate}';
        </sql:query>
            <c:forEach var="u2" items="${users2.rows}"><c:set var="u2_n" value="${u2.c*26}"/></c:forEach>
            
        <sql:query dataSource="${snapshot}" var="users" scope="session">
            SELECT user_id, name, surname FROM users;
        </sql:query>
        
        <!-- Google Charts API -->
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>
        <script type="text/javascript">
            
        google.load('visualization', '1', {packages: ['corechart', 'bar']});
        google.setOnLoadCallback(drawViolationsGraph);
        
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

        <title>MUSES tool for CSOs - Policy Violations</title>
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
            <i class="warning sign icon"></i>           
            <div class="content">
                Security Violation statistics & information
                <div class="sub header">Today's statistics</div>
            </div>
        </h2>
        <div class="ui divider"></div>
        
        <br/>
        <div id="chart_violations"></div>
        <div class="ui divider"></div>
        <br/>
        
        <c:if test="${not empty param.errMsg}">
            <div class="ui negative message"><c:out value="${param.errMsg}" /></div>
            <br>
        </c:if>
        
        <form class="ui form" method="POST" action="violations_date.jsp">
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
                </script>
            </div>      
            <button class="ui purple button" type="submit" value="submit">Show Security Violations per date</button>
        </form>
            
        <br/><br/>
            
        <form class="ui form" method="POST" action="violations_user.jsp">
            <h4 class="ui dividing header">Also, statistics can be shown per user:</h4>
            <div class="fields">
                <div class="six wide field">
                    <select class="ui dropdown" name="role_id">
                        <option value="">Select User...</option>
                        <c:forEach var="user" items="${users.rows}">
                        <option value="<c:out value='${user.user_id}'/>">#<c:out value="${user.user_id}"/> - <c:out value="${user.surname}"/>, <c:out value="${user.name}"/></option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <br/>
            <button class="ui purple button" type="submit" value="submit">Show Security Violations per user</button>
        </form>

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>