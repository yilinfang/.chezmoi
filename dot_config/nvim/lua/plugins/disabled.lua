return {
  {
    "folke/snacks.nvim",
    opts = {
      image = { -- Disable image
        enabled = false,
        formats = {},
      },
      input = { -- Disable input
        enabled = false,
      },
      notifier = { -- Disable notifier
        enabled = false,
      },
    },
  },

  -- Disable noice.nvim
  {
    "folke/noice.nvim",
    enabled = false,
  },

  -- Disable bufferline
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
}
