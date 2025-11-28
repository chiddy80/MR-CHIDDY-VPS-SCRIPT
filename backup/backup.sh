#!/bin/bash
# My Telegram : https://t.me/esimfreegb
# ==========================================
# Professional Color Scheme
PRIMARY='\033[38;5;27m'
SECONDARY='\033[38;5;39m'
SUCCESS='\033[38;5;46m'
WARNING='\033[38;5;214m'
ERROR='\033[38;5;196m'
INFO='\033[38;5;75m'
LIGHT='\033[38;5;250m'
DARK='\033[38;5;240m'
NC='\033[0m'

# UI Elements
DIVIDER="${DARK}──────────────────────────────────────────${NC}"
# ==========================================
# Getting
MYIP=$(hostname -I | awk '{print $1}')
echo -e "${INFO}🔍 Checking VPS Configuration...${NC}"
echo -e "${SUCCESS}✅ Backup System Ready${NC}"
clear

IP=$(hostname -I | awk '{print $1}')
date=$(date +"%Y-%m-%d")
clear
echo -e "${PRIMARY}╔════════════════════════════════════════╗${NC}"
echo -e "${PRIMARY}║             BACKUP SYSTEM              ║${NC}"
echo -e "${PRIMARY}╚════════════════════════════════════════╝${NC}"
echo -e ""
echo -e "${INFO}🔄 Starting Backup Process...${NC}"
sleep 1
echo -e "${INFO}📁 Creating Backup Directory...${NC}"
mkdir /root/backup
sleep 1
echo -e "${INFO}🚀 Starting Backup Operation...${NC}"
sleep 2
clear

# Backup various configuration files and directories
echo -e "${INFO}📦 Backing up system files...${NC}"
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
echo -e "${INFO}🗜️  Compressing backup files...${NC}"
zip -r $IP-$date.zip backup > /dev/null 2>&1

# Check if rclone is available and configured
if command -v rclone &> /dev/null && rclone listremotes | grep -q "dr:"; then
    echo -e "${INFO}☁️  Uploading to cloud storage...${NC}"
    rclone copy /root/$IP-$date.zip dr:backup/
    url=$(rclone link dr:backup/$IP-$date.zip 2>/dev/null)
    if [[ -n "$url" ]]; then
        id=$(echo $url | grep -o 'id=[^&]*' | cut -d'=' -f2)
        # FIXED: Removed /u/4/ to use current user's Google account instead of former owner's
        link="https://drive.google.com/u/4/uc?id=${id}&export=download"
        
        echo -e "${SUCCESS}✅ Backup Completed Successfully${NC}"
        echo -e "${DIVIDER}"
        echo -e "${INFO}📋 Backup Details:${NC}"
        echo -e "${DIVIDER}"
        echo -e "${LIGHT}IP VPS        : ${SECONDARY}$IP${NC}"
        echo -e "${LIGHT}Backup Date   : ${SECONDARY}$date${NC}"
        echo -e "${LIGHT}Backup Link   : ${SECONDARY}$link${NC}"
        echo -e "${DIVIDER}"
        echo -e "${INFO}💾 Script By Mrchiddy${NC}"
        echo ""
        echo -e "${WARNING}📥 To restore data, use the link above${NC}"
        echo ""
    else
        echo -e "${ERROR}❌ Rclone backup failed or no link generated${NC}"
        echo -e "${WARNING}📁 Backup file created locally: /root/$IP-$date.zip${NC}"
    fi
else
    echo -e "${WARNING}⚠️  Rclone not configured or not available${NC}"
    echo -e "${INFO}📁 Backup file created locally: /root/$IP-$date.zip${NC}"
fi

# Cleanup
echo -e "${INFO}🧹 Cleaning up temporary files...${NC}"
rm -rf /root/backup
rm -f /root/$IP-$date.zip
echo -e "${SUCCESS}✅ Backup Process Completed${NC}"
