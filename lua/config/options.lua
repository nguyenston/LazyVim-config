-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.linebreak = true
opt.relativenumber = false
vim.g.maplocalleader = ","
-- Workaround for truncating long TypeScript inlay hints.
-- TODO: Remove this if https://github.com/neovim/neovim/issues/27240 gets addressed.
local ellipsis = "..."
local methods = vim.lsp.protocol.Methods
local inlay_hint_handler = vim.lsp.handlers[methods.textDocument_inlayHint]
vim.lsp.handlers[methods.textDocument_inlayHint] = function(err, result, ctx, config)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if client and client.name == "typescript-tools" then
    result = vim.iter.map(function(hint)
      local label = hint.label ---@type string
      if label:len() >= 30 then
        label = label:sub(1, 29) .. ellipsis
      end
      hint.label = label
      return hint
    end, result)
  end

  inlay_hint_handler(err, result, ctx, config)
end
