" ================================================
" Script: .vimrc
" Description: Minimal zero-plugin Vim configuration with clean defaults, intuitive keybindings, transparent theme, and native commenting.
" ================================================

" --- 1. GENERAL SETTINGS ---
set nocompatible
filetype plugin indent on
syntax on

let mapleader = " "
let maplocalleader = " "

set encoding=utf-8
set fileencoding=utf-8
set hidden                      " Allow buffer switching without saving
if has('mouse')
    set mouse=a                 " Enable mouse support in all modes
    if has('mouse_sgr')
        set ttymouse=sgr        " Fix mouse clicks jumping around in modern terminals & tmux
    endif
endif
set clipboard^=unnamed,unnamedplus " Sync with system clipboard
set backspace=indent,eol,start  " Make backspace behave naturally
set history=1000                " Store line history
set updatetime=300              " Faster completion / diagnostics response
set timeoutlen=500              " Fast leader key timeout
set nobackup nowritebackup swapfile

if has('persistent_undo')
    if !isdirectory(expand('~/.vim/undodir'))
        call mkdir(expand('~/.vim/undodir'), 'p')
    endif
    set undofile
    set undodir=~/.vim/undodir
endif


" --- 2. UI & APPEARANCE ---
set number                      " Show absolute line numbers
" set relativenumber            " Relative line numbers disabled
set cursorline                  " Highlight active line
set showcmd                     " Show partial command in bottom bar
set laststatus=2                " Always display statusline
set showtabline=2               " Always display tabline (buffer tabs)
set title                       " Set terminal title
set scrolloff=8                 " Keep 8 lines visible above/below cursor
set sidescrolloff=8
set wildmenu                    " Visual completion popup for command mode
set wildmode=longest:full,full

if has("patch-8.2.0000") || has("nvim")
    set wildoptions=pum
endif

set background=dark

if has("termguicolors")
    set termguicolors
endif

" --- Transparent Background & Gentle Eye-Friendly Pastel Theme ---
highlight clear Normal
highlight Normal guibg=NONE ctermbg=NONE guifg=#cdd6f4 ctermfg=253
highlight clear NormalNC
highlight NormalNC guibg=NONE ctermbg=NONE guifg=#a6adc8 ctermfg=248

" --- Active Line (CursorLine): Soft Translucent Gray Veil (Harmonizes with Terminal Background) ---
highlight clear CursorLine
highlight CursorLine term=NONE cterm=NONE gui=NONE guibg=#222222 ctermbg=235
highlight clear CursorLineNr
highlight CursorLineNr term=bold cterm=bold gui=bold guifg=#e4e4e7 ctermfg=254 guibg=NONE ctermbg=NONE

highlight clear LineNr
highlight LineNr term=NONE cterm=NONE gui=NONE guifg=#7f849c ctermfg=245 guibg=NONE ctermbg=NONE

highlight clear Visual
highlight Visual term=NONE cterm=NONE gui=NONE guibg=#363a4f ctermbg=238

highlight clear Search
highlight Search term=NONE cterm=NONE gui=NONE guibg=#45475a guifg=#f9e2af ctermbg=239 ctermfg=223
highlight clear IncSearch
highlight IncSearch term=NONE cterm=NONE gui=NONE guibg=#94e2d5 guifg=#181825 ctermbg=115 ctermfg=234

" --- Statusline (100% Transparent, No Reverse, Inherits Terminal Background) ---
highlight clear StatusLine
highlight StatusLine term=bold cterm=bold gui=bold guibg=NONE ctermbg=NONE guifg=#cdd6f4 ctermfg=253
highlight clear StatusLineNC
highlight StatusLineNC term=NONE cterm=NONE gui=NONE guibg=NONE ctermbg=NONE guifg=#6c7086 ctermfg=243

" --- Split Windows & Separators ---
highlight clear VertSplit
highlight VertSplit term=NONE cterm=NONE gui=NONE guifg=#313244 guibg=NONE ctermfg=237 ctermbg=NONE

" --- Popup Menu (Completion & Wildmenu) ---
highlight clear Pmenu
highlight Pmenu term=NONE cterm=NONE gui=NONE guibg=#1e1e2e guifg=#cdd6f4 ctermbg=236 ctermfg=253
highlight clear PmenuSel
highlight PmenuSel term=bold cterm=bold gui=bold guibg=#363a4f guifg=#89dceb ctermbg=238 ctermfg=117
highlight clear WildMenu
highlight WildMenu term=bold cterm=bold gui=bold guibg=#363a4f guifg=#89dceb ctermbg=238 ctermfg=117

" --- Netrw File Explorer ---
highlight clear Directory
highlight Directory term=bold cterm=bold gui=bold guifg=#89dceb ctermfg=117
highlight clear netrwDir
highlight netrwDir term=bold cterm=bold gui=bold guifg=#89dceb ctermfg=117
highlight netrwClassify guifg=#7f849c ctermfg=245
highlight netrwLink guifg=#94e2d5 ctermfg=115
highlight netrwSymLink guifg=#94e2d5 ctermfg=115 gui=italic
highlight netrwExe guifg=#a6e3a1 ctermfg=150
highlight netrwTreeBar guifg=#45475a ctermfg=239
highlight netrwTimeDate guifg=#6c7086 ctermfg=243
highlight netrwSizeDate guifg=#fab387 ctermfg=216

highlight clear MatchParen
highlight MatchParen term=bold cterm=bold gui=bold guibg=#45475a guifg=#89dceb ctermbg=239 ctermfg=117
highlight clear SignColumn
highlight SignColumn term=NONE cterm=NONE gui=NONE guibg=NONE ctermbg=NONE guifg=#6c7086 ctermfg=243
highlight clear FoldColumn
highlight FoldColumn term=NONE cterm=NONE gui=NONE guibg=NONE ctermbg=NONE guifg=#6c7086 ctermfg=243
highlight clear Folded
highlight Folded term=NONE cterm=NONE gui=italic guibg=#24273a ctermbg=235 guifg=#9399b2 ctermfg=247
highlight clear NonText
highlight NonText term=NONE cterm=NONE gui=NONE guibg=NONE ctermbg=NONE guifg=#45475a ctermfg=239
highlight clear EndOfBuffer
highlight EndOfBuffer term=NONE cterm=NONE gui=NONE guibg=NONE ctermbg=NONE guifg=#45475a ctermfg=239
highlight clear SpecialKey
highlight SpecialKey term=NONE cterm=NONE gui=NONE guibg=NONE ctermbg=NONE guifg=#585b70 ctermfg=240

" --- Top Buffer Tabline (100% Transparent Bar Matching Any Terminal Background) ---
highlight clear TabLine
highlight TabLine term=NONE cterm=NONE gui=NONE guibg=NONE ctermbg=NONE guifg=#7f849c ctermfg=245
highlight clear TabLineSel
highlight TabLineSel term=bold cterm=bold gui=bold guibg=NONE ctermbg=NONE guifg=#89dceb ctermfg=117
highlight clear TabLineFill
highlight TabLineFill term=NONE cterm=NONE gui=NONE guibg=NONE ctermbg=NONE guifg=NONE ctermfg=NONE
highlight clear TabLineSep
highlight TabLineSep term=NONE cterm=NONE gui=NONE guibg=NONE ctermbg=NONE guifg=#45475a ctermfg=239
highlight clear TabLineMod
highlight TabLineMod term=bold cterm=bold gui=bold guibg=NONE ctermbg=NONE guifg=#fab387 ctermfg=216

" --- Syntax Highlighting (Soft Pastel, Eliminates Unreadable Dark Blue) ---
highlight Comment guifg=#9399b2 ctermfg=247 gui=italic cterm=italic
highlight SpecialComment guifg=#9399b2 ctermfg=247 gui=italic cterm=italic
highlight Constant guifg=#fab387 ctermfg=216
highlight String guifg=#a6e3a1 ctermfg=150
highlight Character guifg=#a6e3a1 ctermfg=150
highlight Number guifg=#fab387 ctermfg=216
highlight Boolean guifg=#fab387 ctermfg=216
highlight Float guifg=#fab387 ctermfg=216
highlight Identifier guifg=#cdd6f4 ctermfg=253
highlight Function guifg=#89dceb ctermfg=117 gui=bold cterm=bold
highlight Statement guifg=#cba6f7 ctermfg=183 gui=bold cterm=bold
highlight Conditional guifg=#cba6f7 ctermfg=183 gui=bold cterm=bold
highlight Repeat guifg=#cba6f7 ctermfg=183 gui=bold cterm=bold
highlight Label guifg=#cba6f7 ctermfg=183
highlight Operator guifg=#94e2d5 ctermfg=115
highlight Keyword guifg=#cba6f7 ctermfg=183 gui=bold cterm=bold
highlight Exception guifg=#cba6f7 ctermfg=183
highlight PreProc guifg=#f5c2e7 ctermfg=218
highlight Include guifg=#f5c2e7 ctermfg=218
highlight Define guifg=#f5c2e7 ctermfg=218
highlight Macro guifg=#f5c2e7 ctermfg=218
highlight PreCondit guifg=#f5c2e7 ctermfg=218
highlight Type guifg=#f9e2af ctermfg=223 gui=bold cterm=bold
highlight StorageClass guifg=#f9e2af ctermfg=223
highlight Structure guifg=#f9e2af ctermfg=223
highlight Typedef guifg=#f9e2af ctermfg=223
highlight Special guifg=#f2cdcd ctermfg=224
highlight SpecialChar guifg=#f2cdcd ctermfg=224
highlight Delimiter guifg=#94e2d5 ctermfg=115
highlight Todo guifg=#f9e2af guibg=#363a4f ctermfg=223 ctermbg=238 gui=bold,italic cterm=bold
highlight WarningMsg guifg=#fab387 guibg=NONE ctermfg=216 ctermbg=NONE
highlight ErrorMsg guifg=#f38ba8 guibg=NONE ctermfg=211 ctermbg=NONE
highlight Title guifg=#89dceb ctermfg=117 gui=bold cterm=bold
highlight DiffAdd guifg=#a6e3a1 guibg=#233b32 ctermfg=150 ctermbg=236
highlight DiffChange guifg=#f9e2af guibg=#383226 ctermfg=223 ctermbg=236
highlight DiffDelete guifg=#f38ba8 guibg=#3e252e ctermfg=211 ctermbg=236 gui=NONE
highlight DiffText guifg=#fab387 guibg=#453526 ctermfg=216 ctermbg=237 gui=bold

" --- Statusline ---
set statusline=
set statusline+=\ %Y\ \|
set statusline+=\ %f\ %M%R
set statusline+=%=
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}\ \|
set statusline+=\ %l:%c\ \|
set statusline+=\ %p%%

" --- Buffer Tabline (Zero Plugins, Neovim Bufferline Style) ---
function! s:GetValidBuffers() abort
    let l:bufs = []
    for l:b in range(1, bufnr('$'))
        let l:name = bufname(l:b)
        let l:ft = getbufvar(l:b, '&filetype')
        let l:bt = getbufvar(l:b, '&buftype')
        if buflisted(l:b) && l:bt ==# '' && l:ft !=# 'netrw' && l:ft !=# 'qf' && l:ft !=# 'help' && !isdirectory(l:name)
            call add(l:bufs, l:b)
        endif
    endfor
    return l:bufs
endfunction

function! BufferTabClick(info) abort
    let l:b = get(a:info, 'minwid', 0)
    if l:b > 0 && buflisted(l:b)
        execute 'buffer ' . l:b
    endif
    return 1
endfunction

function! BufferTabLine() abort
    let l:bufs = s:GetValidBuffers()
    let l:cur = bufnr('%')
    let l:line = ''
    let l:tab_idx = 1
    let l:has_click = has('statusline_click')

    for l:b in l:bufs
        let l:name = fnamemodify(bufname(l:b), ':t')
        if empty(l:name)
            let l:name = '[No Name]'
        endif
        let l:is_mod = getbufvar(l:b, '&modified')
        let l:click_start = l:has_click ? ('%' . l:b . '[BufferTabClick]') : ('%' . l:tab_idx . 'T')
        let l:click_end = l:has_click ? '%[]' : '%T'

        if l:b == l:cur
            let l:line .= l:click_start . '%#TabLineSel#  ' . l:tab_idx . '  ' . l:name
            if l:is_mod
                let l:line .= ' %#TabLineMod#●%#TabLineSel#'
            endif
            let l:line .= '  %#TabLineSep#│' . l:click_end
        else
            let l:line .= l:click_start . '%#TabLine#  ' . l:tab_idx . '  ' . l:name
            if l:is_mod
                let l:line .= ' %#TabLineMod#●%#TabLine#'
            endif
            let l:line .= '  %#TabLineSep#│' . l:click_end
        endif
        let l:tab_idx += 1
    endfor

    let l:line .= '%#TabLineFill#%='
    return l:line
endfunction

set tabline=%!BufferTabLine()

" --- 3. INDENTATION & WRAPPING ---
set expandtab                   " Convert tabs to spaces
set tabstop=4                   " 1 tab = 4 spaces
set shiftwidth=4                " Indent width = 4 spaces
set softtabstop=4               " 4 spaces for backspace/tab
set shiftround                  " Round indent to multiple of shiftwidth
set autoindent                  " Copy indent from current line
set smartindent                 " Smart indenting for code
set wrap                        " Wrap long lines
set linebreak                   " Wrap lines at convenient points (words)

" Enforce 4-space tab indentation across all filetypes
autocmd FileType * setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab

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
let g:netrw_winsize = 20        " Explorer width 20%
let g:netrw_hide = 0            " Show hidden (dot) and ignored files by default
let g:netrw_list_hide = ''      " Clear hide filter to display all files

" ============================================================
" --- 7. SPECIAL KEYBINDINGS (ESSENTIALS ONLY) ---
" ============================================================

" --- Clear Search Highlight ---
nnoremap <silent> <Esc> :nohlsearch<CR><Esc>

" --- File Explorer Toggle (<leader>e) ---
nnoremap <leader>e :Lexplore<CR>

" --- Window Splits (<leader>| & <leader>-) ---
nnoremap <leader>\| :vsplit<CR>
nnoremap <leader>- :split<CR>

" --- Window Navigation (Ctrl + h/j/k/l) ---
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" --- Document Formatting (<leader>cf) ---
nnoremap <leader>cf gg=G<C-o><C-o>


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

" Toggle comment on current line or visual selection using gcc / gc
nnoremap <silent> gcc :call ToggleCommentNative()<CR>
vnoremap <silent> gc :call ToggleCommentNative()<CR>

