rclone --config /rclone.conf moveto /data/movies/ ACDcrypt:movies >> /config/rclone.log 2>&1
rclone --config /rclone.conf moveto /data/tvshows/ ACDcrypt:tvshows >> /config/rclone.log 2>&1
find /data/movies/* -type d -empty -delete
find /data/tvshows/* -type d -empty -delete
if [ -z "$(mount | grep /acd)" ]; then rclone --config /rclone.conf mount ACDcrypt: /acd; fi >> /config/rclone.log 2>&1
/usr/lib/plexmediaserver/Plex\ Media\ Scanner --scan
