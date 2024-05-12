# Use the official Ubuntu base image
FROM nginx:latest
COPY . /usr/share/nginx/html/
