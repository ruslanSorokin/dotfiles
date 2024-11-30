local capture = {
  arg_outer = "@parameter.outer",
  arg_inner = "@parameter.inner",

  var_outer = "@variable.outer",
  var_inner = "@variable.inner",
}

local treesj_rec = { split = { recursive = true } }
local treesj_norec = { split = { recursive = false } }

---@module "lazy"
---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    keys = {
      { "<c-space>", mode = { "n", "x" }, false },
      { "<bs>", mode = "x", false },
      { "ii", mode = { "x" }, false },
      { "ai", mode = { "x" }, false },
    },
    opts = {
      auto_install = false,

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "v=",
          node_incremental = "v=",
          scope_incremental = "v+",
          node_decremental = "v-",
        },
      },
      indent = {
        enabled = false,
      },
      textobjects = {
        enabled = true,
        swap = {
          enable = true,
          swap_next = {
            ["<leader>]a"] = { query = capture.arg_inner, desc = "argument" },
            ["<leader>]v"] = { query = capture.var_inner, desc = "variable" },
          },
          swap_previous = {
            ["<leader>[a"] = { query = capture.arg_inner, desc = "argument" },
            ["<leader>[v"] = { query = capture.var_inner, desc = "variable" },
          },
        },
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["a="] = { query = "@assignment.outer", desc = "assignment" },
            ["i="] = { query = "@assignment.inner", desc = "assignment" },
            ["[="] = { query = "@assignment.lhs", desc = "assignment" },
            ["]="] = { query = "@assignment.rhs", desc = "assignment" },

            ["ac"] = { query = "@class.outer", desc = "class" },
            ["ic"] = { query = "@class.inner", desc = "class" },

            ["af"] = { query = "@function.outer", desc = "function" },
            ["if"] = { query = "@function.inner", desc = "function" },

            ["aa"] = { query = capture.arg_outer, desc = "argument" },
            ["ia"] = { query = capture.arg_inner, desc = "argument" },

            ["av"] = { query = capture.var_outer, desc = "variable" },
            ["iv"] = { query = capture.var_inner, desc = "variable" },
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "printf",
        -- "comment", // might be: https://github.com/nvim-treesitter/nvim-treesitter/issues/5057

        "kdl",
        "proto",
        "hjson",

        "graphql",
        "hurl",
        "http",

        "gotmpl",
        "just",
        "awk",
        "gpg",
        "ssh_config",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    optional = true,
    opts = {},
    keys = {
      {
        "<leader>u`",
        "<CMD>TSContextToggle<CR>",
        silent = true,
        desc = "Toggle Context",
      },
      {
        "z`",
        "<CMD>lua require('treesitter-context').go_to_context()<CR>",
        silent = true,
        desc = "Go to Context",
      },
    },
  },
  {
    "Wansmer/treesj",
    keys = function()
      local treesj = require("treesj")
      local treesj_langs = require("treesj.langs")["presets"]
      local mini = require("mini.splitjoin")
      local ts_util = require("util.ts")

      return {
        "<leader>t",
        {
          mode = "n",
          "<leader>tt",
          function()
            local lang = ts_util.language_under_cursor()
            if lang and treesj_langs[lang] then
              treesj.toggle(treesj_norec)
            else
              mini.toggle()
            end
          end,
          desc = "SplitJoin: toggle",
        },
        {
          mode = "n",
          "<leader>tT",
          function()
            local lang = ts_util.language_under_cursor()
            if lang and treesj_langs[lang] then
              treesj.toggle(treesj_rec)
            else
              mini.toggle()
            end
          end,
          desc = "SplitJoin: toggle recursively",
        },
        {
          mode = "n",
          "<leader>tj",
          function()
            local lang = ts_util.language_under_cursor()
            if lang and treesj_langs[lang] then
              treesj.join()
            else
              mini.join()
            end
          end,
          desc = "SplitJoin: join",
        },
        {
          mode = "n",
          "<leader>tJ",
          function()
            local lang = ts_util.language_under_cursor()
            if lang and treesj_langs[lang] then
              treesj.join()
            else
              mini.join()
            end
          end,
          desc = "SplitJoin: join recursively",
        },
        {
          mode = "n",
          "<leader>ts",
          function()
            local lang = ts_util.language_under_cursor()
            if lang and treesj_langs[lang] then
              treesj.split(treesj_norec)
            else
              mini.split()
            end
          end,
          desc = "SplitJoin: split",
        },
        {
          mode = "n",
          "<leader>tS",
          function()
            local lang = ts_util.language_under_cursor()
            if lang and treesj_langs[lang] then
              treesj.split(treesj_rec)
            else
              mini.split()
            end
          end,
          desc = "SplitJoin: split recursively",
        },
      }
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.splitjoin" },
    opts = {
      use_default_keymaps = false,
    },
  },
  {
    "echasnovski/mini.splitjoin",
    keys = function()
      local mini_splitjoin = require("mini.splitjoin")
      -- TODO: Find a way to remove selection aftermath

      return {
        "<leader>t",
        {
          mode = "v",
          "<leader>tt",
          function()
            mini_splitjoin.toggle()
          end,
          desc = "SplitJoin: toggle",
        },
        {
          mode = "v",
          "<leader>tT",
          function()
            mini_splitjoin.toggle()
          end,
          desc = "SplitJoin: toggle recursively",
        },
        {
          mode = "v",
          "<leader>tj",
          function()
            mini_splitjoin.join()
          end,
          desc = "SplitJoin: join",
        },
        {
          mode = "v",
          "<leader>tJ",
          function()
            mini_splitjoin.join({})
          end,
          desc = "SplitJoin: join recursively",
        },
        {
          mode = "v",
          "<leader>ts",
          function()
            mini_splitjoin.split()
          end,
          desc = "SplitJoin: split",
        },
        {
          mode = "v",
          "<leader>tS",
          function()
            mini_splitjoin.split()
          end,
          desc = "SplitJoin: split recursively",
        },
      }
    end,
    opts = {
      mappings = { toggle = "", split = "", join = "" },
    },
  },
  {
    "Wansmer/sibling-swap.nvim",
    keys = {
      {
        mode = "n",
        "<leader>]]",
        function()
          require("sibling-swap.swap").swap_with("right", false)
        end,
        desc = "Swap with right sibling",
      },
      {
        mode = "n",
        "<leader>[[",
        function()
          require("sibling-swap.swap").swap_with("left", false)
        end,
        desc = "Swap with left sibling",
      },
      {
        mode = "n",
        "<leader>}}",
        function()
          require("sibling-swap.swap").swap_with("right", true)
        end,
        desc = "Swap with right sibling and invert the sign",
      },
      {
        mode = "n",
        "<leader>{{",
        function()
          require("sibling-swap.swap").swap_with("left", true)
        end,
        desc = "Swap with left sibling and invert the sign",
      },
    },
    opts = {
      use_default_keymaps = false,
      -- Highlight recently swapped node. Can be boolean or table
      -- If table: { ms = 500, hl_opts = { link = 'IncSearch' } }
      -- `hl_opts` is a `val` from `nvim_set_hl()`
      highlight_node_at_cursor = false,
    },
  },
  {
    "andymass/vim-matchup",
    lazy = false,
    keys = { "%" },
    config = function(_, _)
      vim.g.matchup_text_obj_linewise_operators = { "c", "v", "y", "d" }
    end,
  },
}
