source /usr/share/cachyos-fish-config/cachyos-config.fish

function cmd
       pi \
           --no-tools \
           --no-session \
           --no-context-files \
           --no-skills \
           --no-prompt-templates \
           --no-extensions \
           --system-prompt 'Output only the requested shell command and nothing else. Assume fish syntax unless otherwise stated.' \
           -p (string join ' ' -- $argv)
   end

function quickprompt
       pi --no-tools --no-session \
           --system-prompt 'Output only the requested shell command and nothing else. Assume fish syntax unless otherwise stated' \
           -p (string join ' ' -- $argv)
   end

   function fish_greeting
    echo Local time is (set_color purple)(date +%T)(set_color normal) System uptime: (set_color red)(uptime -p)(set_color normal)

end

function tsend
    set -l target (printf '%s\n' iphone171 ubuntu-4gb-hel1-1 iphone181 jasmines-macbook-pro | fzf --prompt="Send to> " --height=~50% --layout=reverse)
    or return 1
    test -n "$target"; or return 1
    sudo tailscale file cp $argv $target:
end

function tget
    sudo tailscale file get --conflict=rename ~/Downloads/tget
end    

function wttr
    set WTTR https://wttr.in/
    curl $WTTR$argv[1]
    
end

alias pacview="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"

function c
	clear; fish_greeting
end

function mkdircd
    if test (count $argv) -ne 1
        echo "expects one arg" >&2 ## >&2 to prevent pipe error
        return 1
    end
    mkdir -p $argv[1]; and cd $argv[1]
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
        /home/grey/.config/wayscriber \
        /home/grey/.pi/agent/extensions/pi-statusline-custom

    set extra_files \
        /home/grey/.config/MangoHud/MangoHud.conf \
        /home/grey/.config/micro/bindings.json \
        /home/grey/.config/micro/settings.json

    # Patterns excluded from the directory mirroring below: app-generated
    # backups, fish's machine-state var store, and systemd .wants symlinks.
    set excludes \
        --exclude '*.bak' \
        --exclude 'fish_variables' \
        --exclude '*.target.wants/'

    echo Copying dotfiles...

    mkdir -p $DOTS

    for path in $files
        cp $path $DOTS/
    end

    for path in $dirs
        set rel (string replace -r '^/home/grey/' '' $path)
        mkdir -p $DOTS/(dirname $rel)
        rsync -a --delete $excludes $path/ $DOTS/$rel/
    end

    for path in $extra_files
        set rel (string replace -r '^/home/grey/' '' $path)
        mkdir -p $DOTS/(dirname $rel)
        cp $path $DOTS/$rel
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

function mmrun
    set PROJECT /home/grey/megaminx-viewer

    cd $PROJECT; and cmake --build build; and begin
        ./build/megaminx_viewer data/megaminx_spec.json > /tmp/megaminx-viewer.log 2>&1 &
        disown
    end
end

source ~/.config/fish/gambitbot.fish

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /home/grey/.ghcup/bin # ghcup-env

function dic-lookup
    ~/dic/target/release/dic
end    
