<%-- 
    Document   : incident_info
    Created on : 27-oct-2015, 9:28:17
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
            SELECT count(*) as i, date(modification) as d FROM security_incident WHERE date(modification)<='${param.date}' GROUP BY date(modification);
        </sql:query>
            
         <sql:query dataSource="${snapshot}" var="incidentList">
            SELECT * FROM security_incident WHERE date(modification)='${param.date}';
        </sql:query>
            
        <c:if test="${incidentList.rowCount == 0 or graphResults.rowCount == 0}">
            <c:redirect url="s_incidents.jsp" >
                <c:param name="errMsg" value="No security incidents registered for those dates." />
            </c:redirect>
        </c:if>
        
        <!-- Google Charts API -->
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>
        <script type="text/javascript">
            
        google.load('visualization', '1', {packages: ['corechart', 'bar']});
        google.setOnLoadCallback(drawEventsGraph);
        
        function drawEventsGraph() {
            
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Date');
            data.addColumn('number', '#Security Violations');
            data.addRows([
                <c:forEach var="count" items="${graphResults.rows}">
                            ['<c:out value="${count.d}"/>', <c:out value="${count.i}"/>],
                </c:forEach>
            ]);

            var options = {
                title: 'Security Incidents statistics until ${param.date}',
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
        
        <title>MUSES tool for CSOs - Security Incidents</title>
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
                Information & Statistics for Security Incidents
            </div>
        </h2>
        <div class="ui divider"></div>
        
        <br/>        
        
        <c:set var="totalCount" scope="session" value="${incidentList.rowCount}"/>        
        <c:set var="perPage" scope="session" value="10"/>
        <c:set var="totalPages" scope="session" value="${totalCount/perPage}"/>

        <c:set var="pageIndex" scope="session" value="${param.start/perPage+1}"/>
        
        <div class="ui purple animated button" align="right" onclick="location.href = 's_incidents.jsp'">
            <div class="visible content">Back to date picking</div>
            <div class="hidden content">
                <i class="left arrow icon"></i>
            </div>
        </div>
        <br /><br />
        <div class="ui centered grid">
            
        <div id="chart_events" class="fifteen wide column"></div></div>

        <table class="ui celled table">
            <label>Security Incidents statistics for ${param.date}</label>
            <thead>
                <tr>
                    <th>#Security Incident</th>
                    <th>Name</th>
                    <th>#Decision</th>
                    <th>#Event</th>
                    <th>#Device</th>
                    <th>#User</th>
                    <th>Reported on</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="rowBody" items="${incidentList.rows}" begin="${param.start}" end="${param.start+perPage}">
                <tr>
                    <td><c:out value="${rowBody.security_incident_id}"/></td>
                    <td><c:out value="${rowBody.name}"/></td>
                    <td><c:out value="${rowBody.decision_id}"/></td>
                    <td><c:out value="${rowBody.event_id}"/></td>
                    <td><c:out value="${rowBody.device_id}"/></td>
                    <td><c:out value="${rowBody.user_id}"/></td>
                    <td><c:out value="${rowBody.modification}"/></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>       
        
        
        <div class="ui purple right floated pagination inverted menu" id="pages">
           <c:if test="${!empty param.start && param.start >(perPage-1) && param.start !=0 }">
             <a class="icon item" href="?start=<c:out value="${param.start - perPage}"/>&date=<c:out value='${param.date}'/>">
                  <i class="left chevron icon"></i>
             </a>
           </c:if>

            <c:forEach var="boundaryStart" varStatus="status" begin="0" end="${totalCount - 1}" step="${perPage}">
                <c:choose>
                    <c:when test="${status.count>0 && status.count != pageIndex}">
                        <a class="item" href="?start=<c:out value='${boundaryStart}'/>">
                            <c:out value="${status.count}"/>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a class="active item">
                            <c:out value="${status.count}"/>
                        </a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>


           <c:if test="${empty param.start || param.start<(totalCount-perPage)}">
               <a class="icon item" href="?start=<c:out value='${param.start + perPage}'/>&date=<c:out value='${param.date}'/>">
                    <i class="right chevron icon"></i>
               </a>
           </c:if>
        </div>
        <br /><br />

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
