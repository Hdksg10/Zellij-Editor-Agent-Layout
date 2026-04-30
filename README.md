# Internal Zellij Editor/Agent Layout

This package installs a Zellij layout for a terminal-native editor and agent workflow.

## What It Installs

- `~/.config/zellij/config.kdl`
- `~/.config/zellij/layouts/dev.kdl`
- `~/.config/zellij/layouts/dev-codex.kdl`

Existing files are backed up with a timestamp suffix before replacement.

## Requirements

Required:

- `zellij`
- `zsh`
- `nvim`

Recommended:

- `opencode`
- `codex`
- `lazygit`
- A Nerd Font in the terminal

The layouts use `command -v` and expect tools to be available on `PATH`.

## Install

From this directory:

```sh
./install.sh
```

If needed:

```sh
chmod +x install.sh
./install.sh
```

The installer runs:

```sh
zellij setup --check
```

when `zellij` is available.

## Start

OpenCode default:

```sh
zellij --layout dev
```

Codex default:

```sh
zellij --layout dev-codex
```

## Layout

Default tab:

- Left tiled pane: Neovim
- Right tiled pane: agent
- Floating panel: LazyGit
- Floating panel: shell
- Top tab bar and bottom status bar

Agent behavior:

- `dev.kdl` prefers `opencode`, then falls back to `codex`
- `dev-codex.kdl` prefers `codex`, then falls back to `opencode`

## Keys

- `Alt-h`, `Alt-j`, `Alt-k`, `Alt-l`: move focus between panes
- `Alt-o`: focus next pane
- `Alt-i`: focus previous pane
- `Alt-f`: toggle fullscreen for the focused pane
- `Alt-a`: hide or show other tiled panes around the focused pane
- `Alt-y`: cycle tiled layout shape
- `Alt-e`: move focused pane between tiled and floating mode
- `Alt-t`: show or hide all floating panels
- `Alt-n`: next tab
- `Alt-p`: previous tab

Move mode:

- `Alt-m`: enter move mode
- arrows or `h/j/k/l`: move the focused pane
- `Enter` or `Esc`: exit mode

Resize mode:

- `Alt-r`: enter resize mode
- `+` or `=`: grow focused pane
- `-` or `_`: shrink focused pane
- arrows or `h/j/k/l`: move focus between panes
- `Enter` or `Esc`: exit mode

## Tiled Layout Presets

Use `Alt-y` to cycle:

- `editor-agent`: editor plus narrow right sidebar, `72% / 28%`
- `editor-sidebar`: editor plus wider right sidebar, `68% / 32%`
- `balanced`: two equal columns
- `editor-two-right`: large editor column and two stacked right panes
- `editor-bottom-right`: editor/sidebar above and one bottom pane

## Notes

- `Alt-Space` is intentionally not used because it conflicts with Windows.
- Pane frames are disabled for a cleaner editor-like UI.
- If a shell prompt looks stale after resizing, press `Ctrl-l` in that shell to redraw.
