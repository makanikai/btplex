FROM timhaak/plex

RUN apt-get -q update && \
    apt-get install -qy cron

ADD crontab /etc/cron.d/crontab
RUN chmod 0644 /etc/cron.d/crontab

ADD backup.sh /backup.sh
RUN chmod +x /backup.sh

ADD update.sh /update.sh
RUN chmod +x /update.sh
RUN /update.sh

VOLUME /btplex

CMD cron && ./update.sh && ./start.sh
