#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
zellij_dir=$config_home/zellij
nvim_dir=$config_home/nvim
backup_suffix=".$(date +%Y%m%d-%H%M%S).bak"

install_file() {
  src=$1
  dst=$2

  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ]; then
    cp "$dst" "$dst$backup_suffix"
    echo "Backed up $dst to $dst$backup_suffix"
  fi

  cp "$src" "$dst"
  echo "Installed $dst"
}

install_tree() {
  src_dir=$1
  dst_dir=$2

  find "$src_dir" -type f | while IFS= read -r src; do
    rel=${src#$src_dir/}
    install_file "$src" "$dst_dir/$rel"
  done
}

install_file "$script_dir/templates/zellij/config.kdl" "$zellij_dir/config.kdl"
install_file "$script_dir/templates/zellij/layouts/dev.kdl" "$zellij_dir/layouts/dev.kdl"
install_file "$script_dir/templates/zellij/layouts/dev-codex.kdl" "$zellij_dir/layouts/dev-codex.kdl"
install_tree "$script_dir/templates/nvim" "$nvim_dir"

if command -v zellij >/dev/null 2>&1; then
  zellij setup --check
else
  echo "zellij was not found on PATH; skipped validation."
fi

if command -v nvim >/dev/null 2>&1; then
  nvim --version >/dev/null
else
  echo "nvim was not found on PATH; skipped validation."
fi

cat <<'EOF'

Installed internal terminal-native editor/agent setup.

Start OpenCode default:
  zellij --layout dev

Start Codex default:
  zellij --layout dev-codex

Start Neovim only:
  nvim
EOF
