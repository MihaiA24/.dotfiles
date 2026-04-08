function change_git_email
    git filter-repo --commit-callback '
if commit.author_email == b"mihaiaftinescu@gmail.com":
    commit.author_name = b"Mihai Aftinescu"
    commit.author_email = b"93051145+MihaiA24@users.noreply.github.com"
'
    echo "Rewriting done. Don't forget to push force if needed."
end
