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
clear
echo -e "${PRIMARY}╔════════════════════════════════════════╗${NC}"
echo -e "${PRIMARY}║           RESTORE SYSTEM               ║${NC}"
echo -e "${PRIMARY}╚════════════════════════════════════════╝${NC}"
echo -e ""
echo -e "${WARNING}⚠️  Important Notice:${NC}"
echo -e "${LIGHT}This feature can only be used with VPS data${NC}"
echo -e "${LIGHT}that was backed up using this autoscript${NC}"
echo -e "${DIVIDER}"
echo -e "${INFO}📥 Please input the link to your VPS backup file${NC}"
echo -e "${LIGHT}You can find this in your email if you ran backup before${NC}"
echo -e "${DIVIDER}"
read -rp "$(echo -e "${LIGHT}🔗 Backup File URL: ${NC}")" -e url

# Validate URL input
if [[ -z "$url" ]]; then
    echo -e "${ERROR}❌ No URL provided. Exiting.${NC}"
    exit 1
fi

echo -e "${INFO}📥 Downloading backup file...${NC}"
if ! wget -O backup.zip "$url"; then
    echo -e "${ERROR}❌ Failed to download backup file${NC}"
    echo -e "${LIGHT}Please check the URL and try again${NC}"
    exit 1
fi

echo -e "${INFO}📦 Extracting backup files...${NC}"
if ! unzip -o backup.zip; then
    echo -e "${ERROR}❌ Failed to extract backup file${NC}"
    echo -e "${LIGHT}File may be corrupted or invalid format${NC}"
    rm -f backup.zip
    exit 1
fi

rm -f backup.zip
sleep 1

echo -e "${SUCCESS}🔄 Starting Restoration Process...${NC}"

# Check if backup directory exists
if [[ ! -d "/root/backup" ]]; then
    echo -e "${ERROR}❌ Backup directory not found${NC}"
    echo -e "${LIGHT}The backup file may be invalid or corrupted${NC}"
    exit 1
fi

cd /root/backup

# Restore files with error handling
echo -e "${INFO}📄 Restoring system files...${NC}"

# System files
[[ -f "passwd" ]] && cp passwd /etc/ && echo -e "  ${SUCCESS}✓${NC} /etc/passwd"
[[ -f "group" ]] && cp group /etc/ && echo -e "  ${SUCCESS}✓${NC} /etc/group"
[[ -f "shadow" ]] && cp shadow /etc/ && echo -e "  ${SUCCESS}✓${NC} /etc/shadow"
[[ -f "gshadow" ]] && cp gshadow /etc/ && echo -e "  ${SUCCESS}✓${NC} /etc/gshadow"

# Service configurations
[[ -d "wireguard" ]] && cp -r wireguard /etc/ && echo -e "  ${SUCCESS}✓${NC} WireGuard"
[[ -f "chap-secrets" ]] && cp chap-secrets /etc/ppp/ && echo -e "  ${SUCCESS}✓${NC} PPP Chap-Secrets"
[[ -f "passwd1" ]] && cp passwd1 /etc/ipsec.d/passwd && echo -e "  ${SUCCESS}✓${NC} IPSec"
[[ -f "ss.conf" ]] && cp ss.conf /etc/shadowsocks-libev/ss.conf && echo -e "  ${SUCCESS}✓${NC} Shadowsocks"

# Application data
[[ -d "crot" ]] && cp -r crot /var/lib/ && echo -e "  ${SUCCESS}✓${NC} Cron jobs"
[[ -d "sstp" ]] && cp -r sstp /home/ && echo -e "  ${SUCCESS}✓${NC} SSTP"
[[ -d "xray" ]] && cp -r xray /etc/ && echo -e "  ${SUCCESS}✓${NC} Xray"
[[ -d "trojan-go" ]] && cp -r trojan-go /etc/ && echo -e "  ${SUCCESS}✓${NC} Trojan-Go"
[[ -d "shadowsocksr" ]] && cp -r shadowsocksr /usr/local/ && echo -e "  ${SUCCESS}✓${NC} ShadowsocksR"
[[ -d "public_html" ]] && cp -r public_html /home/vps/ && echo -e "  ${SUCCESS}✓${NC} Web files"
[[ -f "crontab" ]] && cp crontab /etc/ && echo -e "  ${SUCCESS}✓${NC} Crontab"

# Restart services if available
echo -e "${INFO}🔄 Reloading system services...${NC}"
if command -v systemctl &> /dev/null; then
    # Try to restart relevant services
    for service in cron nginx apache2 ssh; do
        if systemctl is-active --quiet "$service" 2>/dev/null; then
            systemctl restart "$service" 2>/dev/null && echo -e "  ${SUCCESS}✓${NC} Restarted $service"
        fi
    done
fi

# Cleanup
echo -e "${INFO}🧹 Cleaning up temporary files...${NC}"
rm -rf /root/backup

echo -e "${DIVIDER}"
echo -e "${SUCCESS}✅ Restoration Completed Successfully!${NC}"
echo -e "${INFO}💡 Some services may need manual restart for changes to take effect${NC}"
