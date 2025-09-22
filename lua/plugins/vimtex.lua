-- modifications to integrate vimtex
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "bibtex", "latex" })
      end

      if type(opts.highlight.disable) == "table" then
        vim.list_extend(opts.highlight.disable, { "latex" })
      else
        opts.highlight.disable = { "latex" }
      end
    end,
  },

  {
    "nvim-mini/mini.pairs",
    lazy = false, -- Needed to have $$ only active for tex files
    config = function(_, opts)
      require("mini.pairs").setup(opts)
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "tex" },
        callback = function()
          MiniPairs.map_buf(0, "i", "$", { action = "closeopen", pair = "$$" })
        end,
      })
    end,
  },

  {
    "lervag/vimtex",
    lazy = false, -- lazy-loading will disable inverse search
    config = function()
      vim.api.nvim_create_autocmd({ "FileType" }, {
        group = vim.api.nvim_create_augroup("lazyvim_tex_conceal", { clear = true }),
        pattern = { "bib", "tex" },
        callback = function()
          vim.wo.conceallevel = 2
        end,
      })

      -- Dynamically configure the VimTeX PDF viewer based on the operating system
      if vim.fn.has('win32') == 1 then
        -- ## Windows Configuration ##
        -- Use the built-in 'sumatra' method for seamless integration.
        vim.g.vimtex_view_general_viewer  = 'SumatraPDF'
        vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
      else
        -- ## Linux/macOS Configuration ##
        -- Use the 'zathura' method. VimTeX will handle the SyncTeX options automatically.
        vim.g.vimtex_view_method = 'zathura'
      end

      -- This setting is crucial for robust inverse search on windows.
      -- It enables the callback feature of latexmk.
      vim.g.vimtex_compiler_latexmk = {
        callback = 1,
        continuous = 1,
        executable = 'latexmk',
      }

      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
      vim.g.vimtex_imaps_enabled = 0
      vim.g.vimtex_syntax_conceal = {
        accents = 1,
        ligatures = 1,
        cites = 1,
        fancy = 1,
        spacing = 0,
        greek = 1,
        math_bounds = 0,
        math_delimiters = 0,
        math_fracs = 1,
        math_super_sub = 0,
        math_symbols = 1,
        sections = 0,
        styles = 0,
      }
    end,
  },
}
