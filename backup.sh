tar czvf /backup.tar.gz /btplex
rclone --config /rclone.conf copy /backup.tar.gz ACD: >> /config/rclone.log 2>&1
