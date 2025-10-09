FROM nginx:alpine

# Copy HTML files to nginx default directory
COPY index.html /usr/share/nginx/html/
COPY privacy.html /usr/share/nginx/html/

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
