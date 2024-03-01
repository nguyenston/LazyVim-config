return {
  "Olical/conjure",
  enable = false,
  -- ft = { "clojure", "fennel", "python", "julia", "rust" }, -- etc
  -- [Optional] cmp-conjure for cmp
  dependencies = {
    {
      "PaterJason/cmp-conjure",
      config = function()
        local cmp = require("cmp")
        local config = cmp.get_config()
        table.insert(config.sources, {
          name = "buffer",
          option = {
            sources = {
              { name = "conjure" },
            },
          },
        })
        cmp.setup(config)
      end,
    },
  },
  config = function(_, _)
    require("conjure.main").main()
    require("conjure.mapping")["on-filetype"]()
  end,
  init = function()
    -- Set configuration options here
    vim.g["conjure#mapping#doc_word"] = "gk"
    vim.g["conjure#debug"] = false
    vim.g["conjure#client#julia#stdio#command"] = "julia --project=. --banner=no --color=no"
  end,
}
