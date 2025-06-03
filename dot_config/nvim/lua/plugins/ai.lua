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
    vim.keymap.set("n", "<leader>tc", "<cmd>Copilot toggle<CR>", { desc = "[T]oggle [C]opilot" })
  end,
}
