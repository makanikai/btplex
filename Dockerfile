FROM timhaak/plex

RUN apt-get -q update && \
    apt-get install -qy cron fuse unzip && \
    curl -O http://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    unzip rclone-current-linux-amd64.zip && \
    cd rclone-*-linux-amd64 && \
    cp rclone /bin/ && \
    mkdir /acd

ADD crontab /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab
ADD cronjob.sh /cronjob.sh
RUN chmod +x /cronjob.sh

VOLUME ["/rclone.conf", "/caddy"]

CMD rclone --config /rclone.conf mount ACDcrypt: /acd & cron && ./start.sh
