local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      codelenses = { upgradeDependency = true },
      staticcheck = true,
      completeUnimported = true,
      usePlaceholders = false,
      analyses = { unusedparams = true },
    },
  },
}

lspconfig.graphql.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "graphql-lsp" },
  filetypes = { "typescript", "typescriptreact", "graphql" },
  root_dir = util.root_pattern(".git", ".graphqlrc*", ".graphql.config.*", "graphql.config.*"),
}

lspconfig.sqlls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "sql-language-server", "up", "--method", "stdio" },
  filetypes = { "sql" },
}

lspconfig.bufls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "bufls", "serve" },
  filetypes = { "proto" },
  root_dir = util.root_pattern("buf.work.yaml", "buf.yaml", ".git"),
}
