set -g -x fish_greeting 'Guten tag Enigama, you become better every day!!!'
set PAATH XDG_CONFIG_HOME $HOME /usr/bin/fish
set -gx EDITOR nvim

set -gx NVM_DIR $HOME/.nvm
set --universal nvm_default_version v24.13.0

set MAC_DACTYL CE:23:05:69:BD:65
set MAC_AIRPODS_PRO 08:FF:44:17:B3:B7
#Could be changed last number :C3,4...
set MAC_MOUSE D2:33:87:CC:53:C3

# Load OpenAI key from file
set -l openai_key (string trim (cat ~/.config/ai/OPENAI_API_key))
set -gx OPENAI_API_KEY $openai_key

set -l jira_token (string trim (cat ~/.config/JIRA_TOKEN 2>/dev/null))
set -gx JIRA_TOKEN $jira_token

set -l jira_url (string trim (cat ~/.config/JIRA_URL 2>/dev/null))
set -gx JIRA_URL $jira_url

set -l electricity_token (string trim (cat ~/.config/ELECTRICITY_TOKEN))
set -gx ELECTRICITY_TOKEN  $electricity_token

# direnv hook fish | source

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
    set -lx BROWSER ~/.local/bin/chrome-profile1

    if count $argv[1] >/dev/null
        yarn start:$argv[1]
    else
        yarn start
    end
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

function sw -d "Create git worktree and tmux session"
    if set -q argv[1]; and contains -- $argv[1] -h --help
        echo "Usage:"
        echo "  sw <ticket> [folder] [prefix]"
        echo
        echo "Arguments:"
        echo "  ticket   Ticket number (required)"
        echo "  folder   Worktrees folder (default: worktrees)"
        echo "  prefix   Branch prefix (default: CTVUI)"
        echo
        echo "Example:"
        echo "  sw 123"
        echo "  sw 123 infra CORE"
        return 0
    end

    if not set -q argv[1]
        echo "sw: missing ticket number"
        echo "Try: sw --help"
        return 1
    end

    set -l ticket $argv[1]
    set -l folder worktrees
    set -l prefix CTVUI

    if set -q argv[2]
        set folder $argv[2]
    end

    if set -q argv[3]
        set prefix $argv[3]
    end

    set -l branch "$prefix-$ticket"
    set -l path "$HOME/Projects/$folder/$branch"

    git worktree add -b $branch $path
    or return 1

    cd $path
    tmuxr $branch
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

function ctsc
 nvim (which tailscale-launch)
end

# Starter
if [ -z "$TMUX" ]
    tmux new-session -d -s work -c ~/Projects/worktrees/
    tmux attach fly || tmux new -s fly
end

#Tmux short
function ta
    if count $argv[1] >/dev/null
        tmux a -t $argv[1]
    else
        tmux a -t work
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

function suspend
    systemctl suspend
end

# GitHub Dash
alias gh-work='GH_HOST=work.github.com gh dash --config ~/.config/gh-dash/config-work.yml'
alias gh-personal='GH_HOST=github.com gh dash --config ~/.config/gh-dash/config-personal.yml'
set -gx PATH $HOME/go-sdk/go/bin $HOME/go/bin $PATH
