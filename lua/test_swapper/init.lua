local module = require("test_swapper.module")

---@class MyModule
local M = {}

_G.TestSwapper = M

M.swap_test_or_cpp = function()
  return module.swap_test_or_cpp()
end

return M
