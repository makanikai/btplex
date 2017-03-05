deburl=`curl https://plex.tv/api/downloads/1.json | egrep -m 1 -o 'http[^\"]+amd64.deb' | head -1`
debfile=`echo $deburl | grep -o plexmediaserver_.*`

if [ ! -f $debfile ]; then
    wget $deburl
    dpkg -i $debfile
    ls | grep plexmediaserver | grep -v $debfile | xargs rm
    kill -9 $(ps aux | grep -m1 Plex | awk '{print $2}')
fi

