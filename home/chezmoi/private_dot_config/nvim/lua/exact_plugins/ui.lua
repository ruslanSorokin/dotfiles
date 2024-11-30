---@module "lazy"
---@type LazySpec
return {
  -- { "datsfilipe/vesper.nvim", lazy = false },
  -- { "ellisonleao/gruvbox.nvim", lazy = false },
  { "sainnhe/everforest", lazy = false },
  { "catppuccin/nvim", name = "catppuccin", lazy = false },
  { "dracula/vim", name = "dracula", lazy = false },
  { "romgrk/doom-one.vim", lazy = false },
  { "loctvl842/monokai-pro.nvim", lazy = false },
  { "rose-pine/neovim", name = "rose-pine", lazy = false },
  {
    "LazyVim/LazyVim",
    -- optional = true,
    ---@module "lazyvim"
    ---@type LazyVimConfig
    opts = {
      colorscheme = "tokyonight-moon",
      icons = {
        kinds = {
          Array = " ",
          Boolean = "󰨙 ",
          Class = " ",
          Codeium = "󰘦 ",
          Color = " ",
          Control = " ",
          Collapsed = " ",
          Constant = "󰏿 ",
          Constructor = " ",
          Copilot = " ",
          Enum = " ",
          EnumMember = " ",
          Event = " ",
          Field = " ",
          File = " ",
          Folder = " ",
          Function = "󰊕 ",
          Interface = " ",
          Key = "󰉿 ",
          Keyword = " ",
          Method = "󰡱 ",
          Module = " ",
          Namespace = "󰦮 ",
          Null = " ",
          Number = "󰎠 ",
          Object = " ",
          Operator = " ",
          Package = " ",
          Property = " ",
          Reference = " ",
          Snippet = "󱄽 ",
          String = " ",
          Struct = "󰆼 ",
          Supermaven = " ",
          TabNine = "󰏚 ",
          Text = "󰉿 ",
          TypeParameter = " ",
          Unit = " ",
          Value = "󰉿 ",
          Variable = "󰫧 ",
        },
      },
    },
  },
  {
    "echasnovski/mini.icons",
    opts = {
      filetype = {
        gotmpl = { glyph = "󱄽", hl = "MiniIconsGrey" },
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    optional = true,
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = {
      sections = {
        lualine_y = { "encoding", "fileformat", "filetype" },
        lualine_z = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts = {
      close_if_last_window = true,
      window = { position = "right" },
    },
  },
  {
    "folke/trouble.nvim",
    optional = true,
    keys = {
      -- Use uppercase for standard lists
      { "<leader>xX", "<CMD>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
      { "<leader>xx", "<CMD>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<CMD>Trouble symbols toggle<CR>", desc = "Symbols (Trouble)" },
      { "<leader>cS", "<CMD>Trouble lsp toggle<CR>", desc = "LSP references/definitions/... (Trouble)" },
      { "<leader>xl", "<CMD>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" },
      { "<leader>xq", "<CMD>Trouble qflist toggle<CR>", desc = "Quickfix List (Trouble)" },
      -- Add jump to edges
      {
        "[Q",
        function()
          if require("trouble").is_open() then
            require("trouble").first({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cfirst)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "First Trouble/Quickfix Item",
      },
      {
        "]Q",
        function()
          if require("trouble").is_open() then
            require("trouble").last({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.clast)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Last Trouble/Quickfix Item",
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    optional = true,
    opts = { indent = { tab_char = "║" } },
  },
  {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
      local has_figlet = vim.fn.executable("figlet")
      local has_date = vim.fn.executable("date")

      opts.dashboard = {
        width = 60,
        sections = {
          {
            pane = 1,
            section = "terminal",
            cmd = "date +%A | figlet",
            height = 8,
            enabled = has_figlet and has_date,
            padding = 0,
          },
          {
            pane = 1,
            section = "terminal",
            cmd = "date --rfc-email",
            height = 1,
            enabled = has_date,
            padding = 1,
          },
          { section = "keys", gap = 1, padding = 1 },
          function()
            local in_git = Snacks.git.get_root() ~= nil

            return {
              pane = 2,
              key = "b",
              icon = " ",
              desc = "Browse Repo",
              padding = 1,
              action = function()
                Snacks.gitbrowse()
              end,
              enabled = in_git,
            }
          end,
          function()
            local in_git = Snacks.git.get_root() ~= nil
            local has_gh = vim.fn.executable("gh")

            local cmds = {
              {
                icon = " ",
                title = "Git Status",
                cmd = "hub --no-pager diff --stat -B -M -C",
                height = 10,
                enabled = in_git,
              },
              {
                title = "Notifications",
                pane = 1,
                key = "N",
                cmd = "gh notify -s -a -n5",
                action = function()
                  vim.ui.open("https://github.com/notifications")
                end,
                icon = " ",
                height = 5,
                enabled = has_gh and in_git,
              },
              {
                title = "Open Issues",
                key = "i",
                cmd = "gh issue list -L 3 || true",
                action = function()
                  vim.fn.jobstart("gh issue list --web", { detach = true })
                end,
                icon = " ",
                height = 7,
                enabled = has_gh and in_git,
              },
              {
                icon = " ",
                key = "p",
                title = "Open PRs",
                cmd = "gh pr list -L 3 || true",
                action = function()
                  vim.fn.jobstart("gh pr list --web", { detach = true })
                end,
                height = 7,
                enabled = has_gh and in_git,
              },
            }
            return vim.tbl_map(function(cmd)
              return vim.tbl_extend("force", {
                pane = 2,
                section = "terminal",
                padding = 1,
                ttl = 5 * 60,
                indent = 1,
              }, cmd)
            end, cmds)
          end,
          { section = "startup" },
        },
      }
    end,
  },
  {
    "pogyomo/winresize.nvim",
    keys = function()
      local resize = require("winresize").resize
      return {
        {
          mode = "n",
          "<C-left>",
          function()
            resize(0, 2, "left")
          end,
        },
        {
          mode = "n",
          "<C-down>",
          function()
            resize(0, 1, "down")
          end,
        },
        {
          mode = "n",
          "<C-up>",
          function()
            resize(0, 1, "up")
          end,
        },
        {
          mode = "n",
          "<C-right>",
          function()
            resize(0, 2, "right")
          end,
        },
      }
    end,
  },
  {
    "rmagatti/goto-preview",
    event = "BufEnter",
    config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
    keys = {
      "gh",
      { mode = "n", "ghd", "<CMD>lua require('goto-preview').goto_preview_definition()<CR>" },
      { mode = "n", "ght", "<CMD>lua require('goto-preview').goto_preview_type_definition()<CR>" },
      { mode = "n", "ghi", "<CMD>lua require('goto-preview').goto_preview_implementation()<CR>" },
      { mode = "n", "ghD", "<CMD>lua require('goto-preview').goto_preview_declaration()<CR>" },
      { mode = "n", "gH", "<CMD>lua require('goto-preview').close_all_win()<CR>" },
      { mode = "n", "ghr", "<CMD>lua require('goto-preview').goto_preview_references()<CR>" },
    },
  },
}
