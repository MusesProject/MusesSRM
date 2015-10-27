<%-- 
    Document   : connection_config
    Created on : 27-oct-2015, 11:14:18
    Author     : paloma
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
        
        <sql:query dataSource="${snapshot}" var="result" scope="session" >
            SELECT * FROM connection_config;
        </sql:query>

        <title>MUSES tool for CSOs - MUSES Connection configuration</title>
    </head>
    <body>
        
        <jsp:include page="modules/header.jsp"></jsp:include>
        <jsp:include page="modules/menu.jsp"></jsp:include>
        
        <h2 class="ui center aligned icon header">
            <i class="wifi icon"></i>           
            <div class="content">
                MUSES Connection configuration
            </div>
        </h2>
        <div class="ui divider"></div>
        
        <br>
        
        <c:if test="${not empty param.errMsg}">
            <div class="ui negative message"><c:out value="${param.errMsg}" /></div>
            <br>
        </c:if>
        
        <c:set var="totalCount" scope="session" value="${result.rowCount}"/>
        
        <c:if test="${totalCount == 0 }">
            <c:redirect url="configuration.jsp" >
                <c:param name="errMsg" value="No connection configurations in the database." />
            </c:redirect>
        </c:if>
        
        <c:set var="perPage" scope="session" value="30"/>
        <c:set var="totalPages" scope="session" value="${totalCount/perPage}"/>

        <c:set var="pageIndex" scope="session" value="${param.start/perPage+1}"/>

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
                                    <div class="ui button" onclick="location.href = 'connection_config.jsp?configid=${rowBody.config_id}&parameter=timeout'">Change</div>
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
                                    <div class="ui button" onclick="location.href = 'connection_config.jsp?configid=${rowBody.config_id}&parameter=pollTimeout'">Change</div>
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
                                    <div class="ui button" onclick="location.href = 'connection_config.jsp?configid=${rowBody.config_id}&parameter=sleepPollTimeout'">Change</div>
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
                                    <div class="ui button" onclick="location.href = 'connection_config.jsp?configid=${rowBody.config_id}&parameter=pollingEnabled'">Change</div>
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
                                    <div class="ui button" onclick="location.href = 'connection_config.jsp?configid=${rowBody.config_id}&parameter=loginAttempts'">Change</div>
                                </div>
                            </td>
                        </c:otherwise>
                    </c:choose>
                </tr>
            </c:forEach>
            </tbody>
        </table>       
        
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
        <br /><br />

        <jsp:include page="modules/footer.jsp"></jsp:include>
    </body>
</html>
