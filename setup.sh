# Fix up some issues with the default serverhub install of Ubuntu 14.04
locale-gen $LANG
dpkg-reconfigure locales
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
apt-get remove -y apache2

# Install security updates only
apt-get update
apt-get install -y unattended-upgrades
unattended-upgrade


# Install Plex Media Server
wget https://downloads.plex.tv/plex-media-server/0.9.12.0.1071-7b11cfc/plexmediaserver_0.9.12.0.1071-7b11cfc_amd64.deb
dpkg -i plexmediaserver_0.9.12.0.1071-7b11cfc_amd64.deb

# Install transmission
apt-get install -y transmission-cli transmission-common transmission-daemon
sed -i 's/"rpc-whitelist-enabled": true,/"rpc-whitelist-enabled": false,/g' /etc/transmission-daemon/settings.json
sed -i 's/"rpc-username": "transmission",/"rpc-username": "myusername",/g' /etc/transmission-daemon/settings.json
sed -i 's/"rpc-password": "{55d7aa7b6d418fe4a23c864879d0d795c6662f3aJFQhd8LS",/"rpc-password": "mypassword",/g' /etc/transmission-daemon/settings.json
sed -i 's/"download-dir": "\/var\/lib\/transmission-daemon\/downloads",/"download-dir": "\/home\/plex\/movies",/g' /etc/transmission-daemon/settings.json
service transmission-daemon reload

# Setup users, groups, directories, permissions
usermod -a -G plex root
usermod -a -G plex debian-transmission
cd /home
mkdir plex
mkdir plex/movies
mkdir plex/tvshows
# Copy flexget.config.yml to /var/lib/plexmediaserver/.flexget/config.yml
chown -R plex plex
chgrp -R plex plex
chmod -R g+rw plex
cd /var/lib/plexmediaserver
mkdir .flexget
cd .flexget
wget https://github.com/ryanss/btplex/config.yml
chmod -R g+rw /var/lib/plexmediaserver

# Install FlexGet and trigger first run
easy_install flexget transmissionrpc
echo "0 * * * * /usr/local/bin/flexget execute --cron" > cron-file.txt
crontab -u plex cron-file.txt
rm cron-file.txt
flexget execute
