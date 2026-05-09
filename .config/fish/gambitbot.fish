function gambitbot_start
    set -l session gambitbot
    set -l repo /home/grey/opening
    set -l state_file /tmp/gambitbot/board.json
    set -l board_cmd "vendor/lichess-bot/venv/bin/python scripts/boardview.py --state $state_file"

    tmux has-session -t $session 2>/dev/null; and tmux kill-session -t $session

    mkdir -p /tmp/gambitbot
    rm -f $state_file

    set -l board_pane (tmux new-session \
        -d \
        -P -F "#{pane_id}" \
        -s $session \
        -n main \
        -c $repo \
        $board_cmd)

    set -l bot_pane (tmux split-window \
        -h \
        -P -F "#{pane_id}" \
        -t $board_pane \
        -c $repo \
        "env GAMBITBOT_BOARD_STATE=$state_file ./scripts/run_lichess_bot_session.sh -v")

    set -l dash_pane (tmux split-window \
        -v \
        -P -F "#{pane_id}" \
        -t $bot_pane \
        -c $repo \
        "./scripts/live_session_dashboard.py")

    __gambitbot_apply_layout $session
    tmux select-pane -t $board_pane -T board
    tmux select-pane -t $bot_pane -T bot
    tmux select-pane -t $dash_pane -T dashboard

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

function gambitbot_revive
    set -l session gambitbot
    set -l repo /home/grey/opening
    set -l state_file /tmp/gambitbot/board.json
    set -l board_cmd "vendor/lichess-bot/venv/bin/python scripts/boardview.py --state $state_file"
    set -l target all

    if test (count $argv) -gt 0
        set target $argv[1]
    end

    if not contains -- $target all board bot dashboard
        echo "Usage: gambitbot_revive [all|board|bot|dashboard]"
        return 1
    end

    if not tmux has-session -t $session 2>/dev/null
        echo "No '$session' tmux session found. Starting a fresh one."
        gambitbot_start
        return $status
    end

    mkdir -p /tmp/gambitbot

    set -l board_pane (__gambitbot_find_pane $session board)
    set -l bot_pane (__gambitbot_find_pane $session bot)
    set -l dash_pane (__gambitbot_find_pane $session dashboard)

    if test "$target" = all; or test "$target" = board
        if test -z "$board_pane"
            set -l anchor (__gambitbot_first_pane $session)
            if test -z "$anchor"
                echo "No panes left in '$session'. Starting a fresh one."
                tmux kill-session -t $session 2>/dev/null
                gambitbot_start
                return $status
            end

            set board_pane (tmux split-window \
                -h \
                -b \
                -P -F "#{pane_id}" \
                -t $anchor \
                -c $repo \
                $board_cmd)
            tmux select-pane -t $board_pane -T board
        end
    end

    if test "$target" = all; or test "$target" = bot
        if test -z "$bot_pane"
            if test -n "$dash_pane"
                set bot_pane (tmux split-window \
                    -v \
                    -b \
                    -P -F "#{pane_id}" \
                    -t $dash_pane \
                    -c $repo \
                    "env GAMBITBOT_BOARD_STATE=$state_file ./scripts/run_lichess_bot_session.sh -v")
            else if test -n "$board_pane"
                set bot_pane (tmux split-window \
                    -h \
                    -P -F "#{pane_id}" \
                    -t $board_pane \
                    -c $repo \
                    "env GAMBITBOT_BOARD_STATE=$state_file ./scripts/run_lichess_bot_session.sh -v")
            else
                echo "Could not place bot pane because no anchor pane was found."
                return 1
            end
            tmux select-pane -t $bot_pane -T bot
        end
    end

    if test "$target" = all; or test "$target" = dashboard
        set dash_pane (__gambitbot_find_pane $session dashboard)
        if test -z "$dash_pane"
            if test -z "$bot_pane"
                set bot_pane (__gambitbot_find_pane $session bot)
            end
            if test -n "$bot_pane"
                set dash_pane (tmux split-window \
                    -v \
                    -P -F "#{pane_id}" \
                    -t $bot_pane \
                    -c $repo \
                    "./scripts/live_session_dashboard.py")
                tmux select-pane -t $dash_pane -T dashboard
            else
                echo "Could not place dashboard pane because the bot pane is missing."
                return 1
            end
        end
    end

    __gambitbot_apply_layout $session
    echo "Revived missing gambitbot panes in '$session'."
end

function __gambitbot_find_pane
    set -l session $argv[1]
    set -l title $argv[2]

    for line in (tmux list-panes -t "$session:main" -F "#{pane_id} #{pane_title}" 2>/dev/null)
        set -l parts (string split -m1 " " -- $line)
        if test (count $parts) -ge 2; and test "$parts[2]" = "$title"
            echo $parts[1]
            return 0
        end
    end

    return 1
end

function __gambitbot_first_pane
    set -l session $argv[1]

    for pane in (tmux list-panes -t "$session:main" -F "#{pane_id}" 2>/dev/null)
        echo $pane
        return 0
    end

    return 1
end

function __gambitbot_apply_layout
    set -l session $argv[1]
    set -l board_pane (__gambitbot_find_pane $session board)

    tmux set-window-option -t "$session:main" main-pane-width 50% >/dev/null
    tmux set-window-option -t "$session:main" pane-border-status top >/dev/null

    if test -n "$board_pane"
        tmux select-pane -t $board_pane >/dev/null
    end
    tmux select-layout -t "$session:main" main-vertical >/dev/null
end
