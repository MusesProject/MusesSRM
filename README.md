# MusesSRM

Muses Security and Risk Management GUI for MUSES server

## Working with it

You will have to download the version of Netbeans than contains all components (especially important NetBeans Platform SDK and Apache Tomcat) from [here](https://netbeans.org/downloads/). The plain 7.0 version you download from OS repos will not cut it. The JDK from the repos won't either, you'll have to install it [from a PPA](http://www.webupd8.org/2012/01/install-oracle-java-jdk-7-in-ubuntu-via.html).

During the installation of NetBeans is important to remember that in the section on customizing the installation is necessary to check the option to install Apache Tomcat because this is disabled by default. On the other hand, JDK installation will take place automatically.

### After the installation of Netbeans

0. Install MySQL server.
1. Make sure you have a database called "muses" and another called "tomcat_realm" in your MySQL server. If not, go to (https://github.com/MusesProject/MusesSRM/tree/master/src/main/resources/eu/musesproject/db) and run all the scripts in that folder (in the following order:)
	* ``startup_db.sql`` will create the structure of the "Muses" BD
	* ``db_tomcat_startup.sql`` will generate "tomcat_realm" BD
	* ``test-data-inserts.sql`` will add some data to "Muses" BD
	* ``init_db.sql`` will add more data to "Muses" BD

2. Make NetBeans aware of where the Tomcat folder is: Netbeans > Tools > Servers > Add Server > Apache Tomcat.
Then browse to Tomcat folder > Open. And finally enter _musesadmin_ as username and _musespass_ as password.
The Tomcat Folder is also called CATALINA_HOME.
3. Go to CATALINA_HOME/conf and open tomcat-users.xml in a text editor. Inside the _tomcat-users_ tag, include the following users:
```
<user password="musespass" roles="manager, manager-script, admin" username="musesadmin"/>
<user password="tomcat" roles="manager, manager-script, admin" username="tomcat"/>
```
4. Start the Apache server by going to Netbeans, then to Window > Services > Servers > Apache Tomcat or TomEE > Right-click and choose start.
5.  In case Tomcat fails to start, remove the double quote on _noJuliConfig_ and _noJuliManager_ in CATALINA_HOME/bin/catalina.bat. This is a bug http://stackoverflow.com/questions/22225764/starting-of-tomcat-failed-from-netbeans
6. Download [this library](http://mvnrepository.com/artifact/mysql/mysql-connector-java/5.1.30) and place it in CATALINA_HOME/lib. This is a Maven dependency in the SRM project, but by placing it in this folder manually, we prevent from possible future errors.
7. Go again to CATALINA_HOME/conf and open the file _server.xml_ in a text editor. Copy this under the _Realm_ tag. Feel free to modify the values if you have another configurations on your machine.
```
<Realm className="org.apache.catalina.realm.JDBCRealm"
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
```
8. In Netbeans: Run > Run Project (MUSESSRM).
9. The browser should pop up and show the website. Try to login with user _musesadmin_ and pass _musespass_ if you ran the database scripts in step 2.
10. Troubleshooting: Right-click on the MUSESSRM project in Netbeans and choose Properties > Run. Make sure the value of the server is the correct Tomcat in case you have several of them.
