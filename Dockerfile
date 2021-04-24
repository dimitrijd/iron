ARG UBUNTU_VERSION=18.04   
FROM ubuntu:${UBUNTU_VERSION}

ARG NODE_VERSION=14.16.1
ARG NVM_VERSION=v0.34.0
ARG USR_NAME=coder
ARG PASSWORD=pass
ARG uid=1000
ARG gid=1000
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
COPY ./supervisord ./.supervisord
RUN chown $USR_NAME ./.supervisord

USER $USR_NAME
RUN \ 
  wget -O install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
  && sh ./install.sh && rm ./install.sh \
  && mkdir .nvm && mkdir .git  && touch .gitconfig \
  && curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash \
  && [ -s "$NVM_DIR/nvm.sh" ] &&  \. "$NVM_DIR/nvm.sh" \
  && nvm install $NODE_VERSION \
  && sed -i  "s/^ZSH_THEME=.*/ZSH_THEME=${ZSH_THEME}/" .zshrc \
  && sed -i  "s/^plugins=.*/plugins=(${OHMYZSH_PLUGINS})/" .zshrc \
  && echo 'export NVM_DIR="$HOME/.nvm"' >> .zshrc \
  && echo '[ -s "$NVM_DIR/nvm.sh" ] &&  \. "$NVM_DIR/nvm.sh"'  >> .zshrc \
  && echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> .zshrc \
  && curl -fOL https://github.com/cdr/code-server/releases/download/v3.9.3/code-server_3.9.3_amd64.deb \
  && echo $PASSWORD | sudo -S dpkg -i code-server_3.9.3_amd64.deb \
  && rm code-server_3.9.3_amd64.deb \
  && echo "supervisord -c .supervisord/supervisord.conf" >> .bashrc \
  && echo "alias start='supervisorctl -c ~/.supervisord/supervisord.conf start'" >> .bashrc \
  && echo "alias stop='supervisorctl -c ~/.supervisord/supervisord.conf stop'" >> .bashrc \
  && echo "supervisord -c .supervisord/supervisord.conf" >> .zshrc \
  && echo "alias start='supervisorctl -c ~/.supervisord/supervisord.conf start'" >> .zshrc \
  && echo "alias stop='supervisorctl -c ~/.supervisord/supervisord.conf stop'" >> .zshrc \
  && echo "neofetch" >> .zshrc \
  && npm install -g chalk 

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["zsh"]

# sudo mongod  --bind_ip_all &

# Expose ports.
#   - 27017: process
#   - 28017: http
EXPOSE 27017
EXPOSE 28017