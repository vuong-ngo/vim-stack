" ============================================================
" NATURAL & MODERN VIM CONFIGURATION
" Clean Defaults, Intuitive Keybindings, Transparent High-Contrast UI
" Synchronized with VS Code Vim Configuration
" ============================================================

" --- 1. GENERAL SETTINGS ---
set nocompatible
filetype plugin indent on
syntax on

let mapleader = " "
let maplocalleader = " "

set encoding=utf-8
set fileencoding=utf-8
set hidden                      " Allow buffer switching without saving
set mouse=a                     " Enable mouse support in all modes
set clipboard^=unnamed,unnamedplus " Sync with system clipboard
set backspace=indent,eol,start  " Make backspace behave naturally
set history=1000                " Store line history
set updatetime=300              " Faster completion / diagnostics response
set timeoutlen=500              " Fast leader key timeout
set nobackup nowritebackup swapfile

if has('persistent_undo')
    set undofile
    set undodir=~/.vim/undodir
endif

" --- 2. UI & APPEARANCE ---
set number                      " Show absolute line numbers
" set relativenumber            " Relative line numbers disabled
set cursorline                  " Highlight active line
set showcmd                     " Show partial command in bottom bar
set laststatus=2                " Always display statusline
set title                       " Set terminal title
set scrolloff=8                 " Keep 8 lines visible above/below cursor
set sidescrolloff=8
set wildmenu                    " Visual completion popup for command mode
set wildmode=longest:full,full

if has("patch-8.2.0000") || has("nvim")
    set wildoptions=pum
endif

if has("termguicolors")
    set termguicolors
endif

" --- Transparent Background & Custom Highlights ---
highlight Normal guibg=NONE ctermbg=NONE
highlight CursorLine guibg=#27272a ctermbg=236 cterm=NONE gui=NONE
highlight CursorLineNr guifg=#38bdf8 ctermfg=81 gui=bold cterm=bold
highlight LineNr guifg=#71717a ctermfg=243
highlight Visual guibg=#3f3f46 ctermbg=238
highlight Search guibg=#f59e0b guifg=#18181b ctermbg=214 ctermfg=234
highlight IncSearch guibg=#38bdf8 guifg=#18181b ctermbg=81 ctermfg=234
highlight StatusLine guibg=NONE ctermbg=NONE guifg=#f4f4f5 ctermfg=255 gui=bold
highlight StatusLineNC guibg=NONE ctermbg=NONE guifg=#71717a ctermfg=243
highlight Pmenu guibg=#27272a guifg=#f4f4f5 ctermbg=236 ctermfg=255
highlight PmenuSel guibg=#38bdf8 guifg=#18181b ctermbg=81 ctermfg=234 gui=bold
highlight Directory guifg=#38bdf8 ctermfg=81 gui=bold

" --- Statusline ---
set statusline=
set statusline+=\ %Y\ \|
set statusline+=\ %f\ %M%R
set statusline+=%=
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}\ \|
set statusline+=\ %l:%c\ \|
set statusline+=\ %p%%

" --- 3. INDENTATION & WRAPPING ---
set expandtab                   " Convert tabs to spaces
set tabstop=4                   " 1 tab = 4 spaces
set shiftwidth=4                " Indent width = 4 spaces
set softtabstop=4
set autoindent                  " Copy indent from current line
set smartindent                 " Smart indenting for code
set wrap                        " Wrap long lines
set linebreak                   " Wrap lines at convenient points (words)

" --- 4. SEARCH OPTIONS ---
set ignorecase                  " Case-insensitive searching...
set smartcase                   " ...unless search contains capital letters
set hlsearch                    " Highlight search results
set incsearch                   " Search incrementally as characters are typed

" --- 5. SPLITS & WINDOW MANAGEMENT ---
set splitbelow                  " Horizontal split opens below
set splitright                  " Vertical split opens right

" --- 6. NETRW FILE EXPLORER ---
let g:netrw_banner = 0          " Hide top banner
let g:netrw_liststyle = 3       " Tree view
let g:netrw_browse_split = 0    " Open files in current window
let g:netrw_winsize = 25        " Explorer width 25%

" ============================================================
" --- 7. NATURAL KEYBINDINGS ---
" ============================================================

" --- Wrapped Line Navigation ---
" Move by visual lines instead of physical lines when text wraps
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" --- Fast Saving & Quitting (Space Leader) ---
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :qa!<CR>
nnoremap <leader>x :x<CR>

" --- Clear Search Highlight ---
nnoremap <leader>h :nohlsearch<CR>
nnoremap <silent> <Esc> :nohlsearch<CR><Esc>

" --- File Explorer Toggle ---
nnoremap <leader>e :Lexplore<CR>

" --- Move Selected Lines Up / Down ---
nnoremap <A-k> :m .-2<CR>==
nnoremap <A-j> :m .+1<CR>==
vnoremap <A-k> :m '<-2<CR>gv=gv
vnoremap <A-j> :m '>+1<CR>gv=gv

" --- Continuous Visual Indentation ---
" Keep selection active after indenting with < or >
vnoremap < <gv
vnoremap > >gv

" --- Window Navigation (Ctrl + h/j/k/l & Alt + h/j/k/l) ---
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" --- Window Management Shortcuts (Leader + | & Leader + -) ---
nnoremap <leader>\| :vsplit<CR>
nnoremap <leader>- :split<CR>
nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>sh :split<CR>
nnoremap <leader>sc :close<CR>

" --- Window Resizing (Ctrl + Arrow keys) ---
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" --- Buffer / Tab Navigation ---
nnoremap H :bprevious<CR>
nnoremap L :bnext<CR>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap ]b :bnext<CR>
nnoremap [b :bprevious<CR>

" --- Clipboard Paste Enhancement ---
" Prevent replacing paste register when pasting over visual selection
xnoremap p "_dP

" ============================================================
" --- 8. PURE NATIVE CODE COMMENTING (ZERO PLUGINS) ---
" ============================================================
" Toggles comments on selected lines or current line natively using Vimscript
function! ToggleCommentNative() range
    let l:comment = '#'
    if index(['c', 'cpp', 'java', 'javascript', 'typescript', 'php', 'css', 'go', 'rust', 'dart'], &filetype) >= 0
        let l:comment = '//'
    elseif index(['vim'], &filetype) >= 0
        let l:comment = '"'
    elseif index(['html', 'xml'], &filetype) >= 0
        let l:comment = '<!--'
    endif

    let l:first = a:firstline
    let l:last = a:lastline

    for l:i in range(l:first, l:last)
        let l:line = getline(l:i)
        if l:comment == '<!--'
            if l:line =~ '^\s*<!--.*-->\s*$'
                call setline(l:i, substitute(l:line, '^\(\s*\)<!--\s*\(.*\)\s*-->\s*$', '\1\2', ''))
            else
                call setline(l:i, substitute(l:line, '^\(\s*\)\(.*\)$', '\1<!-- \2 -->', ''))
            endif
        else
            let l:escaped = escape(l:comment, '/"*')
            if l:line =~ '^\s*' . l:escaped
                call setline(l:i, substitute(l:line, '^\(\s*\)' . l:escaped . '\s*', '\1', ''))
            else
                call setline(l:i, substitute(l:line, '^\(\s*\)', '\1' . l:comment . ' ', ''))
            endif
        endif
    endfor
endfunction

" Toggle comment on current line or visual selection using <leader>/ or gcc
nnoremap <silent> <leader>/ :call ToggleCommentNative()<CR>
vnoremap <silent> <leader>/ :call ToggleCommentNative()<CR>
nnoremap <silent> gcc :call ToggleCommentNative()<CR>
vnoremap <silent> gc :call ToggleCommentNative()<CR>

