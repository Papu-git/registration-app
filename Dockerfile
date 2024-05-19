


FROM tomcat

MAINTAINER papu

RUN apt-get update && apt-get -y upgrade

WORKDIR /usr/local/tomcat

# COPY /home/ubuntu/workspace/Register-app/webapp/target/webapp.war /usr/local/tomcat/webapps/
# # COPY context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml

# EXPOSE 8080

# FROM tomcat:latest
# RUN cp -R  /home/ubuntu/workspace/Register-app/webapp/target/webapp.war /usr/local/tomcat/webapps/

# # Expose port 8080 to the outside world
# EXPOSE 8080

# # Start Tomcat
# CMD ["catalina.sh", "run"]
