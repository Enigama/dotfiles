set -g -x fish_greeting 'Guten tag Enigama, you become better every day!!!'
set PAATH XDG_CONFIG_HOME $HOME /usr/bin/fish
set -gx EDITOR nvim

set -gx NVM_DIR $HOME/.nvm
set -x LANGUAGES_NODE_VERSION '22.14.0'

set MAC_DACTYL CE:23:05:69:BD:65
set MAC_AIRPODS_PRO 08:FF:44:17:B3:B7
#Could be changed last number :C3,4...
set MAC_MOUSE D2:33:87:CC:53:C3


if not pgrep -u (whoami) ssh-agent > /dev/null
    eval (ssh-agent -c)
    ssh-add ~/.ssh/work_id_rsa
    ssh-add ~/.ssh/personal_id_rsa
    clear
end

# Set up fzf key bindings
# fzf --fish | source

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

##Additional runners
function lint
    yarn lint
end

function typecheck
    yarn typecheck
end
##

##GIT ALIAS
alias gcm='git commit -m'
alias dconf='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

function dcc
    dconf commit -m $argv
end

function dca
    dconf add $argv
end

function dcs
    dconf status
end

function gs
    git status
end

function ga
    git add .
end

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
    git branch $argv
end

function gcf
    git add .
    git commit -m 'fix'
    git push
end

function gl
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
end

#Worktree
function gwl
    git worktree list
end

function gwr
    git worktree remove $argv
end

function gwa
    git worktree add $argv
end

#This is amaizing but we should split it up, and make it more readable
function sw -d "Args: argv[1] - ticket number, argv[2] - folder name. Uses prefix: CTVUI- but we can use argv[3] to change it. Create a new folder or use old one if exists, than create a new folder for worktree with name CTVUI-argv[1]"
    #define a prefix, default is CTVUI, or if we have argv[3] we use it
    set -l prefix CTVUI
    if count $argv[3] >/dev/null
        set prefix $argv[3]
    end

    git worktree add -b $prefix-$argv[1] ../$argv[2]/$prefix-$argv[1] && ../$argv[2]/$prefix-$argv[1]
    tmuxr $prefix-$argv[1]
    tmux send-keys -t . "ynvim" C-m
end

function tmp
    #We definetly can do better
    set -l prefix CTVUI-
    if count $argv[1] >/dev/null
        set prefix $argv[1]
    end
    echo "$prefix, $argv[1]"
end

#Rename tmux window
function tmuxr
    tmux send-keys -t . "tmux rename-window '$argv[1]'" C-m
end

function ynvim -d "Open nvim and call install deps and run server"
    nvim +"TermExec cmd='nci && ys'"
end
##

function V -d "Open nvim and run webpack server according to environment"
    switch $argv[1]
        case "qa"
            nvim +"TermExec cmd='yarn start:qa'"
        case "prod"
            nvim +"TermExec cmd='yarn start:prod'"
        case "dev"
        case "*"
            nvim +"TermExec cmd=ys"
    end
end

#Confiuration files fast
function ckitty
    nvim ~/.config/kitty/kitty.conf
end
function cvim
    nvim ~/.config/nvim/init.lua
end

function cfish
    nvim ~/.config/fish/config.fish
end

function ci3
    nvim ~/.config/i3/config
end

function ctmux
    nvim ~/.tmux.conf
end

function cdac
    nvim ~/Dactyl/config/dac_man_5x6.keymap
end

# Starter
if [ -z "$TMUX" ]
    tmux new-session -d -s magnite -c ~/Projects/worktrees/
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

function devices
    bluetoothctl -- devices
end

function bInfo --description "Show bluetooth info about specific device"
    while true
        read -p 'echo -e "Bluetooth devices\n 1) Dactyl Keyboard\n 2) Logitech Mouse\n 3) Airpods Pro\n Fill device number: "' -l confirm

        switch $confirm
            case 1
                bluetoothctl -- info $MAC_DACTYL
                return 0
            case 2
                bluetoothctl -- info $MAC_MOUSE
                return 0
            case 3
                bluetoothctl -- info $MAC_AIRPODS_PRO
                return 0
            case "*"
                echo Please select one of existing variants
        end
    end
end
function connectM
    echo "print 1"
    echo "print 2"
    echo "print 3"
end

function reminder
    cat ~/Personal/doc.txt
end
