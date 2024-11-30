-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local ts = vim.treesitter.query
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set
local autocmd_group = vim.api.nvim_create_augroup
local util = require("util.ts")

local chezmoi_ft_overrides = {
  fish = "fish",
  conf = "conf",
  nix = "nix",
  lua = "lua",

  bash = "bash",
  sh = "bash",
  zsh = "bash",

  yaml = "yaml",
  toml = "toml",
  json = "json",
  config = "config",

  gpg = "gpg",
  sshconfig = "sshconfig",
  gitconfig = "gitconfig",
  gitignore = "gitignore",
}

local gotmpl_directly_injectable_queries = {
  "conf",
  "config",
  "gpg",
  "sshconfig",
  "gitconfig",
  "gitignore",
  "yaml",
}

for _, lang in pairs(gotmpl_directly_injectable_queries) do
  gotmpl_directly_injectable_queries[lang] = util.build_gotmpl_injections_query_for(lang)
end

---@param bufnr integer
---@param lang string
---@return string
---@return fun()
local gotmpl_composite_ft_and_buf_callback = function(bufnr, lang)
  return "gotmpl." .. lang,
    function()
      local old_query_files = ts.get_files("gotmpl", "injections", nil)
      local old_query = require("util.ts").read_query_files(old_query_files)
      ts.set("gotmpl", "injections", require("util.ts").build_gotmpl_injections_query_for(lang))

      autocmd("BufLeave", {
        buffer = bufnr,
        once = true,
        callback = function()
          ts.set("gotmpl", "injections", old_query)
        end,
      })
    end
end

---@param bufnr integer
---@param filename string
---@param lang string
---@return boolean
local function chezmoi_config(bufnr, filename, lang)
  local is_chezmoi_config = filename:match(".*%.chezmoi%.(.*)%.tmpl") == ""

  if is_chezmoi_config then
    local ft, callback = gotmpl_composite_ft_and_buf_callback(bufnr, lang)
    callback()
    vim.bo[bufnr].filetype = ft
  end

  return is_chezmoi_config
end

---@param info vim.api.keyset.hl_info
---@return vim.api.keyset.highlight
local function hl_info_to_opts(info)
  local cterm_fg
  local cterm_bg

  if info.cterm then
    cterm_fg = info.cterm.foreground
    cterm_bg = info.cterm.background
  end

  return {
    fg = info.fg,
    bg = info.bg,
    sp = info.sp,
    blend = info.blend,
    bold = info.bold,
    standout = info.standout,
    underline = info.underline,
    undercurl = info.undercurl,
    underdouble = info.underdouble,
    underdotted = info.underdotted,
    underdashed = info.underdashed,
    strikethrough = info.strikethrough,
    italic = info.italic,
    reverse = info.reverse,
    nocombine = info.nocombine,
    link = info.link,
    default = info.default,
    ctermfg = cterm_fg,
    ctermbg = cterm_bg,
    cterm = info.cterm,
    force = true,
  }
end

---@param bufnr integer
---@param lang string
---@return boolean
local function gotmpl_directly_injectable(bufnr, lang)
  local query = gotmpl_directly_injectable_queries[lang]
  if not query then
    return false
  end

  local ft, callback = gotmpl_composite_ft_and_buf_callback(bufnr, lang)
  callback()
  vim.bo[bufnr].filetype = ft

  local parser = require("util.ts").get_parser(bufnr)
  if not parser then
    return false
  end

  if require("util.ts").buf_has_injections(parser) then
    local old_hl_group = vim.api.nvim_get_hl(0, { name = "@string.gotmpl" })

    -- TODO: till neovim gives ability to deal with overlapping highlight groups
    vim.api.nvim_set_hl(0, "@string.gotmpl", {})

    autocmd("BufLeave", {
      buffer = bufnr,
      -- once = true,
      callback = function()
        vim.api.nvim_set_hl(0, "@string.gotmpl", hl_info_to_opts(old_hl_group))
      end,
    })
  end

  return true
end

autocmd("FileType", {
  pattern = "*chezmoitmpl",
  callback = function(args)
    vim.schedule(function()
      if vim.bo[args.buf].filetype == "chezmoitmpl" then
        vim.bo[args.buf].filetype = "gotmpl"
        return
      end

      local lang = vim.bo[args.buf].filetype:match("(.*)%.chezmoitmpl")
      lang = chezmoi_ft_overrides[lang]
      if not lang then
        return
      end

      if chezmoi_config(args.buf, args.file, lang) then
        return
      end

      if gotmpl_directly_injectable(args.buf, lang) then
        return
      end

      vim.bo[args.buf].filetype = lang
    end)
  end,
  desc = "Change 'chezmoi' filetype to original extension",
})

---@param start integer
local make_priority_seq = function(start)
  return function()
    local cur = start
    start = start - 1
    return cur
  end
end

local priority_seq = make_priority_seq(1000)

local filetype = function(rhs)
  return { rhs, { priority = priority_seq() } }
end

vim.filetype.add({
  filename = {
    [".chezmoiignore"] = function(_, bufnr)
      return gotmpl_composite_ft_and_buf_callback(bufnr, "gitignore")
    end,
    ["FILE_COLORS"] = "config",
    ["LS_COLORS"] = "config",
    ["EZA_COLORS"] = "config",
  },

  pattern = {
    [".*/%.chezmoi%.(....?)%.tmpl"] = filetype(function(_, bufnr, ft)
      if vim.iter({ "yaml", "yml", "toml", "json" }):find(ft) then
        return gotmpl_composite_ft_and_buf_callback(bufnr, ft)
      end
    end),

    [".*ssh.*/config.*"] = filetype(function(_, _)
      return "sshconfig"
    end),

    [".*gpg.*/config.*"] = filetype(function(_, _)
      return "gpg"
    end),

    [".*/.chezmoitemplates/[^%..*]%.tmpl"] = filetype(function(_, _)
      return "gotmpl"
    end),

    ["(.*)%.tmpl"] = filetype(function(_, bufnr, filename)
      return vim.filetype.match({ buf = bufnr, filename = filename })
    end),
  },
  extension = {
    ["config"] = "config",
    -- ["tmpl"] = "gotmpl",
  },
})

-- autocmd({
--   "CursorMoved",
--   "CursorMovedI",
--   "CursorHold",
--   "CursorHoldI",
-- }, {
--   callback = function(ev)
--     local ok, parser = pcall(vim.treesitter.get_parser, ev.buf)
--     if not ok or not parser then
--       return false
--     end
--
--     local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--     if require("util.ts").get_language_under_cursor(parser, { col = col - 1, row = row }) == "sql" then
--       vim.b.dadbod_cmp_enable = true
--     else
--       vim.b.dadbod_cmp_enable = false
--     end
--   end,
--   desc = "Enable dadbod-completion outside when injected SQL under cursor",
-- })

autocmd("FileType", {
  pattern = "go",
  group = autocmd_group("filetypedetect", { clear = false }),
  callback = function(_)
    --TODO: auto-fold `if err != nil`
    --probably with help of treesitter
    -- vim.cmd("g/\\s*if err /normal za")
  end,
})

local cmd_case = autocmd_group("cmd_case_sensitiveness", {})
autocmd("CmdLineEnter", {
  callback = function()
    vim.opt.ignorecase = true
  end,
  group = cmd_case,
  desc = "Enable 'ignorecase' in command line",
})

autocmd("CmdLineLeave", {
  callback = function()
    vim.opt.ignorecase = false
  end,
  group = cmd_case,
  desc = "Enable 'ignorecase' in command line",
})

autocmd("ColorScheme", {
  callback = function(_)
    vim.api.nvim_set_hl(0, "@lsp.type.string.go", {})
    vim.api.nvim_set_hl(0, "@lsp.type.comment.lua", {})
  end,
  group = autocmd_group("lsp_treesitter_injections_interlop", {}),
  desc = "Disable lsp highlight groups that overlap with injected TS languages",
})

autocmd("TermEnter", {
  callback = function(ev)
    map("t", "<C-l>", "<C-l>", { buffer = ev.buf, nowait = true })
    map("t", "<C-k>", "<C-k>", { buffer = ev.buf, nowait = true })
    map("t", "<C-j>", "<C-j>", { buffer = ev.buf, nowait = true })
    map("t", "<C-h>", "<C-h>", { buffer = ev.buf, nowait = true })
    map("t", "<C-r>", "<C-r>", { buffer = ev.buf, nowait = true })
  end,
  desc = "Disable mappings that overlap with terminal ones",
})

autocmd("FileType", {
  pattern = "lua",
  callback = function(ev)
    map("n", "<Leader>rr", ":.lua<CR>", { desc = "Run: current line as lua code", buffer = ev.buf, nowait = true })
    map("v", "<Leader>rr", ":lua<CR>", { desc = "Run: selection as lua code", buffer = ev.buf, nowait = true })
  end,
  desc = "Add mappings to run lua code",
})

autocmd("Filetype", {
  callback = function(_)
    vim.b.dadbod_cmp_enable = true
  end,
  desc = "Enable dadbod-completion outside of SQL files",
})

autocmd("BufRead", {
  callback = function(args)
    if vim.bo[args.buf].buftype == "quickfix" then
      vim.schedule(function()
        vim.cmd([[cclose]])
        vim.cmd([[Trouble qflist open]])
      end)
    end
  end,
  desc = "Use Trouble Quickfix List by default",
})

autocmd("BufDelete", {
  callback = function()
    vim.schedule(function()
      local buffers = vim.fn.getbufinfo({ buflisted = 1 })

      if #buffers == 1 and buffers[1].name == "" then
        require("snacks.dashboard").open()
      end
    end)
  end,
  desc = "Open Dashboard after closing last buffer",
})
