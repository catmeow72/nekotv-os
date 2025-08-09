#!/bin/sh
[ -d /var/home/user ] && exit
cp -r /etc/skel /var/home/user
chown -R user:user /var/home/user
