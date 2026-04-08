#!/usr/bin/env fish

set SETUP_FILE "$HOME/.dotfiles/setup_linux_cachyos.sh"

if not test -f $SETUP_FILE
    echo "Error: Setup file not found at $SETUP_FILE"
    exit 1
end

# Get packages that were explicitly installed via paru -S from shell history.
# Handles multi-package lines like: paru -S docker docker-buildx docker-compose
set history_packages (builtin history | grep -iP '^\s*paru\s+-S\b' | sed 's/^\s*paru\s\+-S\s\+//' | tr ' ' '\n' | grep -P '^[\w\-\.@+]+$' | sort -u)

# Get ALL packages already listed in the setup file, including from multi-package lines.
# e.g. "paru -S docker docker-buildx docker-compose" → docker, docker-buildx, docker-compose
set listed_packages (grep -iP '^\s*paru\s+-S\b' $SETUP_FILE | sed 's/^\s*paru\s\+-S\s\+//' | tr ' ' '\n' | grep -P '^[\w\-\.@+]+$' | sort -u)

# Get all explicitly installed packages (not pulled in as dependencies)
set explicit_packages (paru -Qe | awk '{print $1}')

set added 0
set skipped 0

for pkg in $history_packages
    # Skip if already in the setup file (any line, any position)
    if contains $pkg $listed_packages
        continue
    end

    # Skip if no longer installed (was uninstalled)
    if not contains $pkg $explicit_packages
        echo "Skipped (not installed or dependency only): $pkg"
        set skipped (math $skipped + 1)
        continue
    end

    echo "paru -S $pkg" >> $SETUP_FILE
    echo "Added: $pkg"
    set added (math $added + 1)
end

echo ""
if test $added -eq 0
    echo "Nothing new to add to $SETUP_FILE"
else
    echo "Done — $added package(s) added to $SETUP_FILE"
end
if test $skipped -gt 0
    echo "$skipped package(s) skipped (uninstalled or dependency only)"
end
