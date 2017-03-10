## Creating rclone.conf file

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
