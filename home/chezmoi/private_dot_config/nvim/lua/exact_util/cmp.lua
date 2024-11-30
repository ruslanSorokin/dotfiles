local M = {}

---@param parser vim.treesitter.LanguageTree
---@param cursor lsp.Position
M.language_under_cursor = function(parser, cursor)
  local row, col = cursor.line, cursor.character

  local lang_tree = parser:language_for_range({ row, col, row, col })
  if lang_tree then
    return lang_tree:lang()
  end

  return nil
end

M.entry_filter_for_injected = function(lang)
  ---@module "cmp"
  ---@param _ cmp.Entry
  ---@param ctx cmp.Context
  return function(_, ctx)
    local ok, parser = pcall(vim.treesitter.get_parser, ctx.bufnr)
    if not ok or not parser then
      return false
    end

    local cursor = ctx.cursor
    if type(cursor) == "vim.Position" then
      cursor = require("cmp.types.lsp").Position.to_lsp(ctx.bufnr, cursor)
    end

    -- return M.language_under_cursor(parser, cursor) == lang
    return require("util.ts").language_under_cursor({ row = cursor.line, col = cursor.character }, ctx.bufnr) == lang
  end
end

return M
