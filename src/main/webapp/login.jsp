<%-- 
    Document   : login
    Created on : Mar 25, 2015, 3:32:14 PM
    Author     : Vahid
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Form</title>
    </head>
    <body>
        <h2>Hello, please log in:</h2>
        <form method="post" action=<c:url value="j_security_check"/>>
            <table>
                <tr>
                    <td>Username: </td>
                    <td><input type="text" name="j_username"/></td>
                </tr>
                <tr>
                    <td>Password: </td>
                    <td><input type="password" name="j_password"/></td>
                </tr>
                <tr>
                    <td><input type="submit" value="Login"/></td>
                    <td><input type="reset" value="Reset"/></td>
                </tr>
            </table>
        </form>
    </body>
</html>
