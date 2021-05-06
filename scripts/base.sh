
# ##
# # devcon --target: base post-build init
# appended to .bashrc and .zshrc

# supervisord start-up
supervisord -c ${HOME}/supervisord/supervisord.conf

# supervisord start / stop / status
alias supervisor='supervisord -c ${HOME}/supervisord/supervisord.conf'
alias start='supervisorctl -c ${HOME}/supervisord/supervisord.conf start'
alias stop='supervisorctl -c ${HOME}/supervisord/supervisord.conf stop'
alias status='supervisorctl -c ${HOME}/supervisord/supervisord.conf status'

# ##

