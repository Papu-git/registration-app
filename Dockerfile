FROM tomcat:latest
RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps
COPY workspace/Register-app/webapp/target/*.war /usr/local/tomcat/webapps
