# ############################################################
#
# devcon v.0.5
# 
# versioned dev container ubuntu + node + mongo + code-server
# stages:
# - base: ubuntu, dumb-init, supervisord, non-root user 
# - stack: node, mongodb-org 
# - dev: nvm, code-server w/ extensions, oh-my-zsh w/ plug-ins
#
# ############################################################

# ############################################################
#
# devcon - **** BASE ****
#
# versioned UBUNTU base
# non-versioned dumb-init, supervisord, $PACKAGES 
# non-root $USER_NAME, $UID, $GID, $SHELL
#
# ############################################################
ARG UBUNTU_VERSION=18.04
FROM ubuntu:${UBUNTU_VERSION} AS devcon_ubuntu_base
ARG PACKAGES='dumb-init supervisor sudo ca-certificates \
              apt-transport-https tzdata gnupg'
ARG USER_NAME=coder
ARG PASSWORD=pass
ARG UID=1000
ARG GID=1000
ARG SHELL=/usr/bin/zsh
ARG HOME=/home/$USER_NAME

RUN \
# \
# install base $PACKAGES, unpinnned versions \
# \
  apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
     apt-get install -y --no-install-recommends ${PACKAGES} \
  && apt-get clean && rm -rf /var/cache/apt/lists \
# \
# install user $USER_NAME $UID, $GID, make they sudoer with $PASSWORD \
# \
  && groupadd -f -g ${GID} ${USER_NAME} \
  && useradd -u ${UID} -g ${USER_NAME} -m -s ${SHELL} ${USER_NAME} \
  && usermod -aG sudo ${USER_NAME} \
  && echo ${USER_NAME}:${PASSWORD} | chpasswd
#
# end of RUN

# ############################################################
#
# devcon - **** STACK ****
#
# versioned NODE_VERSION, NVM_VERSION, MONGO_UBUNTU_VERSION
# non-versioned essential packages
#
# ############################################################
FROM devcon_ubuntu_base AS devcon_ubuntu_stack
# repeated ARGs
ARG USER_NAME=coder
# 
ARG PACKAGES='wget curl'
ARG NODE_VERSION=14.16.1
ARG NVM_VERSION=v0.38.0
ARG NVM_DIR="$HOME/.nvm"
ARG MONGO_UBUNTU_VERSION=x86_64-ubuntu1804-4.0.2
WORKDIR /home/$USER_NAME
RUN \
# \
# install stack $PACKAGES, unpinnned versions \
# \
  apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
     apt-get install -y --no-install-recommends ${PACKAGES} \
  && apt-get clean && rm -rf /var/cache/apt/lists \
# \
# install nvm, node pinned versions $NVM_VERSION and $NODE_VERSION \
# \
  && mkdir .nvm \
  && curl -o- \ 
     "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh"\
     | bash \
  && [ -s "${NVM_DIR}/nvm.sh" ] &&  \. "${NVM_DIR}/nvm.sh" \
  && nvm install ${NODE_VERSION} \
  && chown -R $USER_NAME .nvm \
# \
# install mongodb-org packages, pinned version $MONGO_UBUNTU_VERSION
# create a mongodb group, mongodb:mongodb user, add $USER_NAME to mongod group  
# \
  && target=mongodb-linux-${MONGO_UBUNTU_VERSION} \
  && wget "https://fastdl.mongodb.org/linux/${target}.tgz" \
  && tar fxv "${target}.tgz" \ 
  && mv ${target}/bin/* /usr/bin/ && rm -rf ${target}* \
  && groupadd -f mongodb && useradd --system -g mongodb mongodb \ 
  && usermod -aG mongodb $USER_NAME \
  && mkdir -p /data/db && chown -R mongodb:mongodb /data && chmod -R g+w /data 
# 
# end of RUN

# ############################################################
#
# devcon - **** DEV ****
#
# versioned nvm, code-server, code_extensions
# non-versioned essential packages
#
# ############################################################
FROM devcon_ubuntu_stack AS devcon_ubuntu_dev
# repeated ARGs
ARG USER_NAME=coder
ARG HOME=/home/$USER_NAME
# 
ARG PACKAGES='vim git zsh locales fonts-powerline neofetch'
ARG CODE_VERSION=3.9.3
ARG CODE_EXTENSIONS=pinned
ARG ZSH_THEME=takashiyoshida
ARG OHMYZSH_PLUGINS='git node'

WORKDIR $HOME
COPY . ferrum
RUN \ 
# \
# install dev PACKAGES, unpinnned versions \
# \
  apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
     apt-get install -y --no-install-recommends ${PACKAGES} \
  && apt-get clean && rm -rf /var/cache/apt/lists \
# \
# install code-server, pinned version $CODE_VERSION
# \
  && curl -fL https://github.com/cdr/code-server/releases/download/v${CODE_VERSION}/code-server_${CODE_VERSION}_amd64.deb -o code.deb \
  && dpkg -i code.deb && rm code.deb \
# \
  && chown -R ${USER_NAME} ferrum  
# 
# end of RUN

USER $USER_NAME
RUN \  
# \
# make diretories and touch files needed for the installations \
  mkdir .logs && touch .gitconfig \
# \
# \ install local pinned extensions ferrum/code-server/extensions-$CODE_EXTENSIONS.sh
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




