-- Fuzzy Finder (files, lsp, etc)
return {
  'nvim-telescope/telescope.nvim',
  command = 'Telescope', -- HACK: Load command Telescope
  version = false, -- HACK: Disable version check to use the latest version
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = true },
  },
  config = function()
    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`

    -- HACK: Custom vimgrep arguments
    local custom_vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden', -- NOTE: Include hidden files
    }
    for _, pattern in ipairs(vim.g.exclude_pattern or {}) do
      vim.list_extend(custom_vimgrep_arguments, { '--glob', '!' .. pattern })
    end
    require('telescope').setup {
      defaults = {
        vimgrep_arguments = custom_vimgrep_arguments,
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch Current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find Existing Buffers' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim [F]iles' })

    -- HACK: Custom keymap for telescope.nvim
    vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = '[/] Fuzzily Search in Current Buffer' })

    vim.keymap.set('n', '<leader>sG', function()
      builtin.live_grep {
        additional_args = { '--follow', '--no-ignore-vcs' },
        prompt_title = 'Live Grep in All Files (including ignored files)',
      }
    end, { desc = '[S]earch By [G]rep in All files' })

    -- HACK: Custom find files command
    local get_custom_find_command = function()
      local fd_binary = vim.fn.executable 'fd' == 1 and 'fd' or 'fdfind'
      local custom_find_command = {
        fd_binary,
        '--type',
        'f',
        '--color',
        'never',
        '--hidden', -- NOTE: Include hidden files
      }
      for _, pattern in ipairs(vim.g.exclude_pattern or {}) do
        vim.list_extend(custom_find_command, { '--exclude', pattern })
      end
      return custom_find_command
    end

    vim.keymap.set('n', '<leader>sf', function()
      builtin.find_files {
        find_command = get_custom_find_command(),
      }
    end, { desc = '[S]earch [F]iles' })

    vim.keymap.set('n', '<leader>sF', function()
      builtin.find_files {
        find_command = function()
          return vim.list_extend(get_custom_find_command(), { '--follow', '--no-ignore-vcs' })
        end,
        prompt_title = '[S]earch All [F]iles (including ignored files)',
      }
    end, { desc = '[S]earch All [F]iles' })
  end,
}
