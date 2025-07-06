# Use an official Tomcat base image
FROM tomcat:8.0.20-jre8

# Optional: Remove default webapps to reduce clutter
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file into the webapps directory
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

# Set environment variables if needed (e.g., Java opts)
# ENV JAVA_OPTS="-Xms512m -Xmx1024m"

# Expose the default Tomcat port
EXPOSE 8080

# Default command 
CMD ["catalina.sh", "run"]
