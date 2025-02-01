-- Set up test environment
local plenary_dir = os.getenv("PLENARY_DIR") or "/tmp/plenary.nvim"

-- Clone plenary if needed
if vim.fn.isdirectory(plenary_dir) == 0 then
  vim.fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/nvim-lua/plenary.nvim",
    plenary_dir,
  })
end

-- Add plugin and plenary to runtimepath
vim.opt.rtp:append(".")
vim.opt.rtp:append(plenary_dir)

-- Set up busted
_G.describe = require('plenary.busted').describe
_G.it = require('plenary.busted').it
_G.assert = require('luassert')
_G.before_each = require('plenary.busted').before_each
_G.after_each = require('plenary.busted').after_each

-- Run all test files
local function scan_dir(directory)
  local i, t = 0, {}
  local pfile = io.popen('find "'..directory..'" -type f -name "*_spec.lua"')
  if not pfile then return t end
  for filename in pfile:lines() do
    i = i + 1
    t[i] = filename
  end
  pfile:close()
  return t
end

local test_files = scan_dir("tests")
for _, file in ipairs(test_files) do
  require(file:gsub("tests/", ""):gsub(".lua$", ""))
end
