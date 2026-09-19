#!/bin/sh

# Buat folder .ssh jika belum ada
mkdir -p ~/.ssh

# Generate key jika belum ada
if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519
fi

echo
echo "=== PUBLIC KEY ==="
cat ~/.ssh/id_ed25519.pub

echo
echo "Copy public key di atas ke:"
echo "/home/mika_admin/.ssh/authorized_keys pada node Knights"