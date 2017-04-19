**btplex** is a project aimed at getting a fully automated media server setup as quickly
and easily as possible on any computer capable of running docker


**btplex** includes:
* [Plex Media Server](https://www.plex.tv) - watch your media library from
  anwhere on any device
* [Sonarr](https://sonarr.tv) - automatically download your favourite tv shows
* [Radarr](https://radarr.video) - automatically download movies
* [Jackett](https://github.com/Jackett/Jackett) - improved torrent searching in
  Sonarr and Radarr
* [Tranmission](https://transmissionbt.com) - bittorrent client
* [Private Internet Access](https://www.privateinternetaccess.com/) - safely
  bittorrent through a secure, anonymous VPN
* [rclone](http://rclone.org) - use Backblaze B2 cloud storage to cheaply store
  your media
* [Caddy](https://caddyserver.com) & [Let's Encrypt](https://letsencrypt.org)- Access
  your media server applications through a secure, encrypted connection


## Account Sign-Up

#### Plex
* https://www.plex.tv/sign-up/
* Allows you to access your Plex Media Server from anywhere on any device.

#### Private Internet Access
* https://www.privateinternetaccess.com/
* $3.33/month
* VPN so your VPS account does not get shutdown using bittorrent.

#### Dynamic DNS
* https://www.duckdns.org
* Instead of remembering the IP Address of your server, create an easy to
  remember domain name for accessing your server. Domain suffix must be listed on
  the [Public Suffix List](https://publicsuffix.org/list/public_suffix_list.dat)
  to generate a Let's Encrypt SSL certificate.

#### Virtual Private Server 
* [Luna Node](https://dynamic.lunanode.com/info?r=6310)
* Luna Node $5/month VPS runs btplex pretty well.
* Not required if you are going to run btplex from a home PC or existing server.

#### Backblaze B2 Cloud Storage
* https://www.backblaze.com/b2/cloud-storage.html
* $5/month/TB for cloud storage.
* Not required if you are going to store your media on a local PC.
* Create a bucket called `btplex` which rclone will mount in your Plex container.


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


## Download btplex
```bash
git clone https://github.com/ryanss/btplex.git
cd btplex
```

 
## Configure btplex
* `cp example.env config.env`
* Edit `config.env` file
  * Set `CADDY_HOSTNAME` to your dynamic DNS host (ex. yourhost.duckdns.org) or
    leave blank if you will just access your server via IP address
  * If your domain's suffix is on the
    [Public Suffix List](https://publicsuffix.org/list/public_suffix_list.dat)
    set `CADDY_TLS` to an email address (ex. devnull@yourhost.duckdns.org) to
    use for generating a [Let's Encrypt](https://letsencrypt.org) SSL
    certificate, otherwise leave as `self_signed` to generate a self-signed SSL
    certificate that your browser will complain about
  * Set the `PLEX_USERNAME` and `PLEX_PASSWORD` fields to automatically setup
    Plex remote access (if you don't do this you'll have to enable it yourself by
    `ssh user@yourhost.duckdns.org 32400:localhost:32400` and visiting
    [http://localhost:32400/web](http://localhost:32400/web))
  * Set `OPENVPN_USERNAME` and `OPENVPN_PASSWORD` with your
    [Private Internet Access](https://www.privateinternetaccess.com/) login credentials
  * Uncomment and set the username and password to your
    [Private Internet Access](https://www.privateinternetaccess.com/) Socks proxy listed in the
    [Control Panel](https://www.privateinternetaccess.com/pages/client-control-panel)
* If not using B2 Cloud Storage: Replace `Dockerfile` with `Dockerfile-nob2`
  in `docker-compose.yml` and modify the local `./media` paths in plex, sonarr,
  radarr `volumes` sections


## Run btplex
```bash
docker-compose up --build -d  # Run in background
# or
docker-compose up --build     # Run in foreground to see logs and debug issues
```


## Update btplex
```bash
docker-compose down
docker-compose pull
docker-compose up --build --force-recreate -d
```


## URLs

- Plex: [https://yourhost.duckdns.org:32400/web/index.html](https://yourhost:32400/web/index.html) (Login: Plex account)
- Radarr: [https://yourhost.duckdns.org:8787/](https://yourhost.duckdns.org:8787/) (Login: btuser/btpass)
- Sonarr: [https://yourhost.duckdns.org:9898/](https://yourhost.duckdns.org:9898/) (Login: btuser/btpass)
- Jackett: [https://yourhost.duckdns.org:9117/](https://yourhost.duckdns.org:9117/) (Pass: btpass)
- Transmission: [https://yourhost.duckdns.org:9091/](https://yourhost.duckdns.org:9091/) (Login: btuser/btpass)
* **_Please change the default passwords immediately!_**
