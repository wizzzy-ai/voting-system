# Use official Tomcat image with Java 17
FROM tomcat:9.0-jdk17

# Remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your WAR into Tomcat as ROOT
COPY target/your-app.war /usr/local/tomcat/webapps/ROOT.war

# Expose port (Render maps this automatically)
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
