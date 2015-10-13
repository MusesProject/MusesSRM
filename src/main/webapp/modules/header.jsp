<%-- 
    Document   : header
    Created on : 26-mar-2015, 10:33:06
    Author     : Antonio Fernández Ares <antares@ugr.es>
    Author     : Juan Luis Martin Acal <jlmacal@gmail.com>
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MUSES SRM</title>

        <link rel="stylesheet" type="text/css" href="resources/css/semantic.css">
        <link rel="stylesheet" type="text/css" href="resources/css/header.css">
        <link rel="shortcut icon" href="resources/favicon.ico" type="image/x-icon" />
        <link href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/ui-darkness/jquery-ui.min.css" rel="stylesheet">
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/jquery-ui.min.js"></script>
        <script src="resources/js/semantic.js"></script>
        <script src="resources/js/header.js"></script>

    </head>
    <body id="home">
        <div class="column">
            <div class="ui inverted pink menu">
                <div class="header item"><a href="index.jsp" > MUSES SRM</a></div>
                <div class="right menu">
                    <div class="ui mobile dropdown link item" tabindex="0">
                        Menu
                        <i class="dropdown icon"></i>
                        <div class="menu" tabindex="-1">
                            
                            
                            <a class="item" href="index.jsp">Login</a>
                        </div>
                    </div>
                    <div class="ui dropdown link item" tabindex="0">
                        Stats Menu
                        <i class="dropdown icon"></i>
                        <div class="menu" tabindex="-1">
                            <a class="item" href="events.jsp">Simple Events</a>
                            <a class="item" href="p_violations.jsp">Policy Violations</a>
                            <a class="item" href="s_incidents.jsp">Security Incidents</a>
                            <a class="item" href="behaviour.jsp">User Behaviour</a>
                            <a class="item" href="assets.jsp">Assets</a>
                            <a class="item" href="users.jsp">Users</a>
                            <a class="item" href="sec_rules.jsp">Security Rules</a>
                            <a class="item" href="rules.jsp">Rules</a>
                        </div>
                    </div>
                    <a class="item" href="chart.jsp">Charts</a>
                    <a class="item" href="configuration.jsp">Configuration</a>
                    <c:if test="${pageContext['request'].userPrincipal == null}">
                        <a class="item" href="index.jsp">Login</a>
                    </c:if>
                    <c:if test="${pageContext['request'].userPrincipal != null}">
                        <a class="item" href="logout.jsp">Logout</a>
                    </c:if>
                </div>
            </div>

        </div>


