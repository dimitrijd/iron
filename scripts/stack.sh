
# ##
# devcon --target: stack post-build init
# appended to .bashrc and .zshrc

# nvm environment
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] &&  \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# start mongod supervisord service
alias mongod='echo "on 27017 in container, on 27019 in host\n" && start mongod'

# ##

