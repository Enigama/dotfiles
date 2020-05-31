#fisher add tuvistavie/fish-ssh-agent 
# fisher add oh-my-fish/theme-bobthefish

set -g -x fish_greeting 'Guten tag Enigama'
set PAATH XDG_CONFIG_HOME $HOME /usr/bin/fish
set -gx EDITOR nvim

##npm
function ni
  npm i
end

function nrw
  npm run watch
end
##
##GIT ALIAS
function gs
 git status
end

function ga
 git add .
end

alias gcm='git commit -m'

function gp
 git push
end

function gpr
  git pull --rebase
end

function gcb
  git checkout $argv
end

function gb
  git branch
end

function gcf
  git add .
  git commit -m '[FRONT] fix'
  git push
end
##

#Confiuration files fast
function cvim
  nvim-qt -- -- ~/.config/nvim/init.vim
end

function cfish
  nvim-qt -- -- ~/.config/fish/config.fish
end

function ci3
  nvim-qt -- -- ~/.i3/config
end

##Server Connect##
function server
  ssh seadora_ek@95.216.186.136
end
##
