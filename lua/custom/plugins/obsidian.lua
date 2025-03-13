return {
  {
    'epwalsh/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = 'markdown',
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
      -- Required.
      'nvim-lua/plenary.nvim',

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      new_notes_locaiton = 'current_dir',
      note_id_func = function(title)
        return title
      end,
      note_frontmatter_func = function(note)
        if not note.stage then
          note.stage = 'Backlog'
        end

        local out = { id = note.id, aliases = note.aliases, tags = note.tags, stage = note.stage }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,
      workspaces = {
        {
          name = 'labyrinth',
          path = '/Users/luneyx/Library/Mobile Documents/iCloud~md~obsidian/Documents/Labyrinth',
        },
      },

      -- see below for full list of options 👇
    },
  },
}
