#EXPOSE 3000
#EXPOSE 8443
# DONE add nvm
# DONE add zsh
# issue add oh-my-zsh due to .config home directory - need to decide wherE
# add bells&whistles zshell
# code-server --open >/dev/null 2>&1 &
# add vscoder extension and --open and code . simlar to non-autooder
# add global packages from npm (debug etc)
# add welcome intro 
# export TZ="/usr/share/zoneinfo/America/Los_Angeles"
# add shell function to avoid port collision
# express
# handlebars
# same username
# same userID/groupID


#/etc/services.d/code-server
#/usr/local/share/.config/yarn/global/node_modules/.bin/code-server
#/usr/local/share/.config/yarn/global/node_modules/code-server
#/usr/local/bin/code-server

#[program:mongod]
#command=/usr/bin/mongod --config /etc/mongod.conf
#stdout_logfile=/var/log/supervisor/%(program_name)s.log
#stderr_logfile=/var/log/supervisor/%(program_name)s.log
#autorestart=true
#user=mongodb
#priority=10


