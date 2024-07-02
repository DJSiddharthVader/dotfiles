source ~/.bashrc
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
PATH=$(echo $PATH | awk -v RS=: -v ORS=: '!($0 in a) {a[$0]; print}') #remove duplicate entries in path
