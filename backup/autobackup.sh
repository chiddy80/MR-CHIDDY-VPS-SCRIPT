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
BOX_TOP="${DARK}┌────────────────────────────────────────┐${NC}"
BOX_BOTTOM="${DARK}└────────────────────────────────────────┘${NC}"

# Status Indicators
STATUS_ON="${SUCCESS}ACTIVE${NC}"
STATUS_OFF="${ERROR}INACTIVE${NC}"
# ==========================================
# Getting
MYIP=$(hostname -I | awk '{print $1}')
echo -e "${INFO}🔍 Checking VPS Configuration...${NC}"
echo -e "${SUCCESS}✅ Autobackup System Ready${NC}"
clear

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[ON]${Font_color_suffix}"
Error="${Red_font_prefix}[OFF]${Font_color_suffix}"
cek=$(grep -c -E "^# BEGIN_Backup" /etc/crontab)
if [[ "$cek" = "1" ]]; then
sts="${STATUS_ON}"
else
sts="${STATUS_OFF}"
fi

function start() {
email=$(cat /home/email 2>/dev/null)
if [[ "$email" = "" ]]; then
echo -e "${INFO}📧 Email Notification Setup${NC}"
echo -e "${DIVIDER}"
read -p "$(echo -e "${LIGHT}Enter your email address: ${NC}")" -e email
cat <<EOF>>/home/email
$email
EOF
fi
cat << EOF >> /etc/crontab
# BEGIN_Backup
5 0 * * * root /usr/bin/bash /usr/local/bin/backup
# END_Backup
EOF
systemctl restart cron
sleep 1
echo -e "${INFO}🔄 Applying configuration...${NC}"
clear
echo -e "${SUCCESS}✅ Autobackup Has Been Started${NC}"
echo -e "${INFO}📅 Data Will Be Backed Up Automatically at 00:05 GMT +7${NC}"
exit 0
}

function stop() {
email=$(cat /home/email 2>/dev/null)
if [[ -n "$email" ]]; then
sed -i "/^$email/d" /home/email
fi
sed -i "/^# BEGIN_Backup/,/^# END_Backup/d" /etc/crontab
systemctl restart cron
sleep 1
echo -e "${INFO}🔄 Stopping services...${NC}"
clear
echo -e "${SUCCESS}✅ Autobackup Has Been Stopped${NC}"
exit 0
}

clear
echo -e "${PRIMARY}╔════════════════════════════════════════╗${NC}"
echo -e "${PRIMARY}║           AUTO BACKUP SYSTEM           ║${NC}"
echo -e "${PRIMARY}╚════════════════════════════════════════╝${NC}"
echo -e ""
echo -e "${LIGHT}Current Status: ${sts}${NC}"
echo -e "${LIGHT}Server IP: ${SECONDARY}${MYIP}${NC}"
echo -e "${DIVIDER}"
echo -e ""
echo -e "${INFO}Please select an option:${NC}"
echo -e "  ${SUCCESS}[1]${NC} Enable Autobackup"
echo -e "  ${ERROR}[2]${NC} Disable Autobackup"
echo -e "${DIVIDER}"
read -rp "$(echo -e "${LIGHT}Enter your choice [1-2]: ${NC}")" -e num

if [[ "$num" = "1" ]]; then
start
elif [[ "$num" = "2" ]]; then
stop
else
echo -e "${ERROR}❌ Invalid selection${NC}"
exit 1
fi
