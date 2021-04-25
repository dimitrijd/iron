ARG UBUNTU_VERSION=18.04   
FROM ubuntu:${UBUNTU_VERSION}

ARG NODE_VERSION=14.16.1
ARG NVM_VERSION=v0.38.0
ARG CODE_VERSION=3.9.3
ARG USR_NAME=coder
ARG PASSWORD=pass
ARG uid=1000
ARG gid=1000
ARG SHELL_AT_START=zsh
ARG ZSH_THEME="takashiyoshida"
ARG OHMYZSH_PLUGINS="git node" # must be space separated, with no ( )

ENV SHELL /usr/bin/zsh
ENV HOME /home/$USR_NAME
ENV NVM_DIR "$HOME/.nvm"
ENV DEBIAN_FRONTEND noninteractive  

RUN \ 
  apt-get update \
  && apt-get install -y \
       dumb-init \
       supervisor \
       sudo \ 
       ca-certificates \ 
       apt-transport-https \ 
       tzdata \ 
       gnupg \ 
       wget \ 
       curl \ 
       vim \
       git \
       zsh \ 
       locales \
       fonts-powerline \ 
       neofetch \ 
       --no-install-recommends \
  && locale-gen en_US.UTF-8 \
  && adduser --quiet --disabled-password \ 
       --shell $SHELL --home $HOME \
       --gecos "User" $USR_NAME \
  && usermod -aG sudo $USR_NAME \ 
  && echo $USR_NAME:$PASSWORD | chpasswd \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 \
  && echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | \ 
       tee /etc/apt/sources.list.d/mongodb-org-4.0.list \
  && apt-get update && apt-get install -y mongodb-org \
  && apt-get clean && apt-get autoremove \
  && rm -rf /var/cache/apt/lists \
  && mkdir -p /data/db \
  && groupadd -f mongodb \
  && usermod -aG mongodb $USR_NAME \
  && chown -R mongodb:mongodb /data \
  && chmod -R g+w /data 

WORKDIR $HOME
COPY . ferrum
RUN chown ${USR_NAME} ferrum   
USER $USR_NAME

RUN \ 
# \
# make diretories and touch files needed for the installations \
# \
  mkdir .nvm && mkdir .git && mkdir .logs && touch .gitconfig \
# \
# install nvm, node pinned versions $NVM_VERSION and $NODE_VERSION \
# \
  && curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash \
  && [ -s "${NVM_DIR}/nvm.sh" ] &&  \. "${NVM_DIR}/nvm.sh" \
  && nvm install ${NODE_VERSION} \
# \
# install code-server, pinned version $CODE_VERSION \
# \
  && curl -fL https://github.com/cdr/code-server/releases/download/v${CODE_VERSION}/code-server_${CODE_VERSION}_amd64.deb -o code.deb \
  && echo ${PASSWORD} | sudo -S dpkg -i code.deb && rm code.deb \
# \
# install oh-my-zsh, unpinned lastest version at container build date \
# set default theme $ZSH_THEME and plugins $OHMYZSH_PLUGINS \
# \
  && wget -O install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
  && sh ./install.sh && rm ./install.sh \
  && sed -i  "s/^ZSH_THEME=.*/ZSH_THEME=${ZSH_THEME}/" .zshrc \
  && sed -i  "s/^plugins=.*/plugins=(${OHMYZSH_PLUGINS})/" .zshrc \
# \
# add start up commands and aliases to .zshrc and .bashrc \ 
# \
  && cat ./ferrum/scripts/commands ./ferrum/scripts/aliases | tee -a .zshrc  >> .bashrc 
# 
# end of RUN

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ${SHELL}

# mongo
#EXPOSE 27017   #   - 27017: process

