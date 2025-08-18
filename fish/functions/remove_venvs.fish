function remove_venvs
    echo (set_color cyan)"Searching for .venv directories..."(set_color normal)

    for dir in (find . -type d -name ".venv")
        set absdir (realpath "$dir")
        echo (set_color yellow)"Found: $absdir"(set_color normal)
        read -l -P (set_color brcyan)"Delete this directory? (Y/n) "(set_color normal) confirm

        if test -z "$confirm" -o "$confirm" = "y" -o "$confirm" = "Y"
            echo (set_color green)"Deleting: $absdir"(set_color normal)
            rm -rf "$absdir"
        else
            echo (set_color red)"Skipped: $absdir"(set_color normal)
        end
    end

    echo (set_color cyan)"Done."(set_color normal)
end
