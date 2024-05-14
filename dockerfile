# Use the official Ubuntu base image
FROM nginx:latest
COPY . /usr/share/nginx/html/
COPY nginx/ /etc/nginx/
# Expose port 80 for your application
EXPOSE 80
# Expose port 8080 for your metrics
EXPOSE 8081
