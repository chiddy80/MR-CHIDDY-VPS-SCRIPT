#!/bin/bash
# ==========================================
# Professional Bandwidth Limiter
# ==========================================

# Modern Color Scheme
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

# Status Indicators
STATUS_ON="${SUCCESS}ACTIVE${NC}"
STATUS_OFF="${ERROR}INACTIVE${NC}"

# Getting system info
MYIP=$(wget -qO- ipinfo.io/ip 2>/dev/null)
echo -e "${INFO}🔍 Checking VPS Configuration...${NC}"
echo -e "${SUCCESS}✅ IP Check Bypassed...${NC}"
clear

cek=$(cat /home/limit 2>/dev/null)
NIC=$(ip -o -4 route show to default 2>/dev/null | awk '{print $5}' | head -n1)

function start() {
    echo -e "${INFO}📊 Bandwidth Limiter Configuration${NC}"
    echo -e "${DIVIDER}"
    read -p "$(echo -e "${LIGHT}Set maximum download rate (in Kbps): ${NC}")" down
    read -p "$(echo -e "${LIGHT}Set maximum upload rate (in Kbps): ${NC}")" up
    
    if [[ -z "$down" ]] && [[ -z "$up" ]]; then
        echo -e "${WARNING}⚠ No limits specified, skipping configuration${NC}"
    else
        echo -e "${INFO}🔄 Starting configuration...${NC}"
        sleep 0.5
        
        # Install wondershaper if not present
        if ! command -v wondershaper &> /dev/null; then
            echo -e "${INFO}📦 Installing wondershaper...${NC}"
            apt-get update > /dev/null 2>&1
            apt-get install -y wondershaper > /dev/null 2>&1
        fi
        
        wondershaper -a $NIC -d $down -u $up > /dev/null 2>&1
        systemctl enable --now wondershaper.service 2>/dev/null
        echo "start" > /home/limit
        echo -e "${SUCCESS}✅ Bandwidth limits applied: ${down}Kbps↓ / ${up}Kbps↑${NC}"
    fi
}

function stop() {
    echo -e "${INFO}🛑 Stopping bandwidth limits...${NC}"
    
    if command -v wondershaper &> /dev/null; then
        wondershaper -ca $NIC
        systemctl stop wondershaper.service 2>/dev/null
        systemctl disable wondershaper.service 2>/dev/null
    fi
    
    echo > /home/limit
    echo -e "${SUCCESS}✅ Bandwidth limits removed${NC}"
}

# Determine current status
if [[ "$cek" = "start" ]]; then
    sts="${STATUS_ON}"
else
    sts="${STATUS_OFF}"
fi

# Display UI
clear
echo -e "${PRIMARY}╔════════════════════════════════════════╗${NC}"
echo -e "${PRIMARY}║           BANDWIDTH MANAGER           ║${NC}"
echo -e "${PRIMARY}╚════════════════════════════════════════╝${NC}"
echo -e ""
echo -e "${LIGHT}Current Status: ${sts}${NC}"
echo -e "${DIVIDER}"
echo -e "${LIGHT}Network Interface: ${SECONDARY}${NIC}${NC}"
echo -e "${LIGHT}Server IP: ${SECONDARY}${MYIP}${NC}"
echo -e "${DIVIDER}"
echo -e ""
echo -e "${INFO}Please select an option:${NC}"
echo -e "  ${SUCCESS}[1]${NC} Enable Bandwidth Limits"
echo -e "  ${ERROR}[2]${NC} Disable Bandwidth Limits"
echo -e "${DIVIDER}"
read -rp "$(echo -e "${LIGHT}Enter your choice [1-2]: ${NC}")" num

if [[ "$num" = "1" ]]; then
    start
elif [[ "$num" = "2" ]]; then
    stop
else
    echo -e "${ERROR}❌ Invalid selection${NC}"
    exit 1
fi
