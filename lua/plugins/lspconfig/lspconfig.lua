local imports = {
  servers = function(use_mason)
    return {
      julials = require("plugins.lspconfig.julia").julials(false),
      tsserver = require("plugins.lspconfig.typescript").tsserver(use_mason),
      pyright = require("plugins.lspconfig.python").pyright(use_mason),
      ruff_lsp = require("plugins.lspconfig.python").ruff_lsp(use_mason),
      clangd = require("plugins.lspconfig.cpp").clangd(use_mason),
      -- ccls = require("plugins.lspconfig.cpp").ccls(use_mason),
      nil_ls = { mason = use_mason },
      rust_analyzer = require("plugins.lspconfig.rust").rust_analyzer(use_mason),
      -- marksman = { mason = false },
      lua_ls = require("plugins.lspconfig.lua").lua_ls(use_mason),
      r_language_server = require("plugins.lspconfig.R").r_language_server(use_mason),
    }
  end,

  setup = {
    ruff_lsp = require("plugins.lspconfig.python").setup.ruff_lsp,
    clangd = require("plugins.lspconfig.cpp").setup.clangd,
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- if not nixos, use mason
      local use_mason = require("util.misc").file_exists("~/.config/nvim/is-not-nixos.flag")
      opts.servers = imports.servers(use_mason)
      opts.setup = imports.setup
    end,
  },
}
