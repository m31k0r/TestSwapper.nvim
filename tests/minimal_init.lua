local function ensure_plugin(path, url)
  local clone_output
  local clone_exit_code
  if vim.fn.isdirectory(path) == 0 then
    clone_output = vim.fn.system({"git", "clone", "https://github.com/" .. url, path})
    clone_exit_code = vim.v.shell_error
  end

  if vim.fn.isdirectory(path) == 0 then
    error(
      "failed to prepare plugin dependency: "
        .. url
        .. " (exit code "
        .. (clone_exit_code or "unknown")
        .. ")\n"
        .. (clone_output or "")
    )
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
