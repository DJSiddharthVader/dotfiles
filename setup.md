# Install from scratch

```bash
export BIN_DIR="${HOME}/bin"
mkdir -p "${BIN_DIR}"
# cloen dotfiles
git clone https://github.com/DJSiddharthVader/st
ln -sf ${HOME}/dotfiles/.{ascii,bash,bashrc,cheatsheets,config,css,fonts,scripts,tmux,tmux.conf,vim,vimrc} ${HOME}/
# install apps + lib dependencies
sudo apt install acpi autoconf awk bc bc brightnessctl bzip2 cargo cmake curl feh fonts-font-awesome fzf g++ gcc git gtk2-engines-murrine harfbizz htop i3 lazygit libcairo2-dev libev-dev libfontconfig1-dev libfreetype6-dev libgdk-pixbuf2.0-dev libgif-dev libglib2.0-dev libgtk-3-dev libjpeg-dev libpam0g-dev libreoffice librsvg2-bin libssl-dev libwebkit2gtk-4.0 libx11-xcb-dev libxcb-composite0-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util-dev libxcb-xinerama0-dev libxcb-xkb-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libxml2-dev libxml2-utils light lm-sensors make mpd mullvad mullvad-vpn ncmpcpp neofetch neovim npm numfmt obsidian patch pkg-config polybar pulseaudio python3-i3ipc pywal qpdfview ranger rofi rustup sassc screen scrot slack sshfs syncthing tmux tmuxinator tr tr unclutter uv xbacklight xclip xidlehook zathura
sudo npm install -g tree-sitter-cli
# Install R
sudo apt install --no-install-recommends r-base
sudo apt install --no-install-recommends software-properties-common dirmngr
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
