---@param lang string
local function as_embedded(lang)
  local host_langs = {
    "gotmpl",
  }

  local filetypes = { lang }
  for _, host_lang in ipairs(host_langs) do
    table.insert(filetypes, host_lang .. "." .. lang)
  end

  return filetypes
end

---@module "lazy"
---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      inlay_hints = { enabled = false },
    },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = function(_, opts)
      LazyVim.extend(opts, "servers.lua_ls.filetypes", as_embedded("lua"))
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    ---@module "lspconfig"
    ---@param opts {servers: {bashls: lspconfig.Config}}
    opts = function(_, opts)
      LazyVim.extend(opts, "servers.bashls.filetypes", as_embedded("sh"))
      LazyVim.extend(opts, "servers.bashls.filetypes", as_embedded("zsh"))
      opts.servers.bashls.settings = {
        -- false positives in `source "correct_path"`
        enableSourceErrorDiagnostics = false,
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = function(_, opts)
      LazyVim.extend(opts, "servers.fish_lsp.filetypes", as_embedded("fish"))
      opts.servers.fish_lsp.cmd_env = {
        -- false positives in `source "correct_path"`
        fish_lsp_diagnostic_disable_error_codes = 1004,
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = function(_, opts)
      if not opts.servers.gopls then
        return
      end

      opts.servers.gopls = {
        filetypes = { "go", "gomod", "gowork" },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = function(_, opts)
      LazyVim.extend(opts, "servers.taplo.filetypes", as_embedded("toml"))
      opts.servers.taplo.root_dir = function(_)
        return vim.fs.root(0, { ".git", ".taplo.toml", "taplo.toml" })
          or vim.fs.root(0, function(name, _)
            return name:match("%.*.toml$") ~= nil
          end)
      end
    end,
  },
}
