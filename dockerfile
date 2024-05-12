# Use the official Ubuntu base image
FROM nginx:latest
COPY . /usr/share/nginx/html/
COPY status.conf /etc/nginx/conf.d/
