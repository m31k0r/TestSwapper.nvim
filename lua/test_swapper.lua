-- main module file
local module = require("test_swapper.module")

---@class Config
---@field opt string Your config option
local config = {}

---@class MyModule
local M = {}

---@type Config
M.config = config

M.swap_test_or_cpp = function()
  return module.swap_test_or_cpp()
end

return M
