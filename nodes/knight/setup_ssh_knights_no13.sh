#!/bin/sh

apk add --no-cache openssh

id mika_admin >/dev/null 2>&1 || adduser -D mika_admin

echo "mika_admin:mika123" | chpasswd

ssh-keygen -A

grep -q "PubkeyAuthentication yes" /etc/ssh/sshd_config || echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
grep -q "PasswordAuthentication no" /etc/ssh/sshd_config || echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
grep -q "PermitRootLogin no" /etc/ssh/sshd_config || echo "PermitRootLogin no" >> /etc/ssh/sshd_config

pkill sshd 2>/dev/null

/usr/sbin/sshd

echo
echo "=== SSH STATUS ==="
ss -tln | grep 22