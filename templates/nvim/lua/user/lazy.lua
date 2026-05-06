local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "Mofiqul/vscode.nvim", priority = 1000, config = function()
    vim.o.background = "dark"
    require("vscode").setup({
      italic_comments = true,
      terminal_colors = true,
    })
    vim.cmd.colorscheme("vscode")
  end },

  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {
    options = {
      icons_enabled = true,
      theme = "vscode",
      globalstatus = true,
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },
    sections = {
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { { "filename", path = 1 } },
    },
  } },

  { "folke/which-key.nvim", event = "VeryLazy", opts = {
    icons = {
      mappings = true,
      rules = true,
    },
  } },
  { "lewis6991/gitsigns.nvim", opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
  } },
  { "akinsho/bufferline.nvim", version = "*", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {
    options = {
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      separator_style = "thin",
    },
  } },

  { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x", dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  }, opts = {
    default_component_configs = {
      indent = {
        indent_marker = "│",
        last_indent_marker = "└",
        expander_collapsed = "",
        expander_expanded = "",
      },
    },
    filesystem = {
      follow_current_file = { enabled = true },
      filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = false },
    },
  } },

  { "nvim-telescope/telescope.nvim", tag = "0.1.8", dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  }, config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        prompt_prefix = "  ",
        selection_caret = " ",
        entry_prefix = "  ",
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
    })
    pcall(telescope.load_extension, "fzf")
  end },

  { "nvim-treesitter/nvim-treesitter", tag = "v0.10.0", build = ":TSUpdate", opts = {
    ensure_installed = { "bash", "c", "cpp", "lua", "markdown", "markdown_inline", "python", "rust", "vim", "vimdoc", "yaml" },
    highlight = { enable = true },
    indent = { enable = true },
  }, config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end },

  { "williamboman/mason.nvim", tag = "v1.11.0", opts = {} },
  { "williamboman/mason-lspconfig.nvim", tag = "v1.32.0", dependencies = { "williamboman/mason.nvim" }, opts = {
    ensure_installed = { "bashls", "lua_ls", "pyright", "rust_analyzer", "yamlls" },
  } },

  { "neovim/nvim-lspconfig", tag = "v1.8.0", dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  }, config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lspconfig = require("lspconfig")

    local on_attach = function(_, bufnr)
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
      end
      map("gd", vim.lsp.buf.definition, "Go to definition")
      map("gr", vim.lsp.buf.references, "References")
      map("gI", vim.lsp.buf.implementation, "Go to implementation")
      map("<leader>D", vim.lsp.buf.type_definition, "Type definition")
      map("<leader>rn", vim.lsp.buf.rename, "Rename")
      map("<leader>ca", vim.lsp.buf.code_action, "Code action")
      map("K", vim.lsp.buf.hover, "Hover")
      map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document symbols")
      map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace symbols")
    end

    local servers = {
      bashls = {},
      pyright = {},
      rust_analyzer = {},
      yamlls = {},
      clangd = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim" } },
          },
        },
      },
    }

    for name, config in pairs(servers) do
      config.capabilities = capabilities
      config.on_attach = on_attach
      lspconfig[name].setup(config)
    end
  end },

  { "hrsh7th/nvim-cmp", dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  }, config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    cmp.setup({
      snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
      formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(_, item)
          item.kind = item.kind or ""
          item.menu = item.menu or ""
          return item
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
          else fallback() end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then luasnip.jump(-1)
          else fallback() end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
      }, {
        { name = "buffer" },
      }),
    })
  end },

  { "numToStr/Comment.nvim", opts = {} },
  { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {
    signs = true,
    keywords = {
      FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
  } },
  { "sindrets/diffview.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {
    enhanced_diff_hl = true,
  } },
  { "NeogitOrg/neogit", dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  }, opts = {
    integrations = {
      diffview = true,
      telescope = true,
    },
  } },
  { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {
    signs = {
      error = "",
      warning = "",
      hint = "󰌵",
      information = "",
      other = "",
    },
  } },
  { "stevearc/conform.nvim", opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
    },
  } },
  { "mfussenegger/nvim-lint", config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      zsh = { "zsh" },
      markdown = { "markdownlint" },
    }
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end },
  { "folke/flash.nvim", opts = {
    prompt = {
      prefix = { { "󰉁", "FlashPromptIcon" } },
    },
    modes = {
      char = { enabled = false },
    },
  } },
  { "ThePrimeagen/harpoon", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
  { "nvim-pack/nvim-spectre", dependencies = { "nvim-lua/plenary.nvim" }, opts = {
    color_devicons = true,
    replace_engine = {
      sed = { cmd = "sed" },
    },
  } },
}, {
  ui = {
    border = "rounded",
  },
  checker = { enabled = true, notify = false },
})
