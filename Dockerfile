# Use the latest official Tomcat image as the base
FROM tomcat:latest

# Copy your WAR file into the Tomcat webapps directory
COPY /home/ubuntu/workspace/Register-app/webapp/target/webapp.war /usr/local/tomcat/webapps/

# Expose port 8080 to the outside world
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
