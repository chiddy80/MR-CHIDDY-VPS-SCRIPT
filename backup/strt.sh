#!/bin/bash
# SL
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
echo -e "${SUCCESS}✅ System Access Granted${NC}"
clear

echo -e "${PRIMARY}╔════════════════════════════════════════╗${NC}"
echo -e "${PRIMARY}║         ACCOUNT MANAGEMENT             ║${NC}"
echo -e "${PRIMARY}╚════════════════════════════════════════╝${NC}"
echo -e ""

echo -e "${INFO}📊 Processing Shadowsocks accounts...${NC}"
if [[ -f "/etc/shadowsocks-libev/akun.conf" ]]; then
    data=( `cat /etc/shadowsocks-libev/akun.conf | grep '^###' | cut -d ' ' -f 2`)
    now=`date +"%Y-%m-%d"`
    
    for user in "${data[@]}"
    do
        exp=$(grep -w "^### $user" "/etc/shadowsocks-libev/akun.conf" | cut -d ' ' -f 3)
        if [[ -n "$exp" ]]; then
            d1=$(date -d "$exp" +%s 2>/dev/null)
            d2=$(date -d "$now" +%s 2>/dev/null)
            if [[ -n "$d1" && -n "$d2" ]]; then
                exp2=$(( (d1 - d2) / 86400 ))
                printf "$user\n$exp2\n" | addss 2>/dev/null
                echo -e "  ${INFO}👤${NC} $user - ${WARNING}$exp2 days remaining${NC}"
            fi
        fi
    done
else
    echo -e "  ${WARNING}⚠️ No Shadowsocks accounts found${NC}"
fi

echo -e "${INFO}🔄 Cleaning Shadowsocks configuration...${NC}"
rm -f /etc/shadowsocks-libev/ss.conf 2>/dev/null
echo -e "  ${SUCCESS}✅ Shadowsocks config cleaned${NC}"

echo -e "${INFO}🔐 Processing WireGuard configurations...${NC}"
if [[ -f "/etc/wireguard/wg0.conf" ]]; then
    data=( `cat /etc/wireguard/wg0.conf | grep '^### Client' | cut -d ' ' -f 3`)
    now=`date +"%Y-%m-%d"`
    
    for user in "${data[@]}"
    do
        if [[ -f "/home/vps/public_html/$user.conf" ]]; then
            chmod 644 /home/vps/public_html/$user.conf 2>/dev/null
            echo -e "  ${SUCCESS}✅${NC} WireGuard config: $user"
        fi
    done
else
    echo -e "  ${WARNING}⚠️ No WireGuard configuration found${NC}"
fi

echo -e "${DIVIDER}"
echo -e "${SUCCESS}✅ Account management completed${NC}"
echo -e "${INFO}📅 Processed on: $(date)${NC}"
