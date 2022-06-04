#!/bin/bash

function msg() {
	local text="$1"
	local div_width="80"
	printf "%${div_width}s\n" ' ' | tr ' ' -
	printf "%s\n" "$text"
}

function ask() {
	local question="$1"
	while true; do
		msg "$question"
		read -t 30 -p "[y]es or [no] " -r answer
		case "$answer" in
		y | Y | yes | Yes | YES)
			return 0
			;;
		n | N | No | no)
			return 1
			;;
		*)
			msg "Please answer [y]es or [n]o. "
			;;
		esac
	done
}

sudo pacman -S --needed base-devel base linux linux-firmware linux-headers git
if [ ! -f /usr/bin/paru ]; then
	git clone https://aur.archlinux.org/paru.git
	cd paru || {
		echo "cd paru failed "
		exit 127
	}
	makepkg -si
	cd .. || {
		echo "failed "
		exit 127
	}
	rm -r paru
fi

sudo paru -S - <script/pkglist.txt

cp -r ./configuration/config/* $HOME/.config/

if ask "Neovim: "; then
	neovim=yes
else
	neovim=no
fi

if ask "Lightdm with glorious"; then
	lightdm=yes
fi

if ask "Fcitx5 with Catppuccin"; then
	fcitx5=yes
fi

if ask "Grub with Catppuccin: "; then
	grub=yes
fi

if [ $neovim = yes ]; then
	wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
	if [ -d "$HOME"/bin ]; then
		mv nvim.appimage "$HOME"/bin/nvim
	else
		mkdir "$HOME"/bin
		mv nvim.appimage "$HOME"/bin/nvim
	fi
fi

if [ $lightdm = yes ]; then
	sudo systemctl enable lightdm
	sudo sed -i 's/^\(#?greeter\)-session\s*=\s*\(.*\)/greeter-session = lightdm-webkit2-greeter #\1/ #\2g' /etc/lightdm/lightdm.conf
	sudo sed -i 's/^webkit_theme\s*=\s*\(.*\)/webkit_theme = glorious #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf
	sudo sed -i 's/^debug_mode\s*=\s*\(.*\)/debug_mode = true #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf
fi

if [ $fcitx5 = yes ]; then
	git clone https://github.com/catppuccin/fcitx5.git
	mkdir -p ~/.local/share/fcitx5/themes/
	cp -r ./fcitx5/Catppuccin ~/.local/share/fcitx5/themes
fi

if [ $grub = yes ]; then
	git clone https://github.com/catppuccin/grub.git
	cd grub || {
		echo git clone failed
		exit 127
	}
	sudo cp -r src/* /usr/share/grub/themes/
	# TODO: use sed command, find GRUB_THEME and delete the last matched line, and change it
	echo GRUB_THEME="/usr/share/grub/themes/catppuccin-macchiato-grub-theme/theme.txt" >>/etc/default/grub
	sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ ! -f "$HOME/.oh-my-zsh/themes/passion.zsh-theme" ]; then
	wget https://github.com/ChesterYue/ohmyzsh-theme-passion/blob/master/passion.zsh-theme
	mv passion.zsh-theme "$HOME/.oh-my-zsh/themes/"
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

cp configuration/.zshrc "$HOME/"

if ask "Git configuration: "; then
	read -p "Github username: " -r git_username
	read -p "Github Email address: " -r git_email
	git config --global user.name "$git_username"
	git config --global user.email "$git_email"
	ssh-keygen -t rsa -b 4096 -C "$git_email"
	cat ~/.ssh/id_rsa.pub
	echo Click add ssh key at here: https://link.zhihu.com/?target=https%3A//github.com/settings/keys
fi
