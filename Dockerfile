# ############################################################
#
# devcon v.0.5
# 
# versioned dev container ubuntu + node + mongo + code-server
# three stages:
# - base:  versioned ubuntu and non-root user
# - stack: versioned node and mongodb packages
# - dev:   versioned code-server, extensions, oh-my-zsh, plugs
#
# ############################################################

# ############################################################
#
# devcon - **** BASE ****
#
# versioned UBUNTU base
# non-versioned dumb-init supervisord PACKAGES 
# non-root USR_NAME
#
# ############################################################
ARG UBUNTU_VERSION=18.04
FROM ubuntu:${UBUNTU_VERSION} AS devcon_ubuntu_base

ARG PACKAGES='dumb-init supervisor sudo ca-certificates apt-transport-https tzdata gnupg'
ARG USR_NAME=coder
ARG PASSWORD=pass
ARG UID=1000
ARG GID=1000
ARG SHELL=/usr/bin/zsh
ARG HOME=/home/$USR_NAME

RUN \
# \
# install base $PACKAGES, unpinnned versions \
# \
  apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
     apt-get install -y --no-install-recommends ${PACKAGES} \
  && apt-get clean \
# \
# install user $USR_NAME $UID, $GID, make they sudoer with $PASSWORD \
# \
  && adduser --quiet --disabled-password \
     --shell $SHELL --home $HOME \
     --gecos "User" $USR_NAME \
  && usermod -aG sudo $USR_NAME \
  && echo $USR_NAME:$PASSWORD | chpasswd
#
# end of RUN

# ############################################################
#
# devcon - **** STACK ****
#
# versioned NODE_VERSION, MONGO_UBUNTU_VERSION
# non-versioned essential packages
#
# ############################################################
ARG PACKAGES=wget ca-certificates
ARG NODE_VERSION=14.16.1
ARG MONGO_UBUNTU_VERSION=x86_64-ubuntu1804-4.0.2
ARG $USR_NAME=coder

FROM devcon_ubuntu_base AS devcon_ubuntu_stack
RUN \
# \
# install stack $PACKAGES, unpinnned versions \
# \
  apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
     apt-get install -y --no-install-recommends ${PACKAGES} \
  && apt-get clean \
# \
# install mongodb-org packages, pinned versions for $MONGO_UBUNTU_VERSION
# create a mongodb group, mongodb:mongodb user, add $USR_NAME to mongod group  
# \
  && target=mongodb-linux-${MONGO_UBUNTU_VERSION} \
  && wget "https://fastdl.mongodb.org/linux/${target}.tgz" \
  && tar fxv ${target}.tgz && mv $target/bin/* /usr/bin/ && rm -rf $target* \
  && groupadd -f mongodb && useradd -g mongodb mongodb \ 
  && usermod -aG mongodb $USR_NAME \
  && mkdir -p /data/db && chown -R mongodb:mongodb /data && chmod -R g+w /data 
# 
# end of RUN

# #########################
# #  devcon - **** DEV ****
#
# versioned nvm, code-server, code_extensions
# non-versioned essential packages
#
FROM devcon_ubuntu_stack AS devcon_ubuntu_dev

ARG PACKAGES='curl vim git zsh locales fonts-powerline neofetch'
ARG NODE_VERSION=14.16.1
ARG NVM_VERSION=v0.38.0
ARG CODE_VERSION=3.9.3
ARG CODE_EXTENSIONS=pinned
ARG ZSH_THEME="takashiyoshida"
ARG OHMYZSH_PLUGINS="git node"
ARG USR_NAME=coder
ARG SHELL=/usr/bin/zsh
ARG HOME=/home/$USR_NAME
ARG NVM_DIR="$HOME/.nvm"


RUN \ 
# \
# install dev PACKAGES, unpinnned versions \
# \
  apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
     apt-get install -y --no-install-recommends ${PACKAGES} \
  && apt-get clean 
# 
# end of RUN

WORKDIR $HOME
COPY . ferrum
RUN chown ${USR_NAME} ferrum   
USER $USR_NAME

RUN \  
#
# make diretories and touch files needed for the installations \
  mkdir .nvm && mkdir .git && mkdir .logs && touch .gitconfig \
#
# \
# install nvm, node pinned versions $NVM_VERSION and $NODE_VERSION \
# \
  && curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash \
  && [ -s "${NVM_DIR}/nvm.sh" ] &&  \. "${NVM_DIR}/nvm.sh" \
  && nvm install ${NODE_VERSION} \
# \
# install code-server, pinned version $CODE_VERSION, pinned extensions ferrum/code-server/extensions-$CODE_EXTENSIONS.sh
# \
  && curl -fL https://github.com/cdr/code-server/releases/download/v${CODE_VERSION}/code-server_${CODE_VERSION}_amd64.deb -o code.deb \
  && echo ${PASSWORD} | sudo -S dpkg -i code.deb && rm code.deb \
  && bash "$HOME/ferrum/code-server/extensions-${CODE_EXTENSIONS}.sh" \
# \
# install oh-my-zsh, unpinned lastest version at container build date \
# set default theme $ZSH_THEME and plugins $OHMYZSH_PLUGINS \
# \
  && wget -O install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
  && sh ./install.sh --unattended && rm ./install.sh \
  && sed -i "s/^ZSH_THEME=.*/ZSH_THEME=${ZSH_THEME}/" .zshrc \
  && sed -i "s/^plugins=.*/plugins=(${OHMYZSH_PLUGINS})/" .zshrc \
# \
# add start up commands and aliases to .zshrc and .bashrc \ 
# \
  && cat ./ferrum/scripts/commands ./ferrum/scripts/aliases | tee -a .zshrc  >> .bashrc 
# 
# end of RUN

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/bin/zsh"]

# mongod
EXPOSE 27017
# reactjs client
EXPOSE 3000
# reactjs server
EXPOSE 5000
# code-server
EXPOSE 8443




