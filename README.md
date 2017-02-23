## Install Docker
https://docs.docker.com/engine/installation/


#### Ex. Ubuntu 16.04 VPS
```bash
apt-get update
apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    git
curl -fsSL https://apt.dockerproject.org/gpg | apt-key add
add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"
apt-get update
apt-get install -y docker-engine python-pip
pip install --upgrade pip setuptools
pip install docker-compose
```


## Download & Run btplex
```bash
git clone https://github.com/ryanss/btplex.git
cd btplex
cp example.env .env
# Add Plex/PIA credentials to .env
docker-compose up -d
```


## Post Install

- Plex: https://yourhost:32400/web/ (Login: Plex account - https://www.plex.tv/sign-up/)
- Radarr: https://yourhost:8787/ (Login: btuser/btpass)
- Sonarr: https://yourhost:9898/ (Login: btuser/btpass)
- Transmission: https://yourhost:9091/ (Login: btuser/btpass)


#### Enable Proxy in Radarr and Sonarr
Settings > General > Security > Proxy Settings
- Use Proxy: Socks5
- Hostname: proxy-nl.privateinternetaccess.com
- Port: 1080
- User/Pass: https://www.privateinternetaccess.com/pages/client-control-panel (PPTP/L2TP/SOCKS Username and Password)

