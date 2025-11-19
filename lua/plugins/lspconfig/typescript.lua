return {
  vtsls = function(use_mason)
    local vue_language_server_path = use_mason
        and vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
      or ""
    local vue_plugin = {
      name = "@vue/typescript-plugin",
      location = vue_language_server_path,
      languages = { "vue" },
      configNamespace = "typescript",
    }
    local svelte_plugin = {
      name = "typescript-svelte-plugin",
      location = LazyVim.get_pkg_path("svelte-language-server", "/node_modules/typescript-svelte-plugin"),
      enableForWorkspaceTypeScriptVersions = true,
    }
    return {
      mason = use_mason,
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              -- vue_plugin, -- enable when vue_ls is installed
              svelte_plugin,
            },
          },
        },
      },
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
    }
  end,
  svelte = function(use_mason)
    return {
      keys = {
        {
          "<leader>co",
          LazyVim.lsp.action["source.organizeImports"],
          desc = "Organize Imports",
        },
      },
    }
  end,
}
