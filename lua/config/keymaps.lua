-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local set = vim.keymap.set
local del = vim.keymap.del
local Util = require("lazyvim.util")
local lazyterm = function()
  Snacks.terminal(nil, { cwd = Util.root() })
end

set("n", "<leader>fs", "<cmd>w<cr><esc>", { desc = "Save file" })

-- remaping windows-related commands
set("n", "<leader>mo", "<cmd>only<cr>", { desc = "Delete other windows" })
set("n", "<leader>md", "<cmd>close<cr>", { desc = "Delete window" })
set("n", "<leader>ms", "<cmd>split<cr>", { desc = "Split window below" })
set("n", "<leader>mv", "<cmd>vsplit<cr>", { desc = "Split window right" })
set("n", "<C-\\>", lazyterm, { desc = "Terminal (root dir)" })
set("t", "<C-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })
