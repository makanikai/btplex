tar czvf /backup.tar.gz /btplex
rclone --config /rclone.conf copy /backup.tar.gz ACD: >> /var/log/cron.log 2>&1
