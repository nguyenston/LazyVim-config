return {
  pylyzer = function(use_mason)
    return {
      mason = use_mason,
    }
  end,
  basedpyright = function(use_mason)
    return {
      mason = use_mason,
      capabilities = (function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
        return capabilities
      end)(),
      settings = {
        basedpyright = {
          disableOrganizeImports = true, -- Using Ruff
          analysis = {
            typeCheckingMode = "standard",
            -- ignore = { "*" }, -- Using Ruff
          },
        },
      },
    }
  end,
  ruff = function(use_mason)
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
    ruff = function()
      require("lazyvim.util").lsp.on_attach(function(client, _)
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
      end, "ruff")
    end,
  },
}
