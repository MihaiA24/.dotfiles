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

# uv
fish_add_path "/home/mihai/.local/bin"



# lean-ctx shell hook — transparent CLI compression (90+ patterns)
set -g _lean_ctx_cmds git npm pnpm yarn cargo docker docker-compose gh pip pip3 ruff go golangci-lint eslint prettier tsc ls find grep curl wget

function _lc
	if set -q LEAN_CTX_DISABLED; or not isatty stdout
		command $argv
		return
	end
	'/home/mihai/.cargo/bin/lean-ctx' -c $argv
	set -l _lc_rc $status
	if test $_lc_rc -eq 127 -o $_lc_rc -eq 126
		command $argv
	else
		return $_lc_rc
	end
end

function lean-ctx-on
	for _lc_cmd in $_lean_ctx_cmds
		alias $_lc_cmd '_lc '$_lc_cmd
	end
	alias k '_lc kubectl'
	set -gx LEAN_CTX_ENABLED 1
	echo 'lean-ctx: ON'
end

function lean-ctx-off
	for _lc_cmd in $_lean_ctx_cmds
		functions --erase $_lc_cmd 2>/dev/null; true
	end
	functions --erase k 2>/dev/null; true
	set -e LEAN_CTX_ENABLED
	echo 'lean-ctx: OFF'
end

function lean-ctx-raw
	set -lx LEAN_CTX_RAW 1
	command $argv
end

function lean-ctx-status
	if set -q LEAN_CTX_DISABLED
		echo 'lean-ctx: DISABLED (LEAN_CTX_DISABLED is set)'
	else if set -q LEAN_CTX_ENABLED
		echo 'lean-ctx: ON'
	else
		echo 'lean-ctx: OFF'
	end
end

if not set -q LEAN_CTX_ACTIVE; and not set -q LEAN_CTX_DISABLED; and test (set -q LEAN_CTX_ENABLED; and echo $LEAN_CTX_ENABLED; or echo 1) != '0'
	if command -q lean-ctx
		lean-ctx-on
	end
end
# lean-ctx shell hook — end
