return {
  pyright = function(use_mason)
    return {
      mason = use_mason,
      capabilities = (function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
        return capabilities
      end)(),
      settings = {
        pyright = {
          disableOrganizeImports = true, -- Using Ruff
        },
        python = {
          analysis = {
            -- ignore = { "*" }, -- Using Ruff
          },
        },
      },
    }
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
