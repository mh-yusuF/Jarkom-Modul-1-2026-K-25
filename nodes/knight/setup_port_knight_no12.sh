#!/bin/sh

echo "=== SETUP KNIGHTS SERVICES ==="

# Install HTTP server jika belum ada
if ! command -v httpd >/dev/null 2>&1; then
    echo "[+] Installing busybox-extras..."
    apk add --no-cache busybox-extras
fi

# Install OpenSSH jika belum ada
if ! command -v sshd >/dev/null 2>&1; then
    echo "[+] Installing OpenSSH..."
    apk add --no-cache openssh
fi

# Buat halaman web sederhana
mkdir -p /var/www
echo "Knights Web Server" > /var/www/index.html

# Generate SSH host key jika belum ada
ssh-keygen -A

# Matikan service lama jika ada
pkill httpd 2>/dev/null
pkill sshd 2>/dev/null

# Jalankan HTTP
httpd -f -p 80 -h /var/www &

# Jalankan SSH
/usr/sbin/sshd

echo
echo "=== PORT STATUS ==="
ss -tln

echo
echo "=== EXPECTED ==="
echo "Port 22 : OPEN (SSH)"
echo "Port 80 : OPEN (HTTP)"
echo "Port 7777 : CLOSED"
echo
echo "Gunakan dari Alice:"
echo "nc -vz 192.168.3.2 22"
echo "nc -vz 192.168.3.2 80"
echo "nc -vz 192.168.3.2 7777"