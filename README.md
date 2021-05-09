# devcon 
### versioned  ubuntu + node + mongo + zsh + vscode-server stack

## How to run

`docker run -it -p 271017 -p 3000 -p 5000 -p 5500 -p 8443 dimitrijd/iron`

## To do:
- add global packages from npm (debug etc)
- add welcome intro 
- in $HOME only config source / no data/log/executables
- $HOME/.iron + code it's a full description of EVERYTHING in the code/environment
- $HOME/.iron can create the container to execute the source code in project
- EVERYTHING versioned (including apt packages)
- dived build context into base / stack / dev (inside each build / run)
- asy managing pull / run (establish ports & volumes) / attach /start/ stop 
- export TZ="/usr/share/zoneinfo/America/Los_Angeles"
- XDG compliant
- confing in shared -v
- UID/GUI from linuxserver.io
- all the code for reproducing the environment / github repo in shared-volume/.iron
- in .iron:  Dockerfile etc NO password
- easy sharing .ssh github  mail / name
- easy managign mongodb export / import
- easy ctrl/cmd-click to browser app
- add tiny-vim
- options base: ubuntu | debian | alpine
- options overlay: dumb-init+supervisord | s6 overlay
- options stack: node+mongo | node+Postgres | node+Mysql | node+sqlite3
- options dev: code-server | vim 
- simple way of defining options via Docker-compose
- simple way of managing permission
- three separated environment: base | stack | dev and context 
- code-space compatible
- https://specifications.freedesktop.org/basedir-spec/latest/ - compliant
- https://12factor.net/ - compliant
- https://semver.org/ - compliant
- monthly refreshing base
