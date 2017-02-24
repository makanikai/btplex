if [ -z "$(mount | grep /data/acd)" ]; then rclone --config /config/rclone.conf mount ACDcrypt: /acd; fi >> /var/log/cron.log 2>&1
rclone --config /config/rclone.conf moveto /data/movies/ ACDcrypt:movies >> /var/log/cron.log 2>&1
rclone --config /config/rclone.conf moveto /data/tvshows/ ACDcrypt:tvshows >> /var/log/cron.log 2>&1
find /data/movies/* -type d -empty -delete
find /data/tvshows/* -type d -empty -delete
