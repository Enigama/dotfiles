function scd -d "Smart cd: change dir and rename tmux window"
    if count $argv >/dev/null
        cd $argv[1]
    end
    or return 1

    if set -q TMUX
        if type -q tmux
            set -l window_name (basename (pwd))
            tmux rename-window "$window_name"
        end
    end
end
