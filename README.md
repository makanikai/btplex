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
# Create rclone config for ACD and ACDcrypt in config/plex/rclone.conf
docker-compose up -d
```


## URLs

- Plex: https://yourhost:32400/web/ (Login: Plex account - https://www.plex.tv/sign-up/)
- Radarr: https://yourhost:8787/ (Login: btuser/btpass)
- Sonarr: https://yourhost:9898/ (Login: btuser/btpass)
- Jackett: https://yourhost:9117/ (Pass: btpass)
- Transmission: https://yourhost:9091/ (Login: btuser/btpass)

