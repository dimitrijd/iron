# irontools/ferrum 

### Compact and versioned dev container with dumb-init, supervisor, node, mongo, nvm, zsh, code-server.


## How to get
```
docker pull dimitrijd/iron
```

## How to run
```
docker run -it \
  -p 27017:27017 \
  -p 3000:3000 \
  -p 5000:5000 \
  -p 5500:5500 \
  -p 8443:8443 \
  -v $(pwd):/home/coder/project \
  -t ferrum \
  dimitrijd/iron
```

## To do
- add welcome intro 
- add global packages from npm (debug etc)

### HOME
- XDG compliant
- $HOME/.ferrum can create the container 
- divide build context into base / stack / dev (inside each build / run)

### Versioning
- add versionning to apt-packages via `requirements.txt`

### Build options
- options base: ubuntu | debian | alpine
- options overlay: dumb-init+supervisord | s6 overlay
- options stack: node+mongo | node+Postgres | node+Mysql | node+sqlite3
- options dev: code-server | vim

### Host-side helpers
- managing container status via helper function (pull, run, start, stop, restart)
- sharing .ssh github  mail / name
- managigng mongodb export / import
- code-space compatible

### Permissions
- UID/GUI from linuxserver.io
