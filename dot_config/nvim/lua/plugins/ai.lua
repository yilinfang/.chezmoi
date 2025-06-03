return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = { "LazyFile" },
  build = ":Copilot auth",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = false,
      keymap = {
        accept = "<M-y>",
        accept_word = "<M-w>",
        accept_line = "<M-l>",
        next = "<M-n>",
        prev = "<M-p>",
        dismiss = "<M-d>",
      },
    },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
    },
  },
  config = function(_, opts)
    require("copilot").setup(opts)
    -- HACK: Toggle Copilot
    local is_copilot_enabled = true -- Enable Copilot by default
    Snacks.toggle({
      name = "Copilot",
      get = function()
        return is_copilot_enabled
      end,
      set = function(value)
        is_copilot_enabled = value
        -- Execute the command :Copilot toggle
        vim.cmd([[Copilot toggle]])
      end,
    }):map("<leader>cP")
  end,
}
