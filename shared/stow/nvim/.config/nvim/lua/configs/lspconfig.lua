local M = {}
local map = vim.keymap.set

M.on_attach = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP" .. desc }
  end
  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

  map("n", "<leader>ra", function()
    require "nvchad.lsp.renamer" ()
  end, opts "NvRenamer")

  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  map("n", "gr", vim.lsp.buf.references, opts "Show references")
end

local lspconfig = require "lspconfig"

lspconfig.gopls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
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
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  filetypes = { "typescript", "typescriptreact", "graphql" },
}

lspconfig.sqlls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  cmd = { "sql-language-server", "up", "--method", "stdio" },
  filetypes = { "sql" },
}

lspconfig.bufls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  filetypes = { "proto" },
}

lspconfig.yamlls.setup {
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["../path/relative/to/file.yml"] = "/.github/workflows/*",
        ["/path/from/root/of/project"] = "/.github/workflows/*",
      },
    },
  },
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}

lspconfig.csharp_ls.setup {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}
