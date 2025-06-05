return {
  {
    'b0o/SchemaStore.nvim',
    lazy = true,
    version = false, -- last release is way too old
  },

  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    lazy = true,
    opts = function(_, opts)
      local list_helper = require 'utils.list_helper'
      opts.ensure_installed = list_helper.extend_unique(opts.ensure_installed or {}, {
        'jsonls',
        'prettier',
      })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    opts = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      vim.lsp.config('jsonls', {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
        capabilities = capabilities,
      })
    end,
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        json = { 'prettier' },
      },
    },
  },
}
