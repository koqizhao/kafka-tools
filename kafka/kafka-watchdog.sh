pid=$(/usr/java/default/bin/jps -l | awk '$2=="kafka.Kafka"{print $1}')

if [ "${pid}" == "" ]; then
	cd /home/koqizhao/kafka/kafka
	./kafka.sh daemon-start
fi
