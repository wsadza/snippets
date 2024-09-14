
sudo salt 'stream' state.apply run_application
sudo salt-master &
sudo salt-api &
sudo salt-minion &

```
ubuntu@stream:~$ cat /srv/salt/run_application.sls 
run_application:
  cmd.run:
    - name: heroic --no-sandbox
    - runas: ubuntu
```


```
ubuntu@stream:~$ cat /etc/salt/master
pillar_roots:
  base:
    - /srv/salt/pillar

file_roots:
  base:
    - /srv/salt/extmods
    - /srv/salt

rest_cherrypy:
  host: 0.0.0.0
  port: 8000
  disable_ssl: true

external_auth:
  pam:
    ubuntu:
      - .*
      - '@runner'
      - '@wheel'
      - '@jobs'

loopback: True

netapi_enable_clients:
  - local
  - local_async
  - local_batch
  - local_subset
  - runner
  - runner_async
  - sproxy
  - sproxy_asyn
```

```
ubuntu@stream:~$ cat simple-api.sh

#!/bin/bash

curl -sSk http://localhost:8000/login \
      -c ~/cookies.txt \
      -H 'Accept: application/x-yaml' \
      -d username=ubuntu \
      -d password=ubuntu \
      -d eauth='pam'

#curl -sSk http://localhost:8000 \
#      -b ~/cookies.txt \
#      -H 'Accept: application/x-yaml' \
#      -d client='local' \
#      -d tgt='stream' \
#      -d fun='cmd.script' \
#      -d arg='heroic --no-sandbox'
#      -d kwarg='{"runas":"ubuntu"}'

curl -sSk http://localhost:8000 \
  -b ~/cookies.txt \
  -H 'Accept: application/x-yaml' \
  -d client='local' \
  -d tgt='stream' \
  -d fun='cmd.script' \
  -d arg='["/usr/bin/heroic --no-sandbox"]' \
  -d kwarg='{"runas":"ubuntu", "env": {"DBUS_SESSION_BUS_ADDRESS": "unix:path=/run/user/1000/dbus-session"}}'

#curl -sSk  \
#  http://localhost:8000/run \
#  -b ~/cookies.txt \
#  -H "Accept: application/json" \
#  -H "Content-Type: application/json" \
#  -d '{
#    "client": "local",
#    "tgt": "stream",
#    "fun": "cmd.run",
#    "arg": ["heroic"],
#    "kwargs": {
#      "runas": "ubuntu"
#    }
#  }'

#curl -sS http://localhost:8000/run \
#  -H 'Accept: application/json' \
#  -d eauth='pam' \
#  -d client='local' \
#  -d username='ubuntu' \
#  -d password='ubuntu' \
#  -d tgt='saltmaster' \
#  -d fun='cmd.run' \
#  -d arg='/usr/bin/firefox-trunk' \
```
