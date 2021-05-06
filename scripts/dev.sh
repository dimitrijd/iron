
# ##
# devcon --target: dev post-build init
# appended to .bashrc and .zshrc


# ##
# ferrum aliases 
# appended to .bashrc and .zshrc

# supervisord start / stop / status
# SUPERVISORD_HOME defined in ./commands
alias supervisor='supervisord -c $SUPERVISORD_HOME/supervisord.conf'
alias start='supervisorctl -c $SUPERVISORD_HOME/supervisord.conf start'
alias stop='supervisorctl -c $SUPERVISORD_HOME/supervisord.conf stop'
alias status='supervisorctl -c $SUPERVISORD_HOME/supervisord.conf status'

# services start 
code () {
  echo "open http://0.0.0.0:8443" && start code
}
alias mongod='start mongod'
alias express='start express'

# ##


# ##
# ferrum post-build init
# appended to .bashrc and .zshrc

# stop update prompt and autoapdate by oh-my-zsh
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true


# base directory for ferrum configurations and scripts
export BASE_FERRUM="$HOME/ferrum"

# nvm environment
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] &&  \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# supervisord start-up
export SUPERVISORD_HOME="$HOME/ferrum/supervisord"
supervisord -c $SUPERVISORD_HOME/supervisord.conf

# welcome message
neofetch

# ##

# ##

