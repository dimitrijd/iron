
# help screeen
# 

help_screen() {
# main paramenters
img=dimitrijd/iron
ver=latest
container=iron
host_dir=$(pwd)
container_dir=project

# color definitions 
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
LIGHT_YELLOW='\e[93m'
BLUE='\e[34m'
BOLD='\e[1m'
NORMAL='\e[0m'

echo -e "${BOLD}${RED}dumb-init:${BLUE}$(dumb-init -v)${NORMAL}"
echo -e "${BOLD}${RED}supervisord: ${BLUE}$(supervisord -v)${NORMAL}"

echo -e "${BOLD}${YELLOW}node:${BLUE}$(node -v)${NORMAL}"
echo -e "${BOLD}${YELLOW}npm: ${BLUE}$(npm -v)${NORMAL}"
echo -e "${BOLD}${YELLOW}nvm: ${BLUE}$(nvm -v)${NORMAL}"
echo -e "${BOLD}${YELLOW}mongod: ${BLUE}$($(command -v mongod) --version)${NORMAL}"
