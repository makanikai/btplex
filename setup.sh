#!/bin/sh

# This script automates setting up a Plex Media Server on a Vultr VPS
# that includes a remote bittorrent client with web interface that
# automatically downloads your favourite television shows.

echo "Enter a Transmission username: \c"
read username
echo "Enter a Transmission password: \c"
read password

echo "Find your showRSS user_id."
echo "Generate your custom feed and get the user_id from the url."
echo "Example: http://showrss.info/rss.php?user_id=XXXXXX&hd=null&proper=1)"
echo "where XXXXXX is your user_id."
echo "Enter your showRSS user_id: \c"
read showrssid

echo "Enter your email (or leave blank) for new download notifications: \c"
read email
if [ ! -z "$email" ]; then
    echo "Enter SMTP host (smtp.gmail.com): \c"
    read smtp_host
    echo "Enter SMTP username (username@gmail.com): \c"
    read smtp_username
    echo "Enter SMTP password: \c"
    read smtp_password
    echo "SMTP TLS? (yes/no): \c"
    read smtp_tls
fi

echo "Enter PrivateInternetAccess VPN username (pXXXXXXX) or leave blank for no VPN: \c"
read piauser
if [ ! -z "$piauser" ]; then
    echo "Enter PrivateInternetAccess VPN password: \c"
    read piapass
fi

# Update software
apt-get update
apt-get install -y unattended-upgrades
unattended-upgrade
echo "APT::Periodic::Update-Package-Lists \"1\";" > /etc/apt/apt.conf.d/20auto-upgrades
echo "APT::Periodic::Unattended-Upgrade \"1\";" >> /etc/apt/apt.conf.d/20auto-upgrades

# Install Plex Media Server
wget https://downloads.plex.tv/plex-media-server/0.9.12.11.1406-8403350/plexmediaserver_0.9.12.11.1406-8403350_amd64.deb
dpkg -i plexmediaserver_0.9.12.11.1406-8403350_amd64.deb

# Install transmission
apt-get install -y transmission-cli transmission-common transmission-daemon
usermod -a -G plex debian-transmission
sed -i "s/setuid debian-transmission/setuid plex/g" /etc/init/transmission-daemon.conf
sed -i "s/setgid debian-transmission/setgid plex/g" /etc/init/transmission-daemon.conf
chown -R plex:plex /var/lib/transmission-daemon
chown plex:plex /etc/transmission-daemon/settings.json
service transmission-daemon restart
sleep 1
sed -i "s/\"rpc-whitelist-enabled\": true,/\"rpc-whitelist-enabled\": false,/g" /etc/transmission-daemon/settings.json
sed -i "s/\"rpc-username\": \"transmission\",/\"rpc-username\": \"$username\",/g" /etc/transmission-daemon/settings.json
sed -i "s/\"rpc-password\": \"{.*\",/\"rpc-password\": \"$password\",/g" /etc/transmission-daemon/settings.json
sed -i "s/\"download-dir\": \"\/var\/lib\/transmission-daemon\/downloads\",/\"download-dir\": \"\/home\/plex\/movies\",/g" /etc/transmission-daemon/settings.json
sed -i "s/\"ratio-limit-enabled\": false,/\"ratio-limit-enabled\": true,/g" /etc/transmission-daemon/settings.json
sed -i "s/\"idle-seeding-limit-enabled\": false,/\"idle-seeding-limit-enabled\": true,/g" /etc/transmission-daemon/settings.json
service transmission-daemon reload

# Install and setup OpenVPN
if [ ! -z "$piauser" ]; then
    apt-get install -y openvpn unzip
    cd /etc/openvpn
    wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
    unzip openvpn.zip
    echo $piauser > login.conf
    echo $piapass >> login.conf
    echo "auth-user-pass login.conf" >> US\ East.ovpn
    cp US\ East.ovpn us_east.conf
    echo "AUTOSTART=\"us_east\"" >> /etc/default/openvpn
    echo "ip=\`ip route show | sed -n 2p | awk '{print \$NF}'\`" >> /etc/network/if-up.d/openvpn
    echo "subnet=\`ip route show | sed -n 2p | cut -d' ' -f1-3\`" >> /etc/network/if-up.d/openvpn
    echo "gateway=\`route | sed -n 3p | awk '{print \$2}'\`" >> /etc/network/if-up.d/openvpn
    echo "ip rule add from \$ip table 128" >> /etc/network/if-up.d/openvpn
    echo "ip route add table 128 to \$subnet" >> /etc/network/if-up.d/openvpn
    echo "ip route add table 128 default via \$gateway" >> /etc/network/if-up.d/openvpn
    /etc/network/if-up.d/openvpn
    service openvpn start
fi

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
cat > config.yml << EOF
tasks:
  showrss:
    rss: http://showrss.info/rss.php?user_id=$showrssid&hd=1&proper=1
    all_series: yes
    thetvdb_lookup: yes
    transmission:
      host: localhost
      port: 9091
      username: $username
      password: $password
      path: /home/plex/tvshows/{{series_name}}/Season {{series_season}}
      addpaused: no
EOF
if [ ! -z "$email" ]; then
cat >> config.yml << EOF
email:
  from: updates@btplex
  to: $email
  smtp_host: $smtp_host
  smtp_username: $smtp_username
  smtp_password: $smtp_password
  smtp_tls: $smtp_tls
  template: html
EOF
fi
chown -R plex /var/lib/plexmediaserver
chgrp -R plex /var/lib/plexmediaserver
chmod -R g+rw /var/lib/plexmediaserver

# Add Movies and TV Shows sections to Plex
sudo -i -u plex LD_LIBRARY_PATH=/usr/lib/plexmediaserver/ /usr/lib/plexmediaserver/Plex\ Media\ Scanner --add-section "Movies" --type 1 --location /home/plex/movies
sudo -i -u plex LD_LIBRARY_PATH=/usr/lib/plexmediaserver/ /usr/lib/plexmediaserver/Plex\ Media\ Scanner --add-section "TV Shows" --type 2 --location /home/plex/tvshows
sudo -i -u plex LD_LIBRARY_PATH=/usr/lib/plexmediaserver/ /usr/lib/plexmediaserver/Plex\ Media\ Scanner --scan --refresh

# Install FlexGet and trigger first run
apt-get install -y python-setuptools
apt-get remove -y python-six
easy_install flexget transmissionrpc
# Check for new television episodes at the top of every hour
echo "SHELL=/bin/bash" > cron-file.txt
echo "0 * * * * /usr/local/bin/flexget execute --cron" >> cron-file.txt
# Remove small sample movie files which sometimes confuse Plex
echo "10 * * * * find /home/plex -size -50M \\( -name \"*.avi\" -or -name \"*.mkv\" -or -name \"*.mp4\" -or -name \"*.m4v\" \\) -delete" >> cron-file.txt
# Clean up directories where the video file was deleted by Plex at 5:30 AM every day
echo "30 5 * * * du /home/plex/{movies,tvshows}/* | while read size filename; do if [ \$size -lt 70000 ] && [[ ! -n \$(du -a \$filename | grep .part) ]]; then rm -rf \"\$filename\"; fi done" >> cron-file.txt
crontab -u plex cron-file.txt
# Restart OpenVPN if it gets disconnected
echo "SHELL=/bin/bash" > cron-file.txt
echo "PATH=/bin:/usr/bin:/sbin" >> cron-file.txt
echo "59 * * * * tun=\$(ifconfig | grep -c tun0); if [ \$tun -eq 0 ]; then service openvpn restart; fi" >> cron-file.txt
crontab cron-file.txt
rm cron-file.txt
sudo -H -u plex flexget execute
