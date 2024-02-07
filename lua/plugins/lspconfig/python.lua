return {
  pyright = function(use_mason)
    return { mason = use_mason }
  end,
  ruff_lsp = function(use_mason)
    return {
      mason = use_mason,
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
    }
  end,

  setup = {
    ruff_lsp = function()
      require("lazyvim.util").lsp.on_attach(function(client, _)
        if client.name == "ruff_lsp" then
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end
      end)
    end,
  },
}
