#!/bin/sh

set -x
set -e

if [ ! -f /etc/ssh/ssh_host_rsa_key.pub ]; then
    if [ -f /etc/ssh/volume/ssh_host_rsa_key ]; then
        cp /etc/ssh/volume/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
        chmod 400 /etc/ssh/ssh_host_rsa_key
    fi
fi
if [ ! -f /etc/ssh/ssh_host_rsa_key.pub ]; then
    if [ -f /etc/ssh/volume/ssh_host_rsa_key.pub ]; then
        cp /etc/ssh/volume/ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub
        chmod 400 /etc/ssh/ssh_host_rsa_key.pub
    fi
fi

/sbin/openrc
counter=0
while [ ! -f /etc/ssh/ssh_host_rsa_key ] || [ ! -f /etc/ssh/ssh_host_rsa_key.pub ]; do
    sleep 1
    counter=$((counter + 1))

    if [ $counter -ge 30 ]; then
      echo "ssh host keys not generated"
        exit 1
    fi
done

if [ ! -f /etc/ssh/volume/ssh_host_rsa_key ]; then
    cp /etc/ssh/ssh_host_rsa_key /etc/ssh/volume/ssh_host_rsa_key
fi
if [ ! -f /etc/ssh/volume/ssh_host_rsa_key.pub ]; then
    cp /etc/ssh/ssh_host_rsa_key.pub /etc/ssh/volume/ssh_host_rsa_key.pub
fi

rc-service rsyslog start
rc-service dcron start

/usr/local/bin/dockerd-entrypoint.sh
exec "$@"
