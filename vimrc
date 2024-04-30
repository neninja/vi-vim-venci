set nocompatible

" Buffer ---------------------------------------------------------------------
set hidden

set encoding=utf-8

set autoread
autocmd FocusGained,BufEnter * :silent!<space>!

" Aparência e som ------------------------------------------------------------
try
  colorscheme tokyonight
catch
  colorscheme blue
endtry

set background=dark
set t_Co=256
set termguicolors
set noerrorbells novisualbell t_vb=
set belloff=all
set conceallevel=2

" Comportamento -------------------------------------------------------------
syntax on

filetype plugin indent on
set showmatch
set showmode
set showcmd
set autoindent
"set mouse=
set mouse=a
set linebreak
set nocursorcolumn nocursorline
set number norelativenumber
set nrformats-=octal
set lazyredraw
set nobackup
set noswapfile
set scrolloff=3
set clipboard^=unnamedplus,unnamed
set colorcolumn=
set backspace=indent,eol,start
set formatoptions+=jcr
set hlsearch
set incsearch
set ignorecase
set nosmartcase
set noemoji
if !has('nvim')
  set renderoptions=
else
  set modelineexpr
endif
set modeline
set modelines=5
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set expandtab
set fillchars=vert:│,fold:─

set foldlevelstart=99

let g:html_dynamic_folds=1
let g:html_prevent_copy = "fntd"

let g:netrw_liststyle=3
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
set shellslash

" Autocomplete ---------------------------------------------------------------
set wildmenu
set shortmess+=c
set wildcharm=<tab>
set completeopt=menuone,noinsert,noselect

set wildignore=.git,.git/**
set wildignore+=.svn,.svn/**
set wildignore+=.idea,.idea/**
set wildignore+=node_modules,node_modules/**
set wildignore+=.venv,*/*_cache/*
set wildignore+=dist,dist/**
set wildignore+=target,target/**
set wildignore+=build,build/**
set wildignore+=vendor,vendor/**
set wildignore+=assets,assets/**
set wildignore+=ios,ios/**
set wildignore+=android,android/**
set wildignore+=_site,_site/**
set wildignore+=public,public/**
set wildignore+=*/coverage,*/coverage/**
set wildignore+=*/_reports,*/_reports/**
set wildignore+=*/_gen
set wildignore+=DS_Store,DS_Store/**
set wildignore+=tags
set wildignore+=.next

set wildignorecase

set complete=.,k,w,t

set tags=tags

set omnifunc=syntaxcomplete#Complete

" Statusline -----------------------------------------------------------------
set laststatus=2

set statusline=
set statusline+=\ %{expand('%:~:.')}\ %r\%m
set statusline+=\%=
set statusline+=\ %p%%\ %l:\%c
set statusline+=\ %y

" Funções --------------------------------------------------------------------
function! NN_SetGitDir()
  cd %:p:h
  let gitdir=system("git rev-parse --show-toplevel")
  let isnotgitdir=matchstr(gitdir, '^fatal:.*')
  if empty(isnotgitdir)
    cd `=gitdir`
  endif
endfunction

function! NN_GitAula()
  let log = system("git log --pretty=format:\%s")
  vnew
  put=log
  normal! gg
  if search('^:tv: add aula')>0
    normal! 3W
    let s:numero_aula = expand('<cword>')+1
    echom system("git add -A && git commit -m \":tv: add aula ".s:numero_aula."\"")
  else
    echom system("git add -A && git commit -m \":tv: add aula 1\"")
  endif
  bdelete!
endfunction

function! s:FechaOuDeletaBuffer()
  if tabpagenr('$') > 1 || winnr('$') > 1
    close
  else
    bd!
  endif
endfunction

" Comandos -------------------------------------------------------------------
command! -nargs=* Cake make! <args> | cw
command! -nargs=* Lake make! <args> | cw

command! BufOnly execute 'kb|%bdelete|e #|b#|bd%|normal `b'

" Mapeamentos ----------------------------------------------------------------
let mapleader="\<space>"

nnoremap    <leader><leader>    :w<CR>
nnoremap    <leader>/           :noh<CR>
nnoremap    <leader>.           :pwd<CR>
nnoremap    <leader>df          :call <SID>FechaOuDeletaBuffer()<CR>
nnoremap    <leader>ds          :on<CR>|" fecha todas splits exceto atual
nnoremap    <leader>j           <c-w>w|" estilo DWM
nnoremap    <leader>k           <c-w>W|" estilo DWM
nnoremap    <leader>n           :call NN_<c-d>|" funções pessoais
vnoremap    <leader>n           :call NN_<c-d>|" funções pessoais
vnoremap    <leader>p           "_dP
nnoremap    <expr><leader>q     empty(filter(getwininfo(), 'v:val.quickfix')) ? ":cope<CR>" : ":ccl<CR>"|" toggle quickfix
nnoremap    <expr><leader>l     empty(filter(getwininfo(), 'v:val.loclist')) ? ":lope<CR>" : ":lcl<CR>"|" toggle location-list
nnoremap    <leader>s           :split<CR>
nnoremap    <leader>t           :tab split<CR>
nnoremap    <leader>v           :vsplit<CR>
nnoremap    <leader>y           my^vg_"+y:echo "Copiado!!"<CR>
vnoremap    <leader>y           "+y:echo "Copiado!!"<CR>
nnoremap    <leader>z           za

nnoremap    <expr><leader>0    &diff ? ":diffoff<CR>" : ":diffthis<CR>"
nnoremap    <expr><leader>1    &diff ? ":diffget _LOCAL_<CR>" : ":diffthis<CR>:diffget _LOCAL_<CR>:diffoff<CR>"
nnoremap    <expr><leader>2    &diff ? ":diffget _BASE_<CR>" : ":diffthis<CR>:diffget _BASE_<CR>:diffoff<CR>"
nnoremap    <expr><leader>3    &diff ? ":diffget _REMOTE_<CR>" : ":diffthis<CR>:diffget _REMOTE_<CR>:diffoff<CR>"

nnoremap    !!          :!!<CR>|" repete ultimo :!comando
"nnoremap    #           :b #<CR>
vnoremap    <           <gv|" mantêm select após indentação
vnoremap    >           >gv|" mantêm select após indentação
vnoremap    J           :m '>+1<CR>gv=gv|" move linha selecionada pra baixo
vnoremap    K           :m '<-2<CR>gv=gv|" move linha selecionada pra cima
"inoremap    kj          <esc>|" esc mais fácil
vnoremap    a'          "ac'<c-r>a'|" surround match
vnoremap    a"          "ac"<c-r>a"|" surround match
vnoremap    a(          "ac(<c-r>a)|" surround match
vnoremap    a{          "ac{<c-r>a}|" surround match
vnoremap    a[          "ac[<c-r>a]|" surround match
nnoremap    n           nzzzv|" centraliza match do search
nnoremap    N           Nzzzv|" centraliza match do search
nnoremap    Q           @q
nnoremap    q:          <nop>
nnoremap    Y           Vy
tnoremap    <esc>       <C-\><C-n>
noremap     \           za|" toggle fold
nnoremap    <expr><f2>  &foldlevel ? 'zM' :'zR'|" toggle fold todo arquivo
"noremap     <up>        <nop>|" força hjkl
"noremap     <down>      <nop>|" força hjkl
"noremap     <left>      <nop>|" força hjkl
"noremap     <right>     <nop>|" força hjkl
"inoremap    <up>        <nop>|" força hjkl
"inoremap    <down>      <nop>|" força hjkl
"inoremap    <left>      <nop>|" força hjkl
"inoremap    <right>     <nop>|" força hjkl
nnoremap    <c-\>       <c-]>|" teclado brasileiro <c-]> não funciona para tag jump
inoremap    <c-a>       <C-O>yiW<End>=<C-R>=<C-R>0<CR>|" calculadora - tip 73 https://vim.fandom.com/wiki/Vim_Tips_Wiki:Imported_tips
inoremap    <c-h>       <left>|" força hjkl
cnoremap    <c-h>       <left>|" força hjkl
nnoremap    <c-j>       <c-w>w|" estilo DWM
nnoremap    <c-k>       <c-w>W|" estilo DWM
cnoremap    <c-l>       <right>|" força hjkl
inoremap    <c-l>       <right>|" força hjkl
tnoremap    <c-l>       cls<CR>|" limpa terminal Windows
nnoremap    <c-n>       yiwV|" substitue multi cursors
xnoremap    <c-n>       :s/<c-r><c-*>//g<left><left>|" substitue multi cursors
nnoremap    <c-s>       mi<esc>gg=G`i|" indenta todo o arquivo
nnoremap    <c-q>       q:
nnoremap    <c-t>       :tj <c-r><c-w><CR>|" goto definition (tag jump do ctags)
nnoremap    <c-z>       u
inoremap    <c-z>       u
tnoremap    <s-insert>  <c-w>"*
tnoremap    <c-s-v>     <c-w>"*

" Abreviações ---------------------------------------------------------------
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qa! qa!
cnoreabbrev QA! qa!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qa qa
cnoreabbrev QA qa
cnoreabbrev Wqa wqa
cnoreabbrev WQa wqa
cnoreabbrev WQA wqa
cnoreabbrev wQA wqa
cnoreabbrev wqA wqa
cnoreabbrev wQa wqa

" AutoCmds -------------------------------------------------------------------
augroup filetype_detect
  au!
  au BufRead,BufNewFile *.phtml setfiletype html
  au BufRead,BufNewFile *.gv setfiletype dot
  au BufRead,BufNewFile *.todone setfiletype todone
augrou END
