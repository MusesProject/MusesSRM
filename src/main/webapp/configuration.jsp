<%-- 
    Document   : configuration
    Created on : 08-jun-2015, 9:38:38
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
        <fmt:formatDate value="${date}" pattern="yyyy-MM-dd HH:mm:ss" var="currentDate" />
        
        <sql:query dataSource="${snapshot}" var="result" scope="session" >
            SELECT * FROM connection_config;
        </sql:query>
            
        <sql:query dataSource="${snapshot}" var="resultSilent" scope="session" >
            SELECT silent_mode, access_attempts_before_blocking FROM muses_config ORDER BY date DESC LIMIT 1;
        </sql:query>
            
        <c:forEach var="row" items="${resultSilent.rows}">
            <c:set var="silentMode" value="${row.silent_mode}"/>
            <c:set var="maxLogin" value="${row.access_attempts_before_blocking}"/>
        </c:forEach>
            
        <c:if test="${not empty param.silent and param.silent != silentMode}">
            <sql:update dataSource="${snapshot}" var="insert" scope="session" >
                INSERT INTO muses_config(config_name, silent_mode, access_attempts_before_blocking, date) VALUES (?,?,?,?);
                <c:choose>
                    <c:when test="${param.silent == 0}">
                        <sql:param value="VERBOSE" />
                    </c:when>
                    <c:otherwise>
                        <sql:param value="SILENT" />
                    </c:otherwise>
                </c:choose>
                <sql:param value="${param.silent}" />
                <sql:param value="${maxLogin}" />
                <sql:param value="${currentDate}" />
            </sql:update>
                
            <sql:query dataSource="${snapshot}" var="resultSilent" scope="session" >
                SELECT silent_mode, access_attempts_before_blocking FROM muses_config ORDER BY date DESC LIMIT 1;
            </sql:query>

            <c:forEach var="row" items="${resultSilent.rows}">
                <c:set var="silentMode" value="${row.silent_mode}"/>
                <c:set var="maxLogin" value="${row.access_attempts_before_blocking}"/>
            </c:forEach>
        </c:if>

        <title>MUSES tool for CSOs - MUSES Configuration</title>
    </head>
    <body>
        
        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        
        <h2 class="ui center aligned icon header">
            <i class="configure icon"></i>           
            <div class="content">
                MUSES Configuration
            </div>
        </h2>
        <div class="ui divider"></div>
        
        <br>
        
        <c:if test="${not empty param.errMsg}">
            <div class="ui negative message"><c:out value="${param.errMsg}" /></div>
            <br>
        </c:if>
        
        <c:set var="totalCount" scope="session" value="${result.rowCount}"/>
                    
        <c:if test="${totalCount > 0 }">
            <c:set var="perPage" scope="session" value="10"/>
            <c:set var="totalPages" scope="session" value="${totalCount/perPage}"/>

            <c:set var="pageIndex" scope="session" value="${param.start/perPage+1}"/>
        </c:if>        
        
        <div class="ui toggle checkbox">
            <input name="silent" type="checkbox">
            <label>Silent Mode</label>
        </div>
        
        <script>
            $( document ).ready( function() {
                $('.ui.toggle.checkbox').checkbox();
                var status = parseInt("${silentMode}");
                if (status === 1) {
                    $('.ui.toggle.checkbox').checkbox('check');
                } else {
                    $('.ui.toggle.checkbox').checkbox('uncheck');
                }
                $('.ui.toggle.checkbox').first().checkbox({
                    onChange: function() {
                        var value = $('.ui.toggle.checkbox').checkbox('is checked');
                        if(value) {
                            window.location.href = 'configuration.jsp?silent=1';
                        } else {
                            window.location.href = 'configuration.jsp?silent=0';
                        }
                    }
                });
                if ("${result.rowCount}" === 0) {
                    alert("No configurations in the database.");
                }
            });
        </script>

        <table class="ui celled table">
            <thead>
                <tr>
                    <th>#Configuration</th>
                    <th>Timeout</th>
                    <th>Poll Timeout</th>
                    <th>Sleep Poll Timeout</th>
                    <th>Polling Enabled</th>
                    <th>Maximum login Attempts</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="rowBody" items="${result.rows}" begin="${param.start}" end="${param.start+perPage}">
                <tr>
                    <td><c:out value="${rowBody.config_id}"/></td>
                    <c:choose>
                        <c:when test="${not empty param.configid 
                                        and rowBody.config_id == param.configid 
                                        and param.parameter == 'timeout'}">
                            <td>
                                <form class="ui form" method="POST" action="update_configuration_db.jsp?configid=${rowBody.config_id}">
                                    <div class="field">
                                        <input placeholder="${rowBody.timeout}" name="newTimeout" type="text">
                                    </div>
                                    <button class="ui purple button" type="submit" value="submit">Update</button>
                                </form>
                            </td>
                        </c:when>
                        <c:otherwise>
                            <td><c:out value="${rowBody.timeout}"/> 
                                <div class="right floated content">
                                    <div class="ui button" onclick="location.href = 'configuration.jsp?configid=${rowBody.config_id}&parameter=timeout'">Change</div>
                                </div>
                            </td>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${not empty param.configid 
                                        and rowBody.config_id == param.configid 
                                        and param.parameter == 'pollTimeout'}">
                            <td>
                                <form class="ui form" method="POST" action="update_configuration_db.jsp?configid=${rowBody.config_id}">
                                    <div class="field">
                                        <input placeholder="${rowBody.poll_timeout}" name="newPollTimeout" type="text">
                                    </div>
                                    <button class="ui purple button" type="submit" value="submit">Update</button>
                                </form>
                            </td>
                        </c:when>
                        <c:otherwise>
                            <td><c:out value="${rowBody.poll_timeout}"/> 
                                <div class="right floated content">
                                    <div class="ui button" onclick="location.href = 'configuration.jsp?configid=${rowBody.config_id}&parameter=pollTimeout'">Change</div>
                                </div>
                            </td>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${not empty param.configid 
                                        and rowBody.config_id == param.configid 
                                        and param.parameter == 'sleepPollTimeout'}">
                            <td>
                                <form class="ui form" method="POST" action="update_configuration_db.jsp?configid=${rowBody.config_id}">
                                    <div class="field">
                                        <input placeholder="${rowBody.sleep_poll_timeout}" name="newSleepPollTimeout" type="text">
                                    </div>
                                    <button class="ui purple button" type="submit" value="submit">Update</button>
                                </form>
                            </td>
                        </c:when>
                        <c:otherwise>
                            <td><c:out value="${rowBody.sleep_poll_timeout}"/> 
                                <div class="right floated content">
                                    <div class="ui button" onclick="location.href = 'configuration.jsp?configid=${rowBody.config_id}&parameter=sleepPollTimeout'">Change</div>
                                </div>
                            </td>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${not empty param.configid 
                                        and rowBody.config_id == param.configid 
                                        and param.parameter == 'pollingEnabled'}">
                            <td>
                                <form class="ui form" method="POST" action="update_configuration_db.jsp?configid=${rowBody.config_id}">
                                    <div class="field">
                                        <input placeholder="${rowBody.polling_enabled}" name="newPollingEnabled" type="text">
                                    </div>
                                    <button class="ui purple button" type="submit" value="submit">Update</button>
                                </form>
                            </td>
                        </c:when>
                        <c:otherwise>
                            <td><c:out value="${rowBody.polling_enabled}"/> 
                                <div class="right floated content">
                                    <div class="ui button" onclick="location.href = 'configuration.jsp?configid=${rowBody.config_id}&parameter=pollingEnabled'">Change</div>
                                </div>
                            </td>
                        </c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${not empty param.configid 
                                        and rowBody.config_id == param.configid 
                                        and param.parameter == 'loginAttempts'}">
                            <td>
                                <form class="ui form" method="POST" action="update_configuration_db.jsp?configid=${rowBody.config_id}">
                                    <div class="field">
                                        <input placeholder="${rowBody.login_attempts}" name="newLoginAttempts" type="text">
                                    </div>
                                    <button class="ui purple button" type="submit" value="submit">Update</button>
                                </form>
                            </td>
                        </c:when>
                        <c:otherwise>
                            <td><c:out value="${rowBody.login_attempts}"/> 
                                <div class="right floated content">
                                    <div class="ui button" onclick="location.href = 'configuration.jsp?configid=${rowBody.config_id}&parameter=loginAttempts'">Change</div>
                                </div>
                            </td>
                        </c:otherwise>
                    </c:choose>
                </tr>
            </c:forEach>
            </tbody>
        </table>       

        <c:if test="${perPage > 0 and totalPages > 0 and pageIndex > 0}">
            <div class="ui purple right floated pagination inverted menu" id="pages">
                <c:if test="${!empty param.start && param.start >(perPage-1) && param.start !=0 }">
                  <a class="icon item" href="?start=<c:out value="${param.start - perPage}"/>">
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
                    <a class="icon item" href="?start=<c:out value="${param.start + perPage}"/>">
                         <i class="right chevron icon"></i>
                    </a>
                </c:if>
            </div>
        </c:if>                
            
        <br /><br />

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>

