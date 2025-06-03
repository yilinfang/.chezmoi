-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Select all
vim.keymap.set({ "n", "v" }, "<M-S-a>", "<Esc>ggVG", { desc = "Select all" })

-- Yank to system clipboard
vim.keymap.set({ "v" }, "<M-S-y>", '"+y', { desc = "Yank to system clipboard '\"+'" })

-- HACK: Toggle spell checking in the current buffer
vim.keymap.set("n", "<leader>ts", function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
  local status = vim.opt_local.spell:get() and "ON" or "OFF"
  print("Spell check: " .. status)
end, { desc = "[T]oggle [S]pell Check" })
