-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Select all
vim.keymap.set({ "n", "v" }, "<M-S-a>", "<Esc>ggVG", { desc = "Select all" })

-- Yank to system clipboard
vim.keymap.set({ "v" }, "<M-S-y>", '"+y', { desc = "Yank to system clipboard '\"+'" })
