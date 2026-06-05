#!/usr/bin/env bash
#
# bootstrap.sh — one-shot installer for these dotfiles on Ubuntu + i3.
#
#   New laptop, one line:
#     bash <(curl -fsSL https://raw.githubusercontent.com/Enigama/dotfiles/main/bootstrap.sh)
#
#   Or from inside an existing clone:
#     ./bootstrap.sh
#
# Idempotent: safe to re-run. Every stage guards against already-done work.
#
# IMPORTANT: this script deliberately does NOT switch your default shell to fish
# and does NOT launch an interactive fish session. config.fish reads secret files
# (~/.config/CLAUDE_TOKEN, ssh keys, ...) that are not in this repo, so it would
# error on a fresh machine. Copy your secrets first, THEN run `chsh` (see the
# instructions printed at the end).

set -euo pipefail

REPO_URL="https://github.com/Enigama/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
NODE_VERSION="v24.13.0"
FONT_NAME="FiraCode"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"

# Stow packages to link (all directories use $HOME-relative .config nesting).
STOW_PACKAGES=(nvim fish i3 kitty tmux wallpaper)

log()  { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# ---------------------------------------------------------------------------
# 1. Clone the repo if we're not already running from inside it.
# ---------------------------------------------------------------------------
clone_repo() {
  if [ -d "$DOTFILES_DIR/.git" ]; then
    log "Dotfiles already cloned at $DOTFILES_DIR"
  else
    log "Cloning dotfiles into $DOTFILES_DIR"
    git clone "$REPO_URL" "$DOTFILES_DIR"
  fi
  cd "$DOTFILES_DIR"
}

# ---------------------------------------------------------------------------
# 2. APT packages.
# ---------------------------------------------------------------------------
install_apt() {
  log "Installing APT packages"
  local pkgs=(
    git curl stow build-essential
    i3 i3lock xss-lock suckless-tools network-manager-gnome
    kitty tmux fish
    feh compton flameshot pavucontrol nautilus ranger
    blueman bluez bluez-obexd
    ripgrep luarocks python3 python3-pip lsof unzip fontconfig
  )
  sudo apt update
  sudo apt install -y "${pkgs[@]}"
}

# ---------------------------------------------------------------------------
# 3. Snap packages (neovim, gh, indicator-sound-switcher).
# ---------------------------------------------------------------------------
snap_install() {
  local name="$1"; shift
  if snap list "$name" >/dev/null 2>&1; then
    log "snap '$name' already installed"
  else
    log "Installing snap '$name'"
    sudo snap install "$name" "$@"
  fi
}

install_snaps() {
  if ! have snap; then
    warn "snapd not found; installing it"
    sudo apt install -y snapd
  fi
  snap_install nvim --classic
  snap_install gh
  snap_install indicator-sound-switcher
}

# ---------------------------------------------------------------------------
# 4. Stow the dotfiles into $HOME. Back up any conflicting real files first.
# ---------------------------------------------------------------------------
stow_packages() {
  log "Stowing dotfiles into $HOME"
  cd "$DOTFILES_DIR"
  local pkg
  for pkg in "${STOW_PACKAGES[@]}"; do
    # If stow would conflict with an existing real (non-symlink) file, move it aside.
    if ! stow -t "$HOME" -n "$pkg" >/dev/null 2>&1; then
      warn "Conflicts detected for '$pkg'; backing up offending targets"
      while IFS= read -r target; do
        [ -e "$HOME/$target" ] && [ ! -L "$HOME/$target" ] || continue
        mv -v "$HOME/$target" "$HOME/$target.pre-stow.bak"
      done < <(stow -t "$HOME" -n "$pkg" 2>&1 \
                 | grep -oP '(?<=existing target is neither a link nor a directory: ).*' || true)
    fi
    stow -v -R -t "$HOME" "$pkg"
  done
}

# ---------------------------------------------------------------------------
# 5. luarocks dependency for luasnip.
# ---------------------------------------------------------------------------
install_luarocks_deps() {
  if luarocks list 2>/dev/null | grep -q jsregexp; then
    log "luarocks jsregexp already installed"
  else
    log "Installing luarocks jsregexp (luasnip dependency)"
    sudo luarocks install jsregexp || warn "jsregexp install failed (non-fatal)"
  fi
}

# ---------------------------------------------------------------------------
# 6. fisher + fish plugins (installs everything listed in fish_plugins).
#    Run via `fish -c` (non-interactive) so config.fish secret reads don't fire.
# ---------------------------------------------------------------------------
install_fish_plugins() {
  log "Installing fisher and fish plugins"
  fish -c '
    if not functions -q fisher
      curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
      fisher install jorgebucaran/fisher
    end
    fisher update
  '
}

# ---------------------------------------------------------------------------
# 7. Node (via fish nvm.fish plugin) + yarn.
# ---------------------------------------------------------------------------
install_node() {
  log "Installing Node $NODE_VERSION via nvm.fish + yarn"
  fish -c "nvm install $NODE_VERSION; nvm use $NODE_VERSION"
  fish -c 'nvm use '"$NODE_VERSION"'; npm install -g yarn' || warn "yarn install failed (non-fatal)"
}

# ---------------------------------------------------------------------------
# 8. tmux plugin manager (tpm) + plugins.
# ---------------------------------------------------------------------------
install_tpm() {
  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [ -d "$tpm_dir" ]; then
    log "tpm already present"
  else
    log "Cloning tpm"
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  fi
  log "Installing tmux plugins"
  "$tpm_dir/bin/install_plugins" || warn "tpm install_plugins failed (run prefix+I inside tmux later)"
}

# ---------------------------------------------------------------------------
# 9. FiraCode Nerd Font.
# ---------------------------------------------------------------------------
install_font() {
  local font_dir="$HOME/.local/share/fonts"
  if fc-list 2>/dev/null | grep -qi "$FONT_NAME"; then
    log "$FONT_NAME Nerd Font already installed"
    return
  fi
  log "Installing $FONT_NAME Nerd Font"
  mkdir -p "$font_dir"
  local tmp; tmp="$(mktemp -d)"
  curl -fsSL "$FONT_URL" -o "$tmp/font.zip"
  unzip -o "$tmp/font.zip" -d "$font_dir" >/dev/null
  rm -rf "$tmp"
  fc-cache -f >/dev/null
}

# ---------------------------------------------------------------------------
# 10. Make kitty the default x-terminal-emulator (non-interactive).
# ---------------------------------------------------------------------------
set_default_terminal() {
  if ! have kitty; then warn "kitty not found; skipping default-terminal setup"; return; fi
  log "Setting kitty as default x-terminal-emulator"
  sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$(command -v kitty)" 60
  sudo update-alternatives --set x-terminal-emulator "$(command -v kitty)"
}

# ---------------------------------------------------------------------------
# 11. Pre-install nvim plugins headlessly so first launch is ready.
# ---------------------------------------------------------------------------
sync_nvim() {
  log "Syncing nvim plugins (headless)"
  nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1 || warn "nvim Lazy sync failed (will sync on first launch)"
}

# ---------------------------------------------------------------------------
# 12. Final manual steps (printed, not executed).
# ---------------------------------------------------------------------------
print_next_steps() {
  cat <<'EOF'

============================================================================
  Almost done. A few things only YOU can do (secrets are not in the repo):
============================================================================

1. Copy your secret files into place (config.fish reads these on startup):
     ~/.config/ai/OPENAI_API_key
     ~/.config/CLAUDE_TOKEN
     ~/.config/JIRA_TOKEN
     ~/.config/JIRA_URL
     ~/.config/ELECTRICITY_TOKEN

2. Copy your SSH keys (config.fish ssh-add's these on startup):
     ~/.ssh/work_id_rsa  ~/.ssh/work_id_rsa.pub
     ~/.ssh/personal_id_rsa  ~/.ssh/personal_id_rsa.pub
   See GIT_SETUP.md for the ~/.gitconfig multi-account setup.

3. ONLY AFTER the secrets above are in place, make fish your default shell:
     chsh -s "$(which fish)"
   Then log out and back in. (Doing this before copying secrets means fish
   prints errors and clears the screen on every login.)

Stowed packages are symlinks into ~/dotfiles — edit configs there.
============================================================================
EOF
}

main() {
  clone_repo
  install_apt
  install_snaps
  stow_packages
  install_luarocks_deps
  install_fish_plugins
  install_node
  install_tpm
  install_font
  set_default_terminal
  sync_nvim
  print_next_steps
  log "Bootstrap complete."
}

main "$@"
