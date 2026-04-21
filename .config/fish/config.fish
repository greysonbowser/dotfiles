source /usr/share/cachyos-fish-config/cachyos-config.fish

function fish_greeting
    echo Local time is (set_color purple)(date +%T)(set_color normal) System uptime: (set_color red)(uptime -p)(set_color normal)

end

function wttr
    set WTTR https://wttr.in/
    curl $WTTR$argv[1]
    
end

alias pacview="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"

function c
	clear; fish_greeting
end


function scramble
    for line in (seq 1 7)
        if test (math "$line % 2") -eq 1
            set_color red
        else
            set_color blue --bold
        end

        for i in (seq 1 10)
            if test (math "$i % 2") -eq 1
                set face R
            else
                set face D
            end

            if test (random) -gt 16383
                printf '%s++ ' "$face"
            else
                printf '%s-- ' "$face"
            end
        end

        if test (random) -gt 16383
            printf 'U'
        else
            printf "U'"
        end

        set_color normal
        printf '\n'
    end
end

fish_config theme choose "Rosé Pine"


function dots
    set DOTS /home/grey/dotfiles

    set files \
        /home/grey/.tmux.conf \
        /home/grey/.vimrc

    set dirs \
        /home/grey/.config/fish \
        /home/grey/.config/hypr \
        /home/grey/.config/hyprpanel \
        /home/grey/.config/kitty \
        /home/grey/.config/systemd/user \
        /home/grey/.config/vicinae \
        /home/grey/.config/wayscriber

    set extra_files \
        /home/grey/.config/MangoHud/MangoHud.conf \
        /home/grey/.config/btop/btop.conf \
        /home/grey/.config/kitty/kitty.conf.bak \
        /home/grey/.config/micro/bindings.json \
        /home/grey/.config/micro/settings.json \
        /home/grey/.config/qutebrowser/bookmarks/urls \
        /home/grey/.config/qutebrowser/quickmarks

    echo Copying dotfiles...

    mkdir -p $DOTS

    for path in $files
        if test -f $path
            cp $path $DOTS/
        end
    end

    for path in $dirs
        if test -d $path
            set rel (string replace -r '^/home/grey/' '' $path)
            mkdir -p $DOTS/(dirname $rel)
            rsync -a --delete $path/ $DOTS/$rel/
        end
    end

    for path in $extra_files
        if test -f $path
            set rel (string replace -r '^/home/grey/' '' $path)
            mkdir -p $DOTS/(dirname $rel)
            cp $path $DOTS/$rel
        end
    end

    if not test -d $DOTS/.git
        git -C $DOTS init
    end

    cd $DOTS
    git add --all

    if git diff --cached --quiet
        echo No dotfile changes to commit.
        return
    end

    set message "Update dotfiles "(date '+%Y-%m-%d %H:%M:%S')
    git commit -m "$message"
    git push
end

function gambitbot_start
    set -l session gambitbot
    set -l repo /home/grey/opening

    tmux has-session -t $session 2>/dev/null; and tmux kill-session -t $session
    tmux new-session -d -s $session "cd $repo && ./scripts/run_lichess_bot_session.sh -v"
    tmux split-window -h -t $session "cd $repo && ./scripts/live_session_dashboard.py"
    tmux select-layout -t $session even-horizontal
    echo "Started tmux session '$session'. Attach with: tmux attach -t $session"
end

function gambitbot_stop
    set -l session gambitbot
    if not tmux has-session -t $session 2>/dev/null
        echo "No '$session' tmux session running."
        return 1
    end
    tmux send-keys -t $session C-c
    echo "Sent graceful shutdown signal. Bot will finish active games then exit."
    echo "Run again (or press Ctrl-C twice inside the session) to force-quit immediately."
end
