
# ##
# # devcon --target: base post-build init
# appended to .bashrc and .zshrc

# supervisord start-up
supervisord -c %(ENV_HOME)s/supervisord/supervisord.conf

# supervisord start / stop / status
alias supervisor='supervisord -c %(ENV_HOME)s/supervisord/supervisord.conf'
alias start='supervisorctl -c %(ENV_HOME)s/supervisord/supervisord.conf start'
alias stop='supervisorctl -c %(ENV_HOME)s/supervisord/supervisord.conf stop'
alias status='supervisorctl -c %(ENV_HOME)s/supervisord/supervisord.conf status'

# ##

