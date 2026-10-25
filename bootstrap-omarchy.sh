#!/usr/bin/env bash
#
# bootstrap-omarchy.sh — install these dotfiles on top of Omarchy
# (DHH's Arch + Hyprland distro). Run AFTER you've installed Omarchy from its ISO
# and booted into it.
#
#   bash <(curl -fsSL https://raw.githubusercontent.com/Enigama/dotfiles/main/bootstrap-omarchy.sh)
#
# This layers the cross-platform configs (fish, nvim, tmux, kitty) on top of
# Omarchy and ports the i3 keybindings into a Hyprland override. It does NOT
# touch Omarchy's own files under ~/.local/share/omarchy.
#
# Like bootstrap.sh, this does NOT chsh to fish or launch interactive fish —
# copy your secrets first (see the printed instructions at the end).

set -euo pipefail

REPO_URL="https://github.com/Enigama/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
NODE_VERSION="v24.13.0"

# i3 and wallpaper are X11-specific; Hyprland/Omarchy handle those.
STOW_PACKAGES=(nvim fish tmux kitty)

log()  { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# ---------------------------------------------------------------------------
# 1. Clone if needed.
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
# 2. pacman packages (nvim, git, fonts already ship with Omarchy).
# ---------------------------------------------------------------------------
install_pacman() {
  log "Installing packages via pacman"
  local pkgs=(fish tmux kitty stow ripgrep luarocks python lsof ranger unzip)
  sudo pacman -S --needed --noconfirm "${pkgs[@]}"
}

# ---------------------------------------------------------------------------
# 3. Stow cross-platform packages. Back up Omarchy's own nvim config first.
# ---------------------------------------------------------------------------
stow_packages() {
  # Omarchy ships its own nvim config; move it aside so our stow doesn't conflict.
  if [ -e "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
    log "Backing up Omarchy's nvim config to ~/.config/nvim.omarchy.bak"
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.omarchy.bak"
  fi

  log "Stowing dotfiles into $HOME"
  cd "$DOTFILES_DIR"
  local pkg
  for pkg in "${STOW_PACKAGES[@]}"; do
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
# 4. fisher + plugins, node + yarn, tpm, luarocks dep (same as Ubuntu path).
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

install_node() {
  log "Installing Node $NODE_VERSION via nvm.fish + yarn"
  fish -c "nvm install $NODE_VERSION; nvm use $NODE_VERSION"
  fish -c "nvm use $NODE_VERSION; npm install -g yarn" || warn "yarn install failed (non-fatal)"
}

install_tpm() {
  local tpm_dir="$HOME/.tmux/plugins/tpm"
  [ -d "$tpm_dir" ] || git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  "$tpm_dir/bin/install_plugins" || warn "tpm install_plugins failed (run prefix+I inside tmux later)"
}

install_luarocks_deps() {
  if luarocks list 2>/dev/null | grep -q jsregexp; then
    log "luarocks jsregexp already installed"
  else
    sudo luarocks install jsregexp || warn "jsregexp install failed (non-fatal)"
  fi
}

# ---------------------------------------------------------------------------
# 5. Port i3 keybindings -> Hyprland override.
#    Written to ~/.config/hypr/custom-i3-binds.conf and sourced from
#    ~/.config/hypr/hyprland.conf (appended once, non-destructive).
#    Mappings are translated from i3/.config/i3/config; X11-only autostarts
#    (compton/feh/xss-lock) are dropped because Omarchy already provides them.
# ---------------------------------------------------------------------------
port_keybindings() {
  local hypr_dir="$HOME/.config/hypr"
  local override="$hypr_dir/custom-i3-binds.conf"
  local main="$hypr_dir/hyprland.conf"
  mkdir -p "$hypr_dir"

  log "Writing Hyprland override (ported i3 keybindings) -> $override"
  cat > "$override" <<'EOF'
# ---------------------------------------------------------------------------
# Ported from i3 config (Mod4 / Super). Sourced by hyprland.conf.
# Edit freely; Omarchy's own defaults live in ~/.local/share/omarchy.
# ---------------------------------------------------------------------------
$mainMod = SUPER

# Keyboard layout: us,ua toggle with Alt+Shift (was setxkbmap in i3)
input {
    kb_layout = us,ua
    kb_options = grp:alt_shift_toggle
}

# --- core window management -------------------------------------------------
bind = $mainMod, Return, exec, kitty                 # terminal
bind = $mainMod SHIFT, Q, killactive                 # close focused window
bind = $mainMod, D, exec, walker                     # launcher (was dmenu_run)
bind = $mainMod, F, fullscreen, 0                    # fullscreen toggle
bind = $mainMod SHIFT, Space, togglefloating         # floating toggle
bind = $mainMod, U, togglesplit                      # was split h
bind = $mainMod, I, togglesplit                      # was split v
bind = $mainMod, W, togglegroup                      # tabbed-like (was layout tabbed)

# --- focus (arrows + hjkl) --------------------------------------------------
bind = $mainMod, Left,  movefocus, l
bind = $mainMod, Down,  movefocus, d
bind = $mainMod, Up,    movefocus, u
bind = $mainMod, Right, movefocus, r
bind = $mainMod, h, movefocus, l
bind = $mainMod, j, movefocus, d
bind = $mainMod, k, movefocus, u
bind = $mainMod, l, movefocus, r

# --- move window (Shift + arrows / hjkl) ------------------------------------
bind = $mainMod SHIFT, Left,  movewindow, l
bind = $mainMod SHIFT, Down,  movewindow, d
bind = $mainMod SHIFT, Up,    movewindow, u
bind = $mainMod SHIFT, Right, movewindow, r
bind = $mainMod SHIFT, h, movewindow, l
bind = $mainMod SHIFT, j, movewindow, d
bind = $mainMod SHIFT, k, movewindow, u
bind = $mainMod SHIFT, l, movewindow, r

# --- resize -----------------------------------------------------------------
bind = $mainMod, equal, resizeactive,  10 0
bind = $mainMod, minus, resizeactive, -10 0
# Hold-to-resize submap (was i3 "resize" mode on $mod+r)
bind = $mainMod, R, submap, resize
submap = resize
binde = , j, resizeactive, -10 0
binde = , semicolon, resizeactive, 10 0
binde = , k, resizeactive, 0 10
binde = , l, resizeactive, 0 -10
binde = , Left,  resizeactive, -10 0
binde = , Right, resizeactive, 10 0
binde = , Up,    resizeactive, 0 -10
binde = , Down,  resizeactive, 0 10
bind = , Return, submap, reset
bind = , Escape, submap, reset
submap = reset

# --- workspaces -------------------------------------------------------------
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# --- session ----------------------------------------------------------------
bind = $mainMod SHIFT, C, exec, hyprctl reload       # was i3 reload
bind = $mainMod SHIFT, E, exit                        # exit Hyprland

# --- launch apps (from i3 $mod+c/p/n/m) -------------------------------------
bind = $mainMod, c, exec, chromium                    # browser (or google-chrome-stable)
bind = $mainMod, p, exec, hyprshot -m region          # screenshot (was flameshot)
bind = $mainMod, n, exec, nautilus
bind = $mainMod, m, exec, slack

# --- volume (Omarchy may already bind these; harmless duplicates) -----------
bindl = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bindl = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindl = , XF86AudioMute,        exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bindl = , XF86AudioMicMute,     exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
EOF

  # Source the override from the main Hyprland config (once).
  if [ -f "$main" ] && grep -q 'custom-i3-binds.conf' "$main"; then
    log "hyprland.conf already sources the override"
  else
    log "Appending source line to $main"
    printf '\n# Custom i3-ported keybindings (from dotfiles)\nsource = %s\n' "$override" >> "$main"
  fi

  warn "Monitor->workspace pinning (i3 eDP-1 / eDP-1DP-1-2) was NOT ported;"
  warn "set it in ~/.config/hypr/monitors.conf if you use external displays."
}

# ---------------------------------------------------------------------------
# 6 + 7. Final notes (printed, not executed).
# ---------------------------------------------------------------------------
print_next_steps() {
  cat <<'EOF'

============================================================================
  Omarchy layer installed. Manual steps left (secrets are not in the repo):
============================================================================

1. Copy your secret files (config.fish reads these on startup):
     ~/.config/ai/OPENAI_API_key   ~/.config/CLAUDE_TOKEN
     ~/.config/JIRA_TOKEN          ~/.config/JIRA_URL
     ~/.config/ELECTRICITY_TOKEN
   And your SSH keys: ~/.ssh/{work,personal}_id_rsa(.pub)  (see GIT_SETUP.md)

2. ONLY AFTER secrets are in place, make fish your default shell:
     chsh -s "$(which fish)"
   Then log out / back in.

3. Reload Hyprland to pick up the ported keybindings:
     hyprctl reload

Notes:
  * Your nvim config replaced Omarchy's (backup at ~/.config/nvim.omarchy.bak).
  * Do NOT edit ~/.local/share/omarchy — those are Omarchy's files. `omarchy
    update` won't touch your stow symlinks (~/.config/{nvim,fish,kitty}).
  * Ported keybindings live in ~/.config/hypr/custom-i3-binds.conf.
============================================================================
EOF
}

main() {
  clone_repo
  install_pacman
  stow_packages
  install_luarocks_deps
  install_fish_plugins
  install_node
  install_tpm
  port_keybindings
  print_next_steps
  log "Omarchy bootstrap complete."
}

main "$@"
