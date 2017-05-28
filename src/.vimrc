" =============================================================================
"  .vimrc 067
" =============================================================================

" -----------------------------------------------------------------------------
" Plugin manager
" -----------------------------------------------------------------------------

if &compatible
  set nocompatible " Be iMproved
endif

" Installed dir
let s:dein_dir = expand('~/.cache/dein')
" dein.vim
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" Pull dein.vim from Github if it's not found
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" Settings
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let g:rc_dir    = expand('~/dotfiles/dein')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

" Install plugins not installed yet
if dein#check_install()
  call dein#install()
endif

" -----------------------------------------------------------------------------
" Basics
" -----------------------------------------------------------------------------

" Color scheme
colorscheme molokai

" Override molokai
autocmd ColorScheme * hi LineNr guifg=#7E8E91 guibg=#232526
autocmd ColorScheme * hi Comment guifg=#8E9EA1

" Add extra space to the left side of line number
augroup numberwidth
    autocmd!
    autocmd BufEnter,WinEnter,BufWinEnter * let &l:numberwidth = len(line("$")) + 2
augroup END

" Functons
syntax on " Enable syntax highlight
filetype on

" -----------------------------------------------------------------------------
" Set options
" -----------------------------------------------------------------------------

" Search
set ignorecase        " `ignorecase` hits `IgnoreCase`
set smartcase         " `IgnoreCase` hits `ignorecase`

" Tab/indent
set expandtab         " Convert tab to white space
set autoindent        " Indented by previous line
set smartindent       " C-style indent
set smarttab          " I don't know what it is. lol
set tabstop=4         " 4 spaces for a tab
set shiftwidth=4      " 4 spaces for a shift

" Lines
set cursorline        " Change the color of current line
set list              " Display invisible char
set listchars=tab:>\  " Display format of invisibles
set number            " Display line number
set ruler             " Display current row and column
set nowrap            " No wrap

" Backup
set nobackup          " No backup
set noswapfile        " Don't create swap file
set noundofile        " Don't create a file like *.un~

" Status line
set laststatus=2      " 0: Invisible, 1: Adaptive, 2: Visible
set wildmenu          " Use status line to display searching result
set wildignorecase

" -----------------------------------------------------------------------------
" Key mapping
" -----------------------------------------------------------------------------

" For US keyboard
noremap ; :
noremap : ;

" Brackets completion
inoremap {} {}<LEFT>
inoremap [] []<LEFT>
inoremap () ()<LEFT>
inoremap '' ''<LEFT>
inoremap "" ""<LEFT>
inoremap <> <><LEFT>

" Ctrl-C -> ESC
inoremap <C-c> <ESC>
inoremap <silent> jj <ESC>
inoremap <silent> っｊ <ESC>

" Ctlr-K for expanding a snippet
imap <expr><C-k> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)"
            \ : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <C-k> <Plug>(neosnippet_expand_or_jump)

" Shortcuts for Gtags
nmap <C-q> ;ccl<CR>
nmap <C-l> ;Gtags -g <C-r><C-w><CR>
nmap <C-g> ;Gtags <C-r><C-w><CR>
nmap <C-k> ;Gtags -r <C-r><C-w><CR>
nmap <C-n> ;cn<CR>
nmap <C-p> ;cp<CR>

