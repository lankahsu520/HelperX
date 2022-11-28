#!/bin/bash
 
GIT_DIR="/work_gitroot"
REPO_NAME=$1
 
mkdir -p ${GIT_DIR}/${REPO_NAME}
cd ${GIT_DIR}/${REPO_NAME}
 
git init --bare &> /dev/null
touch git-daemon-export-ok
cp hooks/post-update.sample hooks/post-update
git config http.receivepack true
git update-server-info

sudo chown -R www-data:www-data ${GIT_DIR}/${REPO_NAME}
sudo chgrp -R git ${GIT_DIR}/${REPO_NAME}
sudo chmod g+rwx -R ${GIT_DIR}/${REPO_NAME}

echo "Git repository '${REPO_NAME}' created in ${GIT_DIR}/${REPO_NAME}"

