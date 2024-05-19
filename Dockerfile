
FROM tomcat:latest
RUN cp -R  /home/ubuntu/workspace/Register-app/webapp/target/webapp.war /usr/local/tomcat/webapps/

# Expose port 8080 to the outside world
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
