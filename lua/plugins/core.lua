return {
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
      },
    },
  },

  -- disable default lua_ls Settings
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = {}
    end,
  },

  -- set up lspconfig without mason
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    init = function(_)
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_lspconfig()
      lsp_zero.on_attach(function(_, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({ buffer = bufnr })
      end)

      require("lspconfig").lua_ls.setup({
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
            client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
              Lua = {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = "LuaJIT",
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                  },
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                  -- library = vim.api.nvim_get_runtime_file("", true)
                },
              },
            })
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end
          return true
        end,
      })
      require("lspconfig").rust_analyzer.setup({})
    end,
  },
}
