set -g -x fish_greeting 'Guten tag Enigama, you become better every day!!!'
set PAATH XDG_CONFIG_HOME $HOME /usr/bin/fish
set -gx EDITOR nvim

##npm
function ni
    npm i
end

function nci
    npm ci
end

function ys
    yarn start
end

function yt
    yarn test $argv
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
    git push $argv
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
    git commit -m 'fix'
    git push
end

function gwl
    git worktree list
end

function gwr
    git worktree remove $argv
end

function gwa
    git worktree add $argv
end
##

function V
    nvim
end

#Confiuration files fast
function cvim
    nvim ~/.config/nvim/init.lua
end

function cfish
    nvim ~/.config/fish/config.fish
end

function cneofetch
    nvim ~/.config/neofetch/config.conf
end

function ci3
    nvim ~/.config/i3/config
end

function ctmux
    nvim ~/.tmux.conf
end

function cdac
    nvim ~/Keyboard/Dactyl/config/dac_man_5x6.keymap
end

#function fish_greeting
#  neofetch
#end

# Todo make magnite session first instead of fly
if [ -z "$TMUX" ]
    tmux new-session -d -s magnite -c ~/Projects/application-console.git
    tmux attach fly || tmux new -s fly
end

#Tmux short
function ta
    if count $argv[1] >/dev/null
        tmux a -t $argv[1]
    else
        tmux a -t magnite
    end
end

#File manager by terminal
function rd
    ranger ~/Documents/
end

function stopServer
    if count $argv[1] >/dev/null
        sudo kill -9 (sudo lsof -t -i:$argv[1])
    else
        sudo kill -9 (sudo lsof -t -i:3000)
    end
end
