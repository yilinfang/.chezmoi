return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "ninja", "rst" } },
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        "ruff",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            pyright = {
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                diagnosticMode = "workspace",
              },
            },
          },
        },
        ruff = {},
      },
      setup = {
        pyright = function(_, opts)
          require("lspconfig").pyright.setup(opts)
          return true
        end,
        ruff = function(_, opts)
          require("lspconfig").ruff.setup(opts)
          -- Disable hover capability from Ruff
          --  From https://docs.astral.sh/ruff/editors/setup/#neovim
          vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client == nil then
                return
              end
              if client.name == "ruff" then
                -- Disable hover in favor of Pyright
                client.server_capabilities.hoverProvider = false
              end
            end,
            desc = "LSP: Disable hover capability from Ruff",
          })
          return true
        end,
      },
    },
  },
}
