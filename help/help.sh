# help screeen
#

# color definitions
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
LIGHT_YELLOW='\e[93m'
BLUE='\e[34m'
BOLD='\e[1m'
NORMAL='\e[0m'

info() {
echo -e "${BOLD}${RED}OS: ${BLUE}Ubuntu 18.04.5 LTS${NORMAL}"
echo -e "${BOLD}${RED}dumb-init: ${BLUE}v1.2.1${NORMAL}"
echo -e "${BOLD}${RED}supervisord: ${BLUE}$(supervisord -v)${NORMAL}"
echo -e "${BOLD}${YELLOW}node: ${BLUE}$(node -v)${NORMAL}"
echo -e "${BOLD}${YELLOW}npm: ${BLUE}$(npm -v)${NORMAL}"
echo -e "${BOLD}${YELLOW}nvm: ${BLUE}$(nvm -v)${NORMAL}"
echo -e "${BOLD}${YELLOW}mongod: ${BLUE}$(env mongod --version | head -n 1)${NORMAL}"
echo -e "${BOLD}${YELLOW}mongo: ${BLUE}$(mongo --version | head -n 1)${NORMAL}"
echo -e "${BOLD}${GREEN}zsh: ${BLUE}$(zsh --version)${NORMAL}"
echo -e "${BOLD}${GREEN}code-server: ${BLUE}$(code-server --version)${NORMAL}"
echo -e "${BOLD}user: ${BLUE}$(id -un)${NORMAL}"
echo -e "${BOLD}groups: ${BLUE}$(id -Gn)${NORMAL}"
echo -e "\n${BOLD} >>> type 'help' to get started \n${NORMAL}"
}

help() {
echo -e "${BOLD}${RED}service list and status: ${BLUE}status${NORMAL}"
echo -e "${BOLD}${RED}start code-server: ${BLUE}code${NORMAL}"
echo -e "${BOLD}${RED}start mongod: ${BLUE}mongod${NORMAL}"
echo -e "${BOLD}${RED}stop a service: ${BLUE}stop <service-name>${NORMAL}"
echo -e "${BOLD}${RED}start or stop all services: ${BLUE}start | stop all${NORMAL}"
echo -e "${BOLD}${BLUE}service status:${NORMAL}"
status
echo -e "${BOLD}${GREEN}accessible on ${YELLOW}http://localhost:${BLUE}\$PORT${NORMAL}"
echo -e "${BOLD}${GREEN}mongod: ${BLUE}27017${NORMAL}"
echo -e "${BOLD}${GREEN}reactjs client: ${BLUE}3000${NORMAL}"
echo -e "${BOLD}${GREEN}reactjs server: ${BLUE}5000${NORMAL}"
echo -e "${BOLD}${GREEN}code-server: ${BLUE}8443${NORMAL}"
echo -e "${BOLD}${GREEN}live server code extension: ${BLUE}5500${NORMAL}"
}
