# Set Plex Custom server access URLs
if [ -e /config/Library/Application\ Support/Plex\ Media\ Server/Preferences.xml ] && ! grep -q customConnections /config/Library/Application\ Support/Plex\ Media\ Server/Preferences.xml && [ $CADDY_HOSTNAME != "localhost" ];
then
    sed -i "s/\/>/\ customConnections=\"https:\/\/$CADDY_HOSTNAME:32400,http:\/\/$CADDY_HOSTNAME:32400\"\/>/g" /config/Library/Application\ Support/Plex\ Media\ Server/Preferences.xml;
fi


# Download newest Plex Media Server and install
deburl=`curl -s https://plex.tv/api/downloads/1.json | egrep -m 1 -o 'http[^\"]+amd64.deb' | head -1`
debfile=`echo $deburl | grep -o plexmediaserver_.*`

if [ ! -f $debfile ]; then
    wget -q $deburl
    dpkg -i $debfile 2> /dev/null
    ls | grep plexmediaserver | grep -v $debfile | xargs -r rm
    kill -9 $(ps aux | grep -m1 Plex | awk '{print $2}') 2> /dev/null || true
fi
