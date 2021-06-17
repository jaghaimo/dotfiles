.PHONY: help
help: Makefile
	@echo "Please use one of the following:"
	@sed -n 's/^##//p' $<

## backup		: Backup existing configuration files
.PHONY: backup
backup:
	cp ~/bin . -r
	cp ~/.config/nvim/init.vim dotfiles/.config/nvim/
	cp ~/.config/nvim/coc-settings.json dotfiles/.config/nvim/
	cp ~/.gitconfig dotfiles/
	cp ~/.gitignore dotfiles/
	cp ~/.p10k.zsh dotfiles/
	cp ~/.profile dotfiles/
	cp ~/.ssh/config dotfiles/.ssh
	cp ~/.tmux.conf dotfiles/
	cp ~/.zshrc dotfiles/
	cp ~/.Xresources dotfiles/

## install	: Install new configuration files
.PHONY: install
install:
	mkdir -p ~/.local/share/nvim/backup
	rsync -r bin ~
	rsync -r dotfiles/ ~
