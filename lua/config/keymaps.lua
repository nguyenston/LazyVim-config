-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local set = vim.keymap.set
local del = vim.keymap.del

set("n", "<leader>w", "<cmd>w<cr><esc>", { desc = "Save file" })

-- remaping windows-related commands
set("n", "<leader>mo", "<cmd>only<cr>", { desc = "Delete other windows" })
set("n", "<leader>md", "<cmd>close<cr>", { desc = "Delete window" })
set("n", "<leader>ms", "<cmd>split<cr>", { desc = "Split window below" })
set("n", "<leader>mv", "<cmd>vsplit<cr>", { desc = "Split window right" })

del("n", "<leader>ww")
del("n", "<leader>wd")
del("n", "<leader>w-")
del("n", "<leader>w|")
