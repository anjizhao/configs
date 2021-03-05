
" show line numbers in grey
set number
highlight LineNr ctermfg=grey
" show line/column numbers and location in file
set ruler

" use spaces instead of tabs
set tabstop=4
set shiftwidth=4
set expandtab

" strip trailing whitespace for python files
autocmd BufWritePre *.py %s/\s\+$//e

" syntax highlighting default on
syntax on

" insert newlines with o/O without entering insert mode
nnoremap o o<Esc>
nnoremap O O<Esc>

" go to line after last non-empty line and center vertically
nnoremap LG G:keeppatterns?.<CR>jzz

" zz, but scroll the window up/down a lil more
nnoremap ze zz8<C-e>
nnoremap zy zz8<C-y>

" enable filetype indent
filetype indent on

" fix weird double-indent issue (default is shiftwidth() * 2)
let g:pyindent_open_paren = 'shiftwidth()'

