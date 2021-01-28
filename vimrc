
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

