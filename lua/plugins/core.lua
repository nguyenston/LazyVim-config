return {
  {
    "L3MON4D3/LuaSnip",
    opts = {
      update_events = "TextChanged, TextChangedI",
      enable_autosnippets = true,
      store_selection_keys = "<Tab>",
    },
    keys = function()
      local ls = require("luasnip")
      return {
        {
          "jk",
          function()
            return ls.jumpable(1) and "<Plug>luasnip-jump-next" or "jk"
          end,
          expr = true,
          silent = true,
          mode = "i",
        },
        {
          "kj",
          function()
            return ls.jumpable(-1) and "<Plug>luasnip-jump-prev" or "kj"
          end,
          expr = true,
          silent = true,
          mode = "i",
        },
        {
          "<Tab>",
          function()
            ls.jump(1)
          end,
          mode = "s",
        },
        {
          "<S-Tab>",
          function()
            ls.jump(-1)
          end,
          mode = "s",
        },
        {
          "<C-l>",
          function()
            if ls.choice_active() then
              ls.change_choice(1)
            end
          end,
          mode = { "s", "i" },
        },
        {
          "<C-h>",
          function()
            if ls.choice_active() then
              ls.change_choice(-1)
            end
          end,
          mode = { "s", "i" },
        },
      }
    end,

    init = function(_)
      require("luasnip.loaders.from_lua").load({ paths = { "./snippets" } })
    end,

    config = function(_, opts)
      require("luasnip").setup(opts)
      require("luasnip.loaders.from_vscode").lazy_load({ exclude = { "latex" } })
    end,
  },

  -- julia support
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "kdheepak/cmp-latex-symbols",
      "micangl/cmp-vimtex",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mappings = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<S-CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<C-CR>"] = function(fallback)
          cmp.abort()
          fallback()
        end,
      })

      opts.sources = cmp.config.sources({
        {
          name = "latex_symbols",
          option = {
            strategy = 0, -- mixed
          },
        },
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "path" },
      }, {
        { name = "buffer" },
      })
    end,

    config = function(_, opts)
      local cmp = require("cmp")
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end
      cmp.setup(opts)
      cmp.setup.filetype("tex", {
        sources = {
          { name = "vimtex" },
          { name = "buffer" },
          { name = "path" },
        },
      })
      cmp.setup.filetype("markdown", {
        sources = cmp.config.sources({
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        }),
      })
    end,
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
        "markdownlint", -- maybe works with nixos since this is not an lsp
      }
    end,
  },

  -- Treesitter extra languages
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "toml",
        "rst",
        "ninja",
        "python",
        "lua",
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
      local enable_mason = false
      opts.servers = {
        julials = { mason = enable_mason },
        tsserver = { mason = enable_mason },
        pyright = { mason = enable_mason },
        ruff_lsp = {
          mason = enable_mason,
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports",
            },
          },
        },
        clangd = { mason = enable_mason },
        nil_ls = { mason = enable_mason },
        rust_analyzer = { mason = enable_mason },
        -- marksman = { mason = false },
        lua_ls = {
          mason = enable_mason, -- set to false if you don't want this server to be installed with mason
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

      opts.setup = {
        ruff_lsp = function()
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "ruff_lsp" then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
      }
    end,
  },
}
