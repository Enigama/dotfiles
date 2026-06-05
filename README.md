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
|(custome)i3 status|Bumblebee status, clone into i3 folder after installing i3 and stow it| `git clone git://github.com/tobi-wan-kenobi/bumblebee-status`|
| flameshot | Make screenshots | `sudo apt install flameshot` |

`nvim (btw)`
| Package | Description | Command(s) |
| --------|------------ | -----------|
|rgrep| Telescope |`sudo apt-get install ripgrep`|
| nvm | Nodejs manager| `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh \| bash && source ~/.bashrc`|
|npm| `-`|`sudo apt install npm`?|
|gh| github cli|`sudo snap install gh`|
|python|`-`|`sudo apt install python3`|
|luarock| `-` |`sudo apt install luarocks`|
|jsregexp| for luasnip |`sudo luarocks install jsregexp`|

## Installation

### Primary: Ubuntu + i3 (one line)

On a fresh laptop, this clones the repo, installs every dependency (apt + snap),
stows all configs, sets up fisher/node/yarn/tpm and the Nerd Font, and makes
kitty the default terminal:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Enigama/dotfiles/main/bootstrap.sh)
```

`bootstrap.sh` is idempotent — safe to re-run. From an existing clone just run
`./bootstrap.sh`.

> **After it finishes — two manual steps** (secrets are intentionally not in the repo):
>
> 1. Copy your secret files (`config.fish` reads these on startup):
>    `~/.config/ai/OPENAI_API_key`, `~/.config/CLAUDE_TOKEN`, `~/.config/JIRA_TOKEN`,
>    `~/.config/JIRA_URL`, `~/.config/ELECTRICITY_TOKEN`, and SSH keys
>    `~/.ssh/{work,personal}_id_rsa`.
> 2. **Only after secrets are in place**, make fish your default shell and log out/in:
>    ```bash
>    chsh -s $(which fish)
>    ```
>    The script does **not** do this for you on purpose — switching to fish before
>    the secret files exist makes `config.fish` error and clear the screen on every login.

The dependency tables above list what gets installed if you prefer to do it by hand.

### Secondary: Omarchy (Arch + Hyprland)

[Omarchy](https://omarchy.org) is DHH's opinionated Arch + Hyprland distro. Install
it from its ISO first, boot in, then layer these dotfiles (fish, nvim, tmux, kitty)
plus a Hyprland keybinding set ported from the i3 config:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Enigama/dotfiles/main/bootstrap-omarchy.sh)
```

This skips the X11-only bits (i3, feh, compton, flameshot) since Omarchy/Hyprland
already provide them. It backs up Omarchy's own nvim config to
`~/.config/nvim.omarchy.bak`, writes the ported keybindings to
`~/.config/hypr/custom-i3-binds.conf`, and never touches `~/.local/share/omarchy`.
The same "copy secrets, then `chsh`" follow-up applies.

## Git Setup

For managing multiple GitHub accounts (personal/work), see [GIT_SETUP.md](GIT_SETUP.md).

## Fonts

[FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads)

```

install FiraCode Nerd Font Propo
```
