-- HACK: snacks.nvim
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  --@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
██╗   ██╗██╗███╗   ███╗███████╗ ██████╗ ██████╗  ██████╗  ██████╗  ██████╗ ██████╗ 
██║   ██║██║████╗ ████║██╔════╝██╔═══██╗██╔══██╗██╔════╝ ██╔═══██╗██╔═══██╗██╔══██╗
██║   ██║██║██╔████╔██║█████╗  ██║   ██║██████╔╝██║  ███╗██║   ██║██║   ██║██║  ██║
╚██╗ ██╔╝██║██║╚██╔╝██║██╔══╝  ██║   ██║██╔══██╗██║   ██║██║   ██║██║   ██║██║  ██║
 ╚████╔╝ ██║██║ ╚═╝ ██║██║     ╚██████╔╝██║  ██║╚██████╔╝╚██████╔╝╚██████╔╝██████╔╝
  ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝  ╚═════╝ ╚═════╝ 
          ]],
      },
    },
    image = { -- HACK: Forcefully disable image preview in snacks.nvim.
      enable = false,
      formats = {},
    },
    indent = { enable = true },
    quickfile = { enabled = true, exlucde = { 'latex' } },
    statuscolumn = { enabled = true },
  },
}
