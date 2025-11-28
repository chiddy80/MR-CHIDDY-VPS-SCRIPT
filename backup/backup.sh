#!/bin/bash
# My Telegram : https://t.me/esimfreegb
# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ==========================================
# Getting
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
# IP restriction removed - free to use on any VPS
echo -e "${NC}${GREEN}IP Check Bypassed...${NC}"
clear

IP=$(wget -qO- ipinfo.io/ip);
date=$(date +"%Y-%m-%d")
clear
echo "Starting Backup"
sleep 1
echo "Membuat Directory"
mkdir /root/backup
sleep 1
echo "Start Backup"
sleep 2
clear

# Backup various configuration files and directories
cp /etc/passwd backup/
cp /etc/group backup/
cp /etc/shadow backup/
cp /etc/gshadow backup/
cp -r /etc/wireguard backup/wireguard 2>/dev/null
cp /etc/ppp/chap-secrets backup/chap-secrets 2>/dev/null
cp /etc/ipsec.d/passwd backup/passwd1 2>/dev/null
cp /etc/shadowsocks-libev/akun.conf backup/ss.conf 2>/dev/null
cp -r /var/lib/akbarstorevpn/ backup/akbarstorevpn 2>/dev/null
cp -r /home/sstp backup/sstp 2>/dev/null
cp -r /etc/xray backup/xray 2>/dev/null
cp -r /etc/trojan-go backup/trojan-go 2>/dev/null
cp -r /usr/local/shadowsocksr/ backup/shadowsocksr 2>/dev/null
cp -r /home/vps/public_html backup/public_html 2>/dev/null

cd /root
zip -r $IP-$date.zip backup > /dev/null 2>&1

# Check if rclone is available and configured
if command -v rclone &> /dev/null && rclone listremotes | grep -q "dr:"; then
    rclone copy /root/$IP-$date.zip dr:backup/
    url=$(rclone link dr:backup/$IP-$date.zip 2>/dev/null)
    if [[ -n "$url" ]]; then
        id=$(echo $url | grep -o 'id=[^&]*' | cut -d'=' -f2)
        # FIXED: Removed /u/4/ to use current user's Google account instead of former owner's
        link="https://drive.google.com/uc?id=${id}&export=download"
        echo -e "The following is a link to your vps data backup file."
        echo -e "=================================" 
        echo -e "Detail Backup : "
        echo -e "================================="
        echo -e "IP VPS        : $IP"
        echo -e "Link Backup   : $link"
        echo -e "================================="
        echo -e "Script By Mrchiddy"
        echo ""
        echo -e "If you want to restore data, please enter the link above"
        echo ""
    else
        echo -e "${RED}Rclone backup failed or no link generated${NC}"
        echo -e "Backup file created locally: /root/$IP-$date.zip"
    fi
else
    echo -e "${ORANGE}Rclone not configured or not available${NC}"
    echo -e "Backup file created locally: /root/$IP-$date.zip"
fi

# Cleanup
rm -rf /root/backup
rm -f /root/$IP-$date.zip
echo "Done"
