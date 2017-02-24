FROM timhaak/plex

RUN apt-get -q update && \
    apt-get install -qy cron fuse unzip && \
    curl -O http://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    unzip rclone-current-linux-amd64.zip && \
    cd rclone-*-linux-amd64 && \
    cp rclone /usr/sbin/ && \
    mkdir /data/acd

ADD crontab /etc/cron.d/acd-cron
RUN chmod +x /etc/cron.d/acd-cron

CMD rclone --config /config/rclone.conf mount ACDcrypt: /data/acd & cron && ./start.sh
