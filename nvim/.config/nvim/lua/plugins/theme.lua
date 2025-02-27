return {
  {
    "chriskempson/base16-vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[
        set termguicolors
        colorscheme base16-material-palenight
      ]])
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
  },
  {
    "vim-airline/vim-airline",
    dependencies = {
      "vim-airline/vim-airline-themes",
    },
    config = function()
      vim.g.airline_theme = "minimalist"
    end
  },
}
