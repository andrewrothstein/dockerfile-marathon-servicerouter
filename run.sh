#!/usr/bin/env sh

mkdir /cron
cat > /cron/crontab <<EOF
* * * * * /marathon/bin/servicerouter.py --marathon http://${MARATHON_MASTER_IP}:${MARATHON_MASTER_PORT}
EOF

service rsyslog start
/usr/local/bin/devcron.py /cron/crontab
