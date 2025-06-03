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
      Snacks.toggle({
        name = "Todo Comments",
        get = function()
          return is_highlight_active
        end,
        set = function(value)
          is_highlight_active = value
          if is_highlight_active then
            require("todo-comments").enable()
          else
            require("todo-comments").disable()
          end
        end,
      }):map("<leader>ut")
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
