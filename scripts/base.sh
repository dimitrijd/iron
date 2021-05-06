
# ##
# # devcon --target: base post-build init
# appended to .bashrc and .zshrc

# supervisord start-up
supervisord -c /config/supervisord/supervisord.conf

# supervisord start / stop / status
alias supervisor='supervisord -c /config/supervisord/supervisord.conf'
alias start='supervisorctl -c /config/supervisord/supervisord.conf start'
alias stop='supervisorctl -c /config/supervisord/supervisord.conf stop'
alias status='supervisorctl -c /config/supervisord/supervisord.conf status'

# ##

