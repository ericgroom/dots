local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

local plugins = {
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
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<leader>F", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" }
    },
    config = function()
      require("nvim-tree").setup()
    end
  },
  {
      "nvim-telescope/telescope.nvim",
      keys = {
        { "<leader>f", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
        { "<leader>s", "<cmd>Telescope<cr>", desc = "Telescope"},
        { "<leader>o", "<cmd>Telescope live_grep<cr>", desc = "Grep"},
      }
  },
  "wellle/targets.vim",
  "machakann/vim-sandwich",
  "jiangmiao/auto-pairs",
  "tpope/vim-commentary",
  "tommcdo/vim-lion",
  "sheerun/vim-polyglot",
  "w0rp/ale",
  "vim-airline/vim-airline",
  "vim-airline/vim-airline-themes",
  "airblade/vim-gitgutter",
  "junegunn/fzf",
  "junegunn/fzf.vim",
  "tpope/vim-fugitive",
  {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-tree.lua", -- (optional) to manage project files
      "stevearc/oil.nvim", -- (optional) to manage project files
      "nvim-treesitter/nvim-treesitter", -- (optional) for Quick tests support (required Swift parser)
    },
    config = function()
      vim.keymap.set("n", "<leader>X", "<cmd>XcodebuildPicker<cr>", { desc = "Show Xcodebuild Actions" })
      vim.keymap.set("n", "<leader>xf", "<cmd>XcodebuildProjectManager<cr>", { desc = "Show Project Manager Actions" })

      vim.keymap.set("n", "<leader>xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
      vim.keymap.set("n", "<leader>xB", "<cmd>XcodebuildBuildForTesting<cr>", { desc = "Build For Testing" })
      vim.keymap.set("n", "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" })

      vim.keymap.set("n", "<leader>xt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
      vim.keymap.set("v", "<leader>xt", "<cmd>XcodebuildTestSelected<cr>", { desc = "Run Selected Tests" })
      vim.keymap.set("n", "<leader>xT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run This Test Class" })

      vim.keymap.set("n", "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Xcodebuild Logs" })
      vim.keymap.set("n", "<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", { desc = "Toggle Code Coverage" })
      vim.keymap.set("n", "<leader>xC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", { desc = "Show Code Coverage Report" })
      vim.keymap.set("n", "<leader>xe", "<cmd>XcodebuildTestExplorerToggle<cr>", { desc = "Toggle Test Explorer" })
      vim.keymap.set("n", "<leader>xs", "<cmd>XcodebuildFailingSnapshots<cr>", { desc = "Show Failing Snapshots" })

      vim.keymap.set("n", "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
      vim.keymap.set("n", "<leader>xp", "<cmd>XcodebuildSelectTestPlan<cr>", { desc = "Select Test Plan" })
      vim.keymap.set("n", "<leader>xq", "<cmd>Telescope quickfix<cr>", { desc = "Show QuickFix List" })

      vim.keymap.set("n", "<leader>xx", "<cmd>XcodebuildQuickfixLine<cr>", { desc = "Quickfix Line" })
      vim.keymap.set("n", "<leader>xa", "<cmd>XcodebuildCodeActions<cr>", { desc = "Show Code Actions" })
      require("xcodebuild").setup({
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "wojciech-kulik/xcodebuild.nvim"
    },
    config = function()
      local xcodebuild = require("xcodebuild.integrations.dap")
      -- SAMPLE PATH, change it to your local codelldb path
      local codelldbPath = os.getenv("HOME") .. "/tools/codelldb-aarch64-darwin/extension/adapter/codelldb"

      xcodebuild.setup(codelldbPath)

      vim.keymap.set("n", "<leader>dd", xcodebuild.build_and_debug, { desc = "Build & Debug" })
      vim.keymap.set("n", "<leader>dr", xcodebuild.debug_without_build, { desc = "Debug Without Building" })
      vim.keymap.set("n", "<leader>dt", xcodebuild.debug_tests, { desc = "Debug Tests" })
      vim.keymap.set("n", "<leader>dT", xcodebuild.debug_class_tests, { desc = "Debug Class Tests" })
      vim.keymap.set("n", "<leader>b", xcodebuild.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>B", xcodebuild.toggle_message_breakpoint, { desc = "Toggle Message Breakpoint" })
      vim.keymap.set("n", "<leader>dx", xcodebuild.terminate_session, { desc = "Terminate Debugger" })
    end,
  },
  { 
    "rcarriga/nvim-dap-ui", 
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    config = function()
      require("dapui").setup({})
    end
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()
      local opts = { noremap = true, silent = true }
      local on_attach = function(_, bufnr)
        opts.buffer = bufnr
   
        opts.desc = "Show line diagnostics"
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
   
        opts.desc = "Show documentation for what is under cursor"
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      end
   
      lspconfig["sourcekit"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer", -- source for text in buffer
      "hrsh7th/cmp-path", -- source for file system paths
      "L3MON4D3/LuaSnip", -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- for autocompletion
      "rafamadriz/friendly-snippets", -- useful snippets
      "onsails/lspkind.nvim", -- vs-code like pictograms
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
   
      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()
   
      cmp.setup({
        completion = {
          completeopt = "menu,menuone,preview",
        },
        snippet = { -- configure how nvim-cmp interacts with snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
          ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
          ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
          ["<C-e>"] = cmp.mapping.abort(), -- close completion window
          ["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace }),
          ["<C-b>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-f>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        -- sources for autocompletion
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- snippets
          { name = "buffer" }, -- text within current buffer
          { name = "path" }, -- file system paths
        }),
        -- configure lspkind for vs-code like pictograms in completion menu
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
      })
    end,
  },
}

vim.g.mapleader = " "

require("lazy").setup(plugins, opts)

vim.cmd([[
set nocompatible
filetype off

filetype plugin indent on

" The rest of your config follows here

" **************
" VANILLA OPTIONS
" **************

set rnu " turns on relative line numbers
set nu " changes the 0 from rnu to absolute line

" adds kspell to complete which completes dictionary words
" when spell check is enabled
set complete=.,w,b,u,t,i

" set tab length
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" disable ex mode, feel free to remap later
map Q <Nop>

" syntax 
syntax on

" only is case-sensitive if an uppercase letter is included
set smartcase

" macvim font
set guifont=Fira\ Code\ Regular:h16

" instant search
set incsearch 

" show char when line wraps
set showbreak=↪

" **************
" BINDINGS
" **************
nmap <leader>g :Git<CR>
nmap <leader>w :w <CR>
nmap <leader>W :wq <CR>
nmap <leader>s :source $MYVIMRC <CR>
nmap <leader>e :e $MYVIMRC <CR>
nmap <leader>c :nohlsearch <CR>
nmap <leader>tn :tabnew<CR>
nmap <leader>th :tabprevious<CR>
nmap <leader>tl :tabnext<CR>


" **************
" PLUGIN OPTIONS
" **************
" prettier
let g:ale_fixers = { 'javascript': ['prettier'], 'css': ['prettier'] }
let g:ale_fix_on_save = 1

" only lint in normal mode
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1

" airline
let g:airline_theme='minimalist'
]])
