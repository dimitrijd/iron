# iron script
# 

iron() {
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


command -v docker &>/dev/null || (
    echo -e "${BOLD}${RED}${img} needs docker ->> ${BLUE}https://docs.docker.com/get-docker${NORMAL}" 
    return 1
)

docker images --format '{{.Repository}}' | grep ${img} &>/dev/null || (
    echo -e "${BOLD}${RED}${img} image missing ->> ${YELLOW}${img} downloading...${NORMAL}${LIGHT_YELLOW}" 
    docker pull ${img} && echo -e "${BOLD}${GREEN}${img} ...completed${NORMAL}"
)

docker ps -aq --format '{{.Names}}' | grep ${container} &>/dev/null || (
    echo -e "${BOLD}${RED}${container} container not started ${YELLOW}->> starting...${NORMAL}"
    docker run -it  -v ${host_dir}:/${container_dir} \
      -p 27017:27017 -p 27018:27018 -p 3000:3000 -p 5000:5000 -p 5500:5500 -p 8443:8443 \
      --name ${container} ${img}:${ver} ; return 0
)

docker ps --format '{{.Names}}' | grep ${container} &>/dev/null || (

)
       
}

