#!/bin/bash

chown -R www-data: /var/trac/auth/authz
chown -R www-data: /var/trac/conf/trac.ini
chown -R www-data: /var/trac/db/trac.db
chown -R www-data: /var/trac/log/trac.log

exit 0