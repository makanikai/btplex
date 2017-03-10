tar czvf /backup.tar.gz /btplex \
    --exclude /btplex/media \
    --exclude /btplex/config/plex/Library/Application\ Support/Plex\ Media\ Server/Cache \
    --exclude /btplex/config/plex/Library/Application\ Support/Plex\ Media\ Server/Codecs \
    --exclude /btplex/config/plex/Library/Application\ Support/Plex\ Media\ Server/Crash\ Reports \
    --exclude /btplex/config/plex/Library/Application\ Support/Plex\ Media\ Server/Logs \
    --exclude /btplex/config/plex/Library/Application\ Support/Plex\ Media\ Server/Media \
    --exclude /btplex/config/plex/Library/Application\ Support/Plex\ Media\ Server/Metadata \
    --exclude /btplex/config/plex/Library/Application\ Support/Plex\ Media\ Server/Plug-in\ Support/Caches \
    --exclude /btplex/config/plex/Library/Application\ Support/Plex\ Media\ Server/Plug-in\ Support/Metadata \
    --exclude /btplex/config/plex/Library/Application\ Support/Plex\ Media\ Server/Plug-ins \
    --exclude /btplex/config/radarr/Backups \
    --exclude /btplex/config/radarr/logs \
    --exclude /btplex/config/radarr/MediaCover \
    --exclude /btplex/config/radarr/UpdateLogs \
    --exclude /btplex/config/radarr/xdg \
    --exclude /btplex/config/sonarr/Backups \
    --exclude /btplex/config/sonarr/logs \
    --exclude /btplex/config/sonarr/MediaCover \
    --exclude /btplex/config/sonarr/UpdateLogs \
    --exclude /btplex/config/sonarr/xdg

rclone --config /rclone.conf copy /backup.tar.gz ACD: >> /config/rclone.log 2>&1
