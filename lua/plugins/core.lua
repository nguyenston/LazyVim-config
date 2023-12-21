return {
  -- julia support
  { "kdheepak/cmp-latex-symbols" },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "kdheepak/cmp-latex-symbols" },
    opts = {
      sources = require("cmp").config.sources({
        {
          name = "latex_symbols",
          option = {
            strategy = 0, -- mixed
          },
        },
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "luasnip" },
        { name = "path" },
      }, {
        { name = "buffer" },
      }),
    },
  },

  -- Make tokyonight transparent
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  -- Some neotree remaping
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = {
          { source = "filesystem", display_name = "File" },
          { source = "buffers", display_name = "Bufs" },
          { source = "git_status", display_name = "Git" },
          { source = "diagnostics", display_name = "Diagnostic" },
        },
      },
      -- Settings applied to all sources
      window = {
        width = 30,
        mappings = {},
      },
      -- Settings when source is filesystem
      filesystem = {
        window = {
          mappings = {
            ["o"] = "open",
            ["/"] = "",
            ["F"] = "fuzzy_finder",
            ["<C-c>"] = "clear_filter",
          },
        },
      },
    },
  },

  {
    "folke/which-key.nvim",
    init = function(_)
      -- Add bindings which show up as group name
      local wk = require("which-key")
      wk.register({
        m = { name = "window" },
      }, { mode = "n", prefix = "<leader>" })
    end,
  },

  -- mason doesn't work with nixos
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {
        -- enable if not on nixos
        -- "stylua",
        -- "shfmt",
        -- "flake8",
      }
    end,
  },

  -- Treesitter extra languages
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "rust",
        "julia",
        "c",
        "cpp",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        h = { "clang-format" },
      },
    },
  },

  -- disable default lua_ls Settings
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = {
        clangd = { mason = false },
        nil_ls = { mason = false },
        rust_analyzer = { mason = false },
        lua_ls = {
          mason = false, -- set to false if you don't want this server to be installed with mason
          -- Use this to add any additional keymaps
          -- for specific lsp servers
          ---@type LazyKeysSpec[]
          -- keys = {},
          settings = {
            Lua = {
              runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
              },
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      }
    end,
  },
}
