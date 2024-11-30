---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "<leader>y",
      "<CMD>Yazi<CR>",
      desc = "Open Yazi (cwd)",
    },
    {
      -- Open in the current working directory
      "<leader>Y",
      "<CMD>Yazi cwd<CR>",
      desc = "Open Yazi (Root Dir)",
    },
    {
      -- NOTE: this requires a version of yazi that includes
      -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
      "<leader><C-y>",
      "<CMD>Yazi toggle<CR>",
      desc = "Resume Yazi",
    },
  },
  ---@module "yazi.config"
  ---@type YaziConfig
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      show_help = "<F1>",
    },
  },
}
