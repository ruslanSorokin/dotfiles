---@module "lazy"
---@type LazySpec
return {
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      -- configuration goes here
    },
  },
}
