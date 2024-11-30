local M = {}

M.enabled_for_injected = function(lang)
  ---@module "blink.cmp"
  ---@param ctx? blink.cmp.Context
  return function(ctx)
    if ctx == nil then
      return false
    end

    local row, col = unpack(ctx.cursor)
    return require("util.ts").language_under_cursor({ row = row - 1, col = col }, ctx.bufnr) == lang
  end
end

return M
