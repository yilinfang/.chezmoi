return {
  {
    "folke/todo-comments.nvim",
    opts = {
      signs = false,
    },
    config = function(_, opts)
      require("todo-comments").setup(opts)
      -- HACK: Toggle todo-comments
      local is_highlight_active = true -- Set the initial state to enabled
      vim.keymap.set("n", "<leader>tt", function()
        if is_highlight_active then
          require("todo-comments").disable()
          is_highlight_active = false
        else
          require("todo-comments").enable()
          is_highlight_active = true
        end
      end, { desc = "[T]oggle [T]odo Comments Highlight" })
    end,
  },

  {
    "folke/trouble.nvim",
    opts = {
      modes = {
        lsp = {
          win = { position = "bottom" },
        },
        symbols = {
          win = { position = "bottom" },
        },
      },
    },
  },
}
