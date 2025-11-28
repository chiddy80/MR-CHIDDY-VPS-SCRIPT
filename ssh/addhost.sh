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
echo -e "${SUCCESS}✅ Domain Setup System Ready${NC}"
clear

echo -e "${PRIMARY}╔════════════════════════════════════════╗${NC}"
echo -e "${PRIMARY}║           DOMAIN CONFIGURATION         ║${NC}"
echo -e "${PRIMARY}╚════════════════════════════════════════╝${NC}"
echo -e ""

read -rp "$(echo -e "${LIGHT}🌐 Enter Domain/Host: ${NC}")" -e domain

# Validate domain input
if [[ -z "$domain" ]]; then
    echo -e "${ERROR}❌ No domain provided. Exiting.${NC}"
    exit 1
fi

echo -e "${INFO}📝 Saving domain configuration...${NC}"
echo "IP=$domain" >>/var/lib/akbarstorevpn/ipvps.conf
echo $domain > /etc/xray/domain

echo -e "${INFO}🔄 Stopping Xray service...${NC}"
systemctl stop xray.service

echo -e "${INFO}🔐 Requesting SSL certificate...${NC}"
if /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256; then
    echo -e "${SUCCESS}✅ SSL certificate issued${NC}"
else
    echo -e "${ERROR}❌ Failed to issue SSL certificate${NC}"
    echo -e "${WARNING}⚠️  Please check your domain DNS settings${NC}"
    systemctl start xray.service
    exit 1
fi

echo -e "${INFO}📄 Installing SSL certificate...${NC}"
if ~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc; then
    echo -e "${SUCCESS}✅ SSL certificate installed${NC}"
else
    echo -e "${ERROR}❌ Failed to install SSL certificate${NC}"
    systemctl start xray.service
    exit 1
fi

echo -e "${INFO}🚀 Starting Xray service...${NC}"
systemctl start xray.service

echo -e "${SUCCESS}✅ Domain setup completed successfully!${NC}"
echo -e "${DIVIDER}"
echo -e "${INFO}📋 Domain Details:${NC}"
echo -e "${LIGHT}Domain: ${SECONDARY}$domain${NC}"
echo -e "${LIGHT}SSL Certificate: ${SECONDARY}Installed (ECC)${NC}"
echo -e "${LIGHT}Xray Service: ${SUCCESS}Running${NC}"
echo -e "${DIVIDER}"

sleep 1.5
clear
neofetch
