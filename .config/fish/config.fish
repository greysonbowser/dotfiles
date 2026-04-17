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
    set HOME_DOTS $DOTS/home/grey

    set files \
        /home/grey/.bash_profile \
        /home/grey/.bashrc \
        /home/grey/.gitconfig \
        /home/grey/.npmrc \
        /home/grey/.profile \
        /home/grey/.tmux.conf \
        /home/grey/.vimrc \
        /home/grey/.zshenv \
        /home/grey/.zshrc

    set dirs \
        /home/grey/.config/fish \
        /home/grey/.config/hypr \
        /home/grey/.config/hyprpanel \
        /home/grey/.config/kitty \
        /home/grey/.config/sherlock \
        /home/grey/.config/systemd/user \
        /home/grey/.config/vicinae \
        /home/grey/.config/wayscriber

    set extra_files \
        /home/grey/.config/MangoHud/MangoHud.conf \
        /home/grey/.config/btop/btop.conf \
        /home/grey/.config/micro/bindings.json \
        /home/grey/.config/micro/settings.json \
        /home/grey/.config/qutebrowser/bookmarks/urls \
        /home/grey/.config/qutebrowser/quickmarks \
        /home/grey/.config/Code/User/settings.json \
        /home/grey/.config/VSCodium/User/settings.json

    echo Copying dotfiles...

    mkdir -p $HOME_DOTS

    for path in $files
        if test -f $path
            cp $path $HOME_DOTS/
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

    if git remote get-url origin >/dev/null 2>&1
        git push
    else
        echo Dotfiles copied and committed. Add an origin remote before pushing.
    end
end
