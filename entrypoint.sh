#!/usr/bin/env bash

# Start xrdp sesman service
#/usr/sbin/xrdp-sesman

# Run xrdp in foreground if no commands specified
#if [ -z "$1" ]; then
#    /usr/sbin/xrdp --nodaemon
#else
#    /usr/sbin/xrdp
#    exec "$@"
#fi


sudo service xrdp start
/usr/bin/sudo /usr/sbin/sshd -D -o ListenAddress=0.0.0.0