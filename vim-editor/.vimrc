" =========================================================
" VIMRC - NO PLUGINS, BUILT-IN VIM FEATURES ONLY
" Full keymap set: file tree, new tab, quit, splits,
" buffer switching, fuzzy file finder, comment toggle,
" tab navigation, quick config editing, bracket auto-pairing,
" matchit motion, clipboard sync, auto-reload + cursor restore,
" custom statusline, integrated terminal, indent guides.
" See README.md for the full shortcut reference.
" =========================================================

" ---------- BASICS ----------
set nocompatible              " disable old vi-compatible mode
syntax on                     " enable syntax highlighting
filetype plugin indent on     " enable filetype detection + per-filetype indent

set number                    " show absolute line numbers (not relative)
set numberwidth=4             " width of the line number column
set cursorline                " highlight the line the cursor is on
set showcmd                   " show partially typed commands in the bottom right
set wrap                      " soft-wrap long lines
set scrolloff=8               " keep 8 lines of context above/below cursor when scrolling
set signcolumn=yes            " always show the sign column (like VS Code's gutter)

" ---------- INDENTATION ----------
set tabstop=4                 " a <Tab> is displayed as 4 columns
set shiftwidth=4              " use 4 spaces for each step of (auto)indent
set expandtab                 " insert spaces instead of a literal <Tab> character
set autoindent
set smartindent

" ---------- SEARCH ----------
set ignorecase                " case-insensitive search by default
set smartcase                 " ...unless the search contains an uppercase letter
set incsearch                 " jump to matches as you type
set hlsearch                  " highlight all search matches

" ---------- APPEARANCE ----------
" Sync with the terminal's theme: do NOT force a hardcoded colorscheme.
" Vim keeps its default palette but with a transparent background, so it
" automatically inherits whatever theme the terminal app is using
" (Dracula, Nord, Solarized, Gruvbox, etc.)
if $COLORTERM ==# 'truecolor' || $COLORTERM ==# '24bit'
    set termguicolors         " only enable 24-bit color if the terminal actually supports it
endif
set background=dark           " tell Vim to assume a dark background for contrast choices

" Clear Vim's default background so it falls back to the terminal's own background color
autocmd VimEnter,ColorScheme * highlight Normal       ctermbg=NONE guibg=NONE
autocmd VimEnter,ColorScheme * highlight NonText      ctermbg=NONE guibg=NONE
autocmd VimEnter,ColorScheme * highlight LineNr       ctermbg=NONE guibg=NONE
autocmd VimEnter,ColorScheme * highlight SignColumn   ctermbg=NONE guibg=NONE
autocmd VimEnter,ColorScheme * highlight EndOfBuffer  ctermbg=NONE guibg=NONE
autocmd VimEnter,ColorScheme * highlight VertSplit    ctermbg=NONE guibg=NONE
autocmd VimEnter,ColorScheme * highlight StatusLine   ctermbg=NONE guibg=NONE
autocmd VimEnter,ColorScheme * highlight StatusLineNC ctermbg=NONE guibg=NONE
autocmd VimEnter,ColorScheme * highlight Folded       ctermbg=NONE guibg=NONE

" ---------- LEADER KEY ----------
let mapleader = " "            " use Space as the leader key

" =========================================================
" 1. SPACE + e  => TOGGLE FILE TREE (built-in netrw, no NERDTree needed)
" =========================================================
let g:netrw_banner = 0        " hide the verbose netrw banner
let g:netrw_liststyle = 3     " use tree-style listing
let g:netrw_browse_split = 4  " open selected file in the previous (right-hand) window
let g:netrw_altv = 1
let g:netrw_winsize = 25      " file tree takes 25% of the screen width

" :Lexplore is netrw's own native toggle (open if closed, close if open),
" so we just map straight to it instead of tracking state ourselves.
nnoremap <silent> <leader>e :Lexplore<CR>

" =========================================================
" 2. SPACE + t  => OPEN A NEW TAB
" =========================================================
" Opens a brand new empty tab page (like Ctrl+T in a browser).
nnoremap <silent> <leader>t :tabnew<CR>

" =========================================================
" 3. SPACE + q  => QUIT the current window/file
" =========================================================
nnoremap <leader>q :q<CR>

" =========================================================
" 4. SPACE + |  AND  SPACE + -  => CREATE SPLITS
" =========================================================
" Space + |  -> vertical split (side by side)
" Space + -  -> horizontal split (stacked)
" Note: "|" is the command separator in Ex commands, so it must be escaped
" with a backslash on the left-hand side of the mapping.
nnoremap <silent> <leader>\| :vsplit<CR>
nnoremap <silent> <leader>-  :split<CR>

" =========================================================
" 5. CTRL + i  /  CTRL + o  => SWITCH BETWEEN OPEN FILES (BUFFERS)
" =========================================================
" Ctrl+I  -> go to the next buffer (next file already opened)
" Ctrl+O  -> go to the previous buffer (previous file already opened)
" NOTE: this intentionally overrides Vim's default jumplist navigation
" (normally bound to Ctrl-I / Ctrl-O) in favor of quick file switching.
" Also note some terminals send the same code for <Tab> and <C-i>, so
" Ctrl+I may behave like <Tab> in certain terminal emulators.
nnoremap <silent> <C-i> :bnext<CR>
nnoremap <silent> <C-o> :bprevious<CR>

" =========================================================
" 6. SPACE + p  => FUZZY-STYLE FILE FINDER (built-in :find, no plugin)
" =========================================================
" 'path=**' makes :find search recursively through all subdirectories
" of the current working directory, and wildmenu/wildmode give you an
" interactive, tab-completable list of matches as you type - the closest
" thing to a fuzzy finder using only built-in Vim features.
set path+=**
set wildmenu
set wildmode=longest:full,full
set wildignore+=*/node_modules/*,*/.git/*,*/dist/*,*/build/*

" Opens the command line pre-filled with ":find " so you can start typing
" a filename and press <Tab> to cycle through matches.
nnoremap <leader>p :find<Space>

" =========================================================
" 7. CTRL + /  (Normal & Visual mode) => COMMENT / UNCOMMENT CODE
"    (hand-written function, no commentary-style plugin needed)
" =========================================================
function! ToggleComment() range
    " Pick the comment prefix/suffix based on the current filetype.
    " l:ce (comment end) is empty for single-marker languages, and only
    " set for languages that need a closing marker too (e.g. HTML).
    let l:cs = "#"   " default prefix
    let l:ce = ""    " default: no suffix needed
    if &filetype ==# 'vim'
        let l:cs = '"'
    elseif &filetype =~# '\v(javascript|typescript|java|c|cpp|go|rust|php|css|scss)'
        let l:cs = '//'
    elseif &filetype =~# '\v(python|sh|bash|ruby|yaml|dockerfile)'
        let l:cs = '#'
    elseif &filetype ==# 'lua'
        let l:cs = '--'
    elseif &filetype ==# 'html'
        " HTML needs BOTH an opening and a closing marker to be valid
        let l:cs = '<!--'
        let l:ce = '-->'
    endif

    let l:escaped_cs = escape(l:cs, '/\')
    let l:escaped_ce = escape(l:ce, '/\')

    for l:lnum in range(a:firstline, a:lastline)
        let l:line = getline(l:lnum)
        " Skip fully blank lines so we don't comment out whitespace-only lines
        if l:line =~# '^\s*$'
            continue
        endif

        if l:line =~# '^\s*' . l:escaped_cs
            " already commented -> strip both the prefix and (if any) suffix
            let l:newline = substitute(l:line, '^\(\s*\)' . l:escaped_cs . '\s\?', '\1', '')
            if !empty(l:ce)
                let l:newline = substitute(l:newline, '\s\?' . l:escaped_ce . '\s*$', '', '')
            endif
            call setline(l:lnum, l:newline)
        else
            " not commented yet -> wrap the line in prefix (and suffix, if any)
            let l:indent = matchstr(l:line, '^\s*')
            let l:rest = strpart(l:line, len(l:indent))
            if empty(l:ce)
                call setline(l:lnum, l:indent . l:cs . ' ' . l:rest)
            else
                call setline(l:lnum, l:indent . l:cs . ' ' . l:rest . ' ' . l:ce)
            endif
        endif
    endfor
endfunction

" Ctrl + / in Visual mode -> comment/uncomment the selected lines
" (some terminals send Ctrl+/ as the Ctrl+_ byte sequence, so map both to be safe)
vnoremap <silent> <C-_> :call ToggleComment()<CR>
vnoremap <silent> <C-/> :call ToggleComment()<CR>

" Ctrl + / in Normal mode -> comment/uncomment the current line
nnoremap <silent> <C-_> :call ToggleComment()<CR>
nnoremap <silent> <C-/> :call ToggleComment()<CR>

" Space + / as a fallback, in case your terminal can't send Ctrl+/ at all
nnoremap <silent> <leader>/ :call ToggleComment()<CR>

" =========================================================
" 8. SHIFT + H  /  SHIFT + L  => SWITCH BETWEEN TABS
" =========================================================
" Shift+H -> go to the previous tab (like Ctrl+Shift+Tab in a browser)
" Shift+L -> go to the next tab     (like Ctrl+Tab in a browser)
" NOTE: this overrides the default 'H'/'L' cursor motions (jump to the
" top/bottom of the visible screen). Use 'gg'/'G' or 'zt'/'zb' instead
" if you still need that behavior.
nnoremap <silent> H :tabprevious<CR>
nnoremap <silent> L :tabnext<CR>

" =========================================================
" 9. QUICK CONFIG EDITING  => EDIT AND RELOAD THIS VIMRC FASTER
" =========================================================
" $MYVIMRC always points to whichever vimrc file Vim actually loaded on
" startup, so these mappings work no matter where the file lives.
"
" Space + r + c  -> open $MYVIMRC in a new vertical split for quick edits
" Space + r + s  -> reload (source) $MYVIMRC to apply changes immediately,
"                   without needing to restart Vim
" Space + r + o  -> open $MYVIMRC in a new tab instead of a split
nnoremap <silent> <leader>rc :vsplit $MYVIMRC<CR>
nnoremap <silent> <leader>ro :tabnew $MYVIMRC<CR>
nnoremap <silent> <leader>rs :source $MYVIMRC<CR>:echo "vimrc reloaded"<CR>

" Automatically reload the config the moment you save vimrc itself,
" so changes take effect immediately without manually pressing <leader>rs.
augroup AutoReloadVimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC | echo "vimrc reloaded"
augroup END

" =========================================================
" 10. AUTO-CLOSE BRACKETS AND QUOTES (Insert mode)
" =========================================================
" Typing an opening bracket/quote automatically inserts its matching
" closing character and places the cursor in between.
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>

" Typing a CLOSING bracket that is already sitting right under the cursor
" just moves past it instead of inserting a duplicate.
inoremap <expr> ) strpart(getline('.'), col('.')-1, 1) ==# ')' ? "\<Right>" : ")"
inoremap <expr> ] strpart(getline('.'), col('.')-1, 1) ==# ']' ? "\<Right>" : "]"
inoremap <expr> } strpart(getline('.'), col('.')-1, 1) ==# '}' ? "\<Right>" : "}"

" Quotes use the same character to open and close, so we just toggle:
" if the next character is already the matching quote, skip over it;
" otherwise insert a fresh pair.
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) ==# '"'  ? "\<Right>" : '""<Left>'
inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) ==# "'"  ? "\<Right>" : "''<Left>"

" Pressing Backspace right between an empty pair (e.g. "(|)") deletes
" both characters at once instead of leaving a dangling bracket.
function! s:SmartBackspace() abort
    let l:line = getline('.')
    let l:col = col('.')
    let l:before = l:col > 1 ? l:line[l:col - 2] : ''
    let l:after = l:line[l:col - 1]
    let l:pairs = {'(': ')', '[': ']', '{': '}', '"': '"', "'": "'"}
    if has_key(l:pairs, l:before) && l:after ==# l:pairs[l:before]
        return "\<Right>\<BS>\<BS>"
    endif
    return "\<BS>"
endfunction
inoremap <expr> <BS> <SID>SmartBackspace()

" =========================================================
" 11. ENABLE MATCHIT (ships with Vim itself, not an external plugin)
" =========================================================
" Extends the '%' motion so it can jump between matching if/end,
" opening/closing HTML tags, and other language-aware pairs, not just
" single brackets.
if !exists('g:loaded_matchit')
    packadd! matchit
endif

" =========================================================
" 12. SYSTEM CLIPBOARD SYNC
" =========================================================
" Makes yank/delete/paste (y, d, p) use the OS clipboard by default, so
" copying in Vim lets you paste in other apps and vice versa.
" Requires Vim compiled with +clipboard (check with ":echo has('clipboard')").
if has('clipboard')
    set clipboard=unnamedplus
endif

" =========================================================
" 13. AUTO-RELOAD CHANGED FILES + RESTORE LAST CURSOR POSITION
" =========================================================
" If a file is changed outside of Vim (e.g. by git, another editor, a
" build tool), automatically reload it instead of showing a stale buffer.
set autoread
autocmd FocusGained,BufEnter,CursorHold * checktime

" When reopening a file, jump back to the line/column you were last
" editing instead of always starting at the top.
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif

" =========================================================
" 14. CUSTOM STATUSLINE
" =========================================================
" Shows: current mode, filename + modified/readonly flags, git branch
" (if inside a repo), filetype, and line:column / percentage through file.
set laststatus=2               " always show the statusline, even with a single window

function! s:GitBranch() abort
    if !executable('git')
        return ''
    endif
    let l:branch = system('git rev-parse --abbrev-ref HEAD 2>/dev/null')
    if v:shell_error || empty(l:branch)
        return ''
    endif
    return ' | ' . substitute(l:branch, '\n', '', '') . ' '
endfunction

function! s:StatusLine() abort
    let l:mode_names = {
        \ 'n':  'NORMAL', 'i':  'INSERT', 'v':  'VISUAL', 'V':  'V-LINE',
        \ "\<C-v>": 'V-BLOCK', 'c': 'COMMAND', 'R': 'REPLACE', 't': 'TERMINAL'
        \ }
    let l:mode = get(l:mode_names, mode(), mode())
    let l:ft = empty(&filetype) ? 'no ft' : &filetype
    return ' ' . l:mode . ' | %f%m%r%h%w' . s:GitBranch() . '%=' . l:ft . ' | %l:%c | %p%% '
endfunction

" Apply the function above as the actual statusline format.
" (Without this line, the function exists but is never displayed.)
set statusline=%!s:StatusLine()

" =========================================================
" 15. INTEGRATED TERMINAL
" =========================================================
" Space + s + h -> open a terminal in a horizontal split at the bottom,
" handy for running the current project without leaving Vim.
nnoremap <silent> <leader>sh :botright split \| resize 15 \| terminal<CR>
" Space + s + v -> same, but as a vertical split instead
nnoremap <silent> <leader>sv :botright vsplit \| terminal<CR>
" Esc twice leaves terminal-insert mode and returns to Normal mode,
" matching the muscle memory of every other Vim buffer.
tnoremap <Esc><Esc> <C-\><C-n>

" =========================================================
" 16. INDENT / WHITESPACE GUIDES
" =========================================================
" Makes invisible characters visible: tabs, trailing spaces, and where
" a wrapped line continues, so indentation mistakes are easy to spot.
set list
set listchars=tab:\▸\ ,trail:·,extends:❯,precedes:❮,nbsp:␣
