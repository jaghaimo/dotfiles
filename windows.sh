packages="winscp google-backup-and-sync keepassxc calibre vlc kitty irfanview"
echo choco install $(printf '%s\n' $packages | sort)
