-- Yilin Fang's personal Neovim configuration
-- Based on kickstart.nvim
-- Also inspired a lot by AstroNvim and LazyVim
-- Copyright (c) 2025 Yilin Fang

-- [[ Global options ]]
-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Setting options ]]
-- Enable linenumbers
vim.o.number = true

-- Enable relative line numbers
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- HACK: Customized OSC 52 for SSH
--  Disable paste from system clipboard
if vim.env.SSH_TTY then
  vim.g.clipboard = {
    name = 'Customized OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy '+',
      ['*'] = require('vim.ui.clipboard.osc52').copy '*',
    },
    paste = {
      ['+'] = function()
        local content = vim.fn.getreg ''
        return vim.split(content, '\n')
      end,
      ['*'] = function()
        local content = vim.fn.getreg ''
        return vim.split(content, '\n')
      end,
    },
  }
end

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- HACK: Use rg for grep
vim.o.grepformat = '%f:%l:%c:%m'
vim.o.grepprg = 'rg --vimgrep'

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
vim.o.confirm = true

-- HACK: Disable wrap lines
vim.o.wrap = false
vim.o.linebreak = true

-- HACK: Folding
vim.o.smoothscroll = true
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldlevel = 99

-- HACK: Indent settings
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.shiftround = true -- Round indent
vim.o.shiftwidth = 2 -- Size of an indent
vim.o.smartindent = true -- Smart indenting on new lines
vim.o.tabstop = 2 -- Number of spaces a <Tab> counts for

-- [[ Basic Keymaps ]]
-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- HACK: Map <M-S-a> to select all text in the current buffer
vim.keymap.set({ 'n', 'v' }, '<M-S-a>', '<Esc>ggVG', { desc = 'Select all text in the current buffer' })

-- HACK: Map <M-S-y> to copy the selected text to the system clipboard "+
vim.keymap.set({ 'v' }, '<M-S-y>', '"+y"', { desc = 'Yank selected text to the system clipboard' })

-- HACK: Toggle spell checking in the current buffer
vim.keymap.set('n', '<leader>ts', function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
  local status = vim.opt_local.spell:get() and 'ON' or 'OFF'
  print('Spell check: ' .. status)
end, { desc = '[T]oggle [S]pell Check' })

-- [[ Basic Autocommands ]]
-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- HACK: Check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Check for spell in text filetypes',
  group = vim.api.nvim_create_augroup('kickstart-spell-check', { clear = true }),
  pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- HACK: Automatically resize splits when the window is resize
--  It will resize all splits to have equal height and width,
--  but not preserve the current size of splits.
vim.api.nvim_create_autocmd('VimResized', {
  desc = 'Automatically resize splits when the window is resized',
  group = vim.api.nvim_create_augroup('kickstart-resize-splits', { clear = true }),
  command = 'windo wincmd = ',
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- HACK: Define event LazyFile to BufReadPost, BufNewFile and BufWritePost
local LazyFile = {
  'BufReadPost',
  'BufNewFile',
  'BufWritePost',
}

-- [[ Configure and install plugins ]]
require('lazy').setup({
  { -- Detect tabstop and shiftwidth automatically
    'NMAC427/guess-indent.nvim', -- HACK: guess-indent.nvim
    event = { 'BufReadPost', 'BufNewFile' }, -- HACK: Set the event of guess-indent.nvim to BufReadPost, BufNewFile
    config = function()
      require('guess-indent').setup {}
      vim.keymap.set('n', '<leader>g', function()
        vim.cmd 'GuessIndent'
      end, { desc = '[G]uess Indent' })
    end,
  },

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = { unpack(LazyFile) }, -- HACK: Set the event of gitsigns.nvim to LazyFile
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr) -- HACK: Additional keymaps for gitsigns
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [r]eset hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- HACK: nvim-web-devicons for which-key.nvim
    event = 'VeryLazy', -- HACK: Set the event of which-key.nvim to VeryLazy
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = true,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = {},
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },

      -- HACK: Change which-key peset
      preset = 'helix',
    },
  },

  { -- HACK: Snacks.picker
    'folke/snacks.nvim',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      picker = { enabled = true },
      image = {
        enabled = false, -- NOTE: Disable snacks.image
        formats = {}, -- HACK: Disable image preview for other modules like picker
      },
    },
    keys = {
      {
        '<leader>sh',
        function()
          Snacks.picker.help()
        end,
        desc = '[S]earch [H]elp',
      },
      {
        '<leader>sk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = '[S]earch [K]eymaps',
      },
      {
        '<leader>sf',
        function()
          Snacks.picker.files()
        end,
        desc = '[S]earch [F]iles',
      },
      {
        '<leader>ss',
        function()
          Snacks.picker()
        end,
        desc = '[S]earch [S]elect Picker',
      },
      {
        '<leader>sw',
        function()
          Snacks.picker.grep_word()
        end,
        desc = '[S]earch current [W]ord',
      },
      {
        '<leader>sg',
        function()
          Snacks.picker.grep()
        end,
        desc = '[S]earch by [G]rep',
      },
      {
        '<leader>sd',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = '[S]earch [D]iagnostics',
      },
      {
        '<leader>sr',
        function()
          Snacks.picker.resume()
        end,
        desc = '[S]earch [R]esume',
      },
      {
        '<leader>s.',
        function()
          Snacks.picker.recent()
        end,
        desc = '[S]earch Recent Files ("." for repeat)',
      },
      {
        '<leader><leader>',
        function()
          Snacks.picker.buffers()
        end,
        desc = '[ ] Find existing buffers',
      },
      {
        '<leader>/',
        function()
          Snacks.picker.lines()
        end,
        desc = '[/] Fuzzily search in current buffer',
      },
    },
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    event = { unpack(LazyFile) }, -- HACK: Set the event of nvim-lspconfig to LazyFile
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      'b0o/schemastore.nvim', -- HACK: schemastore.nvim

      -- Useful status updates for LSP.
      {
        'j-hui/fidget.nvim',
        event = { unpack(LazyFile) }, -- HACK: Set the event of fidget.nvim to LazyFile
        opts = {
          notification = {
            window = {
              winblend = 0, -- HACK: Make fidget window transparent
            },
          },
        },
      },
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- HACK: Replace telescope with snacks.picker
          map('grr', function()
            Snacks.picker.lsp_references()
          end, '[G]oto [R]eferences')

          map('gri', function()
            Snacks.picker.lsp_implementations()
          end, '[G]oto [I]mplementation')

          map('grd', function()
            Snacks.picker.lsp_definitions()
          end, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- HACK: Replace telescope with snacks.picker
          map('gO', function()
            Snacks.picker.lsp_symbols { filter = { default = true } }
          end, 'Open Document Symbols')

          map('gW', function()
            Snacks.picker.lsp_workspace_symbols { filter = { default = true } }
          end, 'Open Workspace Symbols')

          map('grt', function()
            Snacks.picker.lsp_type_definitions()
          end, '[G]oto [T]ype Definition')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        },
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- Enable the following language servers
      local servers = { -- HACK: LSP servers
        -- Lua
        ['lua_ls'] = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        -- Pyright
        ['pyright'] = {
          settings = {
            pyright = {
              disableOrganizeImports = true, -- Using Ruff's import organizer
            },
            python = {
              analysis = {
                diagnosticMode = 'workspace',
              },
            },
          },
        },
        -- Ruff
        ['ruff'] = {},
        -- Bashls
        ['bashls'] = {},
        -- Marksman
        ['marksman'] = {},
        -- Jsonls
        ['jsonls'] = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },
        -- Taplo
        ['taplo'] = {},
        -- Yamlls
        ['yamlls'] = {
          settings = {
            yaml = {
              schemaStore = {
                -- You must disable built-in schemaStore support if you want to use
                -- this plugin and its advanced options like `ignore`.
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = '',
              },
              schemas = require('schemastore').yaml.schemas(),
            },
          },
        },
      }
      -- Ensure the servers and tools above are installed
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'shfmt', -- Required by bashls
        'shellcheck', -- Required by bashls
        'prettierd',
        'prettier',
        'markdownlint-cli2',
      })
      -- HACK: Setup LSP servers with neovim 0.11+ API
      for server, config in pairs(servers) do
        vim.lsp.config(server, config)
        -- HACK: We do not need to enable the server, the mason-lspconfig plugin would enable it.
        --  vim.lsp.enable(server)
      end
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        automatic_enable = true, -- HACK: Enable all servers
      }

      -- HACK: Disable hover capability from Ruff
      --  This is to avoid conflicts with Pyright's hover capability.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end
          if client.name == 'ruff' then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end
        end,
        desc = 'LSP: Disable hover capability from Ruff',
      })
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- HACK: formatters
        css = { 'prettierd', 'prettier', stop_after_first = true },
        fish = { 'fish_indent' },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        sh = { 'shfmt' },
        python = { 'ruff_format' },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
        markdown_inline = { 'prettierd', 'prettier', stop_after_first = true },
        toml = { 'taplo' },
        yaml = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'InsertEnter', -- HACK: Set the event of blink.cmp to InsertEnter
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        preset = 'default',
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 }, -- HACK: Show documentation after a delay
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      fuzzy = { implementation = 'prefer_rust_with_warning' }, -- HACK: Use rust fuzzy matcher for blink.cmp

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },

  -- HACK: Colorscheme
  {
    'craftzdog/solarized-osaka.nvim',
    lazy = false,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('solarized-osaka').setup {
        transparent = true,
        styles = {
          sidebars = 'transparent',
          floats = 'transparent',
        },
      }
      vim.cmd [[colorscheme solarized-osaka]]
    end,
  },

  -- Highlight todo, notes, etc in comments
  -- HACK: todo-comments
  {
    'folke/todo-comments.nvim',
    event = { unpack(LazyFile) }, -- HACK: Set the event of todo-comments to LazyFile
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('todo-comments').setup { signs = false }
      -- Set keymaps
      vim.keymap.set('n', '<leader>st', function()
        Snacks.picker.todo_comments()
      end, { desc = '[S]earch [T]odos' })

      -- HACK: Toggle todo-comments
      local is_highlight_active = true -- Set the initial state to enabled
      vim.keymap.set('n', '<leader>tt', function()
        if is_highlight_active then
          require('todo-comments').disable()
          is_highlight_active = false
        else
          require('todo-comments').enable()
          is_highlight_active = true
        end
      end, { desc = '[T]oggle [T]odo Comments Highlight' })
    end,
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      require('mini.surround').setup()

      -- HACK: Other Mini modules
      require('mini.comment').setup()
      require('mini.move').setup()
      require('mini.pairs').setup()
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    event = { unpack(LazyFile), 'VeryLazy' }, -- HACK: Set the event of nvim-treesitter to LazyFile and VeryLazy
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { -- HACK: Treesitter parsers
        'bash',
        'c',
        'diff',
        'fish',
        'html',
        'json',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'python',
        'toml',
        'query',
        'regex',
        'vim',
        'vimdoc',
        'yaml',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },

  { -- HACK: nvim-lint for lintting
    'mfussenegger/nvim-lint',
    event = { unpack(LazyFile) }, -- HACK: Set the event of nvim-lint to LazyFile
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint-cli2' },
      }

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },

  { -- HACK: lualine.nvim for statusline
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'solarized-osaka',
          always_show_tabline = false,
          disabled_filetypes = { statusline = { 'snacks_dashboard' } },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = {
            { 'filename', path = 1 }, -- Relative path
            {
              'diff',
              source = function() -- Use gitsigns.nvim for diff
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_x = {
            'diagnostics',
            'filetype',
            { 'encoding', show_bomb = true },
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        extensions = { 'lazy', 'mason', 'aerial', 'quickfix' },
      }
    end,
  },

  { -- HACK: Other snacks.nvim modules
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
      indent = { enable = true },
      quickfile = { enabled = true, exlucde = { 'latex' } },
      statuscolumn = { enabled = true },
    },
  },

  { -- HACK: persistence.nvim
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {},
  },

  { -- HACK: render-markdown.nvim
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { 'markdown', 'norg', 'rmd', 'org', 'codecompanion' },
    opts = {
      code = {
        sign = false,
        width = 'block',
        left_pad = 2,
        right_pad = 2,
        border = 'thick',
      },
      heading = {
        sign = false,
        icons = {},
      },
      completions = {
        lsp = { enabled = true },
      },
    },
    config = function(_, opts)
      require('render-markdown').setup(opts)
      vim.keymap.set('n', '<leader>tm', function()
        require('render-markdown').buf_toggle()
      end, { desc = '[T]oggle Render [M]arkdown' })
    end,
  },

  { -- HACK: copilot.lua
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = { unpack(LazyFile) }, -- HACK: Set the event of copilot.lua to LazyFile
    build = ':Copilot auth',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        keymap = {
          accept = '<M-y>',
          accept_word = '<M-w>',
          accept_line = '<M-l>',
          next = '<M-n>',
          prev = '<M-p>',
          dismiss = '<M-d>',
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
      },
    },
    config = function(_, opts)
      require('copilot').setup(opts)
      vim.keymap.set('n', '<leader>tc', '<cmd>Copilot toggle<CR>', { desc = '[T]oggle [C]opilot' })
    end,
  },

  { -- HACK: aerial.nvim
    'stevearc/aerial.nvim',
    event = { unpack(LazyFile) }, -- HACK: Set the event of aerial.nvim to LazyFile
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      layout = {
        max_width = { 50, 0.3 },
        min_width = { 20, 0.2 },
      },
    },
    config = function(_, opts)
      require('aerial').setup(opts)
      vim.keymap.set('n', '<leader>ta', '<cmd>AerialToggle right<CR>', { desc = '[T]oggle [A]erial' })
      vim.keymap.set('n', '<leader>sa', function()
        require('aerial').snacks_picker()
      end, { desc = '[S]earch [A]erial Symbol' })
    end,
  },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = {},
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
