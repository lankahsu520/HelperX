FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install \
            supervisor \
            apache2 \
            rsyslog \
            dbus \
            -y

RUN apt-get clean
RUN apt-get autoclean
RUN apt-get autoremove --purge

# dash -> bash
RUN cd /bin && rm sh; ln -s bash sh

WORKDIR /work

# dbus
RUN mkdir -p /run/dbus \
    && dbus-uuidgen > /etc/machine-id
COPY dbusX.conf /etc/dbus-1/system.d

# apache2
# CMD ["apachectl", "-D", "FOREGROUND"]
EXPOSE 80

# supervisord
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-n"]
