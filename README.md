btPlex
======

This repository contains a shell script and config files for automatically
setting up a Plex Media Server on a Vultr VPS that includes a remote
bittorrent client with web interface that automatically downloads your
favourite television shows.

Before running the script, lets setup some necessary accounts:


### Vultr VPS

* https://www.vultr.com
* This setup runs well on the $5/month plan.
* Deploy a new $5/month Storage Instance running Ubuntu 14.04 x64.


### Free DNS (optional)

* http://freedns.afraid.org
* Setting up a DNS is convenient because you just have to remember a domain
  like myvps.mooo.com instead of an IP address like 123.123.123.123.
* Once you've created an account add a new subdomain using the IP address of
  your new Vultr VPS.


### Plex

* https://plex.tv/users/sign_up
* A Plex account is required to access a remote Plex Media Server. This is a
  free account and does not require the "Plex Pass".


### showRSS

* http://showrss.info
* Sign up for a showRSS account and select your favourite television shows. The
  RSS feed that is created for you is what the server will use to download your
  shows.


### PrivateInternetAccess VPN

* https://www.privateinternetaccess.com
* If your VPS downloads torrents without a VPN it will likely get shutdown very
  quickly.


Installation
------------

```bash
# Login to your VPS and bind your local port 8888 to the server's Plex
# port 32400. This is required so we can enable remote access. By default,
# Plex Media Server only allows connections from localhost.
$ ssh root@myvps.mooo.com -L 8888:localhost:32400

# Download and run the setup script
$ wget https://raw.githubusercontent.com/ryanss/btplex/master/setup.sh && sh setup.sh
```

Enable remote access by visiting
http://localhost:8888/web/index.html#!/settings/server in your local browser
and logging in with the Plex account credentials created earlier. This will
link the remote server to your Plex account.

The Plex Media Server can now be access via http://myvps.mooo.com:32400/web and
the Transmission BitTorrent client web interface via
http://myvps.mooo.com:9091. You should already see the latest television shows
downloading in Transmission and they will automatically be added to Plex once
they are done downloading.

Check that OpenVPN is working by adding the following torrent to transmission
and checking that the IP address shown is not the IP address of your
Vultr VPS.
`http://checkmytorrentip.net/torrentip/checkMyTorrentIp.png.torrent`
