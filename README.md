# Dotfiles

Config files that makes my work life balance better.

## Parts of Soul

- nvim (btw)
- i3
- fish
- tmux
- kitty
- wallpaper

## Requirements

First of all we have to have all required dependencies for each part of soul.

`ubuntu`
| Package | Description | Command(s) |
| --------|------------ | -----------|
|blueman| bluetooth gui manager| `sudo apt install blueman & sudo apt install bluez bluez-obexd`|
|pavucontrols| volume controle|`sudo apt install pavucontrol`|

`i3`
| Package | Description | Command(s) |
| --------|------------ | -----------|
| feh | background tool | `sudo apt install feh` |
| switch-indicator | switch bwtween autdio devices like Airpods | `sudo snap install indicator-sound-switcher` |
| compton | terminal tarnsparency | `sudo apt install compton` |
|(custome)i3 status|Bumblebee status, clone into i3 folder| `git clone git://github.com/tobi-wan-kenobi/bumblebee-status`|

`nvim (btw)`
| Package | Description | Command(s) |
| --------|------------ | -----------|
|rgrep| Telescope |`sudo apt-get install ripgrep`|
| nvm | Nodejs manager| `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh \| bash & source ~/.bashrc`|
|npm| `-`|`sudo apt install npm`?|
|gh| github cli|`sudo snap install gh`|
|python|`-`|`sudo apt install python3.12`|
|luarock| `-` |`sudo apt install luarocks`|

## Installation

1. `i3` `sudo apt install i3`

2. `kitty` terminal
   `sudo apt install kitty`

To set kitty as default terminal run this command and choose kitty.

```
sudo update-alternatives --config x-terminal-emulator
```

3. `fish` shell
   `sudo apt-get install fish`

Make fish default shell:

```
sudo chsh -s /usr/local/bin/fish
```

Plugin manager for `fish` -> `fisher` repo `https://github.com/jorgebucaran/fisher`

```
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && fisher install jorgebucaran/nvm.fish
```

4. `nvim` btw `sudo apt-get install neovim`
5. `yarn` optional but necessary for fish shortcuts `npm install --global yarn`
