function git-track-all-remotes
    # Fetch all remote updates including pruning deleted branches
    git fetch --all --prune

    # Loop through remote branches and create/track local ones
    # Skip HEAD and any existing locals
    for remote_branch in (git branch -r | grep '^  origin/' | sed 's/^  origin\///' | grep -v HEAD)
        if not git branch --list $remote_branch >/dev/null 2>&1
            git branch --track $remote_branch origin/$remote_branch
            echo "Created tracking branch: $remote_branch"
        else
            echo "Branch $remote_branch already exists locally"
        end
    end

    echo "All remote branches now tracked locally."
    git branch -a
end
