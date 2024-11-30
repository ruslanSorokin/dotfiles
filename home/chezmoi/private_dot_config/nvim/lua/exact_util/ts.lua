M = {}

---@param bufnr integer
---@return vim.treesitter.LanguageTree?
M.get_parser = function(bufnr)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok or not parser then
    return nil
  end

  return parser
end

---@param cursor? {row: number, col: number}
---@param bufnr? integer
---@return string?
M.language_under_cursor = function(cursor, bufnr)
  if not cursor then
    local c = vim.api.nvim_win_get_cursor(0)
    cursor = { row = c[1] - 1, col = c[2] }
  end

  if not bufnr then
    bufnr = vim.api.nvim_get_current_buf()
  end

  local parser = M.get_parser(bufnr)
  if not parser then
    return nil
  end

  --    pool.Exec(ctx,
  --      `<here>
  --CREATE DOMAIN monetary AS decimal(16, 2);
  --
  --CREATE CAST (int AS monetary) WITH INOUT AS ASSIGNMENT;
  --<here>`)
  -- INFO: need `row - 1` to work at the beginning and end of tabulated strings
  local r, c = cursor.row, cursor.col

  local lang_tree = parser:language_for_range({ r, c, r, c })
  if lang_tree then
    return lang_tree:lang()
  end

  return nil
end

---@param parser vim.treesitter.LanguageTree
---@return boolean
M.buf_has_injections = function(parser)
  return #parser:children() > 1
end

---@param lang string
---@param parser vim.treesitter.LanguageTree
---@return boolean
M.buf_has_injected = function(lang, parser)
  return vim.iter(parser:children()):find(lang)
end

---@param parser vim.treesitter.LanguageTree
---@return boolean
M.buf_has_injected_sql = function(parser)
  return M.buf_has_injected("sql", parser)
end

---@param lang string
---@return string
M.build_gotmpl_injections_query_for = function(lang)
  return string.format(
    [[
      ; inherits gotmpl
      (
        (text) @injection.content
        (#set! injection.language "%s")
        (#set! injection.combined)
      )

      (
        (raw_string_literal) @injection.content
        (#offset! @injection.content 0 1 0 -1)
        (#set! injection.language "%s")
      )
    ]],
    lang,
    lang
  )
end

M.safe_read = function(filename, read_quantifier)
  local file, err = io.open(filename, "r")
  if not file then
    error(err)
  end
  local content = file:read(read_quantifier)
  io.close(file)
  return content
end

---@param filenames string[]
---@return string
M.read_query_files = function(filenames)
  local contents = {}

  for _, filename in ipairs(filenames) do
    table.insert(contents, M.safe_read(filename, "*a"))
  end

  return table.concat(contents, "")
end

return M
