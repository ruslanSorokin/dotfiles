---@module "lazy"
---@type LazySpec
return {
  { import = "lazyvim.plugins.extras.util.chezmoi" },
  {
    "xvzc/chezmoi.nvim",
    optional = true,
    enabled = false,
  },
  {
    "alker0/chezmoi.vim",
    optional = true,
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = 1
    end,
  },
}
