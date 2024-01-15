return {
  {
    "jbyuki/nabla.nvim",
    keys = function()
      return {
        {
          "<leader>p",
          function()
            require("nabla").popup()
          end,
          mode = "n",
        },
      }
    end,
  },

  {
    "preservim/vim-markdown",
    dependencies = {
      "godlygeek/tabular",
    },
    config = function()
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_strikethrough = 1
    end,
  },

  -- background highlighting for headlines
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = function()
      local opts = {}
      for _, ft in ipairs({ "markdown" }) do
        opts[ft] = {
          headline_highlights = {},
          fat_headlines = false,
          fat_headline_upper_string = "-",
          fat_headline_lower_string = "-",
        }
        for i = 1, 6 do
          local hl = "Headline" .. i
          vim.api.nvim_set_hl(0, hl, { link = "Headline", default = true })
          table.insert(opts[ft].headline_highlights, hl)
        end
        return opts
      end
    end,
    config = function(_, opts)
      vim.cmd([[highlight Headline1 guibg=#5c3157]])
      vim.cmd([[highlight Headline2 guibg=#2a4852]])
      -- schedule to prevent headlines slowing down opening a file
      vim.schedule(function()
        require("headlines").setup(opts)
        require("headlines").refresh()
      end)
    end,
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    init = function()
      vim.api.nvim_create_autocmd({ "FileType" }, {
        group = vim.api.nvim_create_augroup("lazyvim_markdown_conceal", { clear = true }),
        pattern = { "markdown" },
        callback = function()
          vim.wo.conceallevel = 2
        end,
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
      "preservim/vim-markdown",
    },
    opts = {
      workspaces = {
        {
          name = "Nether Portal",
          path = "/home/nguyenston/Projects/obsidian-vaults/NetherPortal",
        },
      },
      completion = {
        nvim_cmp = true,
        min_chars = 0,
      },
      note_frontmatter_func = function(note)
        local out = { id = note.id, tags = note.tags }
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "markdown",
        "markdown_inline",
        "latex",
      },
      highlight = {
        enable = true,
        disable = { "latex", "markdown" }, -- so that mathzone dectection works properly
      },
    },
  },
  {
    "oflisback/obsidian-bridge.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {},
    event = {
      "BufReadPre *.md",
      "BufNewFile *.md",
    },
    lazy = true,
  },
}
