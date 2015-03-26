DROP DATABASE IF EXISTS tomcat_realm;
CREATE DATABASE tomcat_realm;
USE tomcat_realm;
CREATE TABLE users (
username varchar(20) NOT NULL PRIMARY KEY,
password varchar(40) NOT NULL
);
CREATE TABLE roles (
rolename varchar(20) NOT NULL PRIMARY KEY
);
CREATE TABLE users_roles (
username varchar(20) NOT NULL,
rolename varchar(20) NOT NULL,
PRIMARY KEY (username, rolename),
CONSTRAINT users_roles_fk1 FOREIGN KEY (username) REFERENCES users (username),
CONSTRAINT users_roles_fk2 FOREIGN KEY (rolename) REFERENCES roles (rolename)
);
INSERT INTO `tomcat_realm`.`users` (`username`, `password`) VALUES ('musesadmin', sha('musespass'));
INSERT INTO `tomcat_realm`.`roles` (`rolename`) VALUES ('manager-gui');
INSERT INTO `tomcat_realm`.`roles` (`rolename`) VALUES ('manager-script');
INSERT INTO `tomcat_realm`.`roles` (`rolename`) VALUES ('manager');
INSERT INTO `tomcat_realm`.`roles` (`rolename`) VALUES ('admin-gui');
INSERT INTO `tomcat_realm`.`roles` (`rolename`) VALUES ('admin-script');
INSERT INTO `tomcat_realm`.`roles` (`rolename`) VALUES ('admin');
INSERT INTO `tomcat_realm`.`users_roles` (`username`, `rolename`) VALUES ('musesadmin', 'manager-gui');
INSERT INTO `tomcat_realm`.`users_roles` (`username`, `rolename`) VALUES ('musesadmin', 'manager-script');
INSERT INTO `tomcat_realm`.`users_roles` (`username`, `rolename`) VALUES ('musesadmin', 'manager');
INSERT INTO `tomcat_realm`.`users_roles` (`username`, `rolename`) VALUES ('musesadmin', 'admin-gui');
INSERT INTO `tomcat_realm`.`users_roles` (`username`, `rolename`) VALUES ('musesadmin', 'admin-script');
INSERT INTO `tomcat_realm`.`users_roles` (`username`, `rolename`) VALUES ('musesadmin', 'admin');
COMMIT;

CREATE USER 'tomcat'@'localhost' IDENTIFIED BY 'tomcat';
GRANT ALL PRIVILEGES ON tomcat_realm.* TO 'tomcat'@'localhost' WITH GRANT OPTION;

/* 
follow the steps below after running this script
1) Place mysql-connector-java.jar in tomcat_home/lib even if you have it as a maven dependency 
2) Place this inside tomcat server.xml underneath the existing realm tag

<Realm  className="org.apache.catalina.realm.JDBCRealm"
 driverName="com.mysql.jdbc.Driver"
 connectionURL="jdbc:mysql://localhost:3306/tomcat_realm"
 connectionName="tomcat"
 connectionPassword="tomcat"
 userTable="users"
 userNameCol="username"
 userCredCol="password"
 userRoleTable="users_roles"
 roleNameCol="rolename" 
 digest="SHA"/>

*/