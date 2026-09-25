local function ensure_plugin(path, url)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.system({"git", "clone", "https://github.com/" .. url, path})
  end

  if vim.fn.isdirectory(path) == 0 then
    error("failed to prepare plugin dependency: " .. url)
  end

  vim.opt.rtp:append(path)
end

local plenary_dir = os.getenv("PLENARY_DIR") or "/tmp/plenary.nvim"
local snacks_dir = os.getenv("SNACKS_DIR") or "/tmp/snacks.nvim"

vim.opt.rtp:append(".")
ensure_plugin(plenary_dir, "nvim-lua/plenary.nvim")
ensure_plugin(snacks_dir, "folke/snacks.nvim")

vim.cmd("runtime plugin/plenary.vim")
require("plenary.busted")
