# Install from scratch

```bash
export BIN_DIR="${HOME}/bin"
mkdir -p "${BIN_DIR}"
# main 
sudo apt-get install polybar i3 mpd libreoffice
# oomox themeing
sudo apt install libgdk-pixbuf2.0-dev libxml2-utils gtk2-engines-murrine librsvg2-bin
cd ${BIN_DIR}
git clone https://github.com/themix-project/oomox-gtk-theme.git
# i3-lock color
sudo apt install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev libgif-dev
cd ${BIN_DIR}
git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color
./build.sh
./install-i3lock-color.sh
# install st
# install fonts
```
