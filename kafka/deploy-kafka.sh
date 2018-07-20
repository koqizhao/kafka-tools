#!/bin/bash

echo -n "password: "
read -s PASSWORD
echo

deploy()
{
    server=$1

    echo -e "deploy server started: $server\n"

    ssh $server "echo $PASSWORD | sudo -S systemctl stop kafka.service"
    ssh $server "mkdir -p ~/kafka"
    ssh $server "echo $PASSWORD | sudo -S rm -rf ~/kafka/kafka"

    scp -r kafka $server:./kafka/
    scp config/server-$i.properties $server:./kafka/kafka/config/server.properties
    scp kafka-env.sh $server:./kafka/kafka/
    scp kafka.sh $server:./kafka/kafka/
    scp kafka.service $server:./kafka/kafka/

    ssh $server "echo $PASSWORD | sudo -S mv ~/kafka/kafka/kafka.service /etc/systemd/system/"
    ssh $server "echo $PASSWORD | sudo -S systemctl daemon-reload"
    ssh $server "echo $PASSWORD | sudo -S systemctl start kafka.service"
    ssh $server "echo $PASSWORD | sudo -S systemctl enable kafka.service"

    echo -e "\ndeploy server finished: $server"
}

source ~/Share/servers.sh

for i in `seq 0 2`
do
    deploy ${servers[$i]}
done

