---@module "lazy"
---@type LazySpec
return {
  {
    "crispgm/nvim-go",
    config = function(_, opts)
      local go = require("go")
      go.setup(opts)
      go.config.update_tool("quicktype", function(tool)
        tool.pkg_mgr = "pnpm"
      end)
    end,
    build = ":GoInstallBinaries",
  },
  {
    "crispgm/nvim-go",
    opts = {
      auto_format = false,
      auto_lint = false,
    },
  },
}
