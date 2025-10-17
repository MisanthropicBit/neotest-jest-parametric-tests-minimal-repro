vim.opt.runtimepath:remove(vim.fn.expand("~/.config/nvim"))
vim.opt.packpath:remove(vim.fn.expand("~/.local/share/nvim/site"))

local lazypath = "/tmp/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/nvim-nio",
    { "nvim-neotest/neotest-jest", branch = "fix-parametric-describes-1" },
  },
  config = function()
    -- Install any required parsers
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "typescript" },
    })

    require("neotest").setup({
      -- Add adapters to the list
      adapters = {
          require("neotest-jest")({
              jest_test_discovery = true,
          })
      },
    })
  end,
})

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>tt", require("neotest").run.run)
vim.keymap.set("n", "<leader>to", require("neotest").output.open)
