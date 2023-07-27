FROM mysql:5.7.42
ENV MYSQL_ROOT_PASSWORD=root_password
ENV MYSQL_DATABASE=vprofiledb
ENV MYSQL_USER=admin
ENV MYSQL_PASSWORD=admin123
COPY ./accountsdb.sql /docker-entrypoint-initdb.d/
EXPOSE 3306