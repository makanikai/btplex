# This script automates setting up a Plex Media Server on a ServerHub VPS that
# includes a remote bittorrent client with web interface that automatically
# downloads your favourite television shows.

echo -n "Enter a Transmission username: "
read username
echo -n "Enter a Transmission password: "
read password
echo "Find your showRSS user_id."
echo "Generate your custom feed and get the user_id from the url."
echo "Example: http://showrss.info/rss.php?user_id=XXXXXX&hd=null&proper=1)"
echo "where XXXXXX is your user_id."
echo -n "Enter your showRSS user_id: "
read showrssid

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
sed -i "s/\"rpc-whitelist-enabled\": true,/\"rpc-whitelist-enabled\": false,/g" /etc/transmission-daemon/settings.json
sed -i "s/\"rpc-username\": \"transmission\",/\"rpc-username\": \"$username\",/g" /etc/transmission-daemon/settings.json
sed -i "s/\"rpc-password\": \"{.*\",/\"rpc-password\": \"$password\",/g" /etc/transmission-daemon/settings.json
sed -i "s/\"download-dir\": \"\/var\/lib\/transmission-daemon\/downloads\",/\"download-dir\": \"\/home\/plex\/movies\",/g" /etc/transmission-daemon/settings.json
service transmission-daemon reload

# Setup users, groups, directories, permissions
cd /home
mkdir plex
mkdir plex/movies
mkdir plex/tvshows
chown -R plex plex
chgrp -R plex plex
chmod -R g+rw plex
cd /var/lib/plexmediaserver
mkdir .flexget
cd .flexget
wget https://raw.githubusercontent.com/ryanss/btplex/master/config.yml
sed -i "s/XXXXXX/$showrssid/g" config.yml
sed -i "s/myusername/$username/g" config.yml
sed -i "s/mypassword/$password/g" config.yml
chgrp -R plex /var/lib/plexmediaserver
usermod -a -G plex debian-transmission

# Install FlexGet and trigger first run
apt-get install -y python-setuptools
easy_install flexget transmissionrpc
echo "0 * * * * /usr/local/bin/flexget execute --cron" > cron-file.txt
crontab -u plex cron-file.txt
rm cron-file.txt
flexget execute
