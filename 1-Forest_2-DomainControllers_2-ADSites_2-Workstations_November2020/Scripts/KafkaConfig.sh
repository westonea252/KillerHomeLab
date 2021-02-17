sudo useradd kafka -m

sudo adduser kafka sudo

sudo adduser kafka sudo


mkdir ~/Downloads
curl "https://downloads.apache.org/kafka/2.7.0//kafka-2.7.0-src.tgz" -o ~/Downloads/kafka.tgz
mkdir ~/kafka && cd ~/kafka
tar -xvzf ~/Downloads/kafka.tgz --strip 1

nano ~/kafka/config/server.properties