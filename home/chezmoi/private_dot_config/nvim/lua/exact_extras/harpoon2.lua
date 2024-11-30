---@module "lazy"
---@type LazySpec
return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = function()
      local harpoon = require("harpoon") ---@module "harpoon"

      local keys = {
        {
          "<leader>H",
          function()
            harpoon:list():add()
            require("bufferline.ui").refresh()
          end,
          desc = "Harpoon File",
        },
        {
          "<leader>h",
          function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Quick Menu",
        },
      }

      for i = 1, 5 do
        table.insert(keys, {
          "<leader>" .. i,
          function()
            if vim.bo.filetype == "neo-tree" then
              require("neo-tree.command").execute({ action = "close" })
            end

            harpoon:list():select(i)
          end,
          desc = "Harpoon to File " .. i,
        })
      end

      return keys
    end,
  },
  {
    "akinsho/bufferline.nvim",
    optional = true,
    ---@param opts bufferline.Config
    opts = function(_, opts)
      opts.options = {
        ---@param buf_opts {ordinal: number, id: number, lower: any, raise: any}
        numbers = function(buf_opts)
          local marks = require("harpoon"):list().items
          local bufname = vim.fn.fnamemodify(vim.fn.bufname(buf_opts.id), ":p")

          for i, mark in ipairs(marks) do
            if bufname == vim.fn.fnamemodify(mark.value, ":p") then
              return tostring(i)
            end
          end

          return ""
        end,
      }
    end,
  },
}
