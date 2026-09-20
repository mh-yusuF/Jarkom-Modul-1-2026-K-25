#!/bin/sh

FTP_DIR="/var/wired/data"
CONF="/etc/vsftpd/vsftpd.conf"
USERLIST="/etc/vsftpd/user_list"

echo "SETUP FTP"

if ! command -v vsftpd >/dev/null 2>&1; then
    apk add --no-cache vsftpd
fi

id alice >/dev/null 2>&1 || adduser -D alice
id mika  >/dev/null 2>&1 || adduser -D mika
id eiri  >/dev/null 2>&1 || adduser -D eiri

# Password
echo "alice:alice123" | chpasswd
echo "mika:mika123"   | chpasswd
echo "eiri:eiri123"   | chpasswd

# Shared folder
mkdir -p "$FTP_DIR"

# Alice = RW
# Mika = read-only karena other hanya r-x
chown alice:alice "$FTP_DIR"
chmod 755 "$FTP_DIR"

# Config directory
mkdir -p /etc/vsftpd

# Config vsftpd
cat > "$CONF" <<EOF
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES

local_root=$FTP_DIR

chroot_local_user=YES
allow_writeable_chroot=YES

pasv_enable=YES
pasv_min_port=30000
pasv_max_port=30100

userlist_enable=YES
userlist_deny=YES
userlist_file=$USERLIST

seccomp_sandbox=NO
EOF

# Blacklist Eiri
echo "eiri" > "$USERLIST"

# Restart vsftpd manual
pkill vsftpd 2>/dev/null || true

vsftpd "$CONF" &

sleep 1

echo
echo "STATUS"

echo "Process:"
ps | grep '[v]sftpd'

echo
echo "Folder:"
ls -ld "$FTP_DIR"

echo
echo "Blacklist:"
cat "$USERLIST"

echo
echo "Port 21:"
netstat -tln 2>/dev/null | grep ':21' || true

echo "AKUN "
echo "alice : alice123  -> READ + WRITE"
echo "mika  : mika123   -> READ ONLY"
echo "eiri  : eiri123   -> BLACKLIST"
echo
echo "FTP directory : $FTP_DIR"
echo "PASV          : 30000-30100"
echo "============================="```
