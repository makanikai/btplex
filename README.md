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
* [rclone](http://rclone.org) - Use an unlimited, encrypt Amazon Cloud Drive for your media storage
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

#### Amazon Cloud Drive
* https://www.amazon.com/clouddrive/
* $5/month for unlimited cloud storage.
* Not required if you are going to store your media on a local PC.
* Create a folder called "backup" in the root directory of your cloud drive
  which rclone will mount in your Plex container.



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
* Create `rclone.conf` file:
```bash
$ rclone config --config ./rclone.conf
YYYY/MM/DD HH:MM:SS Config file "./rclone.conf" not found - using defaults
No remotes found - make a new one
n) New remote
s) Set configuration password
q) Quit config
n/s/q> n
name> ACD
Type of storage to configure.
Choose a number from below, or type in your own value
 1 / Amazon Drive
   \ "amazon cloud drive"
 ...
Storage> 1
Amazon Application Client Id - leave blank normally.
client_id> 
Amazon Application Client Secret - leave blank normally.
client_secret> 
Remote config
Use auto config?
 * Say Y if not sure
 * Say N if you are working on a remote or headless machine
y) Yes
n) No
y/n> y
If your browser doesn't open automatically go to the following link: http://127.0.0.1:53682/auth
Log in and authorize rclone for access
Waiting for code...
Got code
--------------------
[ACD]
client_id = 
client_secret = 
token = {"access_token":"..."}
--------------------
y) Yes this is OK
e) Edit this remote
d) Delete this remote
y/e/d> y
Current remotes:

Name                 Type
====                 ====
ACD                  amazon cloud drive

e) Edit existing remote
n) New remote
d) Delete remote
s) Set configuration password
q) Quit config
e/n/d/s/q> n
name> ACDcrypt
Type of storage to configure.
Choose a number from below, or type in your own value
 ...
 5 / Encrypt/Decrypt a remote
   \ "crypt"
 ...
Storage> 5
Remote to encrypt/decrypt.
Normally should contain a ':' and a path, eg "myremote:path/to/dir",
"myremote:bucket" or maybe "myremote:" (not recommended).
remote> ACD:backup
How to encrypt the filenames.
Choose a number from below, or type in your own value
 1 / Don't encrypt the file names.  Adds a ".bin" extension only.
   \ "off"
 2 / Encrypt the filenames see the docs for the details.
   \ "standard"
filename_encryption> 2
Password or pass phrase for encryption.
y) Yes type in my own password
g) Generate random password
y/g> g
Password strength in bits.
64 is just about memorable
128 is secure
1024 is the maximum
Bits> 128
Your password is: ***
Use this password?
y) Yes
n) No
y/n> y
Password or pass phrase for salt. Optional but recommended.
Should be different to the previous password.
y) Yes type in my own password
g) Generate random password
n) No leave this optional password blank
y/g/n> g
Password strength in bits.
64 is just about memorable
128 is secure
1024 is the maximum
Bits> 128
Your password is: ***
Use this password?
y) Yes
n) No
y/n> y
Remote config
--------------------
[ACDcrypt]
remote = ACD:backup
filename_encryption = standard
password = *** ENCRYPTED ***
password2 = *** ENCRYPTED ***
--------------------
y) Yes this is OK
e) Edit this remote
d) Delete this remote
y/e/d> y
Current remotes:

Name                 Type
====                 ====
ACD                  amazon cloud drive
ACDcrypt             crypt

e) Edit existing remote
n) New remote
d) Delete remote
s) Set configuration password
q) Quit config
e/n/d/s/q> q

$ cat rclone.conf
[ACD]
type = amazon cloud drive
client_id = 
client_secret = 
token = {"access_token":"..."}

[ACDcrypt]
type = crypt
remote = ACD:backup
filename_encryption = standard
password = ***
password2 = ***
```
* **_Make a copy of your rclone.conf file and store it somewhere safe. If you
  lose it you will not be able to decrypt the media files on your Amazon Cloud
  Drive._**


## Run btplex
```bash
docker-compose up --build -d
```


## URLs

- Plex: [https://yourhost.duckdns.org:32400/web/](https://yourhost:32400/web/) (Login: Plex account)
- Radarr: [https://yourhost.duckdns.org:8787/](https://yourhost.duckdns.org:8787/) (Login: btuser/btpass)
- Sonarr: [https://yourhost.duckdns.org:9898/](https://yourhost.duckdns.org:9898/) (Login: btuser/btpass)
- Jackett: [https://yourhost.duckdns.org:9117/](https://yourhost.duckdns.org:9117/) (Pass: btpass)
- Transmission: [https://yourhost.duckdns.org:9091/](https://yourhost.duckdns.org:9091/) (Login: btuser/btpass)
* **_Please change the default passwords immediately!_**
