SHARED_PATH="/var/wired/data" 
VSFTPD_CONF="/etc/vsftpd/vsftpd.conf" 
BLACKLIST_FILE="/etc/vsftpd/user_list" 
echo "[*] Memulai Inisialisasi FTP Server..." 
if ! command -v vsftpd ; then 
  echo "[+] Menginstal vsftpd..." 
  apk add --no-cache vsftpd 
fi 
mkdir -p "$SHARED_PATH" 
chown nobody:nogroup "$SHARED_PATH" 
chmod 755 "$SHARED_PATH" 
mkdir -p /etc/vsftpd 
cat > "$VSFTPD_CONF" << 'EOF' 
listen=YES 
anonymous_enable=NO 
local_enable=YES 
write_enable=YES 
chroot_local_user=YES 
allow_writeable_chroot=YES 
pasv_enable=YES 
pasv_min_port=30000 
pasv_max_port=30100 
userlist_enable=YES 
userlist_deny=YES 
seccomp_sandbox=NO 
EOF 
echo "local_root=$SHARED_PATH" >> "$VSFTPD_CONF" 
echo "userlist_file=$BLACKLIST_FILE" >> "$VSFTPD_CONF" 
echo "eiri" > "$BLACKLIST_FILE" 
vsftpd "$VSFTPD_CONF" & 
sleep 1 
echo "=========================================" 
echo "        STATUS SETUP FTP SELESAI          " 
echo "=========================================" 
echo "- Direktori Target : $SHARED_PATH" 
echo "- Status Proses    :" 
ps | grep '[v]sftpd' 
echo "- Daftar Blacklist :" 
cat "$BLACKLIST_FILE" 
echo "-----------------------------------------" 
echo " Informasi Hak Akses Akun:" 
echo " * alice (Read ^& Write)" 
echo " * mika  (Read-Only)" 
echo " * eiri  (Blacklisted / Ditolak)" 
echo "=========================================" 
