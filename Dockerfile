# ############################################################
# devcon v.0.5
# versioned dev container ubuntu + node + mongo + code-server
# stages:
# - base: ubuntu, dumb-init, supervisord, non-root user 
# - stack: node, nvm, mongodb-org 
# - dev: code-server w/ extensions, oh-my-zsh w/ plug-ins
# ############################################################

# ############################################################
# devcon - **** BASE ****
# versioned UBUNTU base
# non-versioned dumb-init, supervisord, $PACKAGES 
# non-root $USER_NAME, $UID, $GID, sodoer
# ############################################################

ARG UBUNTU_VERSION=18.04
FROM ubuntu:"${UBUNTU_VERSION}" AS base
ARG PACKAGES='dumb-init supervisor sudo curl ca-certificates'
# apt-transport-https tzdata gnupg
ARG USER_NAME=coder
ARG PASSWORD=pass
ARG UID=1000
ARG GID=1000
ARG HOME=/config

# \
# copy base.sh and supervisord/ into $HOME
# 
WORKDIR ${HOME}
COPY ./scripts/base.sh ./scripts/base.sh
COPY ./supervisord ./supervisord

RUN \
# \
# install base $PACKAGES, unpinnned versions \
# \
  apt-get -qq update \
  && DEBIAN_FRONTEND=noninteractive \
     apt-get install -yq --no-install-recommends ${PACKAGES} \
  && apt-get clean \ 
  && rm -rf /var/cache/apt/lists /var/lib/apt/lists /var/cache/debconf* \
# \
# install user $USER_NAME $UID, $GID, make them sudoer with $PASSWORD \
# \
  && useradd -u "${UID}" -U -G sudo -d ${HOME} -s "/bin/bash" "${USER_NAME}" \
  && echo "${USER_NAME}":"${PASSWORD}" | chpasswd \
# \
# create empty directory .logs for supervisord logs
# add base.sh to .bashrc and .zshrc
# change ownership to $USER
# \
  && mkdir ".logs" \
  && echo "source ${HOME}/scripts/base.sh" | tee -a .zshrc  >> .bashrc \
  && chown -R ${USER_NAME}:${USER_NAME} ${HOME} 
#
# end of RUN

USER ${USER_NAME}
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/bash"]

# ############################################################
# devcon - **** STACK ****
# versioned NODE_VERSION, NVM_VERSION, MONGO_UBUNTU_VERSION
# ############################################################
FROM base AS stack
# repeated ARGs
ARG USER_NAME=coder
ARG HOME=/config
# 
ARG NODE_VERSION=14.16.1
ARG NVM_VERSION=v0.38.0
ARG NVM_DIR="$HOME/.nvm"
ARG MONGO_UBUNTU_VERSION=x86_64-ubuntu1804-4.0.2

USER root
WORKDIR ${HOME}
COPY ./scripts/stack.sh ./scripts/stack.sh
COPY ./mongo ./mongo

RUN \
# \
# install pinned versions $NVM_VERSION and $NODE_VERSION \
# \
  mkdir .nvm \
  && curl --silent --fail --location --output - \ 
     "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" \
     | bash  \
  && [ -s "${NVM_DIR}/nvm.sh" ] &&  \. "${NVM_DIR}/nvm.sh" \
  && nvm install ${NODE_VERSION} \
  && rm -rf .nvm/.cache/bin/* && chown -R ${USER_NAME} .nvm \
# \
# install mongodb-org packages, pinned version $MONGO_UBUNTU_VERSION
# create a mongodb group, mongodb:mongodb user, add $USER_NAME to mongod group
# add a sym link in supervisord config directory  
# \
  && target=mongodb-linux-${MONGO_UBUNTU_VERSION} \
  && curl --silent --fail --location --output "${target}.tgz" \
     "https://fastdl.mongodb.org/linux/${target}.tgz" \
  && tar fx "${target}.tgz" \ 
  && mv "${target}"/bin/mongo /usr/bin/ \
  && mv "${target}"/bin/mongod /usr/bin/ \
  && rm -rf "${target}"* \
  && groupadd -f mongodb && useradd --system -g mongodb mongodb \ 
  && usermod -aG mongodb $USER_NAME \
  && mkdir -p /data/db && chown -R mongodb:mongodb /data && chmod -R g+w /data \
  && cp /config/mongo/mongod.supervisord.conf \ 
     /config/supervisord/conf.d/mongod.conf \
# \
# add stack.sh to .bashrc and .zshrc
# change ownership to $USER
# \
  && echo "source ${HOME}/scripts/stack.sh" | tee -a .zshrc  >> .bashrc \
  && chown -R ${USER_NAME} ${HOME}
# 
# end of RUN

USER ${USER_NAME}
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/bash"]

# ############################################################
# devcon - **** DEV ****
# versioned nvm, code-server, code_extensions
# non-versioned git zsh oh-my-zsh fonts-powerline neofetch
# ############################################################
FROM stack AS dev
# repeated ARGs
ARG USER_NAME=coder
ARG HOME=/config
# 
ARG PACKAGES='git zsh fonts-powerline neofetch'
ARG CODE_VERSION=3.9.3
ARG CODE_EXTENSIONS=pinned
ARG ZSH_THEME=takashiyoshida
ARG OHMYZSH_PLUGINS='git node npm'

USER root
WORKDIR $HOME
COPY ./scripts/dev.sh ./scripts/dev.sh
COPY ./code-server ./code-server

RUN \ 
# \
# install dev PACKAGES, unpinnned versions \
# \
  apt-get -qq update \
  && DEBIAN_FRONTEND=noninteractive \
     apt-get install -yq --no-install-recommends ${PACKAGES} \
  && apt-get clean \
  && rm -rf /var/cache/apt/lists /var/lib/apt/lists /var/cache/debconf* \
# \
# install code-server, pinned version $CODE_VERSION
# add a sym link in supervisord config directory
# change ownership to $USER
# \
  && repo="https://github.com/cdr/code-server/releases/download/v${CODE_VERSION}/" \
  && target="code-server_${CODE_VERSION}_amd64.deb" \
  && curl --silent --fail --location --output "${target}" \
     "${repo}${target}" \
  && dpkg -i "${target}" && rm "${target}" \
  && cp /config/code-server/code.supervisord.conf \
     /config/supervisord/conf.d/code.conf \
  && chown -R ${USER_NAME} ${HOME}
#  
# end of RUN

USER $USER_NAME
RUN \   
# \
# \ install local code-server extensions $CODE_EXTENSIONS
  bash "$HOME/code-server/extensions-${CODE_EXTENSIONS}.sh" \
# \
# install oh-my-zsh, unpinned lastest version at container build date \
# set default theme $ZSH_THEME and plugins $OHMYZSH_PLUGINS \
# \
  && curl --silent --fail --location --output install.sh \
     "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" \
  && sh ./install.sh --unattended && rm ./install.sh \
  && sed -i "s/^ZSH_THEME=.*/ZSH_THEME=${ZSH_THEME}/" .zshrc \
  && sed -i "s/^plugins=.*/plugins=(${OHMYZSH_PLUGINS})/" .zshrc \
# \
# add dev.sh to .bashrc and .zshrc
# \
  && echo "source ${HOME}/scripts/dev.sh" | tee -a .zshrc  >> .bashrc 
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
