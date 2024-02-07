return {
  servers = function(use_mason)
    return {
      julials = require("plugins.lspconfig.julia").julials(use_mason),
      tsserver = require("plugins.lspconfig.typescript").tsserver(use_mason),
      pyright = require("plugins.lspconfig.python").pyright(use_mason),
      ruff_lsp = require("plugins.lspconfig.python").ruff_lsp(use_mason),
      clangd = require("plugins.lspconfig.cpp").clangd(use_mason),
      nil_ls = { mason = use_mason },
      rust_analyzer = require("plugins.lspconfig.rust").rust_analyzer(use_mason),
      -- marksman = { mason = false },
      lua_ls = require("plugins.lspconfig.lua").lua_ls(use_mason),
    }
  end,

  setup = {
    ruff_lsp = require("plugins.lspconfig.python").setup.ruff_lsp,
  },
}
