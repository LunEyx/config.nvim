return {
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
      'rafamadriz/friendly-snippets',
      'fang2hou/blink-copilot',
      {
        'Kaiser-Yang/blink-cmp-git',
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
      {
        'Kaiser-Yang/blink-cmp-dictionary',
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
      'moyiz/blink-emoji.nvim',
      'MahanRahmati/blink-nerdfont.nvim',
    },

    -- use a release tag to download pre-built binaries
    version = '*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept, C-n/C-p for up/down)
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys for up/down)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-e: Hide menu
      -- C-k: Toggle signature help
      --
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = {
        preset = 'default',
        ['<Tab>'] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          'snippet_forward',
          'fallback',
        },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        ['<C-d>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'copilot', 'lsp', 'path', 'snippets', 'buffer', 'emoji', 'nerdfont' },
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            score_offset = 100,
            async = true,
          },
          git = {
            module = 'blink-cmp-git',
            name = 'Git',
            opts = {},
          },
          dictionary = {
            module = 'blink-cmp-dictionary',
            name = 'Dict',
            -- Make sure this is at least 2.
            -- 3 is recommended
            min_keyword_length = 3,
            opts = {
              -- options for blink-cmp-dictionary
            },
          },
          emoji = {
            module = 'blink-emoji',
            name = 'Emoji',
            score_offset = 15, -- Tune by preference
            opts = { insert = true }, -- Insert emoji (default) or complete its name
            should_show_items = function()
              return vim.tbl_contains(
                -- Enable emoji completion only for git commits and markdown.
                -- By default, enabled for all file-types.
                { 'gitcommit', 'markdown' },
                vim.o.filetype
              )
            end,
          },
          nerdfont = {
            module = 'blink-nerdfont',
            name = 'Nerd Fonts',
            score_offset = 15, -- Tune by preference
            opts = { insert = true }, -- Insert nerdfont icon (default) or complete its name
          },
        },
      },

      -- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = 'lua' },
      cmdline = {
        enabled = true,
        keymap = {
          ['<Tab>'] = {
            function(cmp)
              if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then
                return cmp.accept()
              end
            end,
            'show_and_insert',
            'select_next',
          },
          ['<C-n>'] = { 'select_next' },
          ['<C-p>'] = { 'select_prev' },
          ['<C-e>'] = { 'cancel' },
        },
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
          window = {
            border = 'rounded',
          },
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = true,
          },
        },
      },
    },
    opts_extend = { 'sources.default' },
  },
}
