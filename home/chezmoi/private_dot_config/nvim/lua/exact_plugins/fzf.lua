---@module "lazy"
---@type LazySpec
return {
  {
    "ibhagwan/fzf-lua",
    opts = function()
      local actions = require("fzf-lua.actions")
      return {
        files = {
          cwd_prompt = false,
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-."] = { actions.toggle_hidden },
          },
        },
        grep = {
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-."] = { actions.toggle_hidden },
          },
          rg_glob = true,
        },
      }
    end,
  },
}
