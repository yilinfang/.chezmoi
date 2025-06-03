-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- General options
vim.opt.scrolloff = 10
vim.opt.clipboard = ""

-- Disable paster from systerm clipboard when throught OSC 52
-- Fix the yanky performance issue when using OSC 52
if vim.env.SSH_TTY then
  vim.g.clipboard = {
    name = "Customized OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = function()
        local content = vim.fn.getreg("")
        return vim.split(content, "\n")
      end,
      ["*"] = function()
        local content = vim.fn.getreg("")
        return vim.split(content, "\n")
      end,
    },
  }
end

-- VSCode like Copilot experience
vim.g.ai_cmp = false
