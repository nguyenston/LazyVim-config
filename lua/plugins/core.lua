return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "nvim-cmp",
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      update_events = "TextChanged, TextChangedI",
      enable_autosnippets = true,
      store_selection_keys = "<Tab>",
    },
    keys = function()
      local ls = require("luasnip")
      return {
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
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      }

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

    -- somehow luasnip jump keymaps only work when put here
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      {
        "<tab>",
        function()
          require("luasnip").jump(1)
        end,
        mode = "s",
      },
      {
        "<s-tab>",
        function()
          require("luasnip").jump(-1)
        end,
        mode = { "i", "s" },
      },
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
    opts = {
      spec = {
        -- Add bindings which show up as group name
        {
          mode = "n",
          { "<leader>m", group = "window" },
        },
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
    },
  },

  {
    "folke/trouble.nvim",
    init = function()
      vim.api.nvim_create_autocmd({ "FileType" }, {
        group = vim.api.nvim_create_augroup("lazyvim_trouble_conceal", { clear = true }),
        pattern = { "trouble" },
        callback = function()
          vim.wo.conceallevel = 0
        end,
      })
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
        "css",
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

  "eigenfoo/stan-vim",
}
