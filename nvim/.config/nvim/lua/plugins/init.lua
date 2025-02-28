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
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-lua/plenary.nvim"
    },
    keys = {
      { "<leader>f", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
      { "<leader>s", "<cmd>Telescope<cr>",           desc = "Telescope" },
      { "<leader>o", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      { "<leader>b", "<cmd>Telescope buffers<cr>",   desc = "Buffers" },
    },
    opts = {
      extensions = {
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        }
      }
    },
    config = function(plugin, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("fzf")
    end
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
