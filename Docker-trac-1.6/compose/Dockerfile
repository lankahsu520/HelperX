FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install \
            supervisor \
            apache2 \
            rsyslog \
            dbus \
            vim \
            subversion \
            curl \
            git \
            tree \
            -y

RUN apt-get install \
            python3 \
            python3-setuptools \
            python3-pip \
            python3-subversion \
            python3-jinja2 \
            libsvn-dev swig \
            libapache2-mod-svn \
            libapache2-mod-wsgi-py3 \
            -y
# ubuntu:20.04
# E: Package 'python3-subversion' has no installation candidate

RUN apt-get install \
            locales \
            -y

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en

RUN apt-get clean
RUN apt-get autoclean
RUN apt-get autoremove --purge

# dash -> bash
RUN cd /bin && rm sh; ln -s bash sh

#WORKDIR /work

# for python 3.12
ENV PIP_668=--break-system-packages
# 安裝 Trac 1.6
RUN pip install \
            ${PIP_668} \
            babel \
            Trac==1.6

# 建立 Trac 目錄
RUN mkdir -p /var/trac
#VOLUME ["/var/trac/conf"]

#ENV MYPROJECT_TRACDIR=/var/trac
ARG MYPROJECT_TRACDIR
#ENV MYPROJECT_NAME=lanka520
ARG MYPROJECT_NAME

RUN trac-admin $MYPROJECT_TRACDIR initenv $MYPROJECT_NAME sqlite:db/trac.db
RUN trac-admin $MYPROJECT_TRACDIR deploy $MYPROJECT_TRACDIR/www
RUN chmod ugo+x $MYPROJECT_TRACDIR/www/cgi-bin/*

# 設定使用者帳號和密碼
#ENV MYPROJECT_ADMIN=lanka
ARG MYPROJECT_ADMIN
#ENV MYPROJECT_ADMIN_PASS=123456
#ARG MYPROJECT_ADMIN_PASS

#RUN htpasswd -b -c $MYPROJECT_TRACDIR/conf/.htpasswd $MYPROJECT_ADMIN $MYPROJECT_ADMIN_PASS

# 設定管理者帳號
RUN trac-admin $MYPROJECT_TRACDIR permission add $MYPROJECT_ADMIN TRAC_ADMIN
RUN trac-admin $MYPROJECT_TRACDIR permission add @viewers LOG_VIEW FILE_VIEW WIKI_VIEW WIKI_CREATE WIKI_MODIFY SEARCH_VIEW REPORT_VIEW REPORT_SQL_VIEW
RUN trac-admin $MYPROJECT_TRACDIR permission add @viewers TICKET_VIEW TICKET_CREATE TICKET_MODIFY BROWSER_VIEW TIMELINE_VIEW CHANGESET_VIEW ROADMAP_VIEW MILESTONE_VIEW

# 移除 anonymous 的權限 BROWSER_VIEW 和 FILE_VIEW
RUN trac-admin /var/trac permission remove anonymous BROWSER_VIEW
RUN trac-admin /var/trac permission remove anonymous FILE_VIEW

#RUN trac-admin $MYPROJECT_TRACDIR permission add authenticated BROWSER_VIEW
#RUN trac-admin $MYPROJECT_TRACDIR permission add authenticated FILE_VIEW

# 安裝 PLUGIN
#ENV PJ_PYTHON_BIN=python
#ubuntu:18.04
#ENV PJ_PYTHON_VER=2.7

ENV PJ_PYTHON_BIN=python3
#ubuntu:20.04
#ENV PJ_PYTHON_VER=3.8
# ubuntu:22.04 
#ENV PJ_PYTHON_VER=3.10
# ubuntu:24.04 
#ENV PJ_PYTHON_VER=3.12

RUN PJ_PYTHON_VER=`python3 -c 'import sys; print("{0[0]}.{0[1]}".format(sys.version_info))'` \
    && update-alternatives --install /usr/bin/python python /usr/bin/python${PJ_PYTHON_VER} 12 \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PJ_PYTHON_VER} 12 \
    && ln -s /usr/local/lib/python${PJ_PYTHON_VER} /usr/local/lib/python3

RUN svn co https://trac-hacks.org/svn/accountmanagerplugin/tags/acct_mgr-0.6.0 /tmp/acct_mgr \
    && cd /tmp/acct_mgr && $PJ_PYTHON_BIN setup.py bdist_egg \
    && cp dist/*.egg /usr/local/lib/python3/dist-packages/ \
    && mkdir -p $MYPROJECT_TRACDIR/plugins \
    && cp dist/*.egg $MYPROJECT_TRACDIR/plugins

RUN svn co https://trac-hacks.org/svn/tracwysiwygplugin/0.12 /tmp/tracwysiwygplugin \
    && cd /tmp/tracwysiwygplugin && $PJ_PYTHON_BIN setup.py bdist_egg \
    && cp dist/*.egg /usr/local/lib/python3/dist-packages/ \
    && mkdir -p $MYPROJECT_TRACDIR/plugins \
    && cp dist/*.egg $MYPROJECT_TRACDIR/plugins

RUN svn co https://trac-hacks.org/svn/svnauthzadminplugin/1.0 /tmp/svnauthzadminplugin \
    && cd /tmp/svnauthzadminplugin && $PJ_PYTHON_BIN setup.py bdist_egg \
    && cp dist/*.egg /usr/local/lib/python3/dist-packages/ \
    && mkdir -p $MYPROJECT_TRACDIR/plugins \
    && cp dist/*.egg $MYPROJECT_TRACDIR/plugins

RUN svn co https://trac-hacks.org/svn/tracpygit2plugin/trunk /tmp/tracpygit2plugin \
    && cd /tmp/tracpygit2plugin && pip install ./ $PIP_668

RUN svn co https://trac-hacks.org/svn/logviewerplugin/trunk /tmp/logviewerplugin \
    && cd /tmp/logviewerplugin && pip install ./ $PIP_668

RUN svn co https://trac-hacks.org/svn/wikiautocompleteplugin/trunk /tmp/wikiautocompleteplugin \
    && cd /tmp/wikiautocompleteplugin && pip install ./ $PIP_668

RUN svn co https://trac-hacks.org/svn/tracdragdropplugin/0.12 /tmp/tracdragdropplugin \
    && cd /tmp/tracdragdropplugin && pip install ./ $PIP_668

#RUN git clone https://github.com/trac-hacks/trac-readme-plugin.git /tmp/trac-readme-plugin \
#    && cd /tmp/trac-readme-plugin && $PJ_PYTHON_BIN setup.py bdist_egg \
#    && cp dist/*.egg /usr/local/lib/python3/dist-packages/ \
#    && mkdir -p $MYPROJECT_TRACDIR/plugins \
#    && cp dist/*.egg $MYPROJECT_TRACDIR/plugins

RUN cp $MYPROJECT_TRACDIR/VERSION $MYPROJECT_TRACDIR/conf
RUN cp $MYPROJECT_TRACDIR/VERSION $MYPROJECT_TRACDIR/db
RUN cp $MYPROJECT_TRACDIR/VERSION $MYPROJECT_TRACDIR/htdocs
RUN cp $MYPROJECT_TRACDIR/VERSION $MYPROJECT_TRACDIR/log
RUN cp $MYPROJECT_TRACDIR/VERSION $MYPROJECT_TRACDIR/plugins
RUN cp $MYPROJECT_TRACDIR/VERSION $MYPROJECT_TRACDIR/templates

# trac_banner
COPY trac_banner.png $MYPROJECT_TRACDIR/trac_banner.png

RUN chown -R www-data: $MYPROJECT_TRACDIR
RUN chmod -R 775 $MYPROJECT_TRACDIR

# 啟用 Apache WSGI
RUN a2enmod wsgi
RUN a2dissite 000-default
#RUN a2enmod python
# enable Apache mod_env, mod_cgi, mod_alias, mod_rewrite, ... modules
RUN a2enmod env cgi alias rewrite dav dav_fs
RUN a2enmod dav_svn

# enable the trac site configuration
#RUN a2ensite trac.conf
#RUN a2ensite svn.conf
#RUN service apache2 reload

# add svn repository - svn123
#RUN chmod -R 775 $MYPROJECT_TRACDIR/repositories/svn-create-repo.sh
#WORKDIR $MYPROJECT_TRACDIR/repositories
#ENV REPO_NAME=svn123
#RUN ./svn-create-repo.sh $REPO_NAME

# dbus
RUN mkdir -p /run/dbus \
    && dbus-uuidgen > /etc/machine-id
COPY dbusX.conf /etc/dbus-1/system.d

# apache2
# CMD ["apachectl", "-D", "FOREGROUND"]
EXPOSE 80

# shellscript
COPY chown-www-data123.sh /sbin

# supervisord
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-n"]
