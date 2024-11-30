---@module "lazy"
---@type LazySpec
return {
  { import = "lazyvim.plugins.extras.ui.treesitter-context" },
  { import = "lazyvim.plugins.extras.ui.indent-blankline" },

  -- TODO: make PR's
  { import = "extras.harpoon2" },
  { import = "extras.mini-move" },
  { import = "extras.yazi" },
  { import = "extras.go" },

  { import = "lazyvim.plugins.extras.editor.harpoon2" },
  { import = "lazyvim.plugins.extras.editor.overseer" },
  { import = "lazyvim.plugins.extras.editor.navic" },
  { import = "lazyvim.plugins.extras.editor.dial" },
  { import = "lazyvim.plugins.extras.editor.mini-diff" },
  { import = "lazyvim.plugins.extras.editor.refactoring" },
  { import = "lazyvim.plugins.extras.editor.illuminate" },

  { import = "lazyvim.plugins.extras.editor.outline" },
  { import = "lazyvim.plugins.extras.editor.aerial" },

  -- { import = "lazyvim.plugins.extras.coding.luasnip" },
  { import = "lazyvim.plugins.extras.coding.mini-comment" },
  { import = "lazyvim.plugins.extras.coding.mini-surround" },
  { import = "lazyvim.plugins.extras.coding.yanky" },
  { import = "lazyvim.plugins.extras.coding.neogen" },

  { import = "lazyvim.plugins.extras.lang.angular" },

  { import = "lazyvim.plugins.extras.lang.thrift" },
  { import = "lazyvim.plugins.extras.util.rest" },

  { import = "lazyvim.plugins.extras.lang.elixir" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.zig" },
  { import = "lazyvim.plugins.extras.lang.ruby" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "lazyvim.plugins.extras.lang.sql" },

  { import = "lazyvim.plugins.extras.lang.omnisharp" },
  { import = "lazyvim.plugins.extras.lang.scala" },
  { import = "lazyvim.plugins.extras.lang.java" },

  -- WARN: HTTP 404
  -- { import = "lazyvim.plugins.extras.lang.terraform" },
  { import = "lazyvim.plugins.extras.lang.ansible" },
  { import = "lazyvim.plugins.extras.lang.docker" },
  { import = "lazyvim.plugins.extras.lang.helm" },

  -- WARN: Cargo exit code 101 and signal 0
  -- { import = "lazyvim.plugins.extras.lang.nix" },
  { import = "lazyvim.plugins.extras.util.dot" },

  { import = "lazyvim.plugins.extras.lang.git" },
  { import = "lazyvim.plugins.extras.lang.nushell" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
  { import = "lazyvim.plugins.extras.lang.toml" },
}
