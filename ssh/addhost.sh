#!/bin/bash
# My Telegram : https://t.me/isipismyself
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
echo "Checking VPS"
echo -e "${GREEN}Permission Accepted (open script)...${NC}"
clear

# Ask for domain
read -rp "Domain/Host : " -e domain
echo "IP=$domain" >> /var/lib/akbarstorevpn/ipvps.conf
echo $domain > /etc/xray/domain

echo "Starting certificate issuance..."
systemctl stop xray.service

# Issue SSL certificate with acme.sh
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain \
--fullchainpath /etc/xray/xray.crt \
--keypath /etc/xray/xray.key \
--ecc

# Start Xray
systemctl start xray.service

echo "Done"
sleep 1.5
clear

# Show server info
neofetch
