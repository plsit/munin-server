#!/bin/bash
mkdir -p /run/munin /var/lib/munin/rrdcached-journal
chown -R munin:munin /run/munin /var/lib/munin/rrdcached-journal
rm run/munin/rrdcached.pid
sudo -u munin /usr/bin/rrdcached -p /run/munin/rrdcached.pid -B -b /var/lib/munin/ -F -j /var/lib/munin/rrdcached-journal/ -m 0660 -l unix:/run/munin/rrdcached.sock -w 1800 -z 1800 -f 3600