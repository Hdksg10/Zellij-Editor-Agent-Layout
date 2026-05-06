local M = {}

local function copy_to_clipboard(value, label)
  vim.fn.setreg("+", value)
  vim.notify("Copied " .. label .. ": " .. value)
end

function M.copy_file_name()
  copy_to_clipboard(vim.fn.expand("%:t"), "file name")
end

function M.copy_file_path()
  copy_to_clipboard(vim.fn.expand("%:p"), "file path")
end

function M.copy_relative_path_line()
  copy_to_clipboard(vim.fn.expand("%:.") .. ":" .. vim.fn.line("."), "relative path and line")
end

function M.copy_file_path_line()
  copy_to_clipboard(vim.fn.expand("%:p") .. ":" .. vim.fn.line("."), "file path and line")
end

function M.setup()
  vim.cmd("silent! aunmenu PopUp")

  vim.cmd([[
    nnoremenu PopUp.Copy\ File\ Name <Cmd>lua require("user.menu").copy_file_name()<CR>
    nnoremenu PopUp.Copy\ Full\ Path <Cmd>lua require("user.menu").copy_file_path()<CR>
    nnoremenu PopUp.Copy\ Relative\ Path:Line <Cmd>lua require("user.menu").copy_relative_path_line()<CR>
    nnoremenu PopUp.Copy\ Full\ Path:Line <Cmd>lua require("user.menu").copy_file_path_line()<CR>
    nnoremenu PopUp.-copy- <Nop>
    nnoremenu PopUp.Go\ To\ Definition <Cmd>lua vim.lsp.buf.definition()<CR>
    nnoremenu PopUp.References <Cmd>lua vim.lsp.buf.references()<CR>
    nnoremenu PopUp.Rename <Cmd>lua vim.lsp.buf.rename()<CR>
    nnoremenu PopUp.Code\ Action <Cmd>lua vim.lsp.buf.code_action()<CR>
    nnoremenu PopUp.Diagnostics <Cmd>Trouble diagnostics toggle filter.buf=0<CR>
    nnoremenu PopUp.-lsp- <Nop>
    nnoremenu PopUp.Git\ Preview\ Hunk <Cmd>Gitsigns preview_hunk<CR>
    nnoremenu PopUp.Git\ Stage\ Hunk <Cmd>Gitsigns stage_hunk<CR>
    nnoremenu PopUp.Git\ Reset\ Hunk <Cmd>Gitsigns reset_hunk<CR>
    nnoremenu PopUp.Git\ Blame\ Line <Cmd>Gitsigns blame_line<CR>
    nnoremenu PopUp.Git\ Diff\ View <Cmd>DiffviewOpen<CR>
    nnoremenu PopUp.Neogit <Cmd>Neogit<CR>

    vnoremenu PopUp.Copy\ Selection "+y
    vnoremenu PopUp.Format\ Selection <Esc><Cmd>lua require("conform").format({ async = true, lsp_fallback = true })<CR>
  ]])
end

M.setup()

return M
