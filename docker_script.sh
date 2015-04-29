##########################################################################3
## Script Name: docker_script.sh
## Description:
##	To create container from image, install pre-reqiuites package, install puppet modules in container. And copy application war file into app server.
#####

#!/bin/bash

tomcat_loc='/usr/tomcat-catalina'
echo "tomcat location" $tomcat_loc

uniq_id=`date +%Y%m%d%H%M%S`
docker run -d -t -i -p 80:8080 -e TOMCAT_HOME=$tomcat_loc --name test_lab_$uniq_id -v /root/puppet:/puppet devopsil/puppet /bin/bash
container_id=`docker ps -a | grep -i test_lab_$uniq_id | awk -F' ' '{print $1}'`
docker exec $container_id yum install -y tar
docker exec $container_id  puppet apply --modulepath=/puppet/modules /puppet/manifests/site.pp --logdest=/var/log/test_lab_$uniq_id.log

docker exec $container_id /bin/cp /puppet/JPetStore.war $tomcat_loc/webapps/.
