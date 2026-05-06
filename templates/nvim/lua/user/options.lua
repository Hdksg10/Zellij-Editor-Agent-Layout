vim.g.mapleader = ","
vim.g.maplocalleader = ";"

local opt = vim.opt

local function copy_with_osc52(lines)
  local text = type(lines) == "table" and table.concat(lines, "\n") or tostring(lines)
  local sequence = "\027]52;c;" .. vim.base64.encode(text) .. "\007"

  if vim.env.TMUX then
    sequence = "\027Ptmux;\027" .. sequence:gsub("\027", "\027\027") .. "\027\\"
  end

  local tty = io.open("/dev/tty", "w")
  if tty then
    tty:write(sequence)
    tty:flush()
    tty:close()
  else
    io.stdout:write(sequence)
    io.stdout:flush()
  end
end

vim.g.clipboard = {
  name = "OSC52",
  copy = {
    ["+"] = copy_with_osc52,
    ["*"] = copy_with_osc52,
  },
  paste = {
    ["+"] = function()
      return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
    end,
    ["*"] = function()
      return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
    end,
  },
  cache_enabled = 0,
}

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.mousemodel = "popup_setpos"
opt.clipboard = "unnamedplus"
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 1500
opt.splitright = true
opt.splitbelow = true
opt.list = true
opt.listchars = { tab = "  ", trail = ".", nbsp = "+" }
opt.inccommand = "split"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.termguicolors = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.wrap = false
opt.completeopt = { "menu", "menuone", "noselect" }

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
})

vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })
