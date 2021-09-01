if &compatible
	set nocompatible
endif

set nu
set nohls
"
" === User Config & Keybinds ===
let mapleader = " "
au FileType vim nnoremap %% :so %<CR>
nnoremap ; :
inoremap jj <ESC>

nnoremap <leader>fs :w<CR>
nnoremap <leader>fS :wa<CR>
nnoremap <leader>wc :q<CR>
nnoremap <leader>wC :q!<CR>
nnoremap <leader>wq :wq<CR>

nnoremap <leader>wv :vs<CR>
nnoremap <leader>ws :sp<CR>

nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" Filetype stuff
au FileType python nnoremap <Leader>r :!python %<CR>

" Add the dein installation directory into runtimepath
set runtimepath+=/home/vecna/.dein/repos/github.com/Shougo/dein.vim

" Required:
let s:dein_dir = expand('~/.dein')
let s:dein_repo_dir = s:dein_dir . 'repos/github.com/Shougo/dein.vim'
let g:rc_dir = expand('~/.dein/rc/')
let s:toml = g:rc_dir . 'dein.toml'
let s:lazy_toml = g:rc_dir . 'lazy_dein.toml'

if dein#load_state(s:dein_dir . 'plugins/')
	" Let dein manage dein
	call dein#begin(s:dein_dir . 'plugins/')
	call dein#load_toml(s:toml, {'lazy':0})
	call dein#load_toml(s:lazy_toml, {'lazy':1})

	if !has('nvim')
		call dein#add('roxma/nvim-yarp')
		call dein#add('roxma/vim-hug-neovim-rpc')
	endif

	call dein#end()
	call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable


" === Plugin Specific Settings ===
set termguicolors
colorscheme palenight
let g:transparent_enabled = v:true

" Lightline placeholder for future theming etc
let g:lightline = {}

" Completion
set completeopt=menuone,noinsert,noselect
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
let g:completion_confirm_key = ""
imap <expr> <CR> pumvisible() ? complete_info()["selected"] != "-1" ?
	\ "\<Plug>(completion_confirm_completion)" : "\<C-e>\<CR>" : "\<CR>"


" Language Servers
lua << EOF
local lsp = require('lspconfig')
local protocol =require('vim.lsp.protocol')

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	local opts = { noremap = true, silent = true }

	-- Set keymaps using below
	-- buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)

	if client.resolved_capabilities.document_formatting then
		vim.api.nvim_command [[augroup Format]]
		-- vim.api.nvim_command [[automcd! * <buffer>]]
		vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
		vim.api.nvim_command [[augroup END]]
	end
	require 'completion'.on_attach(client, bufnr)
end

lsp.tsserver.setup {
	on_attach = on_attach
	}
lsp.svelte.setup {
	on_attach = on_attach
	}
EOF

" LspSaga
lua << EOF
local saga = require 'lspsaga'
saga.init_lsp_saga()
EOF

nnoremap <silent> <leader>cp :Lspsaga preview_definition<CR>
nnoremap <silent> <leader>cs :Lspsaga hover_doc<CR>

" Tree Sitter
lua << EOF
require 'nvim-treesitter.configs'.setup {
	highlight = {
	enable = true,
	disable = {}
	},
	indent = {
		enable = false,
		disable = {}
	},
	ensure_installed = {
		"tsx",
		"toml",
		"fish",
		"json",
		"yaml",
		"html",
		"scss",
		"svelte",
		"python"
	}
}
EOF


" Telescope
nnoremap <silent> <leader>. <cmd>Telescope file_browser<CR>
nnoremap <silent> <leader>/ <cmd>Telescope live_grep<CR>
nnoremap <silent> <leader>, <cmd>Telescope buffers<CR>

lua << EOF
local actions = require 'telescope.actions'
require('telescope').setup {
	defaults = {
		mappings = {
			n = {
				["q"] = actions.close
				}
			}
		}

	}
EOF

lua require'colorizer'.setup()
