#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}
zellij_dir=$config_home/zellij
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

install_file "$script_dir/templates/zellij/config.kdl" "$zellij_dir/config.kdl"
install_file "$script_dir/templates/zellij/layouts/dev.kdl" "$zellij_dir/layouts/dev.kdl"
install_file "$script_dir/templates/zellij/layouts/dev-codex.kdl" "$zellij_dir/layouts/dev-codex.kdl"

if command -v zellij >/dev/null 2>&1; then
  zellij setup --check
else
  echo "zellij was not found on PATH; skipped validation."
fi

cat <<'EOF'

Installed internal Zellij editor/agent layout.

Start OpenCode default:
  zellij --layout dev

Start Codex default:
  zellij --layout dev-codex
EOF
