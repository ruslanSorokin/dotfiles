---@module "lazy"
---@type LazySpec
return {
  {
    "chrisgrieser/nvim-spider",
    keys = {
      {
        mode = { "n", "o", "x" },
        "w",
        "<CMD> lua require('spider').motion('w') <CR>",
        { desc = "Spider-w" },
      },
      {
        mode = { "n", "o", "x" },
        "e",
        "<CMD> lua require('spider').motion('e') <CR>",
        { desc = "Spider-e" },
      },
      {
        mode = { "n", "o", "x" },
        "ge",
        "<CMD> lua require('spider').motion('ge') <CR>",
        { desc = "Spider-ge" },
      },
      {
        mode = { "n", "o", "x" },
        "b",
        "<CMD> lua require('spider').motion('b') <CR>",
        { desc = "Spider-b" },
      },
    },
    opts = {
      skipInsignificantPunctuation = true,
    },
  },
  {
    "echasnovski/mini.operators",
    opts = {
      evaluate = {
        prefix = "g=",
        -- func = nil,
      },

      multiply = {
        prefix = "gC",
        -- func = nil,
      },

      -- Exchange text regions
      exchange = {
        prefix = "gX",

        -- Whether to reindent new text to match previous indent
        reindent_linewise = true,
      },

      -- Replace text with register
      replace = {
        prefix = "gR",

        -- Whether to reindent new text to match previous indent
        reindent_linewise = true,
      },

      -- Sort text
      sort = {
        prefix = "gS",
        -- func = nil,
      },
    },
  },
  {
    "folke/snacks.nvim",
    optional = true,
    --INFO: doesn't work in 'Go'
    opts = { scope = { enabled = false } },
  },
  {
    "urxvtcd/vim-indent-object",
    lazy = false,
    keys = {
      { mode = { "o", "x" }, "ii", "<Plug>(indent-object_linewise-none)" },
      { mode = { "o", "x" }, "iI", "<Plug>(indent-object_linewise-end)" },
      { mode = { "o", "x" }, "ai", "<Plug>(indent-object_linewise-both)" },
      { mode = { "o", "x" }, "aI", "<Plug>(indent-object_linewise-start)" },
    },
  },
}
