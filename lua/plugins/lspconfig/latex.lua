return {
  texlab = function(use_mason)
    return {
      mason = use_mason,
      settings = {
        texlab = {
          bibtexFormatter = "texlab",
          build = {
            args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
            executable = "latexmk",
            forwardSearchAfter = false,
            onSave = false,
          },
          chktex = {
            onEdit = false,
            onOpenAndSave = false,
          },
          diagnosticsDelay = 300,
          formatterLineLength = 80,
          forwardSearch = {
            args = {},
          },
          inlayHints = {
            -- labelDefinitions = false,
            -- labelReferences = false,
            maxLength = 20,
          },
          latexFormatter = "latexindent",
          latexindent = {
            modifyLineBreaks = false,
          },
        },
      },
    }
  end,
}
