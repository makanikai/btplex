rclone --config /rclone.conf moveto /data/movies/ B2:btplex/movies >> /config/rclone.log 2>&1
rclone --config /rclone.conf moveto /data/tvshows/ B2:btplex/tvshows >> /config/rclone.log 2>&1
find /data/movies/* -type d -empty -delete
find /data/tvshows/* -type d -empty -delete
if [ -z "$(mount | grep /b2)" ]; then rclone --config /rclone.conf mount B2:btplex /b2; fi >> /config/rclone.log 2>&1
/usr/lib/plexmediaserver/Plex\ Media\ Scanner --scan
