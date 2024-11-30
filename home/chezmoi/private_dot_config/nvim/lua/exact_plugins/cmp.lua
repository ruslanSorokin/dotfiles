local util = require("util.cmp")

---@module "lazy"
---@type LazySpec
return {
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    ---@module "cmp"
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local lspkind = require("lspkind")
      opts.formatting.format = lspkind.cmp_format({
        mode = "codicons",
        show_labelDetails = true,
      })
      return opts
    end,
    dependencies = {
      "onsails/lspkind.nvim",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    ---@module "cmp"
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "fish" })
      table.insert(opts.sources, {
        name = "vim-dadbod-completion",
        entry_filter = util.entry_filter_for_injected("sql"),
      })
    end,
    dependencies = {
      "mtoohey31/cmp-fish",
      "kristijanhusak/vim-dadbod-completion",
    },
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    lazy = true,
    dir = "/home/ruslan/code/vim/vim-dadbod-completion",
    dev = true,
  },
}
