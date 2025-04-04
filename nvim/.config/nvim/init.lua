vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.relativenumber = true
vim.opt.number = true

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

open_github = function()
  local current_word = vim.fn.expand("<cword>")
  if tonumber(current_word) then
    vim.cmd("!gh pr view --web " .. current_word)
  end
end

vim.keymap.set("n", "<leader>p", open_github, { desc = "Open PR ref in browser" })

local formatting_group = vim.api.nvim_create_augroup("OnSaveFormatting", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  group = formatting_group,
  callback = function()
    vim.lsp.buf.format({
      filter = function(c)
        return c.name ~= "ts_ls"
      end
    })
  end
})

vim.cmd([[
set nocompatible
filetype off

filetype plugin indent on

" The rest of your config follows here

" **************
" VANILLA OPTIONS
" **************

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
nmap <leader>c :nohlsearch <CR>
nmap <leader>tn :tabnew<CR>
nmap <leader>th :tabprevious<CR>
nmap <leader>tl :tabnext<CR>
]])

require("config.lazy")
