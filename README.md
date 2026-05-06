# Internal Terminal IDE Distribution

This package installs a Zellij layout and a Neovim configuration for a terminal-native editor and agent workflow.

## What It Installs

- `~/.config/zellij/config.kdl`
- `~/.config/zellij/layouts/dev.kdl`
- `~/.config/zellij/layouts/dev-codex.kdl`
- `~/.config/nvim/init.lua`
- `~/.config/nvim/lazy-lock.json`
- `~/.config/nvim/lua/user/*.lua`

Existing files are backed up with a timestamp suffix before replacement.

## Requirements

Required:

- `zellij`
- `zsh`
- `nvim`
- `git`

Recommended:

- `opencode`
- `codex`
- `claude`
- `amp`
- `lazygit`
- `make`
- `rg`
- `fd`
- `stylua`
- `shfmt`
- `shellcheck`
- `prettier`
- A Nerd Font in the terminal

The layouts and Neovim plugins use `command -v` and expect tools to be available on `PATH`.

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
nvim --version
```

when those tools are available.

## Start

OpenCode default:

```sh
zellij --layout dev
```

Codex default:

```sh
zellij --layout dev-codex
```

Neovim only:

```sh
nvim
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

## Change the Default Agent

The agent pane is just a Zellij pane that runs an interactive CLI command. Any terminal agent can be used as long as its command is available on `PATH`.

Edit the template before installing:

```sh
nvim templates/zellij/layouts/dev.kdl
nvim templates/zellij/layouts/dev-codex.kdl
```

If the layout is already installed, edit the installed files instead:

```sh
nvim ~/.config/zellij/layouts/dev.kdl
nvim ~/.config/zellij/layouts/dev-codex.kdl
```

In each file, find the agent pane:

```kdl
pane size="28%" name="agent" command="zsh" {
    args "-lc" "if command -v opencode >/dev/null 2>&1; then exec opencode; elif command -v codex >/dev/null 2>&1; then exec codex; else echo 'Neither opencode nor codex was found on PATH.'; echo 'Install one of them, then restart this layout.'; exec zsh; fi"
}
```

To make Claude Code the default, put `claude` first:

```kdl
pane size="28%" name="agent" command="zsh" {
    args "-lc" "if command -v claude >/dev/null 2>&1; then exec claude; elif command -v opencode >/dev/null 2>&1; then exec opencode; elif command -v codex >/dev/null 2>&1; then exec codex; else echo 'No supported code agent was found on PATH.'; echo 'Install claude, opencode, or codex, then restart this layout.'; exec zsh; fi"
}
```

To make Amp the default, put `amp` first:

```kdl
pane size="28%" name="agent" command="zsh" {
    args "-lc" "if command -v amp >/dev/null 2>&1; then exec amp; elif command -v codex >/dev/null 2>&1; then exec codex; elif command -v opencode >/dev/null 2>&1; then exec opencode; else echo 'No supported code agent was found on PATH.'; echo 'Install amp, codex, or opencode, then restart this layout.'; exec zsh; fi"
}
```

To use another agent, replace the first `command -v` check and `exec` target with that agent's command:

```kdl
pane size="28%" name="agent" command="zsh" {
    args "-lc" "if command -v my-agent >/dev/null 2>&1; then exec my-agent; else echo 'my-agent was not found on PATH.'; exec zsh; fi"
}
```

Use `exec agent-command --flag value` if your agent needs startup flags. After editing templates, run `./install.sh` again. After editing installed files directly, restart the Zellij layout.

## Neovim

The Neovim config is installed from `templates/nvim`.

Highlights:

- Lazy.nvim plugin manager with `lazy-lock.json` pinned revisions
- VS Code-style dark theme, lualine, bufferline, Neo-tree, Telescope, Treesitter
- Mason-backed LSP setup for Bash, Lua, Python, Rust, YAML, and clangd
- Completion, snippets, diagnostics, formatting, linting, Git signs, Neogit, Diffview, Trouble, Flash, Harpoon, and Spectre
- OSC52 clipboard support for terminal and remote workflows

First launch may download plugins and language tooling.

Core Neovim keys:

- Leader: `,`
- Local leader: `;`
- `F3`: find files
- `F4`: find buffers
- `F5`: toggle file tree
- `F6`: diagnostics list
- `F9`: Neogit
- `F10`: git diff view
- `F12`: go to definition
- `Shift-F5`: copy full file path
- `Shift-F6`: copy full file path and line
- `,ff`, `,fg`, `,fb`, `,fh`, `,fr`: Telescope pickers
- `,gg`, `,gd`, `,gD`: Git UI and diff views

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
