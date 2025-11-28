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
BOX_TOP="${PRIMARY}╔═════════════════════════════════════════════════════╗${NC}"
BOX_MID="${PRIMARY}║${NC}"
BOX_BOTTOM="${PRIMARY}╚═════════════════════════════════════════════════════╝${NC}"
DIVIDER="${DARK}─────────────────────────────────────────────────────${NC}"

clear
echo -e "${BOX_TOP}"
echo -e "${PRIMARY}║${NC}${SECONDARY}           🚀 PREMIUM AUTO SCRIPT BY MR CHIDDY           ${NC}${PRIMARY}║${NC}"
echo -e "${BOX_MID}"
echo -e "${PRIMARY}║${NC}${LIGHT}              Compatible with Ubuntu 25.04               ${NC}${PRIMARY}║${NC}"
echo -e "${BOX_MID}"
echo -e "${PRIMARY}║${NC}${INFO}  • Ubuntu 25.04 64 bit                          ${NC}${PRIMARY}║${NC}"
echo -e "${PRIMARY}║${NC}${INFO}  • Debian 12 & Ubuntu 22.04 LTS                 ${NC}${PRIMARY}║${NC}"
echo -e "${PRIMARY}║${NC}${INFO}  • KVM & VMWare Virtualization                  ${NC}${PRIMARY}║${NC}"
echo -e "${PRIMARY}║${NC}${INFO}  • Optimized for Modern Systems                 ${NC}${PRIMARY}║${NC}"
echo -e "${BOX_MID}"
echo -e "${PRIMARY}║${NC}${SUCCESS}            Built with Professional Tools              ${NC}${PRIMARY}║${NC}"
echo -e "${BOX_MID}"
echo -e "${PRIMARY}║${NC}${WARNING}                 🙏 THANKS TO                         ${NC}${PRIMARY}║${NC}"
echo -e "${BOX_MID}"
echo -e "${PRIMARY}║${NC}${LIGHT}  • Allah SWT                                   ${NC}${PRIMARY}║${NC}"
echo -e "${PRIMARY}║${NC}${LIGHT}  • My Family                                   ${NC}${PRIMARY}║${NC}"
echo -e "${PRIMARY}║${NC}${LIGHT}  • esimfreegb                                  ${NC}${PRIMARY}║${NC}"
echo -e "${PRIMARY}║${NC}${LIGHT}  • ispismyself                                 ${NC}${PRIMARY}║${NC}"
echo -e "${PRIMARY}║${NC}${LIGHT}  • Open Source Community                       ${NC}${PRIMARY}║${NC}"
echo -e "${BOX_BOTTOM}"
echo -e ""
echo -e "${INFO}💻 System: ${LIGHT}Ubuntu 25.04 Ready${NC}"
echo -e "${INFO}📅 Date:   ${LIGHT}$(date +"%Y-%m-%d %H:%M:%S")${NC}"
echo -e "${DIVIDER}"
