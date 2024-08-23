FROM docker:dind
RUN echo "https://ftp.halifax.rwth-aachen.de/alpine/v3.13/main" >> /etc/apk/repositories
RUN echo "https://ftp.halifax.rwth-aachen.de/alpine/v3.13/community" >> /etc/apk/repositories
RUN apk update && \
    apk upgrade && \
    apk add --update \
      bash openssh openrc vim rsyslog python3-dev libffi-dev openssl-dev gcc libc-dev rust cargo make \
      git curl wget ncurses docker-compose screen htop tcpdump apg busybox-extras bind-tools shadow \
      tzdata apache2-utils logrotate dcron sudo && \
    cp /usr/share/zoneinfo/UTC /etc/localtime && \
    echo "UTC" > /etc/timezone && \
    rm  -rf /tmp/* /var/cache/apk/*
RUN if [ ! -d "/var/run/sshd" ]; then mkdir -p /var/run/sshd; fi
RUN rc-update add sshd
RUN sed -i s/"root:!"/"root:*"/g /etc/shadow
RUN mkdir /etc/src
COPY .bashrc /etc/src/.bashrc
COPY sshd_config /etc/ssh/sshd_config
RUN mkdir /run/openrc && touch /run/openrc/softlevel
COPY screenrc /etc/screenrc
COPY entrypoint.sh /usr/local/bin/
COPY rsyslog.conf /etc/rsyslog.conf
RUN sed -i 's#\(root:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:\)[^:]*#\1/bin/bash#' /etc/passwd
RUN mkdir -p /var/www
RUN adduser -u 82 -D -G www-data www-data
RUN sed -i '/^www-data:/ s/:!/:/' /etc/shadow
RUN chown -R www-data:www-data /var/www
RUN usermod -a -G docker www-data
RUN chsh -s /bin/bash www-data
EXPOSE 22
EXPOSE 80
ENTRYPOINT ["entrypoint.sh"]
