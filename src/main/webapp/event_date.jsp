<%-- 
    Document   : event_date
    Created on : 30-sep-2015, 19:47:33
    Author     : paloma
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        
        <sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
                           url="jdbc:mysql://localhost/muses"
                           user="muses"  password="muses11"/>
        
        <sql:query dataSource="${snapshot}" var="graphResults">
            SELECT count(*) as e, date FROM simple_events WHERE date(date)<='${param.endD}' AND date(date)>='${param.startD}' GROUP BY date;
        </sql:query>
            
         <sql:query dataSource="${snapshot}" var="eventList">
            SELECT * FROM simple_events WHERE date(date)<='${param.endD}' AND date(date)>='${param.startD}' ORDER BY date, time DESC;
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
                <c:forEach var="count" items="${graphResults.rows}">
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
        
        <h2 class="ui center aligned icon header">
            <i class="mobile icon"></i>         
            <div class="content">
                Monitored Events
            </div>
        </h2>
        <div class="ui divider"></div>        
        
        <c:set var="totalCount" scope="session" value="${eventList.rowCount}"/>
        
        <c:if test="${totalCount == 0 }">
            <c:redirect url="events.jsp" >
                <c:param name="errMsg" value="No events registered for those dates." />
            </c:redirect>
        </c:if>
        
        <c:set var="perPage" scope="session" value="15"/>
        <c:set var="totalPages" scope="session" value="${totalCount/perPage}"/>

        <c:set var="pageIndex" scope="session" value="${param.start/perPage+1}"/>
        
        <div class="ui purple animated button" align="right" onclick="location.href = 'events.jsp'">
            <div class="visible content">Back to date picking</div>
            <div class="hidden content">
                <i class="left arrow icon"></i>
            </div>
        </div>
        <br><br>
        <div class="ui centered grid">

        <div id="chart_events" class="fifteen wide column"></div></div>

        <table class="ui celled table">
            <thead>
                <tr>
                    <th>#Event</th>
                    <th>Type</th>
                    <th>#User</th>
                    <th>#Device</th>
                    <th>#App</th>
                    <th>#Asset</th>
                    <th>JSON message</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>#Source</th>
                    <th>EP</th>
                    <th>RT2AE</th>
                    <th>KRS</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="rowBody" items="${eventList.rows}" begin="${param.start}" end="${param.start+perPage}">
                <tr>
                    <td><c:out value="${rowBody.event_id}"/></td>
                    <td><c:out value="${rowBody.event_type_id}"/></td>
                    <td><c:out value="${rowBody.user_id}"/></td>
                    <td><c:out value="${rowBody.device_id}"/></td>
                    <td><c:out value="${rowBody.app_id}"/></td>
                    <td><c:out value="${rowBody.asset_id}"/></td>
                    <td>
                        <c:choose>
                            <c:when test="${fn:length(rowBody.data)>130}">
                                <c:set var="string" value="${fn:substring(rowBody.data, 0, 130)}" />
                                <c:out value="${string}"/>...
                                <div class="ui warning message">
                                    Text is too long, use a MySQL client.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:out value="${rowBody.data}"/>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td><c:out value="${rowBody.date}"/></td>
                    <td><c:out value="${rowBody.time}"/></td>
                    <td><c:out value="${rowBody.source_id}"/></td>
                    <td><c:out value="${rowBody.EP_can_access}"/></td>
                    <td><c:out value="${rowBody.RT2AE_can_access}"/></td>
                    <td><c:out value="${rowBody.KRS_can_access}"/></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>       
        
        
        <div class="ui purple right floated pagination inverted menu" id="pages">
           <c:if test="${!empty param.start && param.start >(perPage-1) && param.start !=0 }">
             <a class="icon item" href="?start=<c:out value="${param.start - perPage}"/>&startD=<c:out value='${param.startD}'/>&endD=<c:out value='${param.endD}'/>">
                  <i class="left chevron icon"></i>
             </a>
           </c:if>

           <c:if test="${empty param.start || param.start<(totalCount-perPage)}">
               <a class="icon item" href="?start=<c:out value='${param.start + perPage}'/>&startD=<c:out value='${param.startD}'/>&endD=<c:out value='${param.endD}'/>">
                    <i class="right chevron icon"></i>
               </a>
           </c:if>
        </div>
        <br /><br />

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>

