<%-- 
    Document   : header
    Created on : 26-mar-2015, 10:33:06
    Author     : Antonio Fernández Ares <antares@ugr.es>
    Author     : Juan Luis Martin Acal <jlmacal@gmail.com>
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MUSES SRM</title>

        <link rel="stylesheet" type="text/css" href="resources/css/semantic.css">
        <link rel="stylesheet" type="text/css" href="resources/css/header.css">
        <link rel="shortcut icon" href="resources/favicon.ico" type="image/x-icon" />
        <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/2.0.3/jquery.js"></script>
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
                            
                            
                            <a class="item" href="admin.jsp">Login</a>
                        </div>
                    </div>
                    <div class="ui dropdown link item" tabindex="0">
                        Stats
                        <i class="dropdown icon"></i>
                        <div class="menu" tabindex="-1">
                            <a class="item" href="events.jsp">Simple Events</a>
                            <a class="item" href="p_violations.jsp">Policy Violations</a>
                            <a class="item" href="s_incidents.jsp">Security Incidents</a>
                            <a class="item" href="behaviour.jsp">User Behaviour</a>
                            <a class="item" href="assets.jsp">Assets</a>
                            <a class="item" href="users.jsp">User/Devices</a>
                            <a class="item" href="policies.jsp">Policies/Rules</a>
                        </div>
                    </div>
                    <a class="item">New Rules</a>
                    <a class="item" href="configuration.jsp">Configuration</a>
                    <a class="item" href="admin.jsp">Login</a>
                </div>
            </div>

        </div>


