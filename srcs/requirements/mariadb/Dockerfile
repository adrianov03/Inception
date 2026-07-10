FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

COPY conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["docker-entrypoint.sh"]
