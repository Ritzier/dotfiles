export ZSH="$HOME/.oh-my-zsh"

#ZSH_THEME="robbyrussell"
ZSH_THEME="passion"

plugins=(
	git
	copyfile
	copypath
	zsh-syntax-highlighting
)
ZSH_COLORIZE_TOOL=chroma
ZSH_COLORIZE_STYLE="colorful"
ZSH_COLORIZE_CHROMA_FORMATTER=terminal256

source $ZSH/oh-my-zsh.sh
export PATH=$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin/:$PATH
export Raspi=/mnt/Raspi/
source /home/user/Downloads/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
