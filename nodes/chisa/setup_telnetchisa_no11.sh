#!/bin/sh

apk add --no-cache busybox-extras

id phantom_user >/dev/null 2>&1 || adduser phantom_user

echo "phantom_user:wired_ghost" | chpasswd

telnetd

echo "=== TELNET STATUS ==="
netstat -tln | grep 23