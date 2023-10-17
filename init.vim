" Plugins
call plug#begin('~/.vim/plugged')
    " File
    Plug 'scrooloose/nerdtree'
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'ojroques/vim-oscyank'
    " Theme
    Plug 'morhetz/gruvbox'
    Plug 'lifepillar/vim-solarized8'
    " Lang
    Plug 'JuliaEditorSupport/julia-vim', { 'on_ft': 'julia' }
    Plug 'sbdchd/neoformat'
    Plug 'lervag/vimtex'
    Plug 'sirver/ultisnips'
    Plug 'honza/vim-snippets'
    " Chinese
    Plug 'lilydjwg/fcitx.vim'
call plug#end()
filetype plugin indent on
" Neovim Setting
" Basic settings
set number lazyredraw mouse=a so=5
" Movements
vmap < <gv
vmap > >gv
map <esc> :noh<cr>
nnoremap ; :
" Python setup
let g:python3_host_prog = '/usr/bin/python3'
" File browsing
map - :NERDTreeToggle<CR>
" No beeping
set visualbell noerrorbells
" Fast scrolling
"set synmaxcol=128
syntax sync minlines=128
" encode
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,gbk,latin1
" Clipboard
let g:clipboard = {
        \   'name': 'osc52',
        \   'copy': {
        \     '+': {lines, regtype -> OSCYankString(join(lines, "\n"))},
        \     '*': {lines, regtype -> OSCYankString(join(lines, "\n"))},
        \   },
        \   'paste': {
        \     '+': {-> [split(getreg(''), '\n'), getregtype('')]},
        \     '*': {-> [split(getreg(''), '\n'), getregtype('')]},
        \   },
        \ }
set clipboard+=unnamedplus
set nopaste noshowmode
filetype on
" Indent
set tabstop=4 shiftwidth=4 expandtab
"set expandtab autoindent smartindent copyindent   " always set autoindenting on & copy the previous indentation on autoindenting
" block select not limited by shortest line
set virtualedit=
set wildmenu
"set colorcolumn=100
set nowrap linebreak
set wildmode=full
set notimeout
" leader is ,
let maplocalleader = " "
let mapleader = " "
set ls=0
" No copy on delete
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP
" Move a line/block up & down by Alt+{j,k}
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
" Gotta run fast!
noremap H ^
noremap L g_
" {} is not useful anyway, ƪ(•̃͡ε•̃͡)∫ ƪ(•̃͡ε•̃͡)∫ ƪ(•̃͡ε•̃͡)∫
nnoremap { 5j
nnoremap } 5k
" History
set undofile undodir=~/.vim/undo/ undolevels=1000 undoreload=10000
" nerdtree
map <leader>t :NERDTreeToggle<CR>
" FZF
nnoremap <leader>b :Buffers<CR>
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)
nnoremap <leader>gc :Commits<CR>
nnoremap <leader>gb :BCommits<CR>
nnoremap <leader>gg :GGrep<CR>
nnoremap <leader>gf :GFiles<CR>
nnoremap <silent> <leader>ft :Filetypes<CR>
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
imap <c-x><c-x> <plug>(fzf-maps-i)
" Leader
nnoremap <leader>s :split<CR>
nnoremap <leader>v :vsplit<CR>
" Don't move the cursor
" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction
" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif

" interactive search replace
set inccommand=split
"map - :E<CR>
" Lang
set conceallevel=0 " more explicit
set spelllang=en
set spellfile=~/.vim/spell/en.utf-8.add
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
nnoremap <F6> :%s/[\u4e00-\u9fff]//gn<CR>
nnoremap <F7> :setlocal foldmethod=syntax<CR>
nnoremap <F8> :setlocal spell! spelllang=en_us<CR>
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
autocmd BufNewFile,BufRead *.mmark set filetype=markdown
autocmd BufNewFile,BufRead *.jmd set filetype=markdown
autocmd BufNewFile,BufRead *.jl nnoremap <leader>B :let @+ = 'breakpoint(' . join(['"' . expand('%:p') . '"',  line(".")], ',') . ')' <CR>
autocmd BufNewFile,BufRead *.tex,*.bib setlocal ts=2 sw=2
autocmd FileType gitcommit,markdown,text,html,tex setlocal spell complete+=kspell tw=80 formatoptions+=m " line break for Chinese
set colorcolumn=80 " and give me a colored column
" Julia
let g:default_julia_version = "devel"
autocmd BufRead,BufNewFile $HOME/.julia/*/Pumas/* setlocal ts=2 sw=2
" LaTeX
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:vimtex_complete_enabled=0
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']
" Special characters
function! ShowDigraphs()
    digraphs
    call getchar()
    return "\<C-k>"
endfunction
inoremap <expr> <C-k> ShowDigraphs()
map <F11> :w<bar>make!<bar>cclose <CR>
set list
set list listchars=tab:▸\ ,trail:·,precedes:←,extends:→
" Git
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
nmap <leader>hs <Plug>(GitGutterStageHunk)
nmap <leader>hu <Plug>(GitGutterUndoHunk)
nmap <leader>hp <Plug>(GitGutterPreviewHunk)
" Theme
set termguicolors
syntax on
let g:gruvbox_contrast_dark = "hard"
let g:gruvbox_contrast_light = "hard"
"colorscheme gruvbox
let g:solarized_visibility = "high"
let g:solarized_diffmode = "high"
let g:solarized_termtrans = 1
colorscheme solarized8
set laststatus=0
