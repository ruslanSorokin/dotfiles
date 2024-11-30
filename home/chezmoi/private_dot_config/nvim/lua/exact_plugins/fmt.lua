---@module "lazy"
---@type LazySpec
return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        toml = { "taplo" },
        lua = { "stylua" },
        kdl = { "kdlfmt" },
        sql = { "pg_format" },
        fish = { "fish_indent" },
        ["gotmpl.fish"] = { "fish_indent" },
        go = { "gofumpt", "goimports-reviser", "golines", "injected" },
      },
      formatters = {
        ---@module "conform"
        ---@type conform.FormatterConfigOverride
        injected = {
          options = {
            ignore_errors = true,
            lang_to_formatters = {
              json = { "jq" },
              sql = { "pg_format" },
              fish = { "fish_indent" },
            },
          },
        },
        ---@module "conform"
        ---@type conform.FormatterConfigOverride
        pg_format = {
          prepend_args = { "-c", vim.fn.expand("~/.config/pg_format/pg_format.conf") },
        },
      },
    },
  },
}
