" vim: set foldmethod=marker foldlevel=0:

" ------------------------------------------------------------------------------
"         _
"  __   _(_)_ __ ___  _ __ ___
"  \ \ / / | '_ ` _ \| '__/ __|
"   \ V /| | | | | | | | | (__
"  (_)_/ |_|_| |_| |_|_|  \___|
"                     yardnsm's .vimrc
" ------------------------------------------------------------------------------

" ------------------------------------------------------------------------------
" General {{{

set nocompatible                      " don't behave like Vi
filetype plugin indent on             " automatically detect file types.

set fileencoding=utf-8
set encoding=utf-8

set modelines=1                       " enable modelines

" }}}

" ------------------------------------------------------------------------------
" Plugins {{{

call plug#begin($DOTFILES . '/nvim/nvim.conf/plugged')

" Color scheme
Plug 'whatyouhide/vim-gotham'

" Javascript stuff
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

" Statusbar
Plug 'vim-airline/vim-airline'

" Gist and stuff
Plug 'mattn/gist-vim'

" Filetree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Git stuff
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Editorconfig
Plug 'editorconfig/editorconfig-vim'

" Easly surround text objects
Plug 'tpope/vim-surround'

" Automatic closing
Plug 'jiangmiao/auto-pairs'

" Easy commenting
Plug 'Tpope/vim-commentary'

" Multiple cursors!
Plug 'terryma/vim-multiple-cursors'

" Move lines and selections
Plug 'matze/vim-move'

" Code completion
Plug 'Valloric/YouCompleteMe'

" Match SGML tags
Plug 'Valloric/MatchTagAlways'

" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" Emojis
Plug 'junegunn/vim-emoji'

" Neovim plugins
Plug 'kassio/neoterm'
Plug 'neomake/neomake'

" Fix neomake
Plug 'benjie/neomake-local-eslint.vim'

call plug#end()

" }}}

" ------------------------------------------------------------------------------
" Plugins config {{{

" Airline
let g:airline_theme = 'gotham'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#tabline#tab_min_count = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_splits = 0
" let g:airline_exclude_filetypes = ['nerdtree']

" Neomake
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_warning_sign = { 'text': 'W', 'texthl': 'WarningMsg' }
let g:neomake_error_sign = { 'text': 'E', 'texthl': 'ErrorMsg' }

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1

" NERDTree
let g:NERDTreeShowHidden = 1
let g:NERDTreeIgnore = ['\.DS_Store$']

" fzf
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment']
  \ }

" fzf status line
function! s:fzf_statusline()
  highlight fzf1 ctermfg=161 ctermbg=0
  highlight fzf1 guifg=161 guibg=0
  setlocal statusline=%#fzf1#~~>\ fzf
  setlocal statusline+=\ %{emoji#for('see_no_evil')}
endfunction
autocmd! User FzfStatusLine call <SID>fzf_statusline()

" }}}

" ------------------------------------------------------------------------------
" Editor {{{

set number                            " show line numbers
set linebreak                         " wraps between words
set list                              " show invisibles
set scrolloff=8                       " allows to scroll of the screen

set backspace=indent,eol,start        " proper backspacing

" Invisibles
set showbreak=↪
set listchars=tab:\»\ ,space:\ ,eol:\ ,trail:·,nbsp:_ " ¬

" Change the split border
set fillchars+=vert:\┃

" }}}

" ------------------------------------------------------------------------------
" Autocommands {{{

" Terminal stuff
autocmd TermOpen * setlocal statusline=%{b:term_title}
autocmd TermOpen * let w:airline_disabled = 1

" }}}

" ------------------------------------------------------------------------------
" Movement {{{

" Move vertically by visual line
nnoremap j gj
nnoremap k gk

" change the cursor shape depending on mode
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

" }}}

" ------------------------------------------------------------------------------
" Colors and Syntax {{{

set background=dark                   " assume a dark background
colorscheme gotham                    " set colorscheme

set t_Co=256                          " we use a 256-color terminal

if &term =~ '256color'
  set t_ut=                           " disable background color erase
endif

syntax on                             " enable syntax highlighting

" Change fold bg
hi Folded ctermbg=green

" }}}

" ------------------------------------------------------------------------------
" Folding {{{

set nofoldenable                      " do not enable folding by default
set foldmethod=indent                 " based folds on indentation
set foldmarker={{{,}}}                " fold marker
set foldlevelstart=10                 " open most folds by default
set foldnestmax=10                    " 10 nested fold at max

" }}}

" ------------------------------------------------------------------------------
" Search {{{

set incsearch                         " shows matches as you type
set smartcase                         " if caps, watch case
set ignorecase                        " ignore case if all lowercase
set hlsearch                          " highlight search results
set gdefault                          " make search&replaces global for the line

" }}}

" ------------------------------------------------------------------------------
" Indent {{{

set autoindent
set smartindent
set expandtab                         " spaces FTW
set shiftround                        " round indent to multiples of shiftwidth

set shiftwidth=2
set softtabstop=2                     " number of spaces in <tab> when editing
set tabstop=2                         " number of visual spaces per <tab>

" }}}

" ------------------------------------------------------------------------------
" File system {{{

set autoread                          " detect when a file is changed

" Backup files
set nobackup
" if &backupdir =~# '^\.,'
"   let &backupdir = $HOME . '/.nvimtmp/backup,' . &backupdir
" endif

" Swap files
set noswapfile
" if &directory =~# '^\.,'
"   let &directory = $HOME . '/.nvimtmp/swap,' . &directory
" endif

" Undo files
set noundofile
" if &undodir =~# '^\.\%(,\|$\)'
"   let &undodir = $HOME . '/.nvimtmp/undo,' . &undodir
" endif

" }}}

" ------------------------------------------------------------------------------
" Misc {{{

set mouse=                            " disable mouse support by default

set showcmd                           " show command in normal (when typed)
set lazyredraw                        " redraw only when we need to
set nocursorline                      " do not highlight current line

set wildmenu                          " enable wildmenu for completion
set wildmode=full

set laststatus=2                      " always show status

set timeout
set timeoutlen=1000
set ttimeoutlen=50

set hidden                            " allow switching buffers w/o saving

set splitbelow                        " split below by default
set splitright                        " split right by default

set colorcolumn=100                   " cuz percision matter

" Open folds to right and bottom
set splitbelow
set splitright

" }}}

" ------------------------------------------------------------------------------
" Mappings and abbreviations {{{

let mapleader=','                     " change the map leader

" Keep blocks selected after indenting
vnoremap > >gv
vnoremap < <gv

" Toggle search highlight
nnoremap <leader><space> :set hlsearch!<CR>

" Enable hlsearch before searching
nnoremap / :set hlsearch<CR>/

" Quick access to .vimrc
nnoremap <leader>r :so $MYVIMRC<CR>
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Toggle pastemode
nnoremap <leader>p :set paste!<CR>

" Space open/closes folds
nnoremap <space> za

" Making working with buffers less painful
nnoremap <leader>T :enew<CR>
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprevious<CR>
nnoremap <leader>bq :bp <BAR> bd #<CR>

" Disable arrow keys for now...
noremap <left> <nop>
noremap <right> <nop>
noremap <up> <nop>
noremap <down> <nop>

" ...and also in INSERT mode
inoremap <left>  <nop>
inoremap <right> <nop>
inoremap <up>    <nop>
inoremap <down>  <nop>

" Splits (there's a problem with <C-h>, ref:
" https://github.com/neovim/neovim/issues/2048)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Terminal mappings
tnoremap <leader><esc> <C-\><C-n>
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Typing ':' requires 2 keystrokes (S-;).
" Let's fix that
nnoremap ; :

" Uppercase the current word
" nnoremap <C-U> gUaw

" Toggle mouse support
function! MouseToggle()
  if &mouse == 'a'
    set mouse=
  else
    set mouse=a
  endif
endfunc
nnoremap <leader>tm :call MouseToggle()<CR>

" Relative number toggle
nnoremap <leader>tn :set relativenumber!<CR>

" NERDtree stuff
nnoremap <leader>/ :NERDTreeToggle<CR>
nnoremap <leader>0 :NERDTreeFocus<CR>

" fzf stuff
nnoremap <C-p> :Files<CR>
nnoremap <leader>lb :Buffers<CR>
nnoremap <leader>lg :GFiles?<CR>
nnoremap <leader>lc :Commits<CR>
nnoremap <leader>lt :Filetypes<CR>
nnoremap <leader>lm :Marks<CR>

" Fix the alt key for 'vim-move'
" macOS can be weird sometimes
nnoremap ˚ <A-k>
nnoremap ∆ <A-j>
vnoremap ˚ <A-k>
vnoremap ∆ <A-j>

" Some abbreviations
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Wq wq
cnoreabbrev WQ wq
cnoreabbrev qQ q!

" }}}
