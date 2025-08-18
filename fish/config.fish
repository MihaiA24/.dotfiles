source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

alias zed='zeditor'


# Persistent SSH agent - passphrase only once per login
set -l agent_file ~/.ssh/agent_info

# Try to load existing agent
if test -f $agent_file
    source $agent_file >/dev/null 2>&1
end

# Check if agent is working and has keys
if not set -q SSH_AUTH_SOCK; or not ssh-add -l >/dev/null 2>&1
    # Start new agent and save info
    ssh-agent -c > $agent_file
    source $agent_file
    ssh-add  # This will ask for passphrase once
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/miniconda3/bin/conda
    eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/opt/miniconda3/etc/fish/conf.d/conda.fish"
        . "/opt/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/opt/miniconda3/bin" $PATH
    end
end
# <<< conda initialize <<<
