if ! ping -c 1 us-midwest.privateinternetaccess.com &> /dev/null;
then
    kill -9 $(ps aux | grep -m1 transmission | awk '{print $2}') || true;
fi
