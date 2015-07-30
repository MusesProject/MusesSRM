<%-- 
    Document   : chart
    Created on : 22-jul-2015, 13:00:56
    Author     : Juan Luis Martin Acal <jlmacal@gmail.com>
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
                   url="jdbc:mysql://localhost/muses"
                   user="muses"  password="muses11"/>

<jsp:include page="modules/header.jsp"></jsp:include>
<jsp:include page="modules/menu.jsp"></jsp:include>

<%--CHART DEFINITION SECTION--------------------------------------------------%>    
<%--Number of Access Request query and graph--%>    
<sql:query dataSource="${snapshot}" var="result">
    SELECT COUNT(*) counter,YEAR(modification) AS year,MONTHNAME(modification) AS month FROM access_request GROUP BY YEAR(modification), MONTH(modification) ORDER BY YEAR(modification), MONTH(modification) ASC;
</sql:query>

    <!--Load the AJAX API-->
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
   
      // Load the Visualization API and the piechart package.
      google.load('visualization', '1.0', {'packages':['corechart']});
     
      // Set a callback to run when the Google Visualization API is loaded.
      google.setOnLoadCallback(drawChart);


      // Callback that creates and populates a data table, 
      // instantiates the pie chart, passes in the data and
      // draws it.
      function drawChart() {

      // Create the data table.
      var data = new google.visualization.DataTable();
      data.addColumn('string', 'Topping');
      data.addColumn('number', '#Access Request');
      data.addRows([
        <c:forEach var="count" items="${result.rows}">
           ['<c:out value="${count.year}"/>-<c:out value="${count.month}"/>', <c:out value="${count.counter}"/>], 
        </c:forEach>
      ]);

      // Set chart options
      var options = {'title':'Number of Access Request (ordered by year and month)',
                     'width':600,
                     'height':300,
                     'colors': ['#B5478B']                 
                    };

      // Instantiate and draw our chart, passing in some options.
      var chart = new google.visualization.BarChart(document.getElementById('chart_access_requests'));
      chart.draw(data, options);
    }
    </script>

<%--Number of Simpe Events query and graph--%>  
<sql:query dataSource="${snapshot}" var="result">
    SELECT COUNT(*) counter,YEAR(date) AS year,MONTHNAME(date) AS month FROM simple_events GROUP BY YEAR(date), MONTH(date) ORDER BY YEAR(date), MONTH(date) ASC;
</sql:query>    
    
    <!--Load the AJAX API-->
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
   
      // Load the Visualization API and the piechart package.
      google.load('visualization', '1.0', {'packages':['corechart']});
     
      // Set a callback to run when the Google Visualization API is loaded.
      google.setOnLoadCallback(drawChart);


      // Callback that creates and populates a data table, 
      // instantiates the pie chart, passes in the data and
      // draws it.
      function drawChart() {

      // Create the data table.
      var data = new google.visualization.DataTable();
      data.addColumn('string', 'Topping');
      data.addColumn('number', '#Simple Events');
      data.addRows([
        <c:forEach var="count" items="${result.rows}">
           ['<c:out value="${count.year}"/>-<c:out value="${count.month}"/>', <c:out value="${count.counter}"/>], 
        </c:forEach>
      ]);

      // Set chart options
      var options = {'title':'Number of Access Request (ordered by year and month)',
                     'width':600,
                     'height':300,
                     'colors': ['#B5478B']                 
                    };

      // Instantiate and draw our chart, passing in some options.
      var chart = new google.visualization.BarChart(document.getElementById('chart_simple_events'));
      chart.draw(data, options);
    }
    </script>

<%--Number of security violations query and graph--%>  
<sql:query dataSource="${snapshot}" var="result">
    SELECT COUNT(*) counter,YEAR(detection) AS year,MONTHNAME(detection) AS month FROM security_violation GROUP BY YEAR(detection), MONTH(detection) ORDER BY YEAR(detection), MONTH(detection) ASC;
</sql:query>    
    
    <!--Load the AJAX API-->
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
   
      // Load the Visualization API and the piechart package.
      google.load('visualization', '1.0', {'packages':['corechart']});
     
      // Set a callback to run when the Google Visualization API is loaded.
      google.setOnLoadCallback(drawChart);


      // Callback that creates and populates a data table, 
      // instantiates the pie chart, passes in the data and
      // draws it.
      function drawChart() {

      // Create the data table.
      var data = new google.visualization.DataTable();
      data.addColumn('string', 'Topping');
      data.addColumn('number', '#Security Violations');
      data.addRows([
        <c:forEach var="count" items="${result.rows}">
           ['<c:out value="${count.year}"/>-<c:out value="${count.month}"/>', <c:out value="${count.counter}"/>], 
        </c:forEach>
      ]);

      // Set chart options
      var options = {'title':'Number of Access Request (ordered by year and month)',
                     'width':600,
                     'height':300,
                     'colors': ['#B5478B']                 
                    };

      // Instantiate and draw our chart, passing in some options.
      var chart = new google.visualization.BarChart(document.getElementById('chart_security_violation'));
      chart.draw(data, options);
    }
    </script>    
<%--END CHART DEFINITION SECTION----------------------------------------------%>       

<%--PRINTING CHARTS SECTION---------------------------------------------------%>  
<!--Div that will hold the bar chart-->
    <div id="chart_access_requests" style="width:600; height:300"></div>
    <div id="chart_simple_events" style="width:600; height:300"></div>
    <div id="chart_security_violation" style="width:600; height:300"></div>
<%--END PRINTING CHARTS SECTION-----------------------------------------------%> 

<%--Debug post parameters--%>
<c:forEach var="count" items="${result.rows}">
    <c:out value="${count.year}"/>
    <c:out value="${count.month}"/>
    <c:out value="${count.counter}"/>
</c:forEach>
<jsp:include page="modules/footer.jsp"></jsp:include>