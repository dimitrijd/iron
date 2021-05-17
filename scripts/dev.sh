
# ##
# devcon --target: dev post-build init
# appended to .bashrc and .zshrc


# services start 
code () {
  echo "open http://0.0.0.0:8443" && start code
}

# stop update prompt and autoapdate by oh-my-zsh
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true

#
source ../help/help.sh

# welcome message
info


# ##

# ##

