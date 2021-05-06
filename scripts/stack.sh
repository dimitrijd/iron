
# ##
# devcon --target: stack post-build init
# appended to .bashrc and .zshrc

# nvm environment
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] &&  \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# start mongod supervisord service
alias mongod='start mongod'

# ##

