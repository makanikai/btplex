FROM timhaak/plex

RUN apt-get -q update && \
    apt-get install -qy cron fuse unzip && \
    curl -Os https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    unzip rclone-current-linux-amd64.zip && \
    cd rclone-*-linux-amd64 && \
    cp rclone /bin/ && \
    mkdir /b2

ADD crontab /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab

ADD cronjob.sh /cronjob.sh
RUN chmod +x /cronjob.sh

ADD backup.sh /backup.sh
RUN chmod +x /backup.sh


ADD update.sh /update.sh
RUN chmod +x /update.sh
RUN /update.sh

ADD config.env /config.env
ADD b2.sh /b2.sh
RUN chmod +x /b2.sh
RUN /b2.sh

VOLUME /btplex

CMD rclone --config /rclone.conf mount B2:btplex /b2 & cron && ./update.sh && ./start.sh
