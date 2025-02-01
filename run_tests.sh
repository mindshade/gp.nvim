#!/bin/bash
set -e

# Clone plenary.nvim for testing
git clone --depth 1 https://github.com/nvim-lua/plenary.nvim /tmp/plenary.nvim

# Run tests using headless neovim
PLENARY_DIR=/tmp/plenary.nvim nvim --headless -c "lua require('tests.minimal')" -c "q"
