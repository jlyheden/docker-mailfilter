#!/bin/bash

set -e

# Defaults
: ${AMAVIS_MYDOMAIN:="example.com"}
: ${AMAVIS_MYHOSTNAME:="mx.${AMAVIS_MYDOMAIN}"}
export AMAVIS_MYDOMAIN AMAVIS_MYHOSTNAME

confd -onetime -backend env

if ! [ -f /var/lib/clamav/main.cvd ]; then
    echo "No clamav db found, running initial freshclam update"
    freshclam
fi

cat >/etc/periodic/daily/clamav_update<<EOF
#!/usr/bin/env bash
freshclam
EOF
chmod +x /etc/periodic/daily/clamav_update

mkdir -p /run/clamav
chown -R clamav:clamav /run/clamav

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf