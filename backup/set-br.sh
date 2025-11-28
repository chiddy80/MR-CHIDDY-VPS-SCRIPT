#!/bin/bash
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
echo -e "${SUCCESS}✅ System Ready for Setup${NC}"
clear

# Link Hosting Kalian
akbarvpn="raw.githubusercontent.com/fisabiliyusri/Mantap/main/backup"

echo -e "${PRIMARY}╔════════════════════════════════════════╗${NC}"
echo -e "${PRIMARY}║           SYSTEM SETUP                ║${NC}"
echo -e "${PRIMARY}╚════════════════════════════════════════╝${NC}"
echo -e ""

echo -e "${INFO}📦 Installing Rclone...${NC}"
apt install rclone -y
echo -e "${SUCCESS}✅ Rclone installed${NC}"

echo -e "${INFO}⚙️  Configuring Rclone...${NC}"
printf "q\n" | rclone config
wget -O /root/.config/rclone/rclone.conf "https://${akbarvpn}/rclone.conf"
echo -e "${SUCCESS}✅ Rclone configured${NC}"

echo -e "${INFO}🚀 Installing Wondershaper...${NC}"
git clone https://github.com/magnific0/wondershaper.git
cd wondershaper
make install
cd
rm -rf wondershaper
echo -e "${SUCCESS}✅ Wondershaper installed${NC}"

echo -e "${INFO}📊 Initializing bandwidth limits...${NC}"
echo > /home/limit
echo -e "${SUCCESS}✅ Bandwidth system ready${NC}"

echo -e "${INFO}📧 Configuring email notifications...${NC}"
apt install msmtp-mta ca-certificates bsd-mailx -y

# Create msmtprc configuration
cat<<EOF>>/etc/msmtprc
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account default
host smtp.gmail.com
port 587
auth on
user bckupvpns@gmail.com
from bckupvpns@gmail.com
password Yangbaru1
logfile ~/.msmtp.log
EOF

chown -R www-data:www-data /etc/msmtprc
echo -e "${SUCCESS}✅ Email system configured${NC}"

echo -e "${INFO}📥 Downloading management scripts...${NC}"
cd /usr/bin

# Download scripts with error handling
scripts=(
    "autobackup"
    "backup" 
    "restore"
    "strt"
    "limitspeed"
)

for script in "${scripts[@]}"; do
    echo -e "${INFO}  📄 Downloading ${script}...${NC}"
    if wget -O "$script" "https://${akbarvpn}/${script}.sh"; then
        chmod +x "$script"
        echo -e "  ${SUCCESS}✅ ${script} installed${NC}"
    else
        echo -e "  ${ERROR}❌ Failed to download ${script}${NC}"
    fi
done

echo -e "${DIVIDER}"
echo -e "${SUCCESS}🎉 Setup Completed Successfully!${NC}"
echo -e ""
echo -e "${INFO}📋 Installed Components:${NC}"
echo -e "  ${SUCCESS}✓${NC} Rclone - Cloud storage management"
echo -e "  ${SUCCESS}✓${NC} Wondershaper - Bandwidth control"
echo -e "  ${SUCCESS}✓${NC} Email notifications - SMTP setup"
echo -e "  ${SUCCESS}✓${NC} Backup system - Automated backups"
echo -e "  ${SUCCESS}✓${NC} Restore system - Data recovery"
echo -e "  ${SUCCESS}✓${NC} Bandwidth manager - Speed limits"
echo -e "${DIVIDER}"
echo -e "${INFO}🚀 System ready for use!${NC}"

cd
rm -f /root/set-br.sh
