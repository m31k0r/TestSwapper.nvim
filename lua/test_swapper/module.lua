local Snacks = require("snacks")

---@class CustomModule
local M = {}

M.swap_test_or_cpp = function()
  local current = vim.api.nvim_buf_get_name(0)

  if current == "" then
    return
  end

  local filename = vim.fn.fnamemodify(current, ":t")
  local directory = vim.fn.fnamemodify(current, ":p:h")

  local base = filename:match("^(.*)%.([ch]pp)$")
  if not base then
    vim.notify("Not a .cpp/.hpp file", vim.log.levels.INFO)
    vim.notify(filename, vim.log.levels.INFO)
    return
  end

  local candidates

  if base:sub(-5) == "_test" then
    -- xxxxxx_test.cpp -> xxxxxx.hpp, then xxxxxx.cpp
    local source_base = base:sub(1, -6)

    candidates = {
      source_base .. ".hpp",
      source_base .. ".cpp",
    }
  else
    -- xxxxxx.cpp/hpp -> xxxxxx_test.cpp
    candidates = {
      base .. "_test.cpp",
      base .. "_tests.cpp",
    }
  end

  local buffers = vim.api.nvim_list_bufs()

  -- First: prefer a buffer in the same directory.
  for _, candidate in ipairs(candidates) do
    local candidate_path = vim.fs.normalize(directory .. "/" .. candidate)

    for _, buf in ipairs(buffers) do
      if vim.api.nvim_buf_is_loaded(buf) then
        local bufname = vim.api.nvim_buf_get_name(buf)

        if vim.fs.normalize(bufname) == candidate_path then
          vim.api.nvim_set_current_buf(buf)
          return
        end
      end
    end
  end

  -- Fallback: match by filename anywhere in the open buffers.
  for _, candidate in ipairs(candidates) do
    for _, buf in ipairs(buffers) do
      if vim.api.nvim_buf_is_loaded(buf) then
        local bufname = vim.api.nvim_buf_get_name(buf)

        if vim.fn.fnamemodify(bufname, ":t") == candidate then
          vim.api.nvim_set_current_buf(buf)
          return
        end
      end
    end
  end

  vim.notify("Buffer not open: " .. table.concat(candidates, " / "), vim.log.levels.INFO)
  Snacks.picker.smart({ pattern = candidates[1] })
end

return M
