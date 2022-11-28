#!/bin/bash
 
SVN_DIR="/work_svnroot"
REPO_NAME=$1
 
sudo svnadmin create $SVN_DIR/${REPO_NAME}
 
#sudo vi ${SVN_DIR}/${REPO_NAME}/conf/svnserve.conf
sudo sed -i "s|\# anon-access =.*|anon-access = read|g" ${SVN_DIR}/${REPO_NAME}/conf/svnserve.conf
sudo sed -i "s|\# auth-access =.*|auth-access = write|g" ${SVN_DIR}/${REPO_NAME}/conf/svnserve.conf
sudo sed -i "s|\# password-db =.*|password-db = passwd|g" ${SVN_DIR}/${REPO_NAME}/conf/svnserve.conf
sudo sed -i "s|\# authz-db =.*|authz-db = authz|g" ${SVN_DIR}/${REPO_NAME}/conf/svnserve.conf
sudo sed -i "s|\# realm =.*|realm = ${REPO_NAME}|g" ${SVN_DIR}/${REPO_NAME}/conf/svnserve.conf

#sudo vi ${SVN_DIR}/${REPO_NAME}/conf/passwd

sudo chown -R www-data: ${SVN_DIR}/${REPO_NAME}
sudo chmod -R 775 ${SVN_DIR}/${REPO_NAME}
sudo chmod -R 777 ${SVN_DIR}/${REPO_NAME}/db

echo "Git repository '${REPO_NAME}' created in ${SVN_DIR}/${REPO_NAME}"

