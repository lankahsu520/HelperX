#!/bin/bash

GIT_DIR=`pwd`
REPO_NAME=$1

[ -z "$REPO_NAME" ] && { echo "Please check REPO_NAME !!!"; exit 1; }

mkdir -p $GIT_DIR/${REPO_NAME}
cd $GIT_DIR/${REPO_NAME}

git --bare init

chown -R www-data: ${GIT_DIR}/${REPO_NAME}
chmod -R 775 ${GIT_DIR}/${REPO_NAME}

#chgrp -R git ${GIT_DIR}/${REPO_NAME}
chmod g+rwx -R ${GIT_DIR}/${REPO_NAME}

echo "Git repository '${REPO_NAME}' created in ${GIT_DIR}/${REPO_NAME}"

