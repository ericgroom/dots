return {
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<leader>F", "<cmd>NvimTreeFindFileToggle<cr>", desc = "NvimTree" }
    },
    config = function()
      require("nvim-tree").setup()
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>f", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
      { "<leader>s", "<cmd>Telescope<cr>",           desc = "Telescope" },
      { "<leader>o", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      { "<leader>b", "<cmd>Telescope buffers<cr>",   desc = "Buffers" },
    }
  },
  "wellle/targets.vim",
  "machakann/vim-sandwich",
  "jiangmiao/auto-pairs",
  "tpope/vim-commentary",
  "tommcdo/vim-lion",
  "nvim-treesitter/nvim-treesitter",
  "airblade/vim-gitgutter",
  "tpope/vim-fugitive",
}
