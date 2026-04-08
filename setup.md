# Install from scratch

```bash
export BIN_DIR="${HOME}/bin"
mkdir -p "${BIN_DIR}"
# cloen dotfiles
git clone https://github.com/DJSiddharthVader/st
ln -sf ${HOME}/dotfiles/.{ascii,bash,bashrc,cheatsheets,config,css,fonts,scripts,tmux,tmux.conf,vim,vimrc} ${HOME}/
# install apps
sudo apt-get install polybar i3 mpd libreoffice syncthing zathura curl qpdfview lm-sensors neofetch rofi tmux neovim feh htop
sudo npm install -g tree-sitter-cli
sudo apt install libgdk-pixbuf2.0-dev libxml2-utils gtk2-engines-murrine librsvg2-bin autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev libgif-dev libssl-dev libxml2-dev lm-sensors bc tr awk 
# Install Obsidian 
cd ${BIN_DIR}
wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.12.7/obsidian_1.12.7_amd64.deb
sudo dpkg -i ./obsidian_1.12.7_amd64.deb 
# Install slack
# Need to manually donwload slack .deb file https://slack.com/downloads/linux
sudo dpkg -i ./slack-desktop-*.deb 
# oomox themeing
cd ${BIN_DIR}
git clone https://github.com/themix-project/oomox-gtk-theme.git
# i3-lock color
cd ${BIN_DIR}
git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color
./build.sh
./install-i3lock-color.sh
# install st
git clone https://github.com/DJSiddharthVader/st
cd st
sudo apt install libgtk-3-dev
sudo make clean install
# install uv for python stuff
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install pywal
```
