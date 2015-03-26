<%-- 
    Document   : menu
    Created on : 26-mar-2015, 11:37:31
    Author     : Antonio Fernández Ares <antares@ugr.es>
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<div class="ui right aligned grid " style="width: 100%; top-padding:2px;">
    <div class="left floated left aligned two wide column">
        
            <div class="ui vertical menu">
                <div class="item">
                    <div class="ui input"><input type="text" placeholder="Search..."></div>
                </div>
                <div class="item">
                    <i class="home icon"></i> Home
                    <div class="menu">
                        <a class="active item">Search</a>
                        <a class="item">Add</a>
                        <a class="item">Remove</a>
                    </div>
                </div>
                <a class="item">
                    <i class="grid layout icon"></i> Browse
                </a>
                <a class="item">
                    <i class="mail icon"></i> Messages
                </a>
                <div class="ui dropdown item">
                    More
                    <i class="dropdown icon"></i>
                    <div class="menu">
                        <a class="item"><i class="edit icon"></i> Edit Profile</a>
                        <a class="item"><i class="globe icon"></i> Choose Language</a>
                        <a class="item"><i class="settings icon"></i> Account Settings</a>
                    </div>
                </div>
            
        </div>
    </div>
    <div class="right floated left aligned fourteen wide column">
        <div class="ui segment">



