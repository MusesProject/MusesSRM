<%-- 
    Document   : login
    Created on : Mar 25, 2015, 3:32:14 PM
    Author     : Vahid
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<jsp:include page="modules/header.jsp"></jsp:include>
<jsp:include page="modules/menu.jsp"></jsp:include>
<jsp:include page="modules/musesintro.jsp"></jsp:include>



    <form class='ui form' method="post" action=<c:url value="j_security_check"/>>
    <h4 class="ui dividing header"></h4>
    
    <div class="ui form">
        <div class="four wide field">
            <label>Username</label>
                <div class="ui left icon input">
                    <input type="text" name="j_username" placeholder="Your username">
                    <i class="user icon"></i>
                </div>
        </div>
        <div class="four wide field">
            <label>Password</label>
                <div class="ui left icon input">
                    <input type="password" name="j_password" placeholder="Your password">
                    <i class="lock icon"></i>
                </div>
        </div>
            <input class='ui purple submit button' type="submit" value="Login"/>
            <input class='ui submit button' type="reset" value="Reset"/>
        </div>
    
    </form>


<jsp:include page="modules/footer.jsp"></jsp:include>