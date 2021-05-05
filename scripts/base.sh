
# ##
# ferrum post-build init
# appended to .bashrc 

# base directory for ferrum configurations and scripts
export BASE_FERRUM="$HOME/ferrum"

# supervisord start-up
supervisord -c $SUPERVISORD_HOME/supervisord.conf

# ##


# ##
# ferrum aliases 
# appended to .bashrc and .zshrc

# supervisord start / stop / status
# SUPERVISORD_HOME defined in ./commands
alias supervisor='supervisord -c $SUPERVISORD_HOME/supervisord.conf'
alias start='supervisorctl -c $SUPERVISORD_HOME/supervisord.conf start'
alias stop='supervisorctl -c $SUPERVISORD_HOME/supervisord.conf stop'
alias status='supervisorctl -c $SUPERVISORD_HOME/supervisord.conf status'

# ##

