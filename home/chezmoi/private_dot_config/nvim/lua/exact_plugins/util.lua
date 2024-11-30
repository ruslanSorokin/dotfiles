---@module "lazy"
---@type LazySpec
return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")

      mc.setup()

      local set = vim.keymap.set
      local prefix = "<leader>m"

      -- Add or skip cursor above/below the main cursor.
      set({ "n", "v" }, "<leader>k", function()
        mc.lineAddCursor(-1)
      end, { desc = "Multicursor: add cursor line up" })
      set({ "n", "v" }, "<leader>j", function()
        mc.lineAddCursor(1)
      end, { desc = "Multicursor: add cursor line down" })
      set({ "n", "v" }, "<leader>K", function()
        mc.lineSkipCursor(-1)
      end, { desc = "Multicursor: skip line up" })
      set({ "n", "v" }, "<leader>J", function()
        mc.lineSkipCursor(1)
      end, { desc = "Multicursor: add  line down" })

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "v" }, prefix .. "n", function()
        mc.matchAddCursor(1)
      end, { desc = "Multicursor: add next match" })
      set({ "n", "v" }, prefix .. "s", function()
        mc.matchSkipCursor(1)
      end, { desc = "Multicursor: skip next match" })
      set({ "n", "v" }, prefix .. "N", function()
        mc.matchAddCursor(-1)
      end, { desc = "Multicursor: add prev match" })
      set({ "n", "v" }, prefix .. "S", function()
        mc.matchSkipCursor(-1)
      end, { desc = "Multicursor: skip prev match" })

      -- Add all matches in the document
      set({ "n", "v" }, prefix .. "a", mc.matchAllAddCursors, { desc = "Multicursor: add all matches" })

      -- Rotate the main cursor.
      set({ "n", "v" }, prefix .. "r", mc.nextCursor, { desc = "Multicursor: rotate main with next" })
      set({ "n", "v" }, prefix .. "R", mc.prevCursor, { desc = "Multicursor: rotate main with prev" })

      -- Delete the main cursor.
      set({ "n", "v" }, prefix .. "x", mc.deleteCursor, { desc = "Multicursor: delete main cursor" })

      --TODO: make the rest of the keys

      -- -- Add and remove cursors with control + left click.
      -- set("n", "<c-leftmouse>", mc.handleMouse)

      -- Easy way to add and remove cursors using the main cursor.
      set({ "n", "v" }, prefix .. "t", mc.toggleCursor, { desc = "Multicursor: toggle cursors" })

      -- -- Clone every cursor and disable the originals.
      -- set({ "n", "v" }, prefix .. "c", mc.duplicateCursors)

      set("n", prefix .. "X", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          --TODO: automatically run fallback
          -- see: https://github.com/Saghen/blink.cmp/blob/85f318b6db5b48d825d4ef575b405a8d41233753/lua/blink/cmp/keymap/fallback.lua
          -- Default <esc> handler.
        end
      end, { desc = "Multicursor: delete all cursors" })

      -- -- bring back cursors if you accidentally clear them
      -- set("n", prefix .. "u", mc.restoreCursors)
      --
      -- -- Align cursor columns.
      -- set("n", "<leader>a", mc.alignCursors)
      --
      -- -- Split visual selections by regex.
      -- set("v", "S", mc.splitCursors)
      --
      -- -- Append/insert for each line of visual selections.
      -- set("v", "I", mc.insertVisual)
      -- set("v", "A", mc.appendVisual)
      --
      -- -- match new cursors within visual selections by regex.
      -- set("v", "M", mc.matchCursors)
      --
      -- -- Rotate visual selection contents.
      -- set("v", "<leader>t", function()
      --   mc.transposeCursors(1)
      -- end)
      -- set("v", "<leader>T", function()
      --   mc.transposeCursors(-1)
      -- end)

      -- Jumplist support
      set({ "v", "n" }, "<c-i>", mc.jumpForward)
      set({ "v", "n" }, "<c-o>", mc.jumpBackward)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
  {
    "gbprod/yanky.nvim",
    keys = {
      {
        "<leader>p",
        false,
        mode = { "n", "x" },
      },
      {
        "<leader>sy",
        function()
          if LazyVim.has("telescope.nvim") then
            require("telescope").extensions.yank_history.yank_history({})
          end
        end,
        desc = "Search Yank History",
        mode = { "n", "x" },
      },
    },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    optional = true,
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      if LazyVim.has("telescope.nvim") then
        require("telescope").load_extension("textcase")
      end
    end,
    keys = {
      "ga", -- Default invocation prefix
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = {
      -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
    -- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
    -- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
    -- available after the first executing of it or after a keymap of text-case.nvim has been used.
    -- WARN:may be a problem
    event = "VeryLazy",
    -- lazy = false,
  },
  {
    "mbbill/undotree",
    init = function()
      local state_dir = vim.fn.stdpath("state") .. "undotree"

      vim.fn.mkdir(state_dir, "p")
      vim.g.undodir = state_dir
      vim.g.undotree_WindowLayout = 4
    end,
    keys = {
      {
        "<leader>su",
        "<CMD>UndotreeToggle<CR>",
        desc = "Search Undo History",
        mode = "n",
      },
    },
  },
  {
    "monaqa/dial.nvim",
    optional = true,
    opts = function(_, opts)
      opts.dials_by_ft.query = "scm"
      local augend = require("dial.augend")

      LazyVim.extend(opts, "groups.scm", { augend.integer.alias.decimal_int })
      LazyVim.extend(opts, "groups.markdown", {
        augend.constant.new({
          elements = { "[]", "[x]" },
          cyclic = false,
          word = false,
          match_before_cursor = true,
        }),
      })
    end,
  },
}
